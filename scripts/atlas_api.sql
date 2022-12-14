
-- -----------------------------------------------------------------------------
-- CREATE SCHEMA for carto api
-- -----------------------------------------------------------------------------
    CREATE SCHEMA IF NOT EXISTS atlas_api;

    -- Change owner of schema and all objects in it to postgres
    ALTER SCHEMA atlas_api OWNER TO postgres;

    GRANT ALL ON SCHEMA atlas_api TO coleo;

    GRANT USAGE ON SCHEMA atlas_api TO read_only_all;

    GRANT USAGE ON SCHEMA atlas_api TO read_only_public;

    GRANT USAGE ON SCHEMA atlas_api TO read_write_all;

    ALTER DEFAULT PRIVILEGES IN SCHEMA atlas_api GRANT SELECT ON TABLES TO read_only_public;

    ALTER DEFAULT PRIVILEGES IN SCHEMA atlas_api GRANT EXECUTE ON FUNCTIONS TO read_only_public;

    ALTER DEFAULT PRIVILEGES IN SCHEMA atlas_api GRANT SELECT ON TABLES TO read_only_all;

    ALTER DEFAULT PRIVILEGES IN SCHEMA atlas_api GRANT EXECUTE ON FUNCTIONS TO read_only_all;

    GRANT SELECT ON ALL TABLES IN SCHEMA atlas_api TO read_only_public;

    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA atlas_api TO read_only_public;

-- -----------------------------------------------------------------------------
-- CREATE TABLE for regions
-- Define the regions_zoom_lookup table containing the zoom levels for each region type and scale
-- -----------------------------------------------------------------------------
    -- Drop the regions_type_scale table if it exists
    DROP TABLE IF EXISTS atlas_api.regions_zoom_lookup;
    CREATE TABLE atlas_api.regions_zoom_lookup (
        type text,
        scale integer,
        zoom integer
    );

    ALTER TABLE atlas_api.regions_zoom_lookup ADD COLUMN name_en VARCHAR(50) DEFAULT NULL;
    ALTER TABLE atlas_api.regions_zoom_lookup ADD COLUMN name_fr VARCHAR(50) DEFAULT NULL;
    ALTER TABLE atlas_api.regions_zoom_lookup ADD COLUMN show_sensitive BOOLEAN DEFAULT FALSE;

    -- Insert the zoom levels for each region type and scale
    INSERT INTO atlas_api.regions_zoom_lookup (type, name_fr, name_en, scale, zoom, show_sensitive)
    VALUES
        ('admin', 'Limites administratives', 'Administrative boundaries', 1, 4, TRUE), -- Quebec
        ('admin', 'Limites administratives', 'Administrative boundaries', 2, 5, TRUE), -- Regions admin
        ('admin', 'Limites administratives', 'Administrative boundaries', 3, 7, TRUE), -- MRC
        ('admin', 'Limites administratives', 'Administrative boundaries', 4, 10, FALSE), -- Municipalités
        ('protected', 'Aires protégées', 'Protected areas', 1, 8, TRUE),
        ('hex', 'Hexagones', 'Hexagons', 250, 4, TRUE),
        ('hex', 'Hexagones', 'Hexagons', 100, 5, TRUE),
        ('hex', 'Hexagones', 'Hexagons', 50, 6, FALSE),
        ('hex', 'Hexagones', 'Hexagons', 20, 7, FALSE),
        ('hex', 'Hexagones', 'Hexagons', 10, 9, FALSE),
        ('hex', 'Hexagones', 'Hexagons', 5, 10, FALSE),
        ('cadre_eco', 'Cadre écologique', 'Ecological framework', 1, 5, TRUE),
        ('cadre_eco', 'Cadre écologique', 'Ecological framework', 2, 6, TRUE),
        ('cadre_eco', 'Cadre écologique', 'Ecological framework', 3, 7, TRUE),
        ('cadre_eco', 'Cadre écologique', 'Ecological framework', 4, 9, FALSE);

    CREATE INDEX IF NOT EXISTS regions_zoom_lookup_type_idx ON atlas_api.regions_zoom_lookup (type);

    CREATE INDEX IF NOT EXISTS regions_zoom_lookup_zoom_idx ON atlas_api.regions_zoom_lookup (zoom);

    CREATE INDEX IF NOT EXISTS regions_zoom_lookup_show_sensitive_idx ON atlas_api.regions_zoom_lookup (show_sensitive);

        CREATE OR REPLACE VIEW atlas_api.region_types AS
        SELECT DISTINCT type, name_en, name_fr
        FROM atlas_api.regions_zoom_lookup
        WHERE "type" in ('admin', 'hex', 'cadre_eco');

        -- CREATE FUNCTION to get the scale for a given region type and zoom level
        CREATE OR REPLACE FUNCTION atlas_api.get_scale(type text, zoom integer, is_sensitive boolean)
        RETURNS integer AS $$
        DECLARE
            best_scale integer;
            lower_scale integer;
        BEGIN
            SELECT scale
            INTO best_scale
            FROM atlas_api.regions_zoom_lookup
            WHERE
                regions_zoom_lookup.type = $1
                AND regions_zoom_lookup.zoom <= $2
                AND (show_sensitive IS TRUE OR $3 IS FALSE)
            ORDER BY regions_zoom_lookup.zoom DESC
            LIMIT 1;

            SELECT scale
            INTO lower_scale
            FROM atlas_api.regions_zoom_lookup
            WHERE regions_zoom_lookup.type = $1
            ORDER BY regions_zoom_lookup.zoom ASC
            LIMIT 1;

            RETURN CASE WHEN best_scale IS NULL THEN lower_scale ELSE best_scale END;
        END;
        $$ LANGUAGE plpgsql;

        -- TEST FUNCTION
        SELECT atlas_api.get_scale('hex', 8, false);


-- ----------------------------------------------------------------------------
-- CREATE MATERIALZIED VIEW FOR SIMPLIFIED REGIONS
-- The simplification is done using the ST_SimplifyPreserveTopology function
-- using a value computed from the zoom level scale of the region
-- The zoom level scale is defined in the regions_zoom_lookup table
-- ----------------------------------------------------------------------------

    DROP MATERIALIZED VIEW IF EXISTS atlas_api.web_regions;
    CREATE MATERIALIZED VIEW atlas_api.web_regions AS
        SELECT
            regions.fid,
            regions.type,
            regions.scale,
            CASE
                WHEN zoom = 3 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.17578), 4326)
                    ))
                WHEN zoom = 4 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.08789), 4326)
                    ))
                WHEN zoom = 5 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.04395), 4326)
                    ))
                WHEN zoom = 6 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.02197), 4326)
                    ))
                WHEN zoom = 7 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.01099), 4326)
                    ))
                WHEN zoom = 8 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.00549), 4326)
                    ))
                WHEN zoom = 9 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.00274), 4326)
                    ))
                WHEN zoom = 10 THEN ST_ForcePolygonCCW(st_makevalid(
                        ST_Transform(st_simplifypreservetopology(geom, 0.00137), 4326)
                    ))
                END AS geom
        FROM regions
        JOIN atlas_api.regions_zoom_lookup ON regions.type = regions_zoom_lookup.type
            AND regions.scale = regions_zoom_lookup.scale;
            

    -- CREATE INDEX ON THE MATERIALIZED VIEW
    CREATE INDEX web_regions_geom_idx ON atlas_api.web_regions USING GIST (geom);

    CREATE INDEX web_regions_fid_idx ON atlas_api.web_regions (fid);

    CREATE INDEX web_regions_type_idx ON atlas_api.web_regions (type);

    CREATE INDEX web_regions_scale_idx ON atlas_api.web_regions (scale);

    CREATE INDEX web_regions_type_scale_idx ON atlas_api.web_regions (type, scale);



-- -----------------------------------------------------------------------------
-- CREATE MATERIALIZED VIEW FOR counts
-- -----------------------------------------------------------------------------
    DROP MATERIALIZED VIEW IF EXISTS atlas_api.counts;
    CREATE MATERIALIZED VIEW IF NOT EXISTS atlas_api.counts AS
    SELECT
        regions.type,
        regions.fid,
        o.id_taxa_obs,
        o.year_obs,
        count(o.id) AS count_obs
    FROM 
        regions,
        observations o,
        -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
        atlas_api.regions_zoom_lookup
    WHERE st_within(o.geom, regions.geom)
        AND o.within_quebec = regions.within_quebec
        AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
    GROUP BY regions.type, regions.fid, o.id_taxa_obs, o.year_obs
    WITH DATA;


    -- CREATE INDEX ON THE MATERIALIZED VIEW

    CREATE INDEX counts_type_fid_idx
        ON atlas_api.counts (type, fid);

    CREATE INDEX counts_fid_idx
        ON atlas_api.counts (fid);

    CREATE INDEX counts_type_idx
        ON atlas_api.counts (type);

    CREATE INDEX counts_year_obs_idx
        ON atlas_api.counts (year_obs);

    CREATE INDEX counts_id_taxa_obs_idx
        ON atlas_api.counts (id_taxa_obs);

    CREATE TABLE atlas_api.temp_obs_regions_taxa_year_counts AS 
    SELECT counts.*, regions.scale FROM atlas_api.counts counts, regions
    WHERE regions.fid = counts.fid
        AND regions.type in ('hex', 'cadre_eco');

    CREATE INDEX temp_obs_regions_taxa_year_counts_type_scale_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (type, scale);

    CREATE INDEX temp_obs_regions_taxa_year_counts_type_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (type);

    CREATE INDEX temp_obs_regions_taxa_year_counts_scale_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (scale);

    CREATE INDEX temp_obs_regions_taxa_year_counts_year_obs_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (year_obs);

    CREATE INDEX temp_obs_regions_taxa_year_counts_id_taxa_obs_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (id_taxa_obs);

    CREATE INDEX temp_obs_regions_taxa_year_counts_fid_idx
        ON atlas_api.temp_obs_regions_taxa_year_counts (fid);



-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_map to return tile x, y and zoom for a given region type, zoom, y, x with summary of observations
-- -----------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_map(text,integer,double precision,double precision,double precision,double precision,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_map(
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
    RETURNS table (json_collection json) AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        RETURN QUERY
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
            ), scale as (
                select atlas_api.get_scale(region_type, $2, sensitive) as scale
                from sensitive
            ), map_regions as (
            SELECT
                web_regions.fid,
                web_regions.type,
                web_regions.scale,
                regions.scale_desc,
                regions.name,
                regions.extra,
                web_regions.geom
            FROM atlas_api.web_regions, regions, scale
            WHERE
                web_regions.type = $1
                AND ST_Intersects(
                    web_regions.geom,
                    ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))
                AND web_regions.scale = scale.scale
                AND web_regions.fid = regions.fid
                AND web_regions.type = regions.type
            ), obs_summary as (
                SELECT
                    fid,
                    count(distinct(id_taxa_obs)) AS count_species,
                    sum(count_obs) AS count_obs
                FROM atlas_api.temp_obs_regions_taxa_year_counts counts 
                JOIN taxa using (id_taxa_obs)
                WHERE type = region_type and scale = (select scale from scale)
                    AND year_obs >= $9 and year_obs <= $10
                GROUP BY fid
            ), features as (
            SELECT
                map_regions.fid,
                map_regions.type,
                map_regions.scale,
                map_regions.scale_desc,
                map_regions.name,
                map_regions.extra,
                map_regions.geom,
                obs_summary.count_species,
                obs_summary.count_obs
            FROM map_regions
            LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
            )
            -- Make the results into a geojson
            SELECT
            json_build_object(
                'type', 'FeatureCollection',
                'features', json_agg(ST_AsGeoJSON(features.*)::json),
                'sensitive', (SELECT sensitive from sensitive)
                )
            FROM features;
    END;
    $$ LANGUAGE plpgsql STABLE;

    EXPLAIN ANALYZE SELECT atlas_api.obs_map('hex', 6, -76, 45, -68, 50, NULL, 19, 1950, 9999);
    EXPLAIN ANALYZE EXECUTE SELECT atlas_api.obs_map('hex', 6, -140, 35, -3, 68, NULL, 19, 1950, 9999);
    FOR sensitive species Apalone spinifera
    EXPLAIN ANALYZE EXECUTE SELECT atlas_api.obs_map('hex', 10, -140, 35, -3, 68, 10146, NULL, 1950, 9999);



-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_summary to return species and obs counts for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- ---------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_summary(integer,text,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_summary(
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS table (
        fid integer,
        taxa_filter_tags json,
        region_filter_tags json,
        obs_count integer,
        taxa_count integer,
        taxa_id_list integer[]
    )
    AS $$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), region_type_scale as (
            select show_sensitive, name_fr, name_en, regions.name as region_name
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_counts as (
            SELECT
                counts.fid,
                counts.type,
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list,
                sum(counts.count_obs) AS count_obs
            FROM atlas_api.temp_obs_regions_taxa_year_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), taxa_list as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_counts
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        ), taxa_groups as (
            SELECT 
                array_agg(vernacular_fr) groups_fr,
                array_agg(vernacular_en) groups_en
            FROM taxa_list, match_taxa_groups(taxa_list.taxa_list)
            WHERE level = 1 or (21 <= id and id >= 25)
        )
        SELECT
            region_fid,
            json_build_object(
                'taxa_tags_fr', groups_fr,
                'taxa_tags_en', groups_en
            ) AS taxa_filter_tags,
            json_build_object(
                'tags_fr', region_type_scale.name_fr,
                'tags_en', region_type_scale.name_en,
                -- name is the string before parenthesis in the name field
                'name_fr', regexp_replace(region_name, ' \(.+\)', ''),
                'name_en', regexp_replace(region_name, ' \(.+\)', ''),
                -- subtitle is the string between parenthesis in the name field
                'subtitle', regexp_replace(region_name, '^.+\((.+)\)$', '\1')
            ) AS region_filter_tags,
            obs_counts.count_obs::integer,
            array_length(obs_counts.taxa_list, 1)::integer as taxa_count,
            taxa_list.taxa_list
        FROM region_type_scale, obs_counts, taxa_list, taxa_groups;
    END;
    $$ LANGUAGE plpgsql STABLE;

    EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => 855385, region_type => 'hex', taxa_keys => ARRAY[10037], min_year => 1950, max_year => 2022);
    
-- ---------------------------------------------------------------------------
-- CREATE MATERIALIZED VIEW FOR regions_obs_taxa_datasets_counts
-- -----------------------------------------------------------------------------
    DROP MATERIALIZED VIEW IF EXISTS atlas_api.obs_regions_taxa_datasets_counts;
    CREATE MATERIALIZED VIEW IF NOT EXISTS atlas_api.obs_regions_taxa_datasets_counts AS
    SELECT
        regions.fid,
        regions.type,
        o.id_taxa_obs,
        o.id_datasets,
        min(o.year_obs) AS min_year,
        max(o.year_obs) AS max_year,
        count(o.id) AS count_obs
    FROM 
        regions,
        observations o,
        -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
        atlas_api.regions_zoom_lookup
    WHERE st_within(o.geom, regions.geom) AND o.within_quebec = regions.within_quebec
        AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
        AND regions.type in ('hex', 'cadre_eco', 'admin') AND o.within_quebec is true
    GROUP BY regions.fid, o.id_datasets, o.id_taxa_obs
    WITH DATA;

    -- CREATE INDEX ON THE MATERIALIZED VIEW
    CREATE INDEX obs_regions_taxa_datasets_counts_type_fid_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (type, fid);

    CREATE INDEX obs_regions_taxa_datasets_counts_fid_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (fid);

    CREATE INDEX obs_regions_taxa_datasets_counts_id_taxa_obs_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (id_taxa_obs);

    CREATE INDEX obs_regions_taxa_datasets_counts_id_datasets_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (id_datasets);

    CREATE INDEX obs_regions_taxa_datasets_counts_min_year_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (min_year);

    CREATE INDEX obs_regions_taxa_datasets_counts_max_year_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (max_year);

-- -----------------------------------------------------------------------------
-- CREATE FUNCTION TO RETURN THE obs_datasets for a given region fid, taxa_id, min_year and max_year
-- -----------------------------------------------------------------------------
    DROP FUNCTION IF EXISTS atlas_api.obs_dataset_summary(integer,text,integer[],integer,integer,integer); 
    CREATE OR REPLACE FUNCTION atlas_api.obs_dataset_summary(
        region_fid integer DEFAULT NULL,
        region_type text DEFAULT NULL,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999)
    RETURNS TABLE (
        dataset text,
        dataset_publisher text,
        dataset_creator text,
        dataset_doi text,
        dataset_license text,
        count_obs integer,
        count_species integer,
        first_year integer,
        last_year integer,
        taxa_groups_fr text,
        taxa_groups_en text
    ) AS $$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        )
        SELECT
            min(d.title) AS dataset,
            min(d.publisher) AS dataset_publisher,
            min(d.creator) AS dataset_creator,
            min(d.doi) AS dataset_doi,
            min(d.license) AS dataset_license,
            sum(counts.count_obs)::integer AS count_obs,
            array_length(api.taxa_branch_tips(counts.id_taxa_obs), 1) AS count_species,
            min(counts.min_year) AS first_year,
            max(counts.max_year) AS last_year,
            string_agg(DISTINCT tg_out.vernacular_fr, ', ') AS taxa_groups_fr,
            string_agg(DISTINCT tg_out.vernacular_en, ', ') AS taxa_groups_en
        FROM
            atlas_api.obs_regions_taxa_datasets_counts counts,
            datasets d,
            taxa,
            taxa_obs_group_lookup tg_out_lu,
            taxa_groups tg_out
        WHERE
            counts.fid = $1
            AND counts.type = $2
            AND counts.id_taxa_obs = taxa.id_taxa_obs
            AND counts.min_year >= $5
            AND counts.max_year <= $6
            AND counts.id_datasets = d.id
            AND tg_out_lu.id_taxa_obs = counts.id_taxa_obs
            AND tg_out_lu.id_group = tg_out.id
			AND tg_out.level = 1
        GROUP BY
            (d.title, d.publisher, d.creator);
    END;
    $$ LANGUAGE plpgsql STABLE;

    SELECT * FROM atlas_api.obs_dataset_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE
    with taxa as (
        select array_agg(id) ids from match_taxa_obs('Acer')
    )
    SELECT atlas_api.obs_dataset_summary(
        region_fid => 855385, taxa_keys => ids, region_type => 'hex', min_year => 1950, max_year => 2022
    )
    FROM taxa;

    EXPLAIN ANALYZE SELECT * FROM atlas_api.obs_dataset_summary(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE SELECT * FROM atlas_api.obs_dataset_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);


-- ---------------------------------------------------------------------------
-- CREATE FUNCTION obs_species_list to download species list for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- -----------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_taxa_list(integer,text,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_taxa_list(
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS SETOF api.taxa AS $$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), region_type_scale as (
            select show_sensitive
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_taxa as (
            SELECT
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list
            FROM atlas_api.temp_obs_regions_taxa_year_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), not_sensitive_taxa as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_taxa
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        )
        SELECT
            taxa.*
        FROM api.taxa, not_sensitive_taxa
        WHERE taxa.id_taxa_obs = ANY (not_sensitive_taxa.taxa_list);
    END;
    $$ LANGUAGE plpgsql STABLE;

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => 855385, region_type => 'hex', taxa_keys => ARRAY[10037], min_year => 1950, max_year => 2022);

-- ---------------------------------------------------------------------------
-- CREATE FUNCTION obs_species_summary to download species summary for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- ---------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_species_summary(integer,integer,text,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_species_summary(
        taxa_key integer,
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS json AS $$
    DECLARE out json;
    BEGIN
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        WITH taxa as (
            SELECT
                valid_scientific_name,
                vernacular_en,
                vernacular_fr
            FROM api.taxa
            WHERE id_taxa_obs = $1
        ), counts as (
            SELECT
                sum(counts.count_obs) as obs_count
            FROM atlas_api.temp_obs_regions_taxa_year_counts counts
            WHERE counts.fid = $2
                AND counts.type = $3
                AND counts.id_taxa_obs = $1
                AND counts.year_obs >= $4
                AND counts.year_obs <= $5
        ), taxa_groups as (
            SELECT
                array_agg(vernacular_fr) as groups_fr,
                array_agg(vernacular_en) as groups_en
            FROM match_taxa_groups(ARRAY[$1])
            WHERE level = 1 OR
                source_desc = 'CDPNQ'
        ), attributes as (
            SELECT
                taxa.*,
                counts.obs_count,
                taxa_groups.*
            FROM taxa, counts, taxa_groups
        )
        SELECT row_to_json(attributes)
        FROM attributes
        INTO out;
        RETURN out;
    END;
    $$ LANGUAGE plpgsql STABLE;

    EXPLAIN ANALYZE select * from atlas_api.obs_species_summary(6525);