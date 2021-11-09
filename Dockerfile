FROM postgres:13.1

RUN apt update && apt install postgis postgresql-13-postgis-3 postgresql-plpython3-13 python3-setuptools python3-pip git -y

RUN pip3 install git+https://github.com/ReseauBiodiversiteQuebec/bdqc_taxa.git#egg=bdqc_taxa

RUN git config --global user.email "vincent.beauregard@usherbrooke.ca"
RUN git config --global user.name "Vincent Beauregard"

COPY ./atlas.sql /docker-entrypoint-initdb.d/atlas.sql
# COPY ./copy_test_observations.sql /docker-entrypoint-initdb.d/copy_test_observations.sql
