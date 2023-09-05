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
        created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        modified_by text DEFAULT CURRENT_USER NOT NULL,
        UNIQUE (scientific_name, authorship)
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