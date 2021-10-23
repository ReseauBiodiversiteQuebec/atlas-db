ALTER TABLE public.observations ADD COLUMN id_taxa_obs integer;

DO language 'plpgsql'
$$
DECLARE r record;
BEGIN
    FOR r IN 
        SELECT id, scientific_name, rank, authorship
        FROM public.taxa
    LOOP
        BEGIN
            WITH ins_taxa AS (
                INSERT INTO public.taxa_obs (scientific_name, rank, authorship)
                VALUES (r.scientific_name, r.rank, r.authorship)
                ON CONFLICT DO NOTHING
                RETURNING id)
            UPDATE public.observations
            SET id_taxa_obs = ins_taxa.id
            FROM ins_taxa
            WHERE id_taxa = r.id;

            EXCEPTION WHEN OTHERS THEN
                raise notice 'Failed for taxa %', r.scientific_name;
                raise notice '%', SQLSTATE;
        END;
    END LOOP;
END$$;