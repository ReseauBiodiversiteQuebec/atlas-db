-- ecozones table
-- Obs_taxa_year_counts
--   Includes all cadre_eco_quebec with observations within quebec
-- Obs_taxa-groups_year_counts
--   Includes all cadre_eco_quebec with observations within quebec

-- Get obs function
--  Arguments : bounding box, level, id_taxa_group=NULL, id_taxa_keys=NULL

------------------------------------------------------------------------------
-- 1. CREATE ecozones OBS COUNT PER TAXA + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------
    -- DROP MATERIALIZED VIEW IF EXISTS public_api.ecozones_taxa_year_obs_count CASCADE;
    -- CREATE MATERIALIZED VIEW public_api.ecozones_taxa_year_obs_count AS
    --     SELECT
    --         ecozones.fid,
    --         ecozones.niv,
    --         o.id_taxa_obs,
    --         o.year_obs,
    --         count(o.id) count_obs
    --         FROM
    --             public_api.cadre_eco_quebec ecozones,
    --             observations o
    --         WHERE st_within(o.geom, ecozones.geom)
    --             AND o.within_quebec IS TRUE
    --         GROUP BY (ecozones.fid, ecozones.niv, o.id_taxa_obs, o.year_obs)
    --     WITH DATA;

    -- CREATE INDEX
    --     ON public_api.ecozones_taxa_year_obs_count (fid);
    -- CREATE INDEX
    --     ON public_api.ecozones_taxa_year_obs_count (id_taxa_obs);
    -- CREATE INDEX
    --     ON public_api.ecozones_taxa_year_obs_count (year_obs);

------------------------------------------------------------------------------
-- 2. FUNCTION TO RETURN ECOZONES COUNTS FOR TAXA/TAXA_GROUP + YEARS
------------------------------------------------------------------------------
    DROP FUNCTION IF EXISTS public_api.get_ecozone_counts(
        integer, numeric, numeric, numeric, numeric, integer, integer, integer[], integer
    );
    CREATE FUNCTION public_api.get_ecozone_counts(
        level integer,
        minX numeric,
        maxX numeric,
        minY numeric,
        maxy numeric,
        minYear integer DEFAULT 1950,
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

        WITH bbox AS (
			SELECT ST_POLYGON(
			FORMAT('LINESTRING(%s %s, %s %s, %s %s, %s %s, %s %s)',
				minX, minY, maxX, minY, maxX, maxY, minX, maxY, minX, minY), 4326
			) as geometry
		), ecozones AS (
			SELECT simple_geom geom, fid, niv, nom
			FROM PUBLIC_API.cadre_eco_quebec, bbox
			WHERE niv = level
				AND ST_INTERSECTS(geom, bbox.geometry)
        ), fid_agg as (
            SELECT
                    o.fid,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.ecozones_taxa_year_obs_count o, ecozones
                WHERE o.fid = ecozones.fid AND o.niv = ecozones.niv
                    AND o.id_taxa_obs = ANY(taxaKeys)
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                GROUP BY o.fid
            UNION
            SELECT
                    o.fid,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM public_api.ecozones_taxa_year_obs_count o,
                    ecozones,
                    taxa_obs_group_lookup glu
                WHERE o.fid = ecozones.fid AND o.niv = ecozones.niv
                    AND o.year_obs >= minYear AND o.year_obs <= maxYear
                    AND glu.id_group = taxaGroupKey
                AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY o.fid
        ), features as (
            select ecozones.geom, ecozones.nom, fid_agg.count_obs, fid_agg.count_species
            FROM ecozones LEFT JOIN fid_agg ON ecozones.fid=fid_agg.fid
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

    EXPLAIN ANALYZE SELECT public_api.get_ecozone_counts(1, -76, -68, 45, 50, 2000, 2021, NULL, 2);