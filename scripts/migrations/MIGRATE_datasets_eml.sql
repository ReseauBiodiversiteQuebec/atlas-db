-- Add eml columns
ALTER TABLE datasets ADD COLUMN eml json;

ALTER TABLE datasets ADD COLUMN eml_url text;