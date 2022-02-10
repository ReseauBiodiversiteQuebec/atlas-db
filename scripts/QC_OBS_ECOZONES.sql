------------------------------------------------------------------------------
-- 2. CREATE OBS MATERIALIZED VIEW
------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS public_api.ecozones_obs_lookup CASCADE;
CREATE MATERIALIZED VIEW public_api.ecozones_obs_lookup
AS
 SELECT h.fid,
	h.niv,
	o.id,
    o.id_taxa_obs,
	o.year_obs
   FROM public_api.cadre_eco_quebec h,
    observations o
  WHERE o.within_quebec IS TRUE AND st_within(o.geom, h.geom)
WITH DATA;

ALTER TABLE public_api.ecozones_obs_lookup
    OWNER TO postgres;

GRANT ALL ON TABLE public_api.ecozones_obs_lookup TO postgres;
GRANT SELECT ON TABLE public_api.ecozones_obs_lookup TO read_only_all;
GRANT SELECT ON TABLE public_api.ecozones_obs_lookup TO read_only_public;

CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (fid)
    TABLESPACE pg_default;

CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (niv)
    TABLESPACE pg_default;

CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (id)
    TABLESPACE pg_default;
CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (id_taxa_obs)
    TABLESPACE pg_default;

CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (year_obs)
    TABLESPACE pg_default;

CREATE INDEX
    ON public_api.ecozones_obs_lookup USING btree
    (niv, id_taxa_obs)
    TABLESPACE pg_default;



------------------------------------------------------------------------------
-- 3. CREATE GET FUNCTION
------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS public_api.get_obs_ecozones(
    integer, numeric, numeric, numeric, numeric, integer[]
);
CREATE FUNCTION public_api.get_obs_ecozones(
	level integer,
	minx numeric,
	maxx numeric,
	miny numeric,
	maxy numeric,
	taxa_keys integer[])
RETURNS json AS $$
WITH bbox AS (
	SELECT ST_POLYGON(
	FORMAT('LINESTRING(%s %s, %s %s, %s %s, %s %s, %s %s)',
		   minx, miny, maxx, miny, maxx, maxy, minx, maxy, minx, miny), 4326
	) as geometry
), h AS (
	SELECT simple_geom, fid
	FROM PUBLIC_API.cadre_eco_quebec, bbox
	WHERE niv = level
		AND ST_INTERSECTS(geom, bbox.geometry)
), year_agg as (
	SELECT
		fid,
		year_obs,
		year_obs || ':' || count(id) || ':' || count(id_taxa_obs) as year_counts
	FROM public_api.ecozones_obs_lookup
	WHERE niv = level AND id_taxa_obs = ANY(taxa_keys)
	GROUP BY (fid, year_obs)
), fid_agg AS (
	SELECT
		fid,
		json_agg(year_counts) year_counts
	FROM year_agg
	GROUP BY fid
), features as (
	select h.geom, fid_agg.year_counts
	FROM h LEFT JOIN fid_agg ON h.fid=fid_agg.fid
) 
SELECT
	json_build_object(
		'type', 'FeatureCollection',
		'features', json_agg(ST_AsGeoJSON(features.*)::json)
		)
FROM features
$$ LANGUAGE sql STABLE;
-- SELECT public_api.get_obs_ecozones(100, -76, -68, 45, 50, ARRAY[6450, 8354])
