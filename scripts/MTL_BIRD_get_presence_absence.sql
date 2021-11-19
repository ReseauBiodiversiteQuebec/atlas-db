-- Create function to generate occurences (true/false) for birds FOR EXHAUSTIVES DATASETS ONLY

drop function if exists api.get_mtl_bird_presence_absence(integer) cascade;
create function api.get_mtl_bird_presence_absence (
	taxa_ref_key integer
)
returns table (
	geom text,
	year_obs int,
	month_obs int,
	day_obs int,
    time_obs time,
	dataset_id int,
    dataset_name varchar,
	taxa_ref_id int,
    taxa_scientific_name varchar,
	occurrence boolean
)
as $$
with 
	taxa_lookup as (
		select distinct on (obs_lookup.id_taxa_obs)
			obs_lookup.id_taxa_obs,
			f_ref.id taxa_ref_id,
			f_ref.scientific_name taxa_scientific_name
		from taxa_obs_ref_lookup ref_lookup
		left join taxa_ref f_ref
			on ref_lookup.id_taxa_ref_valid = f_ref.id
		left join taxa_obs_ref_lookup obs_lookup
			on ref_lookup.id_taxa_ref_valid = obs_lookup.id_taxa_ref_valid
		where ref_lookup.id_taxa_ref = taxa_ref_key
	),
	sampling_pts as (
		select *
		from api.bird_sampling_points
		where public.st_within (geom , (
			select public.ST_UNION (wkb_geometry)
			from montreal_terrestrial_limits))
	),
	pts_lookup as (
		select distinct on (lookup.id_sampling_points)
			lookup.*, 
			taxa_lookup.taxa_ref_id,
			taxa_lookup.taxa_scientific_name
		from taxa_lookup
		left join api.bird_sampling_observations_lookup lookup
			on taxa_lookup.id_taxa_obs = lookup.id_taxa_obs
	)
select
	public.st_asewkt(
		pts.geom
	) as geom,
	pts.year_obs,
	pts.month_obs,
	pts.day_obs,
	pts.time_obs,
	pts_lookup.id_datasets as dataset_id,
	ds.title as dataset_title,
	pts_lookup.taxa_ref_id,
    pts_lookup.taxa_scientific_name,
	(CASE WHEN pts_lookup.id_observations IS NULL THEN
		FALSE
	ELSE
		TRUE
	END) AS occurrence
from pts_lookup
left join datasets ds on pts_lookup.id_datasets = ds.id
right join sampling_pts pts
	on pts_lookup.id_sampling_points = pts.id
$$ LANGUAGE SQL STABLE;