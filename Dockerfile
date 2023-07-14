FROM postgres:13.1

RUN apt update && apt install postgis postgresql-13-postgis-3 postgresql-plpython3-13 python3-setuptools python3-pip git -y

RUN git config --global user.email "vincent.beauregard@usherbrooke.ca"
RUN git config --global user.name "Vincent Beauregard"

RUN pip3 install git+https://github.com/ReseauBiodiversiteQuebec/bdqc_taxa.git#egg=bdqc_taxa

COPY ./dump/dump_atlas.sql /docker-entrypoint-initdb.d/0_dump_atlas.sql
COPY ./dump/dump_test_observations.sql /docker-entrypoint-initdb.d/1_dump_test_observations.sql
COPY ./dump/dump_regions_admin.sql /docker-entrypoint-initdb.d/2_dump_regions_admin.sql
COPY ./dump/dump_regions_cadre_eco.sql /docker-entrypoint-initdb.d/3_dump_regions_cadre_eco.sql
COPY ./dump/dump_regions_hex.sql /docker-entrypoint-initdb.d/4_dump_regions_hex.sql
