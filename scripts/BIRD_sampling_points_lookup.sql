DROP MATERIALIZED VIEW IF EXISTS api.bird_sampling_observations_lookup CASCADE;

CREATE MATERIALIZED VIEW IF NOT EXISTS api.bird_sampling_observations_lookup AS
    SELECT
        obs.id as id_observations,
        pts.id as id_sampling_points,
        lookup.id_taxa_ref_valid as id_taxa_ref,
        min(obs.id_datasets) as id_datasets

    from api.bird_quebec_taxa_ref taxa_ref
    left join (
        select * from taxa_obs_ref_lookup
        where match_type is not null) lookup
        on taxa_ref.id = lookup.id_taxa_ref
    left join observations obs on lookup.id_taxa_obs = obs.id_taxa_obs
    right join api.bird_sampling_points pts
        on obs.geom = pts.geom
        and obs.year_obs = pts.year_obs
        and obs.month_obs = pts.month_obs
        and obs.day_obs = pts.day_obs
        and obs.time_obs = pts.time_obs
    where obs.obs_value is not null
    group by (obs.id, pts.id, lookup.id_taxa_ref_valid);


CREATE INDEX if not exists bird_sampling_observations_lookup_id_observations_idx
    ON api.bird_sampling_observations_lookup (id_observations);

CREATE INDEX if not exists bird_sampling_observations_lookup_id_sampling_points_idx
    ON api.bird_sampling_observations_lookup (id_sampling_points);

CREATE INDEX if not exists bird_sampling_observations_lookup_id_taxa_ref_idx
    ON api.bird_sampling_observations_lookup (id_taxa_ref);
