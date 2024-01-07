## Resources Maintenance

These resources are generated from the database tables and must be periodically updated to reflect changes in the database. The following sections describe those resources and how to update them.

### Periodic updates (CRON jobs)

CRON jobs are used to update resources periodically. They are created for the user `postgres`.

Cron jobs for `atlas` database maintenance are defined by in the `cron/crontab` file and must be added to the crontab file using the following command:

```bash
sudo -u postgres crontab -e
```

Here is an example of the crontab file. Make sure to refer to jobs defined in the `cron/crontab` file. Here `0 21 * * 5` means that the job will be executed every Friday at 21:00.

```bash
# Add the following line to the crontab file for the postgres user
0 21 * * 5 /bin/bash  /home/postgres/atlas-db/cron/refresh_mview_atlas.sh
0 21 * * 5 /bin/bash  psql -d atlas -f /home/postgres/atlas-db/cron/refresh_taxa.sql
0 21 * * 5 /bin/bash  psql -d atlas -f /home/postgres/atlas-db/cron/refresh_api.sql
```

The following CRON jobs are defined:

* `refresh_mview_atlas.sh` : Refreshes materialized views for the `atlas` database.
* `refresh_taxa.sql` : Refreshes taxonomic information in the `atlas` database related to the `taxa_ref`, `taxa_vernacular` and `taxa_groups` tables.
* `refresh_api.sql` : Refreshes the `api.taxa` materialized view and the `atlas_api.obs_region_counts` and `atlas_api.obs_regions_taxa_datasets_counts` tables.

```sql
REFRESH MATERIALIZED VIEW api.taxa;
SELECT atlas_api.obs_region_counts_refresh();
SELECT atlas_api.obs_regions_taxa_datasets_counts_refresh();
```

### Manual updates

Here is a list of resources that are updated by the CRON jobs and that can be updated manually.

#### After inserting new observations in the database

* Update `public.taxa_ref` table using `refresh_taxa_ref();` function
* Update `public.taxa_vernacular` table using `refresh_taxa_vernacular();` function
* Update `public.taxa_groups` Materialized view using `REFRESH MATERIALIZED VIEW taxa_groups;` command
* Update `api.taxa` Materialized view using `REFRESH MATERIALIZED VIEW api.taxa;` command
* Update `atlas_api.obs_region_counts` Table using `atlas_api.obs_regions_counts_refresh();` function
* Update`atlas_api.obs_regions_taxa_datasets_counts` Table using `atlas_api.obs_regions_taxa_datasets_counts_refresh();` function

#### After creation of new regions

* Update `atlas_api.obs_region_counts` Table using `atlas_api.obs_regions_counts_refresh();` function
* Update `atlas_api.obs_regions_taxa_datasets_counts` Table using `atlas_api.obs_regions_taxa_datasets_counts_refresh();` function
* Update `atlas_api.web_regions` Materialized view using `REFRESH MATERIALIZED VIEW web_regions;` command


#### List of resources to update

Rule of thumb: Most of taxonomic information managed by `taxa_ref`, `taxa_vernacular`, `taxa_groups` tables and related ressources must be updated periodically or after insertions on `taxa_obs` table.

* `public.taxa_ref` table : Updated by function `refresh_taxa_ref();`

Example of use:

```sql
SELECT refresh_taxa_ref();
```

* `public.taxa_vernacular` table : Updated by function `refresh_taxa_vernacular();`

* `public.taxa_groups` Materialized view : Updated on refresh.

Example of use:

```sql
REFRESH MATERIALIZED VIEW taxa_groups;
```

* `api.taxa` Materialized view : Updated on refresh.

* `atlas_api.obs_region_counts` Table : Updated by function `atlas_api.obs_regions_counts_refresh();`

* `atlas_api.obs_regions_taxa_datasets_counts` Table : Updated by function `atlas_api.obs_regions_taxa_datasets_counts_refresh();`

* `atlas_api.web_regions` Materialized view : Updated on refresh.


### Dumps

Dumps are generated periodically to track all changes to the database. Ideally, it should be done on every modification of the codebase.

It is important since most of relevant tables from `public` schema are not versioned within the `script` folder.

The dumps are also used to create a staging database for testing purposes.

#### Dumps creation

To create a database dump, you can run the make_dump.sh script with the `postgres` user. Here's how you can do it:

```bash
cd dump
sudo -u postgres bash make_dump.sh
```

The make_dump.sh script performs the following steps:

* It connects to the PostgreSQL database using the credentials and connection parameters specified in the script.
* It uses the pg_dump command to create a dump of the database schema and store it in `dump/dump_atlas_schema.sql`.
* It uses the pg_dump command to create a dump of the database data and store it in `dump/dump_atlas_public_data.sql`.
* It creates a dump of the `public.regions` table and store it in `dump/dump_regions.sql`, which is to heavy (> 100MB) to be versioned by git.
* It samples the `public.observations`, `public.efforts` and `public.obs_efforts` tables and store them in `dump/dump_test_observations.sql` to be used for testing purposes.


### Staging database

The staging database is used to test the application before deploying it to production. It is created from the dumps generated by the `make_dump.sh` script.

#### Staging database creation

To create the staging database, you can run the create_staging_db.sh script with the `postgres` user. Here's how you can do it:

```bash
cd dump
sudo -u postgres bash dump_to_staging.sh
```

The staging database is created from the dumps generated by the `make_dump.sh` script. If you want to update the staging database, you must first update the dumps using the `make_dump.sh` script and then run the `dump_to_staging.sh` script.

> **Important**: `dump_to_staging.sh` script will drop the staging database if it already exists.