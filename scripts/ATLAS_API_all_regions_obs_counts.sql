-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_map_values to return counts of observations and observed taxa zoom for a given region type, and scale
-- -----------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_map_values(text,integer,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_map_values(
        region_type text,
        scale integer,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    -- RETURNS TABLE (json_collection json) AS $$
    RETURNS json AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), map_regions as (
        SELECT
            regions.fid,
            regions.type,
            regions.scale,
            regions.scale_desc,
            regions.name
        FROM regions
        WHERE
            regions.type = $1
            AND regions.scale = $2
        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE counts.type = $1 and counts.scale = $2
                AND counts.year_obs >= $5 and counts.year_obs <= $6
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.name,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_agg(row_to_json(features))
        INTO out_json
        FROM features;
        RETURN out_json;
    END;
    $$ LANGUAGE plpgsql STABLE;

EXPLAIN ANALYZE SELECT atlas_api.obs_map_values('hex', 50, NULL, 19, 1950, 9999);

-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_map_values_slippy to return counts of observations and observed taxa zoom for a given region type, scale and map extent
-- -----------------------------------------------------------------------------
    CREATE OR REPLACE FUNCTION atlas_api.obs_map_values_slippy(
        region_type text,
        zoom integer,
        x_min float,
        y_min float,
        x_max float,
        y_max float,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    -- RETURNS TABLE (json_collection json) AS $$
    RETURNS json AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), map_regions as (
        SELECT
            regions.fid,
            regions.type,
            regions.scale,
            regions.scale_desc,
            regions.name
        FROM regions
        WHERE
            regions.type = $1
            AND regions.scale = $2
            AND ST_Intersects(
                geom,
                ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))

        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE counts.type = $1 and counts.scale = $2
                AND counts.year_obs >= $9 and counts.year_obs <= $10
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.name,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_agg(row_to_json(features))
        INTO out_json
        FROM features;
        RETURN out_json;
    END;
    $$ LANGUAGE plpgsql STABLE;

EXPLAIN ANALYZE SELECT atlas_api.obs_map_values_slippy('hex', 100, -76, 45, -68, 50, NULL, 19, 1950, 9999);