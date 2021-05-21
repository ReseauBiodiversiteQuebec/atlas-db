FROM postgis/postgis
COPY ./schema_dump.sql /docker-entrypoint-initdb.d/atlas-db.sql



