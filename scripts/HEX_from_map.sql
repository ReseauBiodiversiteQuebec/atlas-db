CREATE OR REPLACE FUNCTION public_api.hex_scale_from_map_zoom (
    map_zoom integer
) RETURNS integer AS $$
    SELECT
		CASE
			WHEN map_zoom <= 4 THEN 250
			WHEN map_zoom <= 5 THEN 100
			WHEN map_zoom <= 6 THEN 50
			WHEN map_zoom <= 7 THEN 20
			WHEN map_zoom <= 9 THEN 10
			ELSE 5 
			END hex_level
$$ LANGUAGE SQL;