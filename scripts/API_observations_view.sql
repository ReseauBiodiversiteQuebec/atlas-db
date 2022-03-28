DROP VIEW IF EXISTS api.observations CASCADE;
CREATE VIEW api.observations AS (
	select
		obs.id,
		obs.geom,
		obs.year_obs,
		obs.month_obs,
		obs.day_obs,
		obs.time_obs,
		obs.obs_value as value,
		obs.within_quebec,
		var.name as variable,
		var.unit as variable_unit,
		obs.id_taxa_obs,
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
		obs.id_datasets,
		ds.title as dataset,
		ds.original_source as source,
		obs.org_id_obs as source_record_id,
		obs.org_parent_event as source_parent_event,
		obs.org_event as source_event
	from observations obs
	left join api.taxa
		on obs.id_taxa_obs = taxa.id_taxa_obs
	left join datasets ds
		on obs.id_datasets = ds.id
	left join variables var
		on obs.id_variables = var.id
);