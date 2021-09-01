DROP MATERIALIZED VIEW IF EXISTS api.lookup_bird_sampling_observations CASCADE;

CREATE MATERIALIZED VIEW IF NOT EXISTS api.lookup_bird_sampling_observations AS
    SELECT DISTINCT
        obs.id as id_observations,
        pts.id as id_sampling_points,
        obs.id_taxa as id_taxa
    from api.quebec_observed_bird_taxa bird
    right join observations obs on bird.id_taxa = obs.id_taxa
    left join api.bird_sampling_points pts
        on obs.geom = pts.geom
        and obs.year_obs = pts.year_obs
        and obs.month_obs = pts.month_obs
        and obs.day_obs = pts.day_obs
        and obs.time_obs = pts.time_obs;

CREATE INDEX if not exists lookup_bird_sampling_observations_id_observations_idx
    ON api.lookup_bird_sampling_observations (id_observations);

CREATE INDEX if not exists lookup_bird_sampling_observations_id_sampling_points_idx
    ON api.lookup_bird_sampling_observations (id_sampling_points);

CREATE INDEX if not exists lookup_bird_sampling_observations_id_taxa_idx
    ON api.lookup_bird_sampling_observations (id_taxa);