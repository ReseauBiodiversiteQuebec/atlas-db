## Table: Taxa_Obs

### Description

The `taxa_obs` table is structured to record raw taxonomic information directly from source data. This table is essential for capturing a wide range of taxonomic details, including scientific names, authorship, and taxonomic rank. It is designed to accommodate taxa of any rank, such as species, genus, complexes, etc., without requiring corrections for grammatical accuracy or valid taxonomy. These aspects are managed by other resources within the database, like the `taxa_ref` table.

### Dependencies

- Sequence: `taxa_obs_id_seq`

### Columns

| **Column Name**          | **Type**                   | **Description**                                         | **Constraints**                               |
|--------------------------|----------------------------|---------------------------------------------------------|-----------------------------------------------|
| **id**                   | Integer                    | A unique identifier for each taxonomic observation.     | Primary key, Not Null, Default: nextval('taxa_obs_id_seq'::regclass), Using Index Tablespace ssdpool |
| **scientific_name**      | Text                       | *Optional*. The scientific name of the taxon observed. This includes taxa at any rank, such as species or genus. | Not Null, Part of Unique Constraint |
| **authorship**           | Text                       | *Optional*. The authorship of the scientific name. Defaults to an empty string if not provided. | Not Null, Default: '' (empty string), Part of Unique Constraint |
| **rank**                 | Text                       | *Optional*. The taxonomic rank of the observation. Defaults to an empty string if not provided. | Default: '' (empty string), Part of Unique Constraint |
| **parent_scientific_name** | Text                    | *Optional*. The scientific name of the parent taxon. Used to resolve conflicts where a scientific name corresponds to different organisms in different branches of the tree of life. Optional; if not specified, all results for the given scientific name are returned. | - |
| **created_at**           | Timestamp with time zone   | *Auto on insert/update*. The timestamp when the taxonomic observation was created. | Not Null, Default: CURRENT_TIMESTAMP |
| **modified_at**          | Timestamp with time zone   | *Auto on insert/update*. The timestamp when the taxonomic observation was last modified. | Not Null, Default: CURRENT_TIMESTAMP |
| **modified_by**          | Text                       | *Auto on insert/update*. The user who last modified the taxonomic observation record. | Not Null, Default: CURRENT_USER |

### Additional Constraints

- **Unique Constraint**: `taxa_obs_unique_rows` ensures that each combination of `scientific_name`, `authorship`, and `rank` is unique within the table.

### Indexes

- `taxa_obs_scientific_name_idx` on `scientific_name`

### Triggers

- `update_modified_at`: Before update, updates the `modified_at` timestamp.

### Conflicts and Parent Taxa

The design of the `taxa_obs` table accounts for the potential conflicts in scientific naming. For instance, the same scientific name may correspond to different organisms in separate branches of the tree of life (e.g., `Salix` as a genus of willows in plants and a genus of tunicates in animals). To resolve such conflicts, the `parent_scientific_name` column allows users to specify a parent taxa name, thus restricting results to a specific branch. This feature is particularly useful for accurate data retrieval and association in cases of nomenclatural ambiguity.