DROP FUNCTION IF EXISTS public_api.get_taxa_obs_range(integer[], integer, integer, integer);
CREATE OR REPLACE FUNCTION public_api.get_taxa_obs_range(
    taxa_keys integer[],
    tilezoom integer
) RETURNS json AS $$
    WITH features AS (
        SELECT ST_UNION(geom) geom
        FROM
            public_api.hexquebec hex,
            public_api.hex_taxa_year_obs_count hlu
        WHERE hex.fid = hlu.fid
            and hex.scale = hlu.scale
            and hlu.id_taxa_obs = ANY (taxa_keys)
            and hex.scale = greatest(
                least(50, public_api.hex_scale_from_map_zoom(tilezoom)),
                10)
    )
    SELECT ST_AsGEOJSON(features.*)::json
    FROM features
$$ LANGUAGE SQL STABLE;
EXPLAIN ANALYZE SELECT public_api.get_taxa_obs_range(ARRAY[6450, 8354], 7);