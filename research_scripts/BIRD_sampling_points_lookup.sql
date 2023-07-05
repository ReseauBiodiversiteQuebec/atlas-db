DROP MATERIALIZED VIEW IF EXISTS api.bird_sampling_observations_lookup CASCADE;

CREATE MATERIALIZED VIEW IF NOT EXISTS api.bird_sampling_observations_lookup AS
    with ds as (
        select id from datasets
        where datasets.title in (
        'Atlas des Oiseaux Nicheurs du Québec',
        'eBird Basic Dataset') and datasets.exhaustive = true
    ), obs as (
        select *
        from observations obs
        where id_datasets in (select id from ds)
    )
    SELECT distinct on (obs.id, pts.id, obs.id_taxa_obs)
        obs.id as id_observations,
        pts.id as id_sampling_points,
        obs.id_taxa_obs as id_taxa_obs,
        obs.id_datasets as id_datasets

    from obs
    left join api.bird_sampling_points pts
        on obs.geom = pts.geom
        and obs.year_obs = pts.year_obs
        and obs.month_obs = pts.month_obs
        and obs.day_obs = pts.day_obs
        and obs.time_obs = pts.time_obs
    where obs.obs_value is not null;

CREATE INDEX if not exists bird_sampling_observations_lookup_id_observations_idx
    ON api.bird_sampling_observations_lookup (id_observations);

CREATE INDEX if not exists bird_sampling_observations_lookup_id_sampling_points_idx
    ON api.bird_sampling_observations_lookup (id_sampling_points);

CREATE INDEX if not exists bird_sampling_observations_lookup_id_taxa_obs_idx
    ON api.bird_sampling_observations_lookup (id_taxa_obs);
