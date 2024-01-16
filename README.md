# atlas-db

## Environment

File `.env` must be configured with the following recommended environment variables.

```
POSTGRES_USER=postgres #Recommended
POSTGRES_PASSWORD= #Database will initialize user defined above with this pw and superuser rights 
POSTGRES_DB=pose_dev
```

## Test database

`pose_dev.sql` file contains dump of user roles and definition, and contains sample records from the original table. It is ran by the new postgres server at first initialization.

It can be created by runnning `make.sh` from `postgres` vm, using the `postgres` user :

```
sudo su postgres
source make_dump.sh
```

## Python package dependencies

Some taxonomic features depend on the `bdqc_taxa` package, which is not available on PyPI. It can be installed from the git repository using the following command under the `postgres` user:

```bash
sudo su postgres

pip install --upgrade git+https://github.com/ReseauBiodiversiteQuebec/bdqc_taxa#egg=bdqc_taxa
```

The database must be restarted after installing the package.

```bash
sudo systemctl restart postgresql
```

## Database schemas overview

The database is organized in the following schemas:
- `public`: contains the tables and views used to store biodiversity data

- `api`: contains the tables, views and functions used to store and retrieve joined data from the `public` schema. This schema is used by the API.

- `data_transfer`: contains the tables and views used to store temporary data. This schema may be used by users with `read_write_all` role.

- `atlas_api`: contains the tables, views and functions used to store and retrieve joined data from the `public` schema. These objects are used by the API for the web atlas portal.

- `observations_partitions`: contains partitionned tables used to store observations. Observations are partitionned by column `within_quebec`.

- Deprecated. `public_api`: This schema is deprecated and will be removed in a future version and should not be used anymore. It contains the tables, views and functions used to store and retrieve joined data from the `public` schema. These objects are used by the API for the web atlas portal.

## Roles & permissions

The database is organized in the following roles:
- `read_only_public`: can only read unrestricted data from the `public`, `api` and `atlas_api` schemas. This role is used by the API for general public access.
- `read_only_all`: can only read all data, restricted or not, from the `public`, `api` and `atlas_api` schemas. This role is used by the API for restricted access, such as for researchers and biodiversity quebec members.
- `read_write_all`: can read and write all data, restricted or not, from the `public`, `api` and `atlas_api` schemas. This role is used by biodiversity quebec members to update the database.

<!-- Documentation using mkdocs with material, files, commands -->

## Documentation

Documentation is available at [https://reseaubiodiversitequebec.github.io/atlas-db/](https://reseaubiodiversitequebec.github.io/atlas-db/).

Documentation is created using markdown files in the `docs` folder. It is compiled using `mkdocs` with the material theme. Configuration is provided by the `mkdocs.yml` file. See [Material for MkDocs website](https://squidfunk.github.io/mkdocs-material/) for more information.

Build & deploy is done using GitHub Actions. The workflow is defined in `.github/workflows/mkdocs_build_deploy.yml`. It is triggered on push to the `main` branch.
