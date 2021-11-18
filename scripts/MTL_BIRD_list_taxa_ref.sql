DROP MATERIALIZED VIEW if exists api.bird_mtl_taxa_ref CASCADE;
CREATE MATERIALIZED VIEW if not exists api.bird_mtl_taxa_ref AS (
    with
        mtl_pts_taxa_ref as (
            select distinct on (pts.id, taxa_ref.id)
                pts.id as pts_id,
                pts.year_obs,
                taxa_ref.id as taxa_ref_id
            from api.bird_sampling_points pts
            join api.bird_sampling_observations_lookup pts_lookup
                on pts.id = pts_lookup.id_sampling_points
            left join taxa_obs_ref_lookup ref_lookup
                on pts_lookup.id_taxa_obs = ref_lookup.id_taxa_obs
            left join taxa_ref_synonym taxa_lookup
                on ref_lookup.id_taxa_ref_valid = taxa_lookup.taxa_ref_id
            left join taxa_ref
                on taxa_lookup.taxa_ref_synonym_id = taxa_ref.id
            where st_within(pts.geom, (
                    select public.ST_UNION (wkb_geometry)
                    from montreal_terrestrial_limits))
                and ref_lookup.match_type is not null
                and taxa_ref.valid
            order by taxa_ref.source_id
        ),
        yearly_count as (
            select
                taxa_ref_id,
                year_obs,
                count(*) as count_obs
            from mtl_pts_taxa_ref
            group by (taxa_ref_id, year_obs)
        ),
        taxa_counts as (
            select
                taxa_ref_id,
                max(yearly_count.count_obs) as max_yearly_count,
                avg(yearly_count.count_obs) as avg_yearly_count,
                min(yearly_count.count_obs) as min_yearly_count,
                sum(yearly_count.count_obs) as total_count,
                min(yearly_count.year_obs) as min_year_obs,
                max(yearly_count.year_obs) as max_year_obs
            from yearly_count
            group by (taxa_ref_id)
        )
    select
        taxa_ref.*,
        taxa_counts.max_yearly_count,
        taxa_counts.avg_yearly_count,
        taxa_counts.min_yearly_count,
        taxa_counts.total_count,
        taxa_counts.min_year_obs,
        taxa_counts.max_year_obs
    from taxa_counts
    left join taxa_ref
        on taxa_counts.taxa_ref_id = taxa_ref.id
);