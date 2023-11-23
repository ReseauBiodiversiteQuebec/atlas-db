## Table: Observations

### Description

The `observations` table is central in the Atlas database to recording ecological observations. It is is designed to support different observation types, such as abundances, occurrences, and presence/absence data of various units. The type of observation is specified by the `id_variables` column, which references the `variables` table. See the `variables` table documentation for more details.

It encompasses a wide range of data including geographical coordinates, observation times, taxa details, and associated variables, relying on foreign keys to other tables to store this information. See the `Dependencies` section below for more details and relevant tables documentation.

Partitions are used to store observations that are within or outside of Quebec. This allows for faster queries on observations that are within Quebec, which are the most commonly used. See the `partitions` section below for more details.

Triggers are used to automatically update the `within_quebec`, `modified_at`, `dwc_event_date` columns on insert or update. See the `triggers` section below for more details.

### Dependencies

- Foreign Keys: 
  - `id_datasets` references `public.datasets (id)`
  - `id_taxa` references `public.taxa (id)`
  - `id_taxa_obs` references `public.taxa_obs (id)`
  - `id_variables` references `public.variables (id)`
- Partitions:
  - `observations_partitions.outside_quebec`
  - `observations_partitions.within_quebec`
- Sequence: `observations_partitions.observations_id_seq`

### Columns

| **Column Name**        | **Type**                  | **Description**                                         | **Constraints**                               |
|------------------------|---------------------------|---------------------------------------------------------|-----------------------------------------------|
| **id**                 | Bigint                    | A unique identifier for each observation.               | Primary key (part of), Not Null, Default: nextval('observations_partitions.observations_id_seq'::regclass) |
| **org_parent_event**   | Character Varying         | *Optional*. Identifier of the parent event in the original source. | - |
| **org_event**          | Character Varying         | *Optional*. Identifier of the event in the original source. | - |
| **org_id_obs**         | Character Varying         | *Optional*. Original identifier of the observation in the original source.     | - |
| **id_datasets**        | Integer                   | The identifier of the dataset to which the observation belongs. | Not Null, Foreign key |
| **id_taxa_obs**        | Integer                   | Identifier for the observed taxon.                      | Foreign key |
| **geom**               | Geometry(Point, 4326)     | The geometry of the coordinates of the observation.        | Not Null |
| **year_obs**           | Integer                   | The year of the observation.                            | Not Null |
| **month_obs**          | Integer                   | The month of the observation.                           | - |
| **day_obs**            | Integer                   | The day of the observation.                             | - |
| **time_obs**           | Time                      | The time of the observation.                            | - |
| **id_variables**       | Integer                   | The identifier of the variable observed. Whether of type `abundance`, `occurrence`, etc. is stored in table `variables`                | Not Null, Foreign key |
| **obs_value**          | Numeric                   | The observed value for the variable. Might be integer or float in the case of abundance, or 0 or 1 in case of presence/absence                    | Not Null |
| **id_taxa (deprecated)**            | Integer      | *Deprecated*. The identifier of the taxa observed. From `taxa` table. Only to maintain compatibility. | Foreign key |
| **issue**              | Character Varying         | *Optional*. Any issues or remarks related to the observation. | - |
| **created_by**         | Character Varying         | *Auto on insert*. The user who inserted the observation record within Atlas DB. | Default: CURRENT_USER |
| **modified_at**        | Timestamp with time zone  | *Auto on insert/update*. The timestamp when the observation was last modified.   | Not Null, Default: CURRENT_TIMESTAMP |
| **modified_by**        | Character Varying         | *Auto on insert/update*. The user who last modified the observation within Atlas DB.   | Default: CURRENT_USER |
| **within_quebec**      | Boolean                   | *Auto on insert/update*. Indicates whether the observation was within Quebec.    | Part of primary key, Not Null, Default: false |
| **dwc_event_date**     | Text                      | *Auto on insert/update*. The Darwin Core (DwC) formatted event date of the observation. | Not Null, Default: '' (empty string) |

### Additional Constraints

- **Primary Key Constraint**: The combination of `id` and `within_quebec` serves as a unique identifier for each observation record.
- **Foreign Key Constraints**: Links to `datasets`, `taxa`, and `taxa_obs` tables ensure referential integrity.
- **Unique Constraint**: The combination of `geom`, `dwc_event_date`, `id_taxa_obs`, `obs_value`, `id_variables`, `within_quebec` ensures that each observation is uniquely identifiable and retrievable. This is used to prevent duplicates using the index `observations_unique_rows`.

### Indexes

- `dwc_event_date_idx` on `dwc_event_date`
- `observations_geom_date_time_idx` on `geom`, `year_obs`, `month_obs`, `day_obs`, `time_obs`
- `observations_geom_idx` on `geom`
- `observations_id_datasets_id_taxa_idx` on `id_datasets`, `id_taxa`
- `observations_id_datasets_idx` on `id_datasets`
- `observations_id_idx` on `id`
- `observations_id_taxa_obs_dwc_event_date_geom_idx` on `id_taxa_obs`, `dwc_event_date`, `geom`
- `observations_id_taxa_obs_idx` on `id_taxa_obs`
- `observations_unique_rows` on `geom`, `dwc_event_date`, `id_taxa_obs`, `obs_value`, `id_variables`, `within_quebec`
- `observations_year_obs_idx` on `year_obs`
- Specific indexes on partitions (`within_quebec_year_obs_idx`, `observations_id_taxa_obs_idx` in `observations_partitions.within_quebec`)

### Triggers

- `set_dwc_event_date_trggr`: Before insert, sets the DwC event date.
- `update_modified_at`: Before update, updates the `modified_at` timestamp.
- `action_user_logger`: In partition `observations_partitions.outside_quebec`, logs user actions before insert or update.

### Rationale

#### Use of Partitions for Performance

The use of table partitions in the observations table, particularly with the within_quebec column, is a strategic decision aimed at enhancing database performance. Partitioning is a highly effective method for managing large tables by splitting them into smaller, more manageable pieces. In this case, the observations_partitions schema segregates observation data into distinct partitions based on whether the observations occurred within Quebec (within_quebec = true) or outside it (within_quebec = false). This approach significantly improves query performance by allowing the database engine to quickly locate and retrieve data from a smaller subset of the table. Additionally, it simplifies maintenance tasks such as backups and data purges, as operations can be performed on individual partitions without affecting the entire dataset.

Partition tables `observations_partitions.within_quebec` and `observations_partitions.outside_quebec` are created within the `observations_partitions` schema. 

#### Temporal Columns

The inclusion of year_obs, month_obs, day_obs, and time_obs columns in the observations table is intentionally designed to accommodate observations with varying levels of temporal resolution. This flexibility is crucial in ecological data collection, where the exact time of an observation may range from a specific moment to a broader time frame. By breaking down the observation timestamp into separate components, the database can store and process data that is only accurate to a certain level (e.g., year, month, day, or time). This structure not only caters to the diverse nature of ecological observations but also enhances the ability to perform time-based queries and analyses with varying granularities.

#### Duplicates and DwC Event Date

Duplicates are possible through the process of adding data from various sources, such as GBIF and eBird. Duplicates are limited through the use of a unique constraint on the combination of `geom`, `dwc_event_date`, `id_taxa_obs`, `obs_value`, `id_variables`, `within_quebec`. 

The `dwc_event_date` column values are generated automatically using a trigger function. It is a formatted string that reflects a standardized approach to recording event dates in biodiversity data. The use of this column is required to ensure each observation is distinctly identifiable and retrievable. It also facilitates data interoperability, making it easier to share and compare ecological data across different platforms and studies.