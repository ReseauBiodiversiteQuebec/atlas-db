export PGDATABASE="atlas"

schema_file="dump_atlas_schema.sql"
public_data_file="dump_atlas_public_data.sql" # Exclude observations, efforts and related tables, regions, time_series
obs_file="dump_test_observations.sql"

# Dump users and roles
echo "SET session_replication_role = 'replica';" > $schema_file

pg_dumpall --roles-only --no-password >> $schema_file

# Add create extension postgis
echo "CREATE EXTENSION postgis;" >> $schema_file

# Add create extension plpython3u
echo "CREATE EXTENSION plpython3u;" >> $schema_file

grep -v "CREATE ROLE postgres" $schema_file > tmpfile && mv tmpfile $schema_file
grep -v "ALTER ROLE postgres" $schema_file > tmpfile && mv tmpfile $schema_file

# Dump using -s to dump only schema and -a to dump only data
echo "Dumping schema and data..."
pg_dump -s \
    -n observations_partitions \
    -n public \
    -n api \
    -n atlas_api \
    -n data_transfer \
    >> $schema_file

echo "SET session_replication_role = 'replica';" > $public_data_file
pg_dump -a \
    -t public.datasets \
    -t public.taxa_obs \
    -t public.taxa_refs \
    -t public.taxa_obs_ref_lookup \
    -t public.taxa_vernacular \
    -t public.taxa_vernacular_lookup \
    -t public.taxa_groups \
    -t taxa_group_members \
    -t public.taxa_groups_lookup \
    -t public.time_series \
    -t atlas_api.regions_zoom_lookup \
    -t atlas_api.sensitive_taxa_max_scale \
    >> $public_data_file
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
pg_dump --inserts -a -t regions > dump_regions.sql
