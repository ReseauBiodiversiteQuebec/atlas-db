-- CREATE TABLE api.bird_cadre_eco_counts
BEGIN;
    CREATE TABLE IF NOT EXISTS api.bird_cadre_eco_counts (
        region_fid integer,
        id_taxa_obs integer,
        month integer,
        year integer,
        count_obs integer
    );

    CREATE INDEX IF NOT EXISTS bird_cadre_eco_counts_region_fid_idx
        ON api.bird_cadre_eco_counts (region_fid);

    CREATE INDEX IF NOT EXISTS bird_cadre_eco_counts_id_taxa_obs_idx
        ON api.bird_cadre_eco_counts (id_taxa_obs);

    CREATE INDEX IF NOT EXISTS bird_cadre_eco_counts_month_idx
        ON api.bird_cadre_eco_counts (month);

    CREATE INDEX IF NOT EXISTS bird_cadre_eco_counts_year_idx
        ON api.bird_cadre_eco_counts (year);

    ALTER TABLE api.bird_cadre_eco_counts OWNER TO postgres;
    GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO read_only_all;
    GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO PUBLIC;
    GRANT TRIGGER, REFERENCES, TRUNCATE, UPDATE, SELECT, INSERT ON TABLE api.bird_cadre_eco_counts TO read_write_all;
    GRANT ALL ON TABLE api.bird_cadre_eco_counts TO postgres;
    GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO read_only_public;
END;

-- CREATE FUNCTION TO UPDATE bird_cadre_eco_counts
CREATE OR REPLACE FUNCTION api.refresh_bird_cadre_eco_counts()
RETURNS void AS
$BODY$
BEGIN
    DELETE FROM api.bird_cadre_eco_counts;

    WITH taxa_obs AS (
            SELECT match_taxa_obs.id,
                match_taxa_obs.scientific_name,
                match_taxa_obs.authorship,
                match_taxa_obs.rank,
                match_taxa_obs.created_at,
                match_taxa_obs.modified_at,
                match_taxa_obs.modified_by
            FROM match_taxa_obs('Aves'::text) match_taxa_obs(id, scientific_name, authorship, rank, created_at, modified_at, modified_by)
            ), distinct_obs AS (
            SELECT DISTINCT ON (obs.id_taxa_obs, obs.dwc_event_date, obs.geom) r.fid AS region_fid,
                obs.id AS obs_id,
                obs.id_taxa_obs,
                obs.month_obs AS month,
                obs.year_obs AS year
            FROM regions r,
                observations obs,
                taxa_obs
            WHERE st_within(obs.geom, r.geom)
                AND taxa_obs.id = obs.id_taxa_obs
                AND obs.within_quebec IS TRUE
                AND r.type::text = 'cadre_eco'::text
            )
    INSERT INTO api.bird_cadre_eco_counts
    SELECT distinct_obs.region_fid,
        distinct_obs.id_taxa_obs,
        distinct_obs.month,
        distinct_obs.year,
        count(distinct_obs.obs_id) AS count_obs
    FROM distinct_obs
    GROUP BY distinct_obs.region_fid, distinct_obs.id_taxa_obs, distinct_obs.month, distinct_obs.year;
END;
$BODY$
LANGUAGE plpgsql;

ALTER FUNCTION api.refresh_bird_cadre_eco_counts()
    OWNER TO postgres;
GRANT EXECUTE ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_write_all;
GRANT EXECUTE ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_only_all;
GRANT EXECUTE ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_only_public;