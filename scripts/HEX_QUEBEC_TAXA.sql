------------------------------------------------------------------------------
-- 2. CREATE HEX OBS MATERIALIZED VIEW
------------------------------------------------------------------------------
DROP MATERIALIZED VIEW IF EXISTS public_api.hexquebec_obs_lookup CASCADE;
CREATE MATERIALIZED VIEW public_api.hexquebec_obs_lookup
AS
 SELECT
 	h.fid,
	h.scale,
    o.id,
    o.id_taxa_obs,
	o.year_obs
   FROM public_api.hexquebec h,
    observations o
  WHERE o.within_quebec IS TRUE AND st_within(o.geom, h.geom)
WITH DATA;

ALTER TABLE public_api.hexquebec_obs_lookup
    OWNER TO postgres;

GRANT ALL ON TABLE public_api.hexquebec_obs_lookup TO postgres;
GRANT SELECT ON TABLE public_api.hexquebec_obs_lookup TO read_only_all;

CREATE INDEX hex_obs_lookup_fid_idx
    ON public_api.hexquebec_obs_lookup USING btree
    (fid)
    TABLESPACE pg_default;
CREATE INDEX hex_obs_lookup_id_idx
    ON public_api.hexquebec_obs_lookup USING btree
    (id)
    TABLESPACE pg_default;
CREATE INDEX hex_obs_lookup_id_taxa_obs_idx
    ON public_api.hexquebec_obs_lookup USING btree
    (id_taxa_obs)
    TABLESPACE pg_default;

CREATE INDEX hex_obs_lookup_year_obs_idx
    ON public_api.hexquebec_obs_lookup USING btree
    (year_obs)
    TABLESPACE pg_default;


------------------------------------------------------------------------------
-- 3. CREATE GET FUNCTION
------------------------------------------------------------------------------

DROP FUNCTION IF EXISTS public_api.get_hexquebec_taxa(
    integer, numeric, numeric, numeric, numeric, integer[]
);
CREATE FUNCTION public_api.get_hexquebec_taxa(
	zoom integer,
	minx numeric,
	maxx numeric,
	miny numeric,
	maxy numeric,
	taxa_keys integer[])
RETURNS json AS $$
WITH h AS (
	SELECT geom, fid
	FROM PUBLIC_API.hexquebec
	WHERE scale = zoom
		AND minx < ST_X(CENTROID) AND ST_X(CENTROID) < -maxx
		AND miny < ST_Y(CENTROID) AND ST_Y(CENTROID) < maxy
), year_agg as (
	SELECT
		fid,
		year_obs,
		year_obs || ':' || count(id) || ':' || count(id_taxa_obs) as year_counts
	FROM public_api.hexquebec_obs_lookup
	WHERE scale = zoom
		AND id_taxa_obs = ANY(taxa_keys)
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
-- SELECT public_api.get_hexquebec_taxa(100, -76, -68, 45, 50, ARRAY[6450, 8354])
