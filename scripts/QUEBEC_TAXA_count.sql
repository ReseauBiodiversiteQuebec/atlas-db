-- DROP FUNCTION IF EXISTS public_api.taxa_quebec_count(integer[]);
CREATE OR REPLACE FUNCTION public_api.taxa_quebec_count(
	taxa_keys integer[])
RETURNS integer AS $$
	SELECT sum(count_obs)
	FROM public_api.hex_taxa_year_obs_count
	WHERE id_taxa_obs = ANY(taxa_keys)
		and scale = 50
$$ LANGUAGE sql STABLE;