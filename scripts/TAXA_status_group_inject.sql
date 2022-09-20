-- SELECT distinct qc_status from taxa
CREATE TEMPORARY TABLE IF NOT EXISTS taxa_status_group_lookup (
	old_status text,
	vernacular_fr text,
	vernacular_en text,
	group_id integer);

INSERT INTO taxa_status_group_lookup
VALUES 
	('Susceptible', 'Espèce susceptible', '', NULL),
	('Vulnérable', 'Espèce vulnérable', '', NULL),
	('Vulnérable à la récolte', 'Espèce vulnérable à la récolte', '', NULL),
	('Menacée', 'Espèce menacée', '', NULL);

INSERT INTO taxa_groups (vernacular_fr, vernacular_en)
	SELECT vernacular_fr, vernacular_en
	FROM taxa_status_group_lookup;

UPDATE taxa_groups
SET source_desc = 'CDPNQ'
WHERE vernacular_fr = ANY(ARRAY[
	'Espèce vulnérable',
	'Espèce vulnérable à la récolte',
	'Espèce menacée',
	'Espèce susceptible']);

UPDATE taxa_status_group_lookup
	SET group_id = id
	FROM taxa_groups
	where taxa_groups.vernacular_fr = taxa_status_group_lookup.vernacular_fr;

INSERT INTO taxa_group_members
	select
		lookup.group_id id_group,
		taxa.scientific_name
	from taxa_status_group_lookup lookup, taxa
	where lookup.old_status = taxa.qc_status::text;
REFRESH MATERIALIZED VIEW taxa_obs_group_lookup;

-- TEST
SELECT qc_status from taxa where scientific_name = 'Pseudacris triseriata';


-- CREATE A GROUP FOR ALL status species
INSERT INTO taxa_groups (level, vernacular_en, vernacular_fr)
	VALUES (2, '', 'Espèces à statut CDPNQ');

INSERT INTO taxa_group_members (id_group, scientific_name)
SELECT big_group.id, scientific_name
FROM taxa_group_members, taxa_groups cdpnq_groups, taxa_groups big_group
WHERE source_desc = 'CDPNQ'
	and cdpnq_groups.id = taxa_group_members.id_group
	and big_group.vernacular_fr = 'Espèces à statut CDPNQ';

	
