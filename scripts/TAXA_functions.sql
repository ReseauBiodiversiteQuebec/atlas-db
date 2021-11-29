-- Clean previous taxa_functions
DROP FUNCTION IF EXISTS get_taxa_obs_from_name(text, text);
DROP FUNCTION IF EXISTS get_taxa_ref_relatives(integer);
DROP VIEW IF EXISTS observations_taxa_ref CASCADE;
DROP FUNCTION IF EXISTS get_observation_from_taxa(text, text);


--Procedures MATCHING OF SCIENTIFIC NAME
DROP FUNCTION IF EXISTS match_taxa_obs(text);
CREATE FUNCTION match_taxa_obs(
	taxa_name text	
)
RETURNS SETOF taxa_obs AS $$
    select distinct taxa_obs.*
    from taxa_ref search_ref
    left join taxa_obs_ref_lookup search_lookup
        on search_ref.id = search_lookup.id_taxa_ref
    left join taxa_obs_ref_lookup synonym_lookup
        on search_lookup.id_taxa_ref_valid = synonym_lookup.id_taxa_ref_valid
    left join taxa_obs
	    on synonym_lookup.id_taxa_obs = taxa_obs.id
    where search_ref.scientific_name = taxa_name
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

DROP FUNCTION IF EXISTS filter_observations_from_taxa_match(text);
CREATE FUNCTION filter_observations_from_taxa_match(
    name text)
RETURNS SETOF observations AS $$
    SELECT obs.*
    FROM observations obs
    WHERE obs.id_taxa_obs in (select id from match_taxa_obs(name))
$$ LANGUAGE sql;

-- List observed taxa
CREATE OR REPLACE VIEW list_valid_taxa AS
    SELECT DISTINCT(taxa_ref.*)
    FROM public.taxa_obs_ref_lookup lookup
    LEFT JOIN public.taxa_ref taxa_ref on lookup.id_taxa_ref_valid = taxa_ref.id
    WHERE lookup.match_type is not null;

-- Autocomplete taxa_name
DROP FUNCTION IF EXISTS autocomplete_taxa_name (text);
CREATE FUNCTION autocomplete_taxa_name(
    name text)
RETURNS TABLE (scientific_name text) AS $$
    SELECT DISTINCT(taxa_ref.scientific_name)
    FROM taxa_ref
    WHERE LOWER(scientific_name) like '%' || LOWER(name) || '%'
$$ LANGUAGE sql;

-- select autocomplete_taxa_name('corb');