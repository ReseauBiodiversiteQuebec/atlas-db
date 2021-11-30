SELECT
    insert_taxa_vernacular_from_obs(
        taxa_obs.id
    )
from taxa_obs
where taxa_obs.id not in (select id_taxa_obs from taxa_obs_vernacular_lookup)