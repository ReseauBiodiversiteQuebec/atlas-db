-- Atlas api relies on a list of tables or materialized views that are generated
-- from other tables. Those generated tables must be updated frequently.
-- They also must be updated concurrently to not block usage of the database.

-- This system relies on these ressources :
-- - table named atlas_api.generated_tables_metadata that contains the list of generated tables and related metadata to update them
-- - function named atlas_api.update_generated_tables that updates all generated tables and related metadata

DROP TABLE IF EXISTS generated_tables_metadata CASCADE;
CREATE TABLE generated_tables_metadata (
    id SERIAL PRIMARY KEY,
    source_table_name TEXT NOT NULL,
    source_table_last_modified_column TEXT NOT NULL,
    source_table_last_modified TIMESTAMP,
    generated_table_name TEXT NOT NULL,
    generated_table_last_update TIMESTAMP DEFAULT '1970-01-01 00:00:00',
    update_statement TEXT NOT NULL,
    status TEXT,
    return_message TEXT
);

-- Unique constraint on generated_table_name, source_table_name and update_statement
CREATE UNIQUE INDEX generated_tables_metadata_unique_idx ON generated_tables_metadata (generated_table_name, source_table_name, update_statement);

CREATE OR REPLACE FUNCTION update_generated_tables_metadata()
RETURNS void AS $$
DECLARE
    generated_table RECORD;
    source_table RECORD;
    update_statement TEXT;
    return_message TEXT;
BEGIN
    -- Update source tables last modified date
    FOR source_table IN
        SELECT DISTINCT source_table_name, source_table_last_modified_column
        FROM generated_tables_metadata
    LOOP
        EXECUTE format(
            'UPDATE generated_tables_metadata
            SET source_table_last_modified = (SELECT MAX(%I) FROM %s)
            WHERE source_table_name = %L',
            source_table.source_table_last_modified_column,
            source_table.source_table_name,
            source_table.source_table_name
        );
    END LOOP;

    -- Update generated tables and last update date
    -- Try updating using statement stored in generated_tables_metadata
    -- If it fails, create warning and continue

    FOR generated_table IN
        SELECT
            id,
            generated_table_name,
            max(source_table_last_modified) source_table_last_modified,
            generated_table_last_update,
            update_statement
        FROM generated_tables_metadata
        GROUP BY generated_table_name, generated_table_last_update, update_statement
    LOOP
        -- If generated table last update is before source table, update it
        IF generated_table.generated_table_last_update < generated_table.source_table_last_modified THEN
            BEGIN
                -- STORE EXECUTE RESULT IN VARIABLE
                EXECUTE generated_table.update_statement INTO return_message;
                -- UPDATE GENERATED TABLE LAST UPDATE AND STATUS
                EXECUTE format('UPDATE generated_tables_metadata SET generated_table_last_update = NOW(), status = %L, return_message = %L WHERE id = %L', 'success', return_message, generated_table.id);
            EXCEPTION WHEN OTHERS THEN
                -- UPDATE GENERATED TABLE STATUS AND RETURN MESSAGE
                EXECUTE format('UPDATE generated_tables_metadata SET status = %L, return_message = %L WHERE id = %L', 'error', SQLERRM, generated_table.id);
            END;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

SELECT update_generated_tables_metadata();

-- INSERT GENERATED TABLES METADATA
INSERT INTO generated_tables_metadata (generated_table_name, update_statement, source_table_name, source_table_last_modified_column)
VALUES
    ('atlas_api.web_regions', 'REFRESH MATERIALIZED VIEW CONCURRENTLY atlas_api.web_regions;', 'public.regions', 'updated_at'),
    ('atlas_api.obs_region_counts', 'SELECT atlas_api.obs_region_counts_refresh()', 'public.observations', 'modified_at'),
    ('atlas_api.obs_region_counts', 'SELECT atlas_api.obs_region_counts_refresh()', 'public.regions', 'updated_at'),
    ('atlas_api.obs_regions_taxa_datasets_counts', 'SELECT obs_regions_taxa_datasets_counts_refresh()', 'public.observations', 'modified_at'),
    ('atlas_api.obs_regions_taxa_datasets_counts', 'SELECT obs_regions_taxa_datasets_counts_refresh()', 'public.observations', 'modified_at')
ON CONFLICT DO NOTHING;