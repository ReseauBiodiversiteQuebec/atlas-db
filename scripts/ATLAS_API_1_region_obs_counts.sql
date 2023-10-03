-- -----------------------------------------------------------------------------
-- CREATE GENERATED TABLE VIEW FOR region_counts
-- -----------------------------------------------------------------------------
    CREATE TABLE IF NOT EXISTS atlas_api.obs_region_counts (
        type text,
        scale integer,
        fid integer,
        id_taxa_obs integer,
        year_obs integer,
        count_obs integer
    );

    CREATE INDEX obs_region_counts_type_fid_idx
        ON atlas_api.obs_region_counts (type, fid);

    CREATE INDEX obs_region_counts_type_scale_idx
        ON atlas_api.obs_region_counts (type, scale);

    CREATE INDEX obs_region_counts_fid_idx
        ON atlas_api.obs_region_counts (fid);

    CREATE INDEX obs_region_counts_type_idx
        ON atlas_api.obs_region_counts (type);

    CREATE INDEX obs_region_counts_year_obs_idx
        ON atlas_api.obs_region_counts (year_obs);

    CREATE INDEX obs_region_counts_id_taxa_obs_idx
        ON atlas_api.obs_region_counts (id_taxa_obs);

    CREATE UNIQUE INDEX obs_region_counts_type_fid_id_taxa_obs_year_obs_idx
        ON atlas_api.obs_region_counts (fid, id_taxa_obs, year_obs);

    -- GRANTS
    ALTER TABLE atlas_api.obs_region_counts OWNER TO postgres;
    GRANT SELECT ON TABLE atlas_api.obs_region_counts TO read_only_all;
    GRANT ALL ON TABLE atlas_api.obs_region_counts TO postgres;
    GRANT SELECT ON TABLE atlas_api.obs_region_counts TO read_only_public;


    CREATE OR REPLACE FUNCTION atlas_api.obs_region_counts_refresh()
        RETURNS void AS $$
        INSERT INTO atlas_api.obs_region_counts (
            type,
            scale,
            fid,
            id_taxa_obs,
            year_obs,
            count_obs
        )
        SELECT
            regions.type,
            regions.scale,
            regions.fid,
            o.id_taxa_obs,
            o.year_obs,
            count(o.id) AS count_obs
        FROM 
            regions,
            observations o,
            -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
            atlas_api.regions_zoom_lookup
        WHERE st_within(o.geom, regions.geom)
            AND o.within_quebec = regions.within_quebec
            AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
        GROUP BY regions.type, regions.fid, o.id_taxa_obs, o.year_obs;
        $$ LANGUAGE SQL;

-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_map to return tile x, y and zoom for a given region type, zoom, y, x with summary of observations
-- -----------------------------------------------------------------------------
    -- DROP FUNCTION IF EXISTS atlas_api.obs_map(text,integer,double precision,double precision,double precision,double precision,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_map(
        region_type text,
        zoom integer,
        x_min float,
        y_min float,
        x_max float,
        y_max float,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    -- RETURNS TABLE (json_collection json) AS $$
    RETURNS json AS $$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), scale as (
            select atlas_api.get_scale(region_type, $2, sensitive) as scale
            from sensitive
        ), map_regions as (
        SELECT
            web_regions.fid,
            web_regions.type,
            web_regions.scale,
            regions.scale_desc,
            regions.name,
            regions.extra,
            web_regions.geom
        FROM atlas_api.web_regions, regions, scale
        WHERE
            web_regions.type = $1
            AND ST_Intersects(
                web_regions.geom,
                ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))
            AND web_regions.scale = scale.scale
            AND web_regions.fid = regions.fid
            AND web_regions.type = regions.type
        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE type = region_type and scale = (select scale from scale)
                AND year_obs >= $9 and year_obs <= $10
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.scale_desc,
            map_regions.name,
            map_regions.extra,
            map_regions.geom,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_build_object(
                'type', 'FeatureCollection',
                'features', json_agg(ST_AsGeoJSON(features.*)::json),
                'sensitive', (SELECT sensitive from sensitive)
            )
        INTO out_json
        FROM features;
        RETURN json_agg(out_json);
    END;
    $$ LANGUAGE plpgsql STABLE;

    -- EXPLAIN ANALYZE SELECT atlas_api.obs_map('hex', 6, -76, 45, -68, 50, NULL, 19, 1950, 9999);
    -- EXPLAIN ANALYZE SELECT atlas_api.obs_map('hex', 6, -140, 35, -3, 68, NULL, 19, 1950, 9999);
    -- -- FOR sensitive species Apalone spinifera
    -- EXPLAIN ANALYZE SELECT atlas_api.obs_map('hex', 10, -140, 35, -3, 68, 10146, NULL, 1950, 9999);



-- -----------------------------------------------------------------------------
-- CREATE FUNCTION obs_summary to return species and obs counts for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- ---------------------------------------------------------------------------
    -- DROP FUNCTION atlas_api.obs_summary(integer,text,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_summary(
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS table (
        fid integer,
        taxa_filter_tags json,
        region_filter_tags json,
        obs_count integer,
        taxa_count integer,
        taxa_id_list integer[]
    )
    AS $$
    DECLARE
        region_type_fr text;
        region_type_en text;
    BEGIN
        -- Group is all species (level = 0) if no group
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;

        -- Only one of taxa_group_key or taxa_keys can be specified
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        -- Set region_fid and region_type to default (all quebec) if not specified
        -- We must first store region type tags that will be returned
        SELECT name_fr, name_en INTO region_type_fr, region_type_en
        FROM atlas_api.regions_zoom_lookup
        WHERE type = region_type
        LIMIT 1;

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
        ), region_type_scale as (
            select
                show_sensitive,
                region_type_fr as name_fr,
                region_type_en as name_en,
                regions.name as region_name
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_counts as (
            SELECT
                counts.fid,
                counts.type,
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list,
                sum(counts.count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), taxa_list as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_counts
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        ), taxa_groups as (
            SELECT 
                array_agg(vernacular_fr) groups_fr,
                array_agg(vernacular_en) groups_en
            FROM taxa_list, match_taxa_groups(taxa_list.taxa_list)
            WHERE level = 1 or (21 <= id and id >= 25)
        )
        SELECT
            region_fid,
            json_build_object(
                'taxa_tags_fr', groups_fr,
                'taxa_tags_en', groups_en
            ) AS taxa_filter_tags,
            json_build_object(
                'tags_fr', region_type_scale.name_fr,
                'tags_en', region_type_scale.name_en,
                -- name is the string before parenthesis in the name field
                'name_fr', regexp_replace(region_name, ' \(.+\)', ''),
                'name_en', regexp_replace(region_name, ' \(.+\)', ''),
                -- subtitle is the string between parenthesis in the name field
                'subtitle', regexp_replace(region_name, '^.+\((.+)\)$', '\1')
            ) AS region_filter_tags,
            coalesce(obs_counts.count_obs::integer, 0),
            coalesce(array_length(obs_counts.taxa_list, 1)::integer, 0) as taxa_count,
            taxa_list.taxa_list
        FROM region_type_scale, taxa_list, taxa_groups
        LEFT JOIN obs_counts ON TRUE;
    END;
    $$ LANGUAGE plpgsql STABLE;

    -- EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    -- EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    -- EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => 855385, region_type => 'hex', taxa_keys => ARRAY[10037], min_year => 1950, max_year => 2022);

    -- -- REGRESSION TEST FOR hex with empy observations
    -- EXPLAIN ANALYZE select * from atlas_api.obs_summary(region_fid => 855580, region_type => 'hex', taxa_group_key => 19, min_year => 1950, max_year => 2022);


-- ---------------------------------------------------------------------------
-- CREATE FUNCTION obs_species_summary to download species summary for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- ---------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_species_summary(integer,integer,text,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_species_summary(
        taxa_key integer,
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS json AS $$
    DECLARE out json;
    BEGIN
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        WITH taxa as (
            SELECT
                valid_scientific_name,
                vernacular_en,
                vernacular_fr
            FROM api.__taxa_join_attributes(ARRAY[$1])
        ), counts as (
            SELECT
                sum(counts.count_obs) as obs_count
            FROM atlas_api.obs_region_counts counts
            WHERE counts.fid = $2
                AND counts.type = $3
                AND counts.id_taxa_obs = $1
                AND counts.year_obs >= $4
                AND counts.year_obs <= $5
        ), taxa_groups as (
            SELECT
                array_agg(vernacular_fr) as groups_fr,
                array_agg(vernacular_en) as groups_en
            FROM match_taxa_groups(ARRAY[$1])
            WHERE level = 1 OR
                source_desc = 'CDPNQ'
        ), attributes as (
            SELECT
                taxa.*,
                counts.obs_count,
                taxa_groups.*
            FROM taxa, counts, taxa_groups
        )
        SELECT row_to_json(attributes)
        FROM attributes
        INTO out;
        RETURN out;
    END;
    $$ LANGUAGE plpgsql STABLE;

    -- EXPLAIN ANALYZE select * from atlas_api.obs_species_summary(6525);


-- ---------------------------------------------------------------------------
-- CREATE FUNCTION get_year_counts to download number of observations
------------------------------------------------------------------------------
    -- DROP FUNCTION IF EXISTS atlas_api.get_year_counts(
    --     integer[], integer
    -- );
    CREATE OR REPLACE FUNCTION atlas_api.get_year_counts(
        taxaKeys integer[] DEFAULT NULL,
        taxaGroupKey integer DEFAULT NULL)
    RETURNS json AS $$
    DECLARE
        out_json json;
        region_fid integer;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
        WITH year_counts as (
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM atlas_api.obs_region_counts o
                WHERE o.fid = region_fid
                    AND o.id_taxa_obs = ANY(taxaKeys)
                GROUP BY o.year_obs
            UNION
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM atlas_api.obs_region_counts o,
                    taxa_obs_group_lookup glu
                WHERE o.fid = region_fid
                    AND glu.id_group = taxaGroupKey
                    AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY o.year_obs
        ), year_range as (
            select
                generate_series(
                    1950,
                    max(year_obs)
                ) as year
            from atlas_api.obs_region_counts	
        ), all_year_counts as (
            SELECT
                year_range.year,
                coalesce(year_counts.count_obs, 0) count_obs,
                coalesce(year_counts.count_species, 0) count_species
            FROM year_range
            LEFT JOIN year_counts on year_range.year = year_counts.year
            ORDER BY year_range.year
        )
        SELECT
            json_agg(all_year_counts.*)
            INTO out_json
            FROM all_year_counts;
        RETURN out_json;
    END;
    $$ LANGUAGE plpgsql STABLE;
    -- EXPLAIN ANALYZE SELECT atlas_api.get_year_counts(NULL, 2);

-- ---------------------------------------------------------------------------
-- CREATE FUNCTION obs_species_list to download species list for a given fid, taxa_keys, taxa_group_key, min_year, max_year
-- -----------------------------------------------------------------------------
    DROP FUNCTION atlas_api.obs_taxa_list(integer,text,integer[],integer,integer,integer);
    CREATE OR REPLACE FUNCTION atlas_api.obs_taxa_list(
        region_fid integer DEFAULT NULL::integer,
        region_type text DEFAULT NULL::text,
        taxa_keys integer[] DEFAULT NULL::integer[],
        taxa_group_key integer DEFAULT NULL::integer,
        min_year integer DEFAULT 0,
        max_year integer DEFAULT 9999
    )
    RETURNS SETOF api.taxa AS $$
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
        ), region_type_scale as (
            select show_sensitive
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_taxa as (
            SELECT
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list
            FROM atlas_api.obs_region_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), not_sensitive_taxa as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_taxa
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        )
        SELECT
            taxa.*
        FROM api.taxa, not_sensitive_taxa
        WHERE taxa.id_taxa_obs = ANY (not_sensitive_taxa.taxa_list);
    END;
    $$ LANGUAGE plpgsql STABLE;

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => NULL, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => 855385, region_type => 'hex', min_year => 1950, max_year => 2022);

    EXPLAIN ANALYZE select * from atlas_api.obs_taxa_list(region_fid => 855385, region_type => 'hex', taxa_keys => ARRAY[10037], min_year => 1950, max_year => 2022);