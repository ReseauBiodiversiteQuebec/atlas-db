FROM postgres:13.1

RUN apt update && apt install postgis postgresql-13-postgis-3 postgresql-plpython3-13 python3.7 git -y

COPY ./atlas.sql /docker-entrypoint-initdb.d/atlas.sql
# COPY ./copy_test_observations.sql /docker-entrypoint-initdb.d/copy_test_observations.sql
COPY ./scripts/install_bdqc_taxa.sh /tmp/install_bdqc_taxa.sh
RUN /tmp/install_bdqc_taxa.sh