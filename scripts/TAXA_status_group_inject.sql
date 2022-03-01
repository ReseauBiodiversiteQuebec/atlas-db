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

UPDATE taxa_status_group_lookup
SET group_id = id
FROM taxa_groups
where taxa_groups.vernacular_fr = taxa_status_group_lookup.vernacular_fr;
INSERT INTO taxa_group_members
select
	lookup.group_id id_group,
	taxa.scientific_name
from taxa_status_group_lookup lookup, taxa
where lookup.old_status = taxa.qc_status::text
REFRESH MATERIALIZED VIEW taxa_obs_group_lookup
SELECT qc_status from taxa where scientific_name = 'Pseudacris triseriata'