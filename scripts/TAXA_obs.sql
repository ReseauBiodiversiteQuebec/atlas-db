-------------------------------------------------------------------------------
-- DESCRIPTION
-- Create table to contain observed taxa names and related attributes
-- from raw observed files
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- CREATE public.taxa_obs resource
-------------------------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS public.taxa_obs (
        id SERIAL PRIMARY KEY,
        scientific_name text NOT NULL,
        authorship text,
        rank text,
        parent_scientific_name text,
        created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        modified_by text DEFAULT CURRENT_USER NOT NULL,
        UNIQUE (scientific_name, authorship, rank, parent_scientific_name)
    );

    CREATE FUNCTION IF NOT EXISTS trigger_set_timestamp()
        RETURNS TRIGGER AS $$
        BEGIN
        NEW.modified_at = NOW();
        RETURN NEW;
        END;
        $$ LANGUAGE plpgsql;


    DROP TRIGGER IF EXISTS update_modified_at ON public.taxa_obs;
    CREATE TRIGGER update_modified_at
    BEFORE UPDATE ON public.taxa_obs FOR EACH ROW
    EXECUTE PROCEDURE trigger_set_timestamp();

    CREATE INDEX IF NOT EXISTS taxa_obs_scientific_name_idx
    ON public.taxa_obs (scientific_name);

-- ALTER TABLE public.taxa_obs
-- ADD CONSTRAINT unique_taxa_obs
-- UNIQUE (scientific_name, authorship, rank, parent_scientific_name);

-------------------------------------------------------------------------------
-- ALTER public.observations ADD COLUMN id_taxa_obs
-- Description : will relate to taxa_obs table with many-to one relations
-- Other scripts:
-- * Create index
-------------------------------------------------------------------------------

    ALTER TABLE observations ADD COLUMN id_taxa_obs integer;

    ALTER TABLE observations
        ADD CONSTRAINT observations_id_taxa_obs_fkey
        FOREIGN KEY (id_taxa_obs)
        REFERENCES taxa_obs (id)
        ON UPDATE CASCADE;

    CREATE INDEX IF NOT EXISTS observations_id_taxa_obs_idx
        ON public.observations (id_taxa_obs);



--------------------------------------------------------------------------------
-- Fix problematic taxa names
-- The taxa_obs.scientific_names that match multiple taxa_ref.scientific_names
--
--
-- Multiple observations may be related to the same taxa_obs reccord.
-- To fix a problematic taxa_obs, we may add a parent_scientific_name to the taxa_obs 
-- with the public.fix_taxa_obs_parent_scientific_name function. This will update
-- *ALL* the observations that are related to the taxa_obs.
--
-- If some observations belong to one synonym and others to another, 
-- we may add a new taxa_obs reccord, and update the observations that are related 
-- to the new taxa_obs (update id_taxa_obs of these observations). Then, use 
-- the public.fix_taxa_obs_parent_scientific_name function to update the taxa_ref 
-- and taxa_vernacular of the new taxa_obs.
--------------------------------------------------------------------------------
-- All taxa_obs.scientific_names that match multiple taxa_ref.scientific_names
SELECT
    o.scientific_name,
    COUNT(DISTINCT r.scientific_name) AS counts,
    ARRAY_AGG(DISTINCT r.scientific_name),
    ARRAY_AGG(DISTINCT o.id)
    -- ARRAY_AGG(DISTINCT ds.original_source)
    -- ARRAY_AGG(DISTINCT ds.creator),
    -- ARRAY_AGG(DISTINCT ds.title),
    --ARRAY_AGG(DISTINCT ds.keywords)
FROM taxa_ref r
JOIN taxa_obs_ref_lookup lu ON r.id = lu.id_taxa_ref
JOIN taxa_obs o ON o.id = lu.id_taxa_obs
-- left JOIN observations obs ON obs.id_taxa_obs = o.id
-- left JOIN datasets ds ON ds.id = obs.id_datasets
WHERE r.rank = 'order'
GROUP BY o.scientific_name
HAVING COUNT(DISTINCT r.scientific_name) > 1
ORDER BY counts DESC;

-- Check datasets of problematic taxa
select tobs.scientific_name, ds.*
from taxa_obs as tobs
join observations as obs on obs.id_taxa_obs = tobs.id
join datasets as ds on ds.id = obs.id_datasets
where tobs.id =  7720;

select * 
from taxa_obs 
-- left join observations on observations.id_taxa_obs = taxa_obs.id
where taxa_obs.id=9087;


-- Fix problematic taxa_obs -----------------------------------------------
-- Saccorhiza dermatodea
select public.fix_taxa_obs_parent_scientific_name(9087, 'Ochrophyta'::text);