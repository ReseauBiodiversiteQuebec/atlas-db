DO language 'plpgsql'
$$
DECLARE
    r record;
    iterator integer := 0;
    total integer := (
        select count(id) from taxa_obs
        WHERE taxa_obs.id not in (
            select id_taxa_obs from taxa_obs_vernacular_lookup)
    );
BEGIN
    RAISE NOTICE '%', NOW();
    FOR r IN 
        SELECT id, scientific_name
        from taxa_obs
        where taxa_obs.id not in (select id_taxa_obs from taxa_obs_vernacular_lookup)
        -- LIMIT 100
    LOOP
        BEGIN
            iterator := iterator + 1;
            RAISE NOTICE 'inserting record % / %', iterator, total;
            PERFORM insert_taxa_vernacular_from_obs(r.id);
            EXCEPTION WHEN OTHERS THEN
                raise notice 'Failed for taxa %', r.scientific_name;
                raise notice '% %', SQLERRM, SQLSTATE;
            COMMIT;
        END;
    END LOOP;
    RAISE NOTICE '%', NOW();
END$$;