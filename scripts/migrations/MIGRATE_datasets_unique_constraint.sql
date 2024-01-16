-- Add a unique constraint on table datasets based on pair (original_source, org_dataset_id)
--   Because of the duplicates, we need to update depending tables first, then delete duplicates, then add the constraint
--   This is done in 4 steps:
--   1. Create a temporary table with the unique values
--   2. Update depending tables
--   3. Delete duplicates
--   4. Add the constraint

-- 0. Create index on original_source, org_dataset_id to speed up the process
CREATE INDEX datasets_original_source_org_dataset_id_idx ON datasets (original_source, org_dataset_id);
CREATE INDEX datasets_original_source_idx ON datasets (original_source);
CREATE INDEX datasets_org_dataset_id_idx ON datasets (org_dataset_id);

-- 1. Create a temporary table with correspondance between kept_id and deleted_id
DROP TABLE IF EXISTS tmp_datasets;
CREATE TABLE tmp_datasets AS
with datasets as (select * from datasets limit 1000)
SELECT distinct on (k.original_source, k.org_dataset_id)
    k.id as kept_id, d.id as deleted_id
FROM datasets k, datasets d
WHERE k.original_source = d.original_source
AND k.org_dataset_id = d.org_dataset_id
AND k.id <> d.id
AND k.org_dataset_id IS NOT NULL
AND d.org_dataset_id IS NOT NULL
ORDER BY k.original_source, k.org_dataset_id, k.id DESC;

-- 2. Update depending tables
UPDATE observations
SET id_datasets = tmp_datasets.kept_id
FROM tmp_datasets
WHERE id_datasets = tmp_datasets.deleted_id;

-- 3. Delete duplicates
DELETE FROM datasets
WHERE id IN (SELECT deleted_id FROM tmp_datasets);

-- 4. Add the constraint
ALTER TABLE datasets
ADD CONSTRAINT datasets_original_source_org_dataset_id_key UNIQUE (original_source, org_dataset_id);

-- 5. Clean up
DROP TABLE tmp_datasets;
DROP INDEX datasets_original_source_org_dataset_id_idx;
DROP INDEX datasets_original_source_idx;
DROP INDEX datasets_org_dataset_id_idx;