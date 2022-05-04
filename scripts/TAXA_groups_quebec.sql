--------------------------------------------------------------------------------
-- DESCRIPTION
-- Objects to generate and maintain a list of taxa observed within quebec
--
-- METHOD
-- `taxa_group` named `quebec` and a method to update it from observation table
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- 0. Create quebec taxa_group
--------------------------------------------------------------------------------

-- Already updated in taxa_groups



--------------------------------------------------------------------------------
-- 1. Function to update list of quebec observations from obs within quebec
--
-- Only stores observed ref scientific_name
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION refresh_taxa_group_members_quebec()
RETURNS void AS
$$
INSERT INTO taxa_group_members
WITH qc_group as (
	select id from taxa_groups
	where lower(vernacular_en) = 'quebec'
)
SELECT
    distinct on (taxa_ref.scientific_name)
    qc_group.id id_group,
    taxa_ref.scientific_name
FROM
    observations obs,
	qc_group,
    taxa_obs_ref_lookup ref_lu,
    taxa_ref
WHERE obs.within_quebec IS TRUE
    AND obs.id_taxa_obs = ref_lu.id_taxa_obs
    AND ref_lu.is_parent IS NOT TRUE
    AND ref_lu.id_taxa_ref = taxa_ref.id
$$ LANGUAGE SQL;

SELECT refresh_taxa_group_members_quebec();