export PGDATABASE="atlas"

out_file="atlas.sql"

# Dump users and roles
pg_dumpall --roles-only  > $out_file

grep -v "CREATE ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file
grep -v "ALTER ROLE postgres" $out_file > tmpfile && mv tmpfile $out_file

pg_dump -s >>$out_file
pg_dump -a \
    -T observations \
    -T obs_efforts >>$out_file

# Dump selected observations in 'test_observations.txt' file and add line to copy in sql dump
psql -c 'create table public.test_observations (like public.observations including all);

insert into public.test_observations
select *
from public.observations
order by random()
limit 60000;'

echo "COPY public.observations FROM stdin;">>$out_file
psql -c 'COPY test_observations TO stdout'>>$out_file
echo "\.">>$out_file

echo "COPY public.obs_efforts FROM stdin;">>$out_file
psql -c '
COPY (
    SELECT *
    FROM obs_efforts
    WHERE id_obs IN (
        SELECT obs.id
        FROM test_observations obs))
TO stdout'>>$out_file
echo "\.">>$out_file

psql -c "drop table test_observations;"