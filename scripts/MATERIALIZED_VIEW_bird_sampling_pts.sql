-- Create materialized view for obs points of birds for more rapid occurence generation

-- Drop resourcs from previous naming
DROP INDEX if exists public.observations_geom_year_month_day_idx;

-- Observations indexing for faster join / materialized views

CREATE INDEX if not exists observations_id_taxa_idx
   ON public.observations (id_taxa);

CREATE INDEX if not exists observations_geom_date_time_idx
   ON public.observations (geom, year_obs, month_obs, day_obs, time_obs);

-- BIRD SAMPLING POINTS AND INDEXES

DROP MATERIALIZED VIEW IF EXISTS api.bird_sampling_points CASCADE;

CREATE MATERIALIZED VIEW IF NOT EXISTS api.bird_sampling_points AS
select
	row_number() over( order by pts.geom, pts.year_obs, pts.month_obs, pts.day_obs, pts.time_obs ) as id,
    pts.geom,
	pts.year_obs,
	pts.month_obs,
	pts.day_obs,
	pts.time_obs
from (
	select distinct
		obs.geom,
		obs.year_obs,
		obs.month_obs,
		obs.day_obs, 
		obs.time_obs
	from public.observations obs
	left join public.datasets as ds on obs.id_datasets = ds.id
	where 
		ds.title in (
			'Atlas des Oiseaux Nicheurs du Québec',
			'eBird Basic Dataset') and
		ds.exhaustive = true
	 ) pts
order by id;

CREATE INDEX if not exists bird_sampling_points_id_idx
    ON api.bird_sampling_points (id);

CREATE INDEX if not exists bird_sampling_points_points_geom_date_time_idx
    ON api.bird_sampling_points (geom, year_obs, month_obs, day_obs, time_obs);

