-- INSTALL python PL EXTENSION TO SUPPORT API CALL
CREATE EXTENSION IF NOT EXISTS plpython3u;

-- CREATE FUNCTION TO ACCESS REFERENCE TAXA FROM GLOBAL NAMES
DROP FUNCTION IF EXISTS public.get_taxa_ref_gnames(text, text);
CREATE FUNCTION public.get_taxa_ref_gnames(
    name text,
    name_authorship text DEFAULT NULL)
RETURNS TABLE (
    source_name text,
    source_id numeric,
    source_record_id text,
    scientific_name text,
    authorship text,
    rank text,
    rank_order integer,
    valid boolean,
    valid_srid text,
    classification_srids text[],
    match_type text
)
LANGUAGE plpython3u
AS $function$
from bdqc_taxa.taxa_ref import TaxaRef
out = TaxaRef.from_global_names(name, name_authorship)
return out
$function$;

-- TEST get_taxa_ref_gnames
-- SELECT * FROM public.get_taxa_ref_gnames('Cyanocitta cristata');
-- SELECT * FROM public.get_taxa_ref_gnames('Antigone canadensis');


-- TODO verify what function was created and reuse it
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.modified_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- CREATE `taxa_ref` table and related resources

DROP TABLE IF EXISTS public.taxa_ref CASCADE;
CREATE TABLE IF NOT EXISTS public.taxa_ref (
    id SERIAL PRIMARY KEY,
    source_name text NOT NULL,
    source_id numeric,
    source_record_id text NOT NULL,
    scientific_name text NOT NULL,
    authorship text,
    rank text NOT NULL,
    valid boolean NOT NULL,
    valid_srid text NOT NULL,
    classification_srids text[],
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by text NOT NULL DEFAULT CURRENT_USER,
    UNIQUE (source_name, source_record_id)
);
CREATE INDEX IF NOT EXISTS source_id_srid_idx
  ON public.taxa_ref (source_id, valid_srid);

CREATE INDEX IF NOT EXISTS scientific_name_idx
  ON public.taxa_ref (scientific_name);

DROP TRIGGER IF EXISTS update_modified_at ON public.taxa_ref;
CREATE TRIGGER update_modified_at
  BEFORE UPDATE ON public.taxa_ref FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();


-- CREATE `taxa_obs` table and related resources
DROP TABLE IF EXISTS public.taxa_obs CASCADE;
CREATE TABLE IF NOT EXISTS public.taxa_obs (
    id SERIAL PRIMARY KEY,
    scientific_name text NOT NULL,
    authorship text,
    rank text,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by text DEFAULT CURRENT_USER NOT NULL,
    UNIQUE (scientific_name, authorship)
);

DROP TRIGGER IF EXISTS update_modified_at ON public.taxa_obs;
CREATE TRIGGER update_modified_at
  BEFORE UPDATE ON public.taxa_obs FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

-- CREATE `taxa_obs_ref_lookup` table and related resources
DROP TABLE IF EXISTS public.taxa_obs_ref_lookup CASCADE;
CREATE TABLE IF NOT EXISTS public.taxa_obs_ref_lookup (
    id_taxa_obs integer NOT NULL,
    id_taxa_ref integer NOT NULL,
    id_taxa_ref_valid integer NOT NULL,
    match_type text,
    UNIQUE (id_taxa_obs, id_taxa_ref)
);

CREATE INDEX IF NOT EXISTS id_taxa_obs_idx
  ON public.taxa_obs_ref_lookup (id_taxa_obs);

CREATE INDEX IF NOT EXISTS id_taxa_ref_idx
  ON public.taxa_obs_ref_lookup (id_taxa_ref);

CREATE INDEX IF NOT EXISTS id_taxa_ref_valid_idx
  ON public.taxa_obs_ref_lookup (id_taxa_ref_valid);

-- INSERT taxa_ref from obs record field

DROP FUNCTION IF EXISTS insert_taxa_ref_from_obs(integer, text, text) CASCADE;
CREATE OR REPLACE FUNCTION insert_taxa_ref_from_obs(
    new_id integer,
    new_scientific_name text,
    new_authorship text DEFAULT NULL
)
RETURNS void AS
$BODY$
BEGIN
    DROP TABLE IF EXISTS temp_src_taxa_ref;
    CREATE TEMPORARY TABLE temp_src_taxa_ref AS (
        SELECT source_ref.*, taxa_ref.id id_taxa_ref
        FROM get_taxa_ref_gnames(new_scientific_name, new_authorship) source_ref
        LEFT JOIN public.taxa_ref taxa_ref
            ON source_ref.source_id = taxa_ref.source_id
            AND source_ref.source_record_id = taxa_ref.source_record_id
    );

    WITH ins_ref AS (
        INSERT INTO public.taxa_ref (
            source_name,
            source_id,
            source_record_id,
            scientific_name,
            authorship,
            rank,
            valid,
            valid_srid,
            classification_srids
        )
        SELECT
            source_name,
            source_id,
            source_record_id,
            scientific_name,
            authorship,
            rank,
            valid,
            valid_srid,
            classification_srids
        FROM temp_src_taxa_ref
        ON CONFLICT DO NOTHING
        RETURNING id AS id_taxa_ref, source_record_id, source_id)
    UPDATE temp_src_taxa_ref
        SET id_taxa_ref = ins_ref.id_taxa_ref
        FROM ins_ref
        WHERE
            temp_src_taxa_ref.source_id = ins_ref.source_id
            AND temp_src_taxa_ref.source_record_id = ins_ref.source_record_id;

    INSERT INTO public.taxa_obs_ref_lookup (
            id_taxa_obs, id_taxa_ref, id_taxa_ref_valid, match_type)
        SELECT
            new_id AS id_taxa_obs,
            src_ref.id_taxa_ref AS id_taxa_ref,
            _id_join.id_taxa_ref AS id_taxa_ref_valid,
            src_ref.match_type AS match_type
        FROM temp_src_taxa_ref src_ref
        LEFT JOIN temp_src_taxa_ref _id_join
            ON src_ref.valid_srid = _id_join.source_record_id
        ON CONFLICT DO NOTHING;
END;
$BODY$
LANGUAGE 'plpgsql';

-- CREATE the column `id_taxa_obs` in table observations

ALTER TABLE public.observations ADD COLUMN id_taxa_obs integer;
CREATE INDEX if not exists observations_id_taxa_obs_idx
   ON public.observations (id_taxa_obs);


-- CREATE the trigger for taxa_ref insertion:

CREATE OR REPLACE FUNCTION trigger_insert_taxa_ref_from_obs()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM insert_taxa_ref_from_obs(
        NEW.id, NEW.scientific_name, NEW.authorship
        );
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS taxa_insert_ref ON public.taxa_obs;
CREATE TRIGGER taxa_insert_ref AFTER INSERT
ON public.taxa_obs
FOR EACH ROW
EXECUTE PROCEDURE trigger_insert_taxa_ref_from_obs();

-- -- List observed taxa
CREATE OR REPLACE VIEW list_valid_taxa AS
    SELECT DISTINCT(taxa_ref.*)
    FROM public.taxa_obs_ref_lookup lookup
    LEFT JOIN public.taxa_ref taxa_ref on lookup.id_taxa_ref_valid = taxa_ref.id
    WHERE lookup.match_type is not null;


--Procedures FUZZY MATCHING OF SCIENTIFIC NAME
DROP FUNCTION IF EXISTS get_taxa_obs_from_name(text, text);
CREATE FUNCTION get_taxa_obs_from_name(
    scientific_name text,
    authorship text DEFAULT NULL)
RETURNS SETOF public.taxa_obs AS $$
    SELECT DISTINCT(taxa_obs.*)
    FROM get_taxa_ref_gnames(scientific_name, authorship) source_ref
    LEFT JOIN public.taxa_ref taxa_ref
        ON source_ref.source_id = taxa_ref.source_id
        AND source_ref.valid_srid = taxa_ref.valid_srid
    LEFT JOIN public.taxa_obs_ref_lookup lookup on
        taxa_ref.id = lookup.id_taxa_ref_valid
    LEFT JOIN public.taxa_obs taxa_obs on
        lookup.id_taxa_obs = taxa_obs.id
    WHERE source_ref.valid AND source_ref.match_type is not null;
$$ LANGUAGE sql;

--Procedure Return same level or children synonyms taxa_ref
DROP FUNCTION IF EXISTS get_taxa_ref_relatives(integer);

CREATE FUNCTION get_taxa_ref_relatives(
    searched_id_taxa_ref integer)
RETURNS SETOF public.taxa_ref AS $$
    select distinct r_ref.*
    from taxa_obs_ref_lookup s_lookup
    left join taxa_obs_ref_lookup r_lookup
        on s_lookup.id_taxa_obs = r_lookup.id_taxa_obs
    left join taxa_ref r_ref
        on r_lookup.id_taxa_ref = r_ref.id
    where s_lookup.id_taxa_ref = searched_id_taxa_ref;
$$ LANGUAGE sql;

-- SELECT * FROM get_taxa_ref_relatives(32);


--Procedures MATCHING OF SCIENTIFIC NAME
DROP FUNCTION IF EXISTS match_taxa_ref_relatives(text);
CREATE FUNCTION match_taxa_ref_relatives(
    name text)
RETURNS SETOF public.taxa_ref AS $$
    select distinct r_ref.*
    from taxa_ref s_ref
    left join taxa_obs_ref_lookup s_lookup
        on s_ref.id = s_lookup.id_taxa_ref
    left join taxa_obs_ref_lookup r_lookup
        on s_lookup.id_taxa_obs = r_lookup.id_taxa_obs
    left join taxa_ref r_ref
        on r_lookup.id_taxa_ref = r_ref.id
    where s_ref.scientific_name = name;
$$ LANGUAGE sql;

-- SELECT * FROM match_taxa_ref_relatives('Aves');

-- Get taxa_obs ref
CREATE OR REPLACE VIEW observations_taxa_ref AS
    SELECT obs.*, lookup.id_taxa_ref_valid
    FROM observations obs
    LEFT JOIN taxa_obs_ref_lookup lookup ON obs.id_taxa_obs = lookup.id_taxa_obs
    WHERE lookup.match_type is not null;

DROP FUNCTION IF EXISTS get_observation_from_taxa(text, text);
CREATE FUNCTION get_observation_from_taxa(
    name text,
    authorship text DEFAULT NULL)
RETURNS SETOF observations_taxa_ref AS $$
    SELECT obs.*
    FROM get_taxa_obs_from_name(name, authorship) taxa_obs
    LEFT JOIN public.observations_taxa_ref obs
        ON taxa_obs.id = obs.id_taxa_obs
$$ LANGUAGE sql;

-- TEST queries

-- DELETE FROM public.taxa_ref;
-- DELETE FROM public.taxa_obs;
-- DELETE FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Cyanocitta cristata');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Antigone nanadensis');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Antigone cacadensis');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Grus canadensis');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer sp.');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer saccharum.');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer nigrum');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer rubrum');