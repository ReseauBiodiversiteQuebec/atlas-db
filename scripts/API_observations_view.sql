DROP VIEW IF EXISTS api.observations CASCADE;
CREATE VIEW api.observations AS (
select
		st_astext(obs.geom),
		obs.year_obs as year,
		obs.month_obs as month,
		obs.day_obs as day,
		obs.time_obs as time,
		obs.obs_value as value,
		var.name as variable,
		var.unit as variable_unit,
		taxa.observed_scientific_name taxa_observed_scientific_name,
		taxa.valid_scientific_name taxa_valid_scientific_name,
		taxa.vernacular_en taxa_vernacular_en,
		taxa.vernacular_fr taxa_vernacular_fr,
		taxa.group_en taxa_group_en,
		taxa.group_fr taxa_group_fr,
		taxa.vernacular taxa_vernacular_sources,
		taxa.source_references taxa_reference_sources,
		ds.type_sampling,
		ds.type_obs,
		ds.title as dataset,
		ds.original_source as source,
		obs.org_id_obs as source_record_id
	from observations obs
	left join api.taxa
		on obs.id_taxa_obs = taxa.id_taxa_obs
	left join datasets ds
		on obs.id_datasets = ds.id
	left join variables var
		on obs.id_variables = var.id
);