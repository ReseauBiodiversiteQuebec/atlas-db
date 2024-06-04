-- ALTER observations set constraint to not null to id_taxa_obs column

DELETE FROM observations WHERE id_taxa_obs IS NULL;

ALTER TABLE observations ALTER COLUMN id_taxa_obs SET NOT NULL;