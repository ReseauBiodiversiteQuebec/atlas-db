FROM postgis/postgis
COPY ./pose_dev.sql /docker-entrypoint-initdb.d/pose_dev.sql