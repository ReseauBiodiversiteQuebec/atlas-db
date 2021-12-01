DROP VIEW if exists api.taxa CASCADE;
CREATE VIEW api.taxa AS (
	with obs_ref as (
		select
			obs_lookup.id_taxa_obs,
            MIN(taxa_obs.scientific_name) observed_scientific_name,
			taxa_ref.scientific_name valid_scientific_name,
			taxa_ref.rank,
			json_agg(json_build_object(
			   'source_name', taxa_ref.source_name,
			   'source_taxon_key', taxa_ref.source_record_id)) as source_references
		from taxa_obs_ref_lookup obs_lookup
        left join taxa_obs on obs_lookup.id_taxa_obs = taxa_obs.id
		left join taxa_ref on obs_lookup.id_taxa_ref_valid = taxa_ref.id
		where obs_lookup.match_type is not null
		group by (obs_lookup.id_taxa_obs, taxa_ref.scientific_name, taxa_ref.rank)
	), obs_group as (
		select
			distinct on (group_lookup.id_taxa_obs)
			group_lookup.id_taxa_obs,
			taxa_groups.vernacular_en as group_en,
			taxa_groups.vernacular_fr as group_fr
		from taxa_obs_group_lookup group_lookup
		left join taxa_groups on group_lookup.id_group = taxa_groups.id
		where taxa_groups.level = 1
	), vernacular_all as(
		select v_lookup.id_taxa_obs, taxa_vernacular.*
		from taxa_obs_vernacular_lookup v_lookup
		left join taxa_vernacular on v_lookup.id_taxa_vernacular = taxa_vernacular.id
		where match_type is not null
	), best_vernacular as (
		select
			ver_en.id_taxa_obs,
			ver_en.name as vernacular_en,
			ver_fr.name as vernacular_fr
		from (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'eng') as ver_en
		left join (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'fra') as ver_fr
			on ver_en.id_taxa_obs = ver_fr.id_taxa_obs
	), vernacular_group as (
		select 
			vernacular_all.id_taxa_obs,
			json_agg(json_build_object(
				'name', vernacular_all.name,
				'source', vernacular_all.source_name,
				'source_taxon_key', vernacular_all.source_record_id,
				'language', vernacular_all.language
			)) as vernacular
		from vernacular_all
		group by vernacular_all.id_taxa_obs
	)
	select
		distinct on (obs_ref.id_taxa_obs, obs_ref.valid_scientific_name)
		obs_ref.id_taxa_obs,
        obs_ref.observed_scientific_name,
		obs_ref.valid_scientific_name,
		obs_ref.rank,
		best_vernacular.vernacular_en,
		best_vernacular.vernacular_fr,
		obs_group.group_en,
		obs_group.group_fr,
		vernacular_group.vernacular,
		obs_ref.source_references
	from obs_ref
	left join vernacular_group
		on obs_ref.id_taxa_obs = vernacular_group.id_taxa_obs
	left join obs_group
		on obs_ref.id_taxa_obs = obs_group.id_taxa_obs
	left join best_vernacular
		on obs_ref.id_taxa_obs = best_vernacular.id_taxa_obs
	ORDER BY obs_ref.id_taxa_obs, obs_ref.valid_scientific_name,
        best_vernacular.vernacular_en NULLS LAST
)
