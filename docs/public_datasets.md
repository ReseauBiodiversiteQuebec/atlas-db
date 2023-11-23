## Table: Datasets

### Description

The datasets table stores comprehensive metadata about ecological observation datasets. This includes information about the source, creator, type of data, and publication details. It serves as a central repository for tracking various datasets related to ecological observations.

### Dependencies

*None*

### Columns

| **Column Name**     | **Type**                  | **Description**                                                                                       | **Constraints**       |
|---------------------|---------------------------|-------------------------------------------------------------------------------------------------------|-----------------------|
| **id**              | Integer                   | A unique identifier for each dataset.                                                                 | Primary key, Not Null |
| **original_source** | Character Varying         | The original source of the dataset. Where was it obtained from (e.g., 'GBIF', 'eBird', 'MELCCFP').    | Not Null              |
| **org_dataset_id**  | Character Varying         | *Optional*. An identifier used by the `original_source` or `publisher` for the dataset.               | -                     |
| **creator**         | Character Varying         | *Optional*. The creator of the dataset (e.g., individual researcher or institution).                  | -                     |
| **title**           | Character Varying         | The title of the dataset.                                                                             | Not Null              |
| **publisher**       | Character Varying         | *Optional*. The publisher of the dataset (e.g., 'Nature Publishing Group', 'Elsevier', 'GBIF', 'Données Québec'). | -                     |
| **modified**        | Date                      | The date when the dataset was last modified.                                                          | Not Null              |
| **keywords**        | Character Varying[]       | *Optional*. An array of keywords associated with the dataset.                                         | -                     |
| **abstract**        | Text                      | *Optional*. A brief abstract or summary of the dataset.                                               | -                     |
| **type_sampling**   | Character Varying         | *Optional*. The type of sampling method used in the dataset.                                          | -                     |
| **type_obs**        | public.type_observation   | *Optional*. The type of observation (Enum values: 'living specimen', 'preserved specimen', 'fossil specimen', 'human observation', 'machine observation', 'literature', 'material sample', 'others'). | - |
| **intellectual_rights** | Character Varying     | *Optional*. Information about the intellectual rights of the dataset.                                 | -                     |
| **license**         | Character Varying         | *Optional*. The license under which the dataset is released (e.g., 'CC BY 4.0', 'GPL', 'Entente de partage').     | -                     |
| **owner**           | Character Varying         | *Optional*. The owner of the dataset (e.g., a university, research institution, or individual researcher).        | -                     |
| **methods**         | Text                      | *Optional*. A detailed description of the methods used in the dataset.                                | -                     |
| **open_data**       | Boolean                   | A boolean indicating whether the dataset is open data.                                                | Not Null              |
| **exhaustive**      | Boolean                   | A boolean indicating whether the dataset is exhaustive, meaning obtained from a checklist survey.     | Not Null              |
| **direct_obs**      | Boolean                   | A boolean indicating whether the dataset contains direct observations.                                | Not Null              |
| **centroid**        | Boolean                   | *Optional*. A boolean indicating whether the dataset contains centroid data.                          | Default: False        |
| **doi**             | Text                      | *Optional*. The Digital Object Identifier for the dataset. (e.g. https://doi.org/10.15468/ykxm8x)     | Default: Empty String |
| **citation**        | Text                      | *Optional*. The recommended citation for the dataset.                                                 | Default: Empty String |