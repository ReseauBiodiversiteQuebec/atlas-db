-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % TABLE taxa_vernacular
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- DROP TABLE IF EXISTS public.taxa_vernacular CASCADE;
CREATE TABLE public.taxa_vernacular (
    id SERIAL PRIMARY KEY,
    source_name text NOT NULL,
    source_record_id text NOT NULL,
    name text NOT NULL,
    language text NOT NULL,
    rank text,
    rank_order integer not null default -1,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by text NOT NULL DEFAULT CURRENT_USER,
    UNIQUE (source_name, source_record_id, language)
);

-- alter default value  -1
Alter table public.taxa_vernacular
    alter column rank_order set default -1;

CREATE INDEX IF NOT EXISTS taxa_vernacular_source_name_idx
  ON public.taxa_vernacular (source_name);

CREATE INDEX IF NOT EXISTS taxa_vernacular_source_record_id_idx
    ON public.taxa_vernacular (source_record_id);

CREATE INDEX IF NOT EXISTS taxa_vernacular_language_idx
    ON public.taxa_vernacular (language);


-- DROP TRIGGER IF EXISTS update_modified_at ON public.taxa_vernacular;
-- CREATE TRIGGER update_modified_at
--   BEFORE UPDATE ON public.taxa_vernacular FOR EACH ROW
--   EXECUTE PROCEDURE trigger_set_timestamp();

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % TABLE taxa_vernacular_ref_lookup
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- DROP TABLE IF EXISTS public.taxa_obs_vernacular_lookup CASCADE;
CREATE TABLE IF NOT EXISTS public.taxa_obs_vernacular_lookup (
    id_taxa_obs integer NOT NULL,
    id_taxa_vernacular integer NOT NULL,
    match_type text,
    UNIQUE (id_taxa_obs, id_taxa_vernacular)
);

CREATE INDEX IF NOT EXISTS id_taxa_obs_idx
  ON public.taxa_obs_vernacular_lookup (id_taxa_obs);

CREATE INDEX IF NOT EXISTS id_taxa_vernacular_idx
  ON public.taxa_obs_vernacular_lookup (id_taxa_vernacular);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION taxa_vernacular_from_names
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DROP FUNCTION IF EXISTS public.taxa_vernacular_from_match(text);
CREATE OR REPLACE FUNCTION public.taxa_vernacular_from_match(
    observed_scientific_name text)
RETURNS TABLE (
    source text,
    source_taxon_key text,
    name text,
    language text,
    rank text,
    rank_order integer
)
LANGUAGE plpython3u
AS $function$
from bdqc_taxa.vernacular import Vernacular
out = Vernacular.from_match(observed_scientific_name)
return out
$function$;

-- TEST
-- explain analyze select * from public.taxa_vernacular_from_match('Picoides villosus');

DROP FUNCTION IF EXISTS public.taxa_vernacular_from_gbif(text);
CREATE FUNCTION public.taxa_vernacular_from_gbif(
    gbif_taxon_key text)
RETURNS TABLE (
    source text,
    source_taxon_key text,
    name text,
    language text
)
LANGUAGE plpython3u
AS $function$
from bdqc_taxa.vernacular import Vernacular
out = Vernacular.from_gbif(int(gbif_taxon_key))
return out
$function$;

-- explain analyze select * from public.taxa_vernacular_from_gbif('9192501');


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION insert_taxa_vernacular_from_obs
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DROP FUNCTION IF EXISTS public.insert_taxa_vernacular_using_ref(integer);
CREATE OR REPLACE FUNCTION insert_taxa_vernacular_using_ref(id_taxa_ref integer)
RETURNS void AS
$BODY$
DECLARE
    scientific_name_rec record;
BEGIN
    CREATE TEMPORARY TABLE distinct_taxa_ref as
        select distinct on (scientific_name)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank)
        from taxa_ref
        where taxa_ref.id = $1;

    FOR scientific_name_rec IN
        SELECT scientific_name FROM distinct_taxa_ref
    LOOP
        WITH related_taxa_obs as (
            select
                id_taxa_obs,
                match_type
            from taxa_obs_ref_lookup ref_lu, distinct_taxa_ref
            where ref_lu.id_taxa_ref = distinct_taxa_ref.id
        ), ins_taxa_vernacular as (
            INSERT INTO taxa_vernacular (
                source_name,
                source_record_id,
                name,
                language,
                rank,
                rank_order
            )
            SELECT
                source,
                source_taxon_key,
                name,
                language,
                rank,
                rank_order
            FROM taxa_vernacular_from_match(scientific_name_rec.scientific_name)
            ON CONFLICT (source_name, source_record_id, language) DO NOTHING
            RETURNING id as taxa_vernacular_id
        )
        INSERT INTO taxa_obs_vernacular_lookup (
            id_taxa_obs,
            id_taxa_vernacular,
            match_type
        )
        SELECT
            related_taxa_obs.id_taxa_obs,
            ins_taxa_vernacular.taxa_vernacular_id,
            coalesce(related_taxa_obs.match_type, 'parent')
        FROM related_taxa_obs,
            ins_taxa_vernacular
        ON CONFLICT (id_taxa_obs, id_taxa_vernacular) DO NOTHING;
    END LOOP;
    DROP TABLE distinct_taxa_ref;
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_taxa_vernacular_using_all_ref()
RETURNS void AS
$$
DECLARE
    scientific_name_rec record;
BEGIN
    FOR scientific_name_rec IN
        SELECT
            distinct on (taxa_ref.scientific_name, taxa_ref.rank)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank)
        FROM taxa_ref
    LOOP
        BEGIN
            PERFORM insert_taxa_vernacular_using_ref(scientific_name_rec.id);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'insert_taxa_vernacular_using_ref(%s) failed for taxa (%s): %', scientific_name_rec.id, scientific_name_rec.scientific_name, SQLERRM;
        END;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- select insert_taxa_vernacular_using_ref(273000);


-- DROP FUNCTION IF EXISTS insert_taxa_vernacular_from_taxa_obs(integer) CASCADE;
CREATE OR REPLACE FUNCTION insert_taxa_vernacular_from_taxa_obs(
    ins_taxa_obs_id integer
)
RETURNS void AS
$BODY$
$$
SELECT
    distinct on (taxa_ref.scientific_name, taxa_ref.rank)
    insert_taxa_vernacular_using_ref(taxa_ref.id)
FROM taxa_ref, taxa_obs_ref_lookup
WHERE taxa_obs_ref_lookup.id_taxa_obs = ins_taxa_obs_id
    AND taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref;
$$ LANGUAGE SQL;

------------------------------------------------------------------------
-- FUNCTION refresh_taxa_vernacular
------------------------------------------------------------------------

drop function if exists taxa_vernacular_fix_caribou();
create function taxa_vernacular_fix_caribou ()
returns void as
$$
delete from taxa_obs_vernacular_lookup vlu
using taxa_ref, taxa_obs_ref_lookup, taxa_vernacular, taxa_obs
where taxa_ref.scientific_name <> 'Rangifer tarandus'
	and taxa_obs.scientific_name <> 'Rangifer tarandus'
	and taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
	and taxa_obs.id = taxa_obs_ref_lookup.id_taxa_obs
	and taxa_vernacular.name = 'caribou'
	and taxa_vernacular.id = vlu.id_taxa_vernacular
	and vlu.id_taxa_obs = taxa_obs.id;
$$ language sql;


-- DROP FUNCTION IF EXISTS refresh_taxa_vernacular() CASCADE;
CREATE OR REPLACE FUNCTION refresh_taxa_vernacular()
RETURNS void AS
$$
BEGIN
    DELETE FROM taxa_obs_vernacular_lookup;
    DELETE FROM taxa_vernacular;
    PERFORM insert_taxa_vernacular_using_all_ref() ;
    PERFORM taxa_vernacular_fix_caribou();
END;
$$ LANGUAGE plpgsql;