
-- -----------------------------------------------------------------------------
-- CREATE SCHEMA for atlas api
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

    -- GRANT SELECT ON ALL TABLES, SEQUENCES, AND VIEWS IN SCHEMA atlas_api TO read_only_public;



    GRANT SELECT ON ALL TABLES IN SCHEMA atlas_api TO read_only_public;

    GRANT SELECT ON ALL SEQUENCES IN SCHEMA atlas_api TO read_only_public;

    GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA atlas_api TO read_only_public;

    GRANT read_only_public TO read_only_all;

    GRANT read_only_public TO read_write_all;

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
-- ----------------------------------------------------------------------------```

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

    CREATE UNIQUE INDEX web_regions_fid_idx ON atlas_api.web_regions (fid);

    CREATE INDEX web_regions_type_idx ON atlas_api.web_regions (type);

    CREATE INDEX web_regions_scale_idx ON atlas_api.web_regions (scale);

    CREATE INDEX web_regions_type_scale_idx ON atlas_api.web_regions (type, scale);

