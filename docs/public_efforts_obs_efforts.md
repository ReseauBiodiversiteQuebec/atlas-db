## Table: Efforts

### Description

The `efforts` table is specifically designed to record the efforts associated with ecological observations. This table plays a crucial role in quantifying and categorizing the effort invested in obtaining various observations. The efforts could be in various forms like time spent, area covered, traps used, etc., and are quantified as numeric values. The link to the `variables` table through `id_variables` specifies the type of effort being recorded, ensuring a standardized and coherent approach to effort recording across different observation types.

#### Relationship with Observations

The efforts table is intricately linked to the observations table through the obs_efforts lookup table. This table acts as a relational bridge, establishing a connection between individual observations and the corresponding efforts involved in their acquisition. The obs_efforts table essentially serves as a many-to-many relationship facilitator, allowing each observation to be associated with one or more effort entries, and vice versa. See the `obs_efforts` table documentation for more details.

### Dependencies

- Sequence: `efforts_id_seq`
- Foreign Key: 
  - `id_variables` references `public.variables (id)`

### Columns

| **Column Name**   | **Type**    | **Description**                                              | **Constraints**                                      |
|-------------------|-------------|--------------------------------------------------------------|------------------------------------------------------|
| **id**            | Integer     | A unique identifier for each effort entry.                   | Primary key, Not Null, Default: nextval('efforts_id_seq'::regclass) |
| **id_variables**  | Integer     | The identifier of the variable associated with the effort.   | Not Null, Foreign key                                |
| **effort_value**  | Numeric     | The quantitative value representing the effort.              | Not Null, Part of Unique Constraint                   |

### Additional Constraints

- **Unique Constraint**: `efforts_id_variables_effort_value_key` ensures that each combination of `id_variables` and `effort_value` is unique within the table, preventing redundancy in effort recording.

### Foreign Key Constraints

- `efforts_id_variables_fkey`: Links to the `variables` table, ensuring that each effort is associated with a valid variable type, providing context and meaning to the effort value recorded.


## Table: Obs_Efforts

### Description

The `obs_efforts` table serves as a linking mechanism between ecological observations and the efforts associated with them. It is a junction table designed to create a many-to-many relationship, capturing which efforts are related to specific observations. This design is essential for providing a comprehensive understanding of the resources and efforts expended in gathering each observation, such as the time, distance covered, or equipment used. By establishing a clear connection between observations and their corresponding efforts, this table enhances the granularity and context of ecological data analysis.

### Dependencies

- Foreign Keys: 
  - `id_obs` references an observation table (to be specified).
  - `id_efforts` references `public.efforts (id)`

### Columns

| **Column Name** | **Type** | **Description**                                                                                     | **Constraints** |
|-----------------|----------|-----------------------------------------------------------------------------------------------------|-----------------|
| **id_obs**      | Bigint   | The identifier of the observation. Represents a link to a specific observation record.              | Not Null, Part of Unique Constraint |
| **id_efforts**  | Integer  | The identifier of the effort. Links to a specific effort record in the `efforts` table.             | Not Null, Foreign key, Part of Unique Constraint |

### Additional Constraints

- **Unique Constraint**: `obs_efforts_id_obs_id_efforts_key` ensures that each combination of `id_obs` and `id_efforts` is unique within the table, preventing duplication in the linking of observations and efforts.

### Foreign Key Constraints

- `obs_efforts_id_efforts_fkey`: Ensures the integrity of the link between the `obs_efforts` and `efforts` tables, confirming that every effort associated with an observation is valid and exists in the `efforts` table.