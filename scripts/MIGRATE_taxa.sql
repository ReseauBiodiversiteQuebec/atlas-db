DO language 'plpgsql'
$$
BEGIN
    RAISE NOTICE '%', NOW();
    with r as ( 
        SELECT id, scientific_name, rank, authorship
        FROM public.taxa
        WHERE scientific_name not in (select scientific_name from taxa_obs)
        )
    INSERT INTO public.taxa_obs (scientific_name, rank, authorship)
    select r.scientific_name, r.rank, r.authorship
    FROM r;
    RAISE NOTICE 'Completed insertion %', NOW();
    
    with taxa_obs_lookup as (
        select
            taxa.id as id_taxa,
            taxa_obs.id as id_taxa_obs
        from taxa
        left join taxa_obs
            on taxa.scientific_name = taxa_obs.scientific_name
            and taxa.authorship = taxa_obs.authorship
            and taxa.rank::text = taxa_obs.rank::text
        )
    update observations obs
    set id_taxa_obs = taxa_obs_lookup.id_taxa_obs
    from taxa_obs_lookup
    where obs.id_taxa = taxa_obs_lookup.id_taxa;
    RAISE NOTICE 'Completed observations update %', NOW();
END$$;