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
