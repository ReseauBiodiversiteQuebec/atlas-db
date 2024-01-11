--------------------------------------------------------------------------------
-- CREATE FUNCTION public.fix_taxa_obs_parent_scientific_name
-- DESCRIPTION When conflicting parent_scientific_name are found in taxa_obs,
--  this function will update taxa_obs taxa_obs_ref_lookup and taxa_vernacular_lookup
--  to match the parent_scientific_name of the taxa_obs record
--------------------------------------------------------------------------------

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
