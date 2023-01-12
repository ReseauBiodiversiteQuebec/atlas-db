-- DROP FUNCTION IF EXISTS atlas_api.list_species(integer[]);
CREATE OR REPLACE FUNCTION atlas_api.list_species(taxakeys integer[])
RETURNS TABLE (
	id_taxa_obs integer[],
	valid_scientific_name text,
	vernacular_en text,
	vernacular_fr text,
	rank text
) AS
$$
with taxas as (
	select *
	from api.taxa
	where id_taxa_obs = ANY(taxakeys)
		and rank = 'species'
)
select
	array_agg(taxas.id_taxa_obs) id_taxa_obs,
	valid_scientific_name,
	vernacular_en,
	vernacular_fr,
	rank
from taxas
group by valid_scientific_name, vernacular_en, vernacular_fr, rank
$$ LANGUAGE sql stable;

EXPLAIN ANALYZE
WITH params as (
    select array_agg(id) taxakeys from match_taxa_obs('Acer')
)
SELECT species.* from params, list_species(taxakeys) species;