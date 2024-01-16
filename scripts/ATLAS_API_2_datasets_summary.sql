-- -----------------------------------------------------------------------------
-- CREATE GENERATED TABLE FOR obs_regions_taxa_datasets_counts
-- -----------------------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS atlas_api.obs_regions_taxa_datasets_counts (
        fid integer NOT NULL,
        type text NOT NULL,
        id_taxa_obs integer NOT NULL,
        id_datasets integer NOT NULL,
        min_year integer NOT NULL,
        max_year integer NOT NULL,
        count_obs integer NOT NULL
    );

    -- CREATE INDEX ON THE GENERATED TABLE
    CREATE INDEX obs_regions_taxa_datasets_counts_type_fid_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (type, fid);

    CREATE INDEX obs_regions_taxa_datasets_counts_fid_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (fid);

    CREATE INDEX obs_regions_taxa_datasets_counts_id_taxa_obs_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (id_taxa_obs);

    CREATE INDEX obs_regions_taxa_datasets_counts_id_datasets_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (id_datasets);

    CREATE INDEX obs_regions_taxa_datasets_counts_min_year_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (min_year);

    CREATE INDEX obs_regions_taxa_datasets_counts_max_year_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (max_year);

    CREATE UNIQUE INDEX obs_regions_taxa_datasets_counts_fid_id_taxa_obs_id_datasets_idx
        ON atlas_api.obs_regions_taxa_datasets_counts (fid, id_taxa_obs, id_datasets);
    

    -- CREATE FUNCTION TO REFRESH THE GENERATED TABLE
    CREATE FUNCTION atlas_api.obs_regions_taxa_datasets_counts_refresh()
        RETURNS void AS
        $$
        BEGIN
            DELETE FROM atlas_api.obs_regions_taxa_datasets_counts;
            INSERT INTO atlas_api.obs_regions_taxa_datasets_counts (
                fid,
                type,
                id_taxa_obs,
                id_datasets,
                min_year,
                max_year,
                count_obs
            )
            SELECT
                regions.fid,
                regions.type,
                o.id_taxa_obs,
                o.id_datasets,
                min(o.year_obs) AS min_year,
                max(o.year_obs) AS max_year,
                count(o.id) AS count_obs
            FROM 
                regions,
                observations o,
                -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
                atlas_api.regions_zoom_lookup
            WHERE st_within(o.geom, regions.geom) AND o.within_quebec = regions.within_quebec
                AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
            GROUP BY regions.fid, o.id_datasets, o.id_taxa_obs;
        END;
        $$ LANGUAGE plpgsql;




-- -----------------------------------------------------------------------------
-- CREATE FUNCTION TO RETURN THE obs_datasets for a given region fid, taxa_id, min_year and max_year
-- -----------------------------------------------------------------------------
    -- DROP FUNCTION IF EXISTS atlas_api.obs_dataset_summary(integer,text,integer[],integer,integer,integer); 
    CREATE OR REPLACE FUNCTION atlas_api.obs_dataset_summary(
        region_fid integer DEFAULT NULL,
        region_type text DEFAULT NULL,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999)
    RETURNS TABLE (
        dataset text,
        dataset_publisher text,
        dataset_creator text,
        dataset_doi text,
        dataset_license text,
        count_obs integer,
        count_species integer,
        first_year integer,
        last_year integer,
        taxa_groups_fr text,
        taxa_groups_en text
    ) AS $$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        )
        SELECT
            min(d.title) AS dataset,
            min(d.publisher) AS dataset_publisher,
            min(d.creator) AS dataset_creator,
            min(d.doi) AS dataset_doi,
            min(d.license) AS dataset_license,
            sum(counts.count_obs)::integer AS count_obs,
            array_length(api.taxa_branch_tips(counts.id_taxa_obs), 1) AS count_species,
            min(counts.min_year) AS first_year,
            max(counts.max_year) AS last_year,
            string_agg(DISTINCT tg_out.vernacular_fr, ', ') AS taxa_groups_fr,
            string_agg(DISTINCT tg_out.vernacular_en, ', ') AS taxa_groups_en
        FROM
            atlas_api.obs_regions_taxa_datasets_counts counts,
            datasets d,
            taxa,
            taxa_obs_group_lookup tg_out_lu,
            taxa_groups tg_out
        WHERE
            counts.fid = $1
            AND counts.type = $2
            AND counts.id_taxa_obs = taxa.id_taxa_obs
            AND counts.min_year <= $6
            AND counts.max_year >= $5
            AND counts.id_datasets = d.id
            AND tg_out_lu.id_taxa_obs = counts.id_taxa_obs
            AND tg_out_lu.id_group = tg_out.id
			AND tg_out.level = 1
        GROUP BY
            (d.title, d.publisher, d.creator);
    END;
    $$ LANGUAGE plpgsql STABLE;

    -- SELECT * FROM atlas_api.obs_dataset_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    -- EXPLAIN ANALYZE
    -- with taxa as (
    --     select array_agg(id) ids from match_taxa_obs('Acer')
    -- )
    -- SELECT atlas_api.obs_dataset_summary(
    --     region_fid => 855385, taxa_keys => ids, region_type => 'hex', min_year => 1950, max_year => 2022
    -- )
    -- FROM taxa;

    -- EXPLAIN ANALYZE SELECT * FROM atlas_api.obs_dataset_summary(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    -- EXPLAIN ANALYZE SELECT * FROM atlas_api.obs_dataset_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);


