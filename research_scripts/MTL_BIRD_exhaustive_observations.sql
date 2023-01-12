DROP VIEW IF EXISTS api.mtl_bird_exhaustive_observations CASCADE;
CREATE VIEW api.mtl_bird_exhaustive_observations AS (
	with mtl as (
		select ST_UNION(wkb_geometry) geom
		from montreal_terrestrial_limits
	)
	select obs.*
	from api.bird_sampling_observations_lookup lookup
	left join api.observations obs
		on obs.id = lookup.id_observations
	where st_within(obs.geom, (select geom from mtl))
);