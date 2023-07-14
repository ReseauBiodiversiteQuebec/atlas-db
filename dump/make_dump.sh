export PGDATABASE="atlas"

out_file="dump_atlas.sql"
obs_file="dump_test_observations.sql"

# Dump users and roles
echo "SET session_replication_role = 'replica';" > $out_file

pg_dumpall --roles-only >> $out_file

# Add create extension postgis
echo "CREATE EXTENSION postgis;" >> $out_file

# Add create extension plpython3u
echo "CREATE EXTENSION plpython3u;" >> $out_file

grep -v "CREATE ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file
grep -v "ALTER ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file

# Dump using -s to dump only schema and -a to dump only data
echo "Dumping schema and data..."
pg_dump -s -n observations_partitions \
    -n public \
    -n api \
    -n public_api \
    -n atlas_api \
    -n data_transfer \
    >> $out_file

pg_dump -a \
    -n public \
    -n api \
    -n public_api \
    -n atlas_api \
    -T observations \
    -T obs_efforts \
    -T public.montreal_terrestrial_limits \
    -T public.regions \
    -T qc_limit \
    -T qc_region_limit \
    -T public.cdpnq_ranges \
    -T atlas_api.temp_obs_regions_taxa_year_counts \
    -T public.time_series \
    >> $out_file
echo "...done"

# Dump selected observations in 'test_observations.txt' file and add line to copy in sql dump
echo "Dumping test observations..."
echo "SET session_replication_role = 'replica';" > $obs_file 
psql -c 'create table public.test_observations (like public.observations including all);

insert into public.test_observations
select *
from public.observations
order by random()
limit 60000;'

echo "COPY public.observations FROM stdin;">>$obs_file
psql -c 'COPY test_observations TO stdout'>>$obs_file
echo "\.">>$obs_file

echo "COPY public.obs_efforts FROM stdin;">>$obs_file
psql -c '
COPY (
    SELECT *
    FROM obs_efforts
    WHERE id_obs IN (
        SELECT obs.id
        FROM test_observations obs))
TO stdout'>>$obs_file
echo "\.">>$obs_file

# RESTART sequence for observations to avoid duplicate id
echo """
DO \$\$
DECLARE
    max_id INT;
BEGIN
    SELECT MAX(id) + 1 INTO max_id FROM observations;
    EXECUTE 'ALTER SEQUENCE observations_partitions.observations_id_seq RESTART WITH ' || max_id;
END \$\$;
""" >> $obs_file

psql -c "drop table test_observations;"

# Dump regions of type hex in dump_regions.sql
echo "Dumping regions..."
pg_dump -a -t regions > dump_regions.sql