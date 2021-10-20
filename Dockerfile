FROM postgis/postgis:9.5-2.5
COPY ./pose_dev.sql /docker-entrypoint-initdb.d/pose_dev.sql