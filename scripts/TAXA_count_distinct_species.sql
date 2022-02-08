-- FUNCTIONS counts distinct species considering
-- - Synonyms
-- - Mismatch between ref source valid names


drop function if exists count_distinct_species;

create function count_distinct_species(
	taxa_obs_keys int[]
)
returns int as
$$
with distinct_species as (
	select
		distinct on (scientific_name)
		ref_lookup.id_taxa_obs
	from
		taxa_obs_ref_lookup ref_lookup,
		taxa_ref
	where
		ref_lookup.id_taxa_obs = any(taxa_obs_keys)
		and ref_lookup.id_taxa_ref = taxa_ref.id
		and taxa_ref.valid is true
		and taxa_ref.rank = 'species')
select
	count(distinct(id_taxa_obs))
from distinct_species
$$ LANGUAGE sql;
