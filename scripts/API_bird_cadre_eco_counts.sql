-- DROP MATERIALIZED VIEW IF EXISTS api.bird_cadre_eco_counts;

-- CREATE MATERIALIZED VIEW api.bird_cadre_eco_counts as
-- select
-- 	r.fid as region_fid,
-- 	id_taxa_obs,
-- 	month_obs as "month",
-- 	year_obs as "year",
-- 	count(obs.id) as count_obs
-- from regions r, observations obs, taxa_obs
-- where st_within(obs.geom, r.geom)
-- 	and taxa_obs.id = obs.id_taxa_obs
-- 	and obs.within_quebec is true
-- 	and type = 'cadre_eco' and scale in (2, 3)
--     and year_obs in (2015, 2016, 2017, 2018, 2019)
-- group by
-- 	r.fid, id_taxa_obs, month_obs, year_obs;
BEGIN
create index
on observations (id_taxa_obs, dwc_event_date, geom);

DROP MATERIALIZED VIEW IF EXISTS api.bird_cadre_eco_counts;

CREATE MATERIALIZED VIEW api.bird_cadre_eco_counts as
with taxa_obs as (
	select * from match_taxa_obs('Aves')
), distinct_obs as (
	select
		distinct on (id_taxa_obs, dwc_event_date, obs.geom)
		r.fid as region_fid,
		obs.id as obs_id,
		id_taxa_obs,
		month_obs as "month",
		year_obs as "year"
	from regions r, observations obs, taxa_obs
	where st_within(obs.geom, r.geom)
		and taxa_obs.id = obs.id_taxa_obs
		and obs.within_quebec is true
		and type = 'cadre_eco' and scale in (2, 3)
)
select
	region_fid,
	id_taxa_obs,
	"month",
	"year",
	count(obs_id) as count_obs
from distinct_obs
group by region_fid, id_taxa_obs, "month", "year";
END;