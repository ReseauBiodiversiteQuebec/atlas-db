drop materialized view if exists api.bird_quebec_taxa_ref cascade;

create materialized view if not exists api.bird_quebec_taxa_ref as
with extent as (
	SELECT ST_POLYGON (
	'LINESTRING(-79.8 62.56,-57.1 62.56,-57.1 45, -79.8 45, -79.8 62.56)',
	4326)
)
select distinct r_ref.*
from taxa_ref s_ref
left join taxa_obs_ref_lookup s_lookup
	on s_ref.id = s_lookup.id_taxa_ref
left join observations obs
	on s_lookup.id_taxa_obs = obs.id_taxa_obs
left join taxa_obs_ref_lookup r_lookup
	on s_lookup.id_taxa_obs = r_lookup.id_taxa_obs
left join taxa_ref r_ref
	on r_lookup.id_taxa_ref = r_ref.id
where s_ref.scientific_name = 'Aves'
	and ST_CONTAINS((SELECT * FROM extent), obs.geom)
