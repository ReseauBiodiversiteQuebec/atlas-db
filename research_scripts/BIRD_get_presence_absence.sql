-- Create function to generate occurences (true/false) for birds FOR EXHAUSTIVES DATASETS ONLY

drop function if exists api.get_bird_presence_absence(text, integer, integer) cascade;
create function api.get_bird_presence_absence (
	taxa_name text,
    page_limit integer DEFAULT NULL,
    page_offset integer DEFAULT NULL
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
		select distinct on (ref_lookup.id_taxa_obs)
			ref_lookup.id_taxa_obs,
			taxa_ref.id taxa_ref_id,
			taxa_ref.scientific_name taxa_scientific_name
		from match_taxa_obs(taxa_name) taxa_obs
		left join taxa_obs_ref_lookup ref_lookup
			on taxa_obs.id = ref_lookup.id_taxa_obs
		left join taxa_ref
			on ref_lookup.id_taxa_ref_valid = taxa_ref.id
		where ref_lookup.match_type is not NULL
	),
	sampling_pts as (
		select *
		from api.bird_sampling_points
		order by id
        limit (page_limit) offset (page_offset)
		),
	pts_lookup as (
		select distinct on (lookup.id_sampling_points)
			lookup.*, 
			taxa_lookup.taxa_ref_id,
			taxa_lookup.taxa_scientific_name
		from api.bird_sampling_observations_lookup lookup
		join taxa_lookup
			on lookup.id_taxa_obs = taxa_lookup.id_taxa_obs
		where lookup.id_sampling_points in (select id from sampling_pts)
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

explain analyze select * from api.get_bird_presence_absence('Leuconotopicus villosus')