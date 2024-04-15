SELECT refresh_taxa_ref_complete();
SELECT refresh_taxa_vernacular();
REFRESH MATERIALIZED VIEW CONCURRENTLY public.taxa_obs_group_lookup;