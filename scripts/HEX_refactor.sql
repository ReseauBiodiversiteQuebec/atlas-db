-- Hex table at 250
-- Hex table
-- Obs_taxa_year_counts
--   Includes for 250 for all observations
--   Includes all hexquebec with observations within quebec

-- Get obs function
--  Arguments : bounding box, years, level, id_taxa_group=NULL, id_taxa_keys=NULL

----------------------------------------------------------------------------
-- 1. CREATE HEX OBS COUNT PER TAXA + YEAR MATERIALIZED VIEW
----------------------------------------------------------------------------
    -- DROP MATERIALIZED VIEW IF EXISTS public_api.hex_taxa_year_obs_count CASCADE;
    CREATE MATERIALIZED VIEW public_api.hex_taxa_year_obs_count AS
        SELECT
            hex.fid,
            hex.scale,
            o.id_taxa_obs,
            o.year_obs,
            count(o.id) count_obs
            FROM
                public_api.hexquebec hex,
                observations o
            WHERE st_within(o.geom, hex.geom)
                AND o.within_quebec IS TRUE
            GROUP BY (hex.fid, hex.scale, o.id_taxa_obs, o.year_obs)
        UNION ALL
        SELECT
            hex.fid,
            250 scale,
            o.id_taxa_obs,
            o.year_obs,
            count(o.id) count_obs
            FROM
                public_api.hex_250_na hex,
                observations o
            WHERE st_within(o.geom, hex.geom)
            GROUP BY (hex.fid, o.id_taxa_obs, o.year_obs)
        WITH DATA;

    CREATE INDEX
        ON public_api.hex_taxa_year_obs_count (fid);
    CREATE INDEX
        ON public_api.hex_taxa_year_obs_count (id_taxa_obs);
    CREATE INDEX
        ON public_api.hex_taxa_year_obs_count (year_obs);

------------------------------------------------------------------------------
-- 2. FUNCTION TO RETURN HEX COUNTS FOR TAXA/TAXA_GROUP + YEARS
------------------------------------------------------------------------------
    DROP FUNCTION IF EXISTS public_api.get_hex_counts(
        integer, numeric, numeric, numeric, numeric, integer, integer, integer[], integer
    );
    CREATE FUNCTION public_api.get_hex_counts(
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
        ), fid_agg as (
            SELECT
                    o.fid,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o, hex
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND o.id_taxa_obs = ANY(taxaKeys)
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                GROUP BY o.fid
            UNION
            SELECT
                    o.fid,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o,
                    hex,
                    taxa_obs_group_lookup glu
                WHERE o.fid = hex.fid AND o.scale = hex.scale
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                    AND glu.id_group = taxaGroupKey
                AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY o.fid
        ), features as (
            select hex.geom, fid_agg.count_obs, fid_agg.count_species
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


------------------------------------------------------------------------------
-- 3. FUNCTION TO RETURN YEAR COUNTS FOR TAXA/TAXA_GROUP
------------------------------------------------------------------------------

    DROP FUNCTION IF EXISTS public_api.get_year_counts(
        integer[], integer
    );
    CREATE FUNCTION public_api.get_year_counts(
        taxaKeys integer[] DEFAULT NULL,
        taxaGroupKey integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        WITH year_counts as (
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o
                WHERE o.scale = 100
                    AND o.id_taxa_obs = ANY(taxaKeys)
                GROUP BY o.year_obs
            UNION
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o,
                    taxa_obs_group_lookup glu
                WHERE o.scale = 100
                    AND glu.id_group = taxaGroupKey
                    AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY o.year_obs
        ), year_range as (
            select
                generate_series(
                    1950,
                    max(year_obs)
                ) as year
            from public_api.hex_taxa_year_obs_count	
        ), all_year_counts as (
            SELECT
                year_range.year,
                coalesce(year_counts.count_obs, 0) count_obs,
                coalesce(year_counts.count_species, 0) count_species
            FROM year_range
            LEFT JOIN year_counts on year_range.year = year_counts.year
            ORDER BY year_range.year
        )
        SELECT
            json_agg(all_year_counts.*)
            INTO out_json
            FROM all_year_counts;
        RETURN out_json;
    END;
    $$ LANGUAGE plpgsql STABLE;
EXPLAIN ANALYZE SELECT public_api.get_year_counts(NULL, 2);

------------------------------------------------------------------------------
-- 3. FUNCTION TO RETURN TOTAL COUNTS FOR TAXA/TAXA_GROUP
------------------------------------------------------------------------------

    DROP FUNCTION IF EXISTS public_api.get_total_counts(
        integer[], integer
    );
    CREATE FUNCTION public_api.get_total_counts(
        taxaKeys integer[] DEFAULT NULL,
        taxaGroupKey integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        WITH total_counts as (
            SELECT
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o
                WHERE o.scale = 100
                    AND o.id_taxa_obs = ANY(taxaKeys)
            UNION
            SELECT
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.hex_taxa_year_obs_count o,
                    taxa_obs_group_lookup glu
                WHERE o.scale = 100
                    AND glu.id_group = taxaGroupKey
                    AND glu.id_taxa_obs = o.id_taxa_obs
        )
        SELECT
            json_agg(total_counts.*)
            INTO out_json
            FROM total_counts
            WHERE total_counts.count_obs is not null;
        RETURN out_json;
    END;
    $$ LANGUAGE plpgsql STABLE;
EXPLAIN ANALYZE SELECT public_api.get_total_counts(NULL, 2);

