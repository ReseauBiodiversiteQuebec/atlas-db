DROP VIEW IF EXISTS api.taxa_groups CASCADE;
CREATE VIEW api.taxa_groups AS (
    with taxa_obs_agg as (
        select
            id_group,
            array_agg(id_taxa_obs) id_taxa_obs
        from taxa_obs_group_lookup
        where id_taxa_obs is not null
        group by id_group
    )
    select
        taxa_groups.id,
        taxa_groups.level,
        taxa_groups.vernacular_en,
        taxa_groups.vernacular_fr,
        taxa_obs_agg.id_taxa_obs
    from
        taxa_groups
    left join taxa_obs_agg on taxa_groups.id = taxa_obs_agg.id_group
    order by taxa_groups.level, taxa_groups.id
)