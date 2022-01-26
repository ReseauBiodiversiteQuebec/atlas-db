DROP MATERIALIZED VIEW IF EXISTS public_api.taxa_obs_quebec_count;
CREATE MATERIALIZED VIEW public_api.taxa_obs_quebec_count AS
SELECT
	id_taxa_obs,
	count(id) as taxa_count
FROM public.observations
WHERE within_quebec IS TRUE
GROUP BY id_taxa_obs;

DROP FUNCTION IF EXISTS public_api.taxa_quebec_count(integer[]);
CREATE FUNCTION public_api.taxa_quebec_count(
	taxa_keys integer[])
RETURNS integer AS $$
	SELECT sum(taxa_count)
	FROM public_api.taxa_obs_quebec_count
	WHERE id_taxa_obs = ANY(taxa_keys);
$$ LANGUAGE sql STABLE;