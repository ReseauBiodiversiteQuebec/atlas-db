CREATE OR REPLACE VIEW api.time_series AS (
	select
		ts.*,
		taxa.observed_scientific_name taxa_observed_scientific_name,
		taxa.valid_scientific_name taxa_valid_scientific_name,
		taxa.vernacular_en taxa_vernacular_en,
		taxa.vernacular_fr taxa_vernacular_fr,
		taxa.group_en taxa_group_en,
		taxa.group_fr taxa_group_fr,
		ds.type_sampling,
		ds.type_obs,
		ds.title as dataset,
		ds.original_source as source
	from time_series ts
	left join api.taxa
		on ts.id_taxa_obs = taxa.id_taxa_obs
	left join datasets ds
		on ts.id_datasets = ds.id
);