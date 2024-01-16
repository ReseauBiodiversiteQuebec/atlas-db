-- Add columns 
ALTER TABLE observations ADD COLUMN coordinate_uncertainty text;
ALTER TABLE observations ADD COLUMN coordinate_uncertainty_id_variables integer REFERENCES variables(id);
ALTER TABLE observations ADD COLUMN record_by text;
