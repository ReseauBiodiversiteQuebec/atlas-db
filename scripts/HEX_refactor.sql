-- Hex table at 250
-- Hex table
-- Obs_taxa_year_counts
--   Includes for 250 for all observations
--   Includes all hexquebec with observations within quebec
-- Obs_taxa-groups_year_counts
--   Includes for 250 for all observations
--   Includes all hexquebec with observations within quebec

-- Get obs function
--  Arguments : bounding box, level, id_taxa_group=NULL, id_taxa_keys=NULL

------------------------------------------------------------------------------
-- 1. CREATE HEX OBS COUNT PER TAXA + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------
    -- DROP MATERIALIZED VIEW IF EXISTS public_api.hex_taxa_year_obs_count CASCADE;
    -- CREATE MATERIALIZED VIEW public_api.hex_taxa_year_obs_count AS
    --     SELECT
    --         hex.fid,
    --         hex.scale,
    --         o.id_taxa_obs,
    --         o.year_obs,
    --         count(o.id) count_obs
    --         FROM
    --             public_api.hexquebec hex,
    --             observations o
    --         WHERE st_within(o.geom, hex.geom)
    --             AND o.within_quebec IS TRUE
    --         GROUP BY (hex.fid, hex.scale, o.id_taxa_obs, o.year_obs)
    --     UNION ALL
    --     SELECT
    --         hex.fid,
    --         250 scale,
    --         o.id_taxa_obs,
    --         o.year_obs,
    --         count(o.id) count_obs
    --         FROM
    --             public_api.hex_250_na hex,
    --             observations o
    --         WHERE st_within(o.geom, hex.geom)
    --         GROUP BY (hex.fid, o.id_taxa_obs, o.year_obs)
    --     WITH DATA;

    -- CREATE INDEX
    --     ON public_api.hex_taxa_year_obs_count (fid);
    -- CREATE INDEX
    --     ON public_api.hex_taxa_year_obs_count (id_taxa_obs);
    -- CREATE INDEX
    --     ON public_api.hex_taxa_year_obs_count (year_obs);

------------------------------------------------------------------------------
-- 3. CREATE HEX OBS COUNT PER TAXA_GROUP + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------


    DROP FUNCTION IF EXISTS public_api.get_hex_counts(
        integer, numeric, numeric, numeric, numeric, integer[], integer
    );
    CREATE FUNCTION public_api.get_hex_counts(
        level integer,
        minX numeric,
        maxX numeric,
        minY numeric,
        maxY numeric,
        taxaKeys integer[] DEFAULT NULL,
        taxaGroupKey integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_collection json;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        WITH hex as (
            SELECT h.geom, h.fid, h.scale
                FROM PUBLIC_API.hexquebec h
                WHERE scale = level
                    AND minX < ST_X(CENTROID) AND ST_X(CENTROID) < -maxX
                    AND minY < ST_Y(CENTROID) AND ST_Y(CENTROID) < maxy
            UNION
            SELECT h.geom, h.fid, 250 scale
                FROM PUBLIC_API.hex_250_na h
                WHERE
                    minX < ST_X(CENTROID) AND ST_X(CENTROID) < -maxX
                    AND minY < ST_Y(CENTROID) AND ST_Y(CENTROID) < maxy
        ), year_agg as (
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    array_agg(DISTINCT(o.id_taxa_obs)) id_taxa_obs
                FROM public_api.hex_taxa_year_obs_count o, hex
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND o.id_taxa_obs = ANY(taxaKeys)
                GROUP BY (o.fid, o.year_obs)
            UNION
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    array_agg(DISTINCT(o.id_taxa_obs)) id_taxa_obs
                FROM public_api.hex_taxa_year_obs_count o,
                    hex,
                    taxa_obs_group_lookup glu
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND glu.id_group = taxaGroupKey
                AND o.id_taxa_obs = glu.id_taxa_obs
                GROUP BY (o.fid, o.year_obs)
        ), fid_agg AS (
            SELECT
                year_agg.fid,
                json_agg(json_build_object(
                    'year', year_agg.year_obs,
                    'obsCount', year_agg.count_obs,
                    'speciesKeys', year_agg.id_taxa_obs
                )) year_counts
            FROM year_agg
            GROUP BY year_agg.fid
        ), features as (
            select hex.geom, fid_agg.year_counts
            FROM hex LEFT JOIN fid_agg ON hex.fid=fid_agg.fid
        )
        SELECT
            json_build_object(
                'type', 'FeatureCollection',
                'features', json_agg(ST_AsGeoJSON(features.*)::json)
                )
            INTO out_collection
            FROM features;
        RETURN out_collection;
    END;
    $$ LANGUAGE plpgsql STABLE;
-- EXPLAIN ANALYZE SELECT public_api.get_hex_counts(100, -76, -68, 45, 50, NULL, 2);

------------------------------------------------------------------------------
-- 3. CREATE HEX OBS COUNT PER TAXA_GROUP + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------


    DROP FUNCTION IF EXISTS public_api.get_hex_year_counts(
        integer, numeric, numeric, numeric, numeric, integer, integer, integer[], integer
    );
    CREATE FUNCTION public_api.get_hex_year_counts(
        level integer,
        minX numeric,
        maxX numeric,
        minY numeric,
        maxy numeric,
        minYear integer DEFAULT 1000,
        maxYear integer DEFAULT 2100,
        taxaKeys integer[] DEFAULT NULL,
        taxaGroupKey integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_collection json;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        WITH hex as (
            SELECT h.geom, h.fid, h.scale
                FROM PUBLIC_API.hexquebec h
                WHERE scale = level
                    AND minX < ST_X(CENTROID) AND ST_X(CENTROID) < -maxX
                    AND minY < ST_Y(CENTROID) AND ST_Y(CENTROID) < maxy
            UNION
            SELECT h.geom, h.fid, 250 scale
                FROM PUBLIC_API.hex_250_na h
                WHERE
                    minX < ST_X(CENTROID) AND ST_X(CENTROID) < -maxX
                    AND minY < ST_Y(CENTROID) AND ST_Y(CENTROID) < maxy
        ), year_agg as (
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o, hex
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND o.id_taxa_obs = ANY(taxaKeys)
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                GROUP BY (o.fid, o.year_obs)
            UNION
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o,
                    hex,
                    taxa_obs_group_lookup glu
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                    AND glu.id_group = taxaGroupKey
                AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY (o.fid, o.year_obs)
        ), fid_agg AS (
            SELECT
                year_agg.fid,
                json_agg(json_build_object(
                    'year', year_agg.year_obs,
                    'obsCount', year_agg.count_obs,
                    'speciesCount', year_agg.count_species
                )) year_counts
            FROM year_agg
            GROUP BY year_agg.fid
        ), features as (
            select hex.geom, fid_agg.year_counts
            FROM hex LEFT JOIN fid_agg ON hex.fid=fid_agg.fid
        )
        SELECT
            json_build_object(
                'type', 'FeatureCollection',
                'features', json_agg(ST_AsGeoJSON(features.*)::json)
                )
            INTO out_collection
            FROM features;
        RETURN out_collection;
    END;
    $$ LANGUAGE plpgsql STABLE;
-- EXPLAIN ANALYZE SELECT public_api.get_hex_year_counts(100, -76, -68, 45, 50, 2000, 2021, NULL, 2);
