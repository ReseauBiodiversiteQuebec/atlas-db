ALTER TABLE taxa_obs ADD COLUMN parent_scientific_name text DEFAULT NULL;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION public.match_taxa_sources
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DROP FUNCTION IF EXISTS public.match_taxa_sources(text, text);
CREATE OR REPLACE FUNCTION public.match_taxa_sources(
    name text,
    name_authorship text DEFAULT NULL,
    parent_scientific_name text DEFAULT NULL)
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
    match_type text,
    is_parent boolean
)
LANGUAGE plpython3u
AS $function$
from bdqc_taxa.taxa_ref import TaxaRef
import plpy
try:
  return TaxaRef.from_all_sources(name, name_authorship, parent_scientific_name)
except Exception as e:
  plpy.notice(f'Failed to match_taxa_sources: {name} {name_authorship}')
  raise Exception(e)
out = TaxaRef.from_all_sources(name, name_authorship)
return out
$function$;


-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION insert_taxa_ref_from_taxa_obs
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DROP FUNCTION IF EXISTS insert_taxa_ref_from_taxa_obs(integer, text, text);

CREATE OR REPLACE FUNCTION insert_taxa_ref_from_taxa_obs(
    taxa_obs_id integer,
    taxa_obs_scientific_name text,
    taxa_obs_authorship text DEFAULT NULL,
    taxa_obs_parent_scientific_name text DEFAULT NULL
)
RETURNS void AS
$BODY$
BEGIN
    DROP TABLE IF EXISTS temp_src_ref;
    CREATE TEMPORARY TABLE temp_src_ref AS (
        SELECT *
        FROM public.match_taxa_sources(taxa_obs_scientific_name, taxa_obs_authorship, taxa_obs_parent_scientific_name)
    );

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
    FROM temp_src_ref
    ON CONFLICT DO NOTHING;

    INSERT INTO public.taxa_obs_ref_lookup (
            id_taxa_obs, id_taxa_ref, id_taxa_ref_valid, match_type, is_parent)
        SELECT
            taxa_obs_id AS id_taxa_obs,
            taxa_ref.id AS id_taxa_ref,
            valid_taxa_ref.id AS id_taxa_ref_valid,
            temp_src_ref.match_type AS match_type, 
            temp_src_ref.is_parent AS is_parent
        FROM
            temp_src_ref,
            taxa_ref,
            taxa_ref as valid_taxa_ref
        WHERE  
            temp_src_ref.source_id = taxa_ref.source_id
            AND temp_src_ref.source_record_id = taxa_ref.source_record_id
            and temp_src_ref.source_id = valid_taxa_ref.source_id
            and temp_src_ref.valid_srid = valid_taxa_ref.source_record_id
        ON CONFLICT DO NOTHING;
END;
$BODY$
LANGUAGE 'plpgsql';

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION refresh_taxa_ref
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CREATE OR REPLACE FUNCTION refresh_taxa_ref()
RETURNS void AS
$$
DECLARE
    taxa_obs_record RECORD;
BEGIN
    DELETE FROM public.taxa_obs_ref_lookup;
    DELETE FROM public.taxa_ref;
    FOR taxa_obs_record IN SELECT * FROM public.taxa_obs LOOP
        BEGIN
            PERFORM public.insert_taxa_ref_from_taxa_obs(
            taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
            );
        EXCEPTION
            WHEN OTHERS THEN
            RAISE NOTICE 'Error inserting record with id % and scientific name %', taxa_obs_record.id, taxa_obs_record.scientific_name;
            CONTINUE;
        END;
    END LOOP;
END;
$$ LANGUAGE 'plpgsql';

-- TEST SALIX
BEGIN;

UPDATE public.taxa_obs SET parent_scientific_name = 'Plantae' WHERE scientific_name = 'Salix';

WITH taxa_obs_record AS (
    SELECT * FROM public.taxa_obs WHERE scientific_name = 'Salix'
)
DELETE FROM public.taxa_obs_ref_lookup
USING taxa_obs_record
WHERE id_taxa_obs = taxa_obs_record.id;

WITH taxa_obs_record AS (
    SELECT * FROM public.taxa_obs WHERE scientific_name = 'Salix'
)
SELECT public.insert_taxa_ref_from_taxa_obs(
    taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
)
FROM taxa_obs_record;

SELECT taxa_ref.*
FROM taxa_obs, taxa_ref, taxa_obs_ref_lookup
WHERE taxa_obs.id = taxa_obs_ref_lookup.id_taxa_obs
    AND taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
    AND taxa_obs.scientific_name = 'Salix'
    AND taxa_ref.rank = 'kingdom';

ROLLBACK;

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- % FUNCTION fix_taxa_obs_parent_scientific_name
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CREATE OR REPLACE FUNCTION fix_taxa_obs_parent_scientific_name(id_taxa_obs integer, parent_scientific_name text)
RETURNS void AS
$$
DECLARE
  taxa_obs_record RECORD;
  scientific_name_rec record;
BEGIN
    -- Update taxa_ref
    UPDATE public.taxa_obs SET parent_scientific_name = $2, updated_at = CURRENT_TIMESTAMP WHERE taxa_obs.id = $1;

    FOR taxa_obs_record IN SELECT * FROM public.taxa_obs WHERE taxa_obs.id = $1
    LOOP
        DELETE FROM public.taxa_obs_ref_lookup WHERE public.taxa_obs_ref_lookup.id_taxa_obs = taxa_obs_record.id;

        PERFORM public.insert_taxa_ref_from_taxa_obs(
            taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
        );
    END LOOP;
    -- Update taxa_vernacular
    FOR scientific_name_rec IN
        SELECT
            distinct on (taxa_ref.scientific_name, taxa_ref.rank)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank),
            taxa_obs_vernacular_lookup.id_taxa_vernacular
        FROM taxa_ref, taxa_obs_ref_lookup, taxa_obs_vernacular_lookup, taxa_obs
        where taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
            and taxa_obs_ref_lookup.id_taxa_obs = taxa_obs.id
            and taxa_obs_vernacular_lookup.id_taxa_obs = taxa_obs.id
            and taxa_obs.id = $1
    LOOP
        BEGIN
            DELETE from taxa_obs_vernacular_lookup where taxa_obs_vernacular_lookup.id_taxa_vernacular = scientific_name_rec.id_taxa_vernacular;
            DELETE from taxa_vernacular where taxa_vernacular.id = scientific_name_rec.id_taxa_vernacular;

            PERFORM insert_taxa_vernacular_using_ref(scientific_name_rec.id);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'insert_taxa_vernacular_using_ref(%s) failed for taxa (%s): %', scientific_name_rec.id, scientific_name_rec.scientific_name, SQLERRM;
        END;
    END LOOP;
END;
$$ LANGUAGE 'plpgsql';

-- TEST SALIX (Gallinula galeata; id = 735)
SELECT * FROM public.taxa_obs WHERE scientific_name = 'Salix'
SELECT * FROM public.taxa_obs WHERE id = 735

SELECT public.fix_taxa_obs_parent_scientific_name(735, 'Tracheophyta');

SELECT taxa_ref.*
FROM taxa_obs, taxa_ref, taxa_obs_ref_lookup
WHERE taxa_obs.id = taxa_obs_ref_lookup.id_taxa_obs
    AND taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
    AND taxa_obs.id = 735;

SELECT taxa_vernacular.*
FROM taxa_obs, taxa_vernacular, taxa_obs_vernacular_lookup
WHERE taxa_obs.id = taxa_obs_vernacular_lookup.id_taxa_obs
    AND taxa_vernacular.id = taxa_obs_vernacular_lookup.id_taxa_vernacular
    AND taxa_obs.id = 735;
