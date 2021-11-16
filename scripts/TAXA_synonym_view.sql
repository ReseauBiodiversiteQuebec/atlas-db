DROP VIEW IF exists taxa_ref_synonym CASCADE;
CREATE VIEW taxa_ref_synonym AS (
    select distinct
        l_lookup.id_taxa_ref taxa_ref_id,
        second_synonym_ref_lookup.id_taxa_ref taxa_ref_synonym_id,
        second_synonym_ref_lookup.id_taxa_obs taxa_obs_id
    from taxa_obs_ref_lookup l_lookup --Searched ref
    join taxa_ref l_ref
        on l_lookup.id_taxa_ref = l_ref.id
    join taxa_obs_ref_lookup first_synonym_ref_lookup -- Found all synonym ref for the same observed taxa
        on l_lookup.id_taxa_obs = first_synonym_ref_lookup.id_taxa_obs
    join taxa_ref first_synonym_ref
        on first_synonym_ref_lookup.id_taxa_ref = first_synonym_ref.id
    join taxa_obs_ref_lookup pivot_obs_lookup -- Found all obs taxa with first synonym
        on first_synonym_ref_lookup.id_taxa_ref_valid = pivot_obs_lookup.id_taxa_ref_valid
    join taxa_obs_ref_lookup second_synonym_ref_lookup -- Found second synonym ref for the same observed taxa
        on pivot_obs_lookup.id_taxa_obs = second_synonym_ref_lookup.id_taxa_obs
    join taxa_ref second_synonym_ref
        on second_synonym_ref_lookup.id_taxa_ref = second_synonym_ref.id

    where lower(l_ref.rank) = lower(first_synonym_ref.rank)
        and lower(l_ref.rank) = lower(second_synonym_ref.rank)
    
);