export PGDATABASE="atlas"

out_file="dump_atlas.sql"
hex_file="dump_hex.sql"
obs_file="dump_test_observations.sql"

# Dump users and roles
echo "SET session_replication_role = 'replica';" > $out_file 
pg_dumpall --roles-only  > $out_file

grep -v "CREATE ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file
grep -v "ALTER ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file

pg_dump -s --no-tablespaces >> $out_file
pg_dump -a \
    -T observations \
    -T obs_efforts \
    -T public_api.hex_250_na \
    -T public_api.hexquebec100km \
    -T public_api.hexquebec10km  \
    -T public_api.hexquebec20km  \
    -T public_api.hexquebec50km  \
    -T public_api.hexquebec5km   \
    >> $out_file

# DUMP hex data in a separate file for space under 100 Mb git management
echo "SET session_replication_role = 'replica';" > $hex_file 

pg_dump -a \
    -t public_api.hex_250_na     \
    -t public_api.hexquebec100km \
    -t public_api.hexquebec10km  \
    -t public_api.hexquebec20km  \
    -t public_api.hexquebec50km  \
    -t public_api.hexquebec5km   \
    >> $hex_file

# Dump selected observations in 'test_observations.txt' file and add line to copy in sql dump
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

psql -c "drop table test_observations;"