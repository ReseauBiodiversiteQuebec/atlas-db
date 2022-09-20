--------------------------------------------------------------------------------
-- CREATE TABLE OF ecozones group richness
--------------------------------------------------------------------------------
    DROP TABLE IF EXISTS public_api.ecozones_species_group_richness CASCADE;
    CREATE TABLE IF NOT EXISTS public_api.ecozones_species_group_richness (
        fid integer,
        niv integer,
        id_group integer,
        richness integer
    );

    CREATE INDEX 
    ON public_api.ecozones_species_group_richness (fid, niv);

    CREATE INDEX 
    ON public_api.ecozones_species_group_richness (id_group);


    INSERT INTO public_api.ecozones_species_group_richness
        SELECT
            cts.fid,
            cts.niv,
            glu.id_group,
            round(count(distinct(cts.id_taxa_obs) * 1.052))
        FROM
            public_api.ecozones_taxa_year_obs_count cts,
            public.taxa_obs_group_lookup glu,
            public.taxa_groups
        WHERE cts.id_taxa_obs = glu.id_taxa_obs
            AND glu.id_group = taxa_groups.id
            AND taxa_groups.level <= 1
        GROUP BY (cts.fid, cts.niv, glu.id_group);

--------------------------------------------------------------------------------
-- CREATE TABLE OF ecozones species richness
--------------------------------------------------------------------------------

    DROP FUNCTION IF EXISTS public_api.get_ecozone_richness(
        integer, numeric, numeric, numeric, numeric, integer[], integer
    );
    CREATE FUNCTION public_api.get_ecozone_richness(
        level integer,
        minX numeric,
        maxX numeric,
        minY numeric,
        maxy numeric,
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
        ), features as (
            SELECT
                    ecozones.geom,
                    ecozones.nom,
                    richness
                FROM public_api.ecozones_species_group_richness r
                RIGHT JOIN ecozones
                    on r.fid = ecozones.fid
                WHERE r.fid = ecozones.fid
                    AND r.niv = ecozones.niv
                    AND r.id_group = taxaGroupKey
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

    EXPLAIN ANALYZE SELECT public_api.get_ecozone_richness(1, -76, -68, 45, 50, NULL, 2);
