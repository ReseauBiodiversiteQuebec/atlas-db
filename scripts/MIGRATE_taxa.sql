-- ALTER TABLE public.observations ADD COLUMN id_taxa_obs integer;

DO language 'plpgsql'
$$
DECLARE
    r record;
    iterator integer := 0;
    total integer := (select count(id) from taxa WHERE scientific_name not in (select scientific_name from taxa_obs));
BEGIN
    RAISE NOTICE '%', NOW();
    FOR r IN 
        SELECT id, scientific_name, rank, authorship
        FROM public.taxa
        WHERE scientific_name not in (select scientific_name from taxa_obs)
    LOOP
        BEGIN
            iterator := iterator + 1;
            RAISE NOTICE 'inserting record % / %', iterator, total;
            WITH ins_taxa AS (
                INSERT INTO public.taxa_obs (scientific_name, rank, authorship)
                VALUES (r.scientific_name, r.rank, r.authorship)
                RETURNING id)
            UPDATE public.observations
            SET id_taxa_obs = ins_taxa.id
            FROM ins_taxa
            WHERE id_taxa = r.id;
            EXCEPTION WHEN OTHERS THEN
                raise notice 'Failed for taxa %', r.scientific_name;
                raise notice '% %', SQLERRM, SQLSTATE;
            COMMIT;
        END;
    END LOOP;
    RAISE NOTICE '%', NOW();
END$$;