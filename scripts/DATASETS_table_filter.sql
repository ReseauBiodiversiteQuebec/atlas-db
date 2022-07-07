DROP MATERIALIZED VIEW IF EXISTS public_api.obs_datasets_taxa_count CASCADE;
CREATE MATERIALIZED VIEW public_api.obs_datasets_taxa_count AS
    SELECT
        o.id_taxa_obs,
        o.year_obs,
        o.id_datasets,
        glu.id_group,
        count(o.id) count_obs
        FROM
            observations o, taxa_obs_group_lookup glu, taxa_groups
        WHERE o.within_quebec IS TRUE
            and taxa_groups.level = 1
            and glu.id_group = taxa_groups.id
            and glu.id_taxa_obs = o.id_taxa_obs
        GROUP BY (o.id_taxa_obs, o.year_obs, o.id_datasets, glu.id_group)
    WITH DATA;

CREATE INDEX
    ON public_api.obs_datasets_taxa_count (id_taxa_obs);
CREATE INDEX
    ON public_api.obs_datasets_taxa_count (year_obs);
CREATE INDEX
    ON public_api.obs_datasets_taxa_count (id_datasets);


CREATE OR REPLACE FUNCTION public_api.list_datasets_summary(
    taxakeys integer[] DEFAULT NULL,
    taxagroupkey integer DEFAULT NULL)
RETURNS TABLE (
    dataset text,
    dataset_source text,
    count_observations integer,
    count_species integer,
    first_year integer,
    last_year integer,
    taxa_groups_fr text,
    taxa_groups_en text
) AS $$
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        RETURN QUERY
            with o as (
                select
                    id_datasets,
                    count_distinct_species(array_agg(olu.id_taxa_obs)) count_species,
                    sum(count_obs) count_observations,
                    min(year_obs) first_year,
                    max(year_obs) last_year,
                    string_agg(distinct(taxa_groups.vernacular_fr), ', ') taxa_groups_fr,
                    string_agg(distinct(taxa_groups.vernacular_en), ', ') taxa_groups_en
                from
                    public_api.obs_datasets_taxa_count olu,
                    taxa_obs_group_lookup glu,
                    taxa_groups
                where (olu.id_taxa_obs = any(taxakeys) 
                    or glu.id_group = taxagroupkey)
                    and glu.id_taxa_obs = olu.id_taxa_obs
                    and taxa_groups.id = olu.id_group
                group by id_datasets
            )
            SELECT
                ds.title::text dataset,
                ds.original_source::text dataset_source,
                o.count_observations::integer,
                o.count_species::integer,
                o.first_year::integer,
                o.last_year::integer,
                o.taxa_groups_fr::text,
                o.taxa_groups_en::text
            from o, datasets ds
            where ds.id = o.id_datasets;
    END;
$$ LANGUAGE plpgsql stable;


-- TESTS
EXPLAIN ANALYZE select * from public_api.list_datasets_summary(ARRAY[10033], NULL);