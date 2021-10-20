-- Create function to generate occurences (true/false) for birds FOR EXHAUSTIVES DATASETS ONLY

drop function if exists api.get_bird_presence_absence(integer, integer, integer) cascade;
create function api.get_bird_presence_absence (
	bird_taxa_id integer,
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
	taxa_id int,
    taxa_scientific_name varchar,
	occurrence boolean
)
language plpgsql STABLE 
as $$
begin
    return query
        select
            public.st_asewkt(
                pts.geom
            ) as geom,
            pts.year_obs,
            pts.month_obs,
            pts.day_obs,
            pts.time_obs,
            obs.id_datasets as dataset_id,
            ds.title as dataset_name,
            pts.id_taxa as taxa_id,
            taxa.scientific_name as taxa_scientific_name,
            (CASE WHEN obs.obs_value IS NULL THEN
                FALSE
            ELSE
                TRUE
            END) AS occurrence
        from (
            select *, bird_taxa_id as id_taxa
            from api.bird_sampling_points
            order by id
            limit (page_limit) offset (page_offset)
            ) pts

        left join (
            select
                _obs.id,
                _obs.id_datasets,
                _obs.obs_value,
                _lookup.id_sampling_points
            from public.observations _obs
            left join api.lookup_bird_sampling_observations _lookup
                on _obs.id = _lookup.id_observations
            where _obs.id_taxa = bird_taxa_id) obs
            on pts.id = obs.id_sampling_points
            
        left join public.taxa taxa on pts.id_taxa = taxa.id
        left join public.datasets ds on obs.id_datasets = ds.id;
end;
$$;

ALTER TABLE api.bird_sampling_points
    OWNER TO admins;

-- explain analyse select * from api.get_bird_presence_absence(bird_taxa_id);