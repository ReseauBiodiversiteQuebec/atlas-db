drop materialized view if exists api.bird_quebec_taxa_ref cascade;

create materialized view if not exists api.bird_quebec_taxa_ref as
    with qc_pts_taxa_ref as (
        select
            distinct on (pts.id, taxa_lookup.id_taxa_ref_valid)
            pts.id as pts_id,
            pts.year_obs,
            taxa_lookup.id_taxa_ref_valid as taxa_ref_id,
            taxa_lookup.id_taxa_obs
        from api.bird_sampling_observations_lookup pts_lookup
        join taxa_obs_ref_lookup taxa_lookup
            on pts_lookup.id_taxa_obs = taxa_lookup.id_taxa_obs
        join api.bird_sampling_points pts
            on pts_lookup.id_sampling_points = pts.id
        where st_within(pts.geom, (
                select public.ST_UNION (wkb_geometry)
                from qc_region_limit))
    ),
    yearly_count as (
        select
            taxa_ref_id,
            year_obs,
            count(*) as count_obs
        from qc_pts_taxa_ref
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
        group by (taxa_ref_id))
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
