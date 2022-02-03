DO
$$
DECLARE
	r record;
BEGIN
	FOR r IN 
        select * from pg_catalog.pg_tables
        where schemaname = 'public'
            and tablename in
                ('taxa_obs', 'taxa_ref', 'taxa_obs_ref_lookup', 'taxa', 'observations')
            and (tablespace <> 'ssdpool' or tablespace is null)
	LOOP
		EXECUTE 'ALTER TABLE IF EXISTS ' || r.tablename || ' SET TABLESPACE ssdpool';
	END LOOP;
END;
$$ LANGUAGE plpgsql;

DO
$$
DECLARE
	r record;
BEGIN
	FOR r IN 
        select * from pg_catalog.pg_indexes
        where schemaname = 'public'
            and tablename in
                ('taxa_obs', 'taxa_ref', 'taxa_obs_ref_lookup', 'taxa', 'observations')
            and (tablespace <> 'ssdpool' or tablespace is null)
	LOOP
		EXECUTE 'ALTER INDEX IF EXISTS ' || r.indexname || ' SET TABLESPACE ssdpool';
	END LOOP;
END;
$$ LANGUAGE plpgsql;