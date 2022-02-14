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
    DROP MATERIALIZED VIEW IF EXISTS public_api.ecozones_taxa_year_obs_count CASCADE;
    CREATE MATERIALIZED VIEW public_api.ecozones_taxa_year_obs_count AS
        SELECT
            ecozones.fid,
            ecozones.niv,
            o.id_taxa_obs,
            o.year_obs,
            count(o.id) count_obs
            FROM
                public_api.cadre_eco_quebec ecozones,
                observations o
            WHERE st_within(o.geom, ecozones.geom)
                AND o.within_quebec IS TRUE
            GROUP BY (ecozones.fid, ecozones.niv, o.id_taxa_obs, o.year_obs)
        WITH DATA;

    CREATE INDEX
        ON public_api.ecozones_taxa_year_obs_count (fid);
    CREATE INDEX
        ON public_api.ecozones_taxa_year_obs_count (id_taxa_obs);
    CREATE INDEX
        ON public_api.ecozones_taxa_year_obs_count (year_obs);

------------------------------------------------------------------------------
-- 2. CREATE ecozones OBS COUNT PER TAXA_GROUP + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------
    DROP MATERIALIZED VIEW IF EXISTS public_api.ecozones_taxagroup_year_obs_count CASCADE;
    CREATE MATERIALIZED VIEW public_api.ecozones_taxagroup_year_obs_count AS
        SELECT
            mv.fid,
            mv.niv,
            mv.year_obs,
            glu.id_group id_taxa_group,
            sum(mv.count_obs) count_obs,
            array_agg(mv.id_taxa_obs) id_taxa_obs
            FROM
                public_api.ecozones_taxa_year_obs_count mv,
                taxa_obs_group_lookup glu
            WHERE mv.id_taxa_obs = glu.id_taxa_obs
            GROUP BY (mv.fid, mv.niv, mv.year_obs, glu.id_group)
        WITH DATA;

    CREATE INDEX
        ON public_api.ecozones_taxagroup_year_obs_count (fid);
    CREATE INDEX
        ON public_api.ecozones_taxagroup_year_obs_count (id_taxa_group);
    CREATE INDEX 
        ON public_api.ecozones_taxagroup_year_obs_count (year_obs);

------------------------------------------------------------------------------
-- 3. CREATE ecozones OBS COUNT PER TAXA_GROUP + YEAR MATERIALIZED VIEW
------------------------------------------------------------------------------


    DROP FUNCTION IF EXISTS public_api.get_ecozone_counts(
        integer, numeric, numeric, numeric, numeric, integer[], integer
    );
    CREATE FUNCTION public_api.get_ecozone_counts(
        level integer,
        minx numeric,
        maxx numeric,
        miny numeric,
        maxy numeric,
        taxa_keys integer[] DEFAULT NULL,
        taxa_group_key integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_collection json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` or `taxa_keys` can be specified';
        END IF;

        WITH bbox AS (
			SELECT ST_POLYGON(
			FORMAT('LINESTRING(%s %s, %s %s, %s %s, %s %s, %s %s)',
				minx, miny, maxx, miny, maxx, maxy, minx, maxy, minx, miny), 4326
			) as geometry
		), ecozones AS (
			SELECT simple_geom geom, fid, niv
			FROM PUBLIC_API.cadre_eco_quebec, bbox
			WHERE niv = level
				AND ST_INTERSECTS(geom, bbox.geometry)
        ), year_agg as (
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    array_agg(DISTINCT(o.id_taxa_obs)) id_taxa_obs
                FROM public_api.ecozones_taxa_year_obs_count o, ecozones
                WHERE o.fid = ecozones.fid AND o.niv = ecozones.niv
                    AND o.id_taxa_obs = ANY(taxa_keys)
                GROUP BY (o.fid, o.year_obs)
            UNION
            SELECT
                    o.fid,
                    o.year_obs,
                    sum(o.count_obs) count_obs,
                    array_agg(DISTINCT(o.id_taxa_obs)) id_taxa_obs
                FROM public_api.ecozones_taxagroup_year_obs_count o
                RIGHT JOIN ecozones on o.fid = ecozones.fid AND o.niv = ecozones.niv
                WHERE o.id_taxa_group = taxa_group_key
                GROUP BY (o.fid, o.year_obs)
        ), fid_agg AS (
            SELECT
                year_agg.fid,
                json_agg(json_build_object(
                    'year', year_agg.year_obs,
                    'count_obs', year_agg.count_obs,
                    'id_taxa_list', year_agg.id_taxa_obs
                )) year_counts
            FROM year_agg
            GROUP BY year_agg.fid
        ), features as (
            select ecozones.geom, fid_agg.year_counts
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
SELECT public_api.get_ecozone_counts(1, -76, -68, 45, 50, NULL, 2);
