-- Make sure column where there is a constraint cannot be null for efficient
--    comparison at insertion.

ALTER TABLE public.variables DROP CONSTRAINT variables_name_unit_key;
UPDATE public.variables SET unit = '' where unit is null;
WITH first_variable as (
	select distinct on (name, unit) *
	from variables
	order by name, unit, id
), match_variable as (
	select var.id as id_var, f_var.id as good_id_var
	from variables var
	left join first_variable f_var
		on var.name = f_var.name
		and var.unit = f_var.unit
), update_obs as (
UPDATE observations
SET id_variables = match_variable.good_id_var
FROM match_variable
WHERE observations.id_variables = match_variable.id_var)
DELETE FROM variables
where id not in (select good_id_var from match_variable);

ALTER TABLE public.variables
    ADD CONSTRAINT variables_name_unit_key UNIQUE (name, unit);
ALTER TABLE public.variables
    ALTER COLUMN unit SET NOT NULL;
ALTER TABLE public.variables
    ALTER COLUMN unit SET DEFAULT '';

-- ALTER COLUMN TAXA_OBS

ALTER TABLE public.taxa_obs
    ADD CONSTRAINT taxa_obs_scientific_name_authorship_key
    UNIQUE (scientific_name, authorship);
ALTER TABLE public.taxa_obs
    ALTER COLUMN authorship SET NOT NULL;
ALTER TABLE public.taxa_obs
    ALTER COLUMN authorship SET DEFAULT '';