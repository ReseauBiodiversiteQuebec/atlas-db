-- Clean previous taxa_functions
DROP VIEW IF EXISTS observations_taxa_ref CASCADE;
DROP FUNCTION IF EXISTS get_observation_from_taxa(text, text);

CREATE OR REPLACE VIEW taxa_obs_synonym_lookup AS (
    SELECT
        distinct match_obs.id_taxa_obs, synonym_obs.id_taxa_obs AS id_taxa_obs_synonym
    FROM taxa_obs_ref_lookup AS match_obs
    LEFT JOIN taxa_obs_ref_lookup AS synonym_obs
        ON match_obs.id_taxa_ref_valid = synonym_obs.id_taxa_ref
    WHERE match_obs.is_parent IS FALSE
        AND synonym_obs.is_parent IS FALSE
        AND match_obs.id_taxa_obs <> synonym_obs.id_taxa_obs
);


--Procedures MATCHING OF SCIENTIFIC NAME
DROP FUNCTION IF EXISTS match_taxa_obs(text);
CREATE OR REPLACE FUNCTION match_taxa_obs(
	taxa_name text	
)
-- returns integer[]
RETURNS SETOF taxa_obs AS $$
    with match_taxa_obs as (
        (
            SELECT distinct(match_obs.id_taxa_obs) as id_taxa_obs
            FROM taxa_ref AS matched_ref
            LEFT JOIN taxa_obs_ref_lookup AS match_obs
                ON matched_ref.id = match_obs.id_taxa_ref
            WHERE matched_ref.scientific_name ILIKE $1
        ) UNION (
            select distinct(vernacular_lookup.id_taxa_obs) as id_taxa_obs
            from taxa_vernacular
            left join taxa_obs_vernacular_lookup vernacular_lookup
                on taxa_vernacular.id = vernacular_lookup.id_taxa_vernacular
            where taxa_vernacular.name ILIKE $1
        )
    ), synonym_taxa_obs as (
        select id_taxa_obs from match_taxa_obs
        UNION
        SELECT id_taxa_obs_synonym as id_taxa_obs
        from taxa_obs_synonym_lookup
        JOIN match_taxa_obs USING (id_taxa_obs)
    )
    select distinct on (id_taxa_obs) taxa_obs.*
    from synonym_taxa_obs, taxa_obs
    where id_taxa_obs = taxa_obs.id
$$ LANGUAGE sql;

DROP FUNCTION IF EXISTS match_taxa_ref_relatives(text);
CREATE FUNCTION match_taxa_ref_relatives(
    taxa_name text)
RETURNS SETOF public.taxa_ref AS $$
    select distinct taxa_ref.*
    from taxa_ref search_ref
    left join taxa_obs_ref_lookup search_lookup
        on search_ref.id = search_lookup.id_taxa_ref
    left join taxa_obs_ref_lookup synonym_lookup
        on search_lookup.id_taxa_ref_valid = synonym_lookup.id_taxa_ref_valid
    left join taxa_ref
        on synonym_lookup.id_taxa_ref = taxa_ref.id
    where search_ref.scientific_name = taxa_name
    $$ LANGUAGE sql;

-- Filter observations from taxa

DROP FUNCTION IF EXISTS filter_qc_obs_from_taxa_match(text);
CREATE FUNCTION filter_qc_obs_from_taxa_match(
    name text)
RETURNS SETOF observations AS $$
    SELECT obs.*
    FROM observations obs
    WHERE obs.id_taxa_obs in (select id from match_taxa_obs(name));
        -- and obs.within_quebec is TRUE;
$$ LANGUAGE sql;

-- List observed taxa
CREATE OR REPLACE VIEW list_valid_taxa AS
    SELECT DISTINCT(taxa_ref.*)
    FROM public.taxa_obs_ref_lookup lookup
    LEFT JOIN public.taxa_ref taxa_ref on lookup.id_taxa_ref_valid = taxa_ref.id
    WHERE lookup.match_type is not null;

-- -----------------------------------------------------------------------------
-- FUNCTION match_taxa_groups
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION match_taxa_groups(
	id_taxa_obs integer[]
)
RETURNS SETOF taxa_groups AS $$
	with group_id_taxa_obs as (
		select
			id_group,
			array_agg(id_taxa_obs) id_taxa_obs
		from taxa_obs_group_lookup
		group by id_group
	)
	select taxa_groups.* from group_id_taxa_obs, taxa_groups
	where $1 <@ id_taxa_obs
		and id_group = taxa_groups.id
$$ language sql;


