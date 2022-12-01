-- -----------------------------------------------------
-- Table `api.taxa_ref_sources
-- DESCRIPTION: This table contains the list of sources for taxa data with priority
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS api.taxa_ref_sources (
  source_id INTEGER PRIMARY KEY,
  source_name VARCHAR(255) NOT NULL,
  source_priority INTEGER NOT NULL
);

DELETE FROM api.taxa_ref_sources;

INSERT INTO api.taxa_ref_sources
VALUES (1002, 'CDPNQ', 1),
	(1001, 'Bryoquel', 2),
	(147, 'VASCAN', 3),
	(3, 'ITIS', 4),
	(11, 'GBIF Backbone Taxonomy', 5),
	(1, 'Catalogue of Life', 6);

CREATE TABLE IF NOT EXISTS api.taxa_vernacular_sources(
	source_name VARCHAR(255) PRIMARY KEY,
	source_priority INTEGER NOT NULL
);

DELETE FROM api.taxa_vernacular_sources;

INSERT INTO api.taxa_vernacular_sources
VALUES ('CDPNQ', 1),
	('Bryoquel', 2),
	('Database of Vascular Plants of Canada (VASCAN)', 3),
	('Integrated Taxonomic Information System (ITIS)', 4);


-- -----------------------------------------------------------------------------
-- VIEW api.taxa
-- DESCRIPTION List all observed taxons with their matched attributes from ref
--   ref sources and vernacular sources
-- -----------------------------------------------------------------------------

-- DROP VIEW if exists api.taxa CASCADE;
CREATE OR REPLACE VIEW api.taxa AS (
	with all_ref as (
		select
			obs_lookup.id_taxa_obs,
			taxa_ref.scientific_name valid_scientific_name,
			taxa_ref.rank,
			taxa_ref.source_name,
			source_priority,
			taxa_ref.source_record_id source_taxon_key
		from taxa_obs_ref_lookup obs_lookup
		left join taxa_ref on obs_lookup.id_taxa_ref_valid = taxa_ref.id
		JOIN api.taxa_ref_sources USING (source_id)
		WHERE obs_lookup.match_type is not null
			AND obs_lookup.match_type != 'complex'
		ORDER BY obs_lookup.id_taxa_obs, source_priority
	), agg_ref as (
		select
			id_taxa_obs,
			json_agg(json_build_object(
			   'source_name', source_name,
			   'valid_scientific_name', valid_scientific_name,
			   'rank', rank, 
			   'source_taxon_key', source_taxon_key)) as source_references
		from all_ref
		group by (id_taxa_obs)
	), best_ref as (
		select
			distinct on (id_taxa_obs)
			id_taxa_obs,
			valid_scientific_name,
			rank
		from all_ref
		order by id_taxa_obs, source_priority asc
	), obs_group as (
		select
			distinct on (group_lookup.id_taxa_obs)
			group_lookup.id_taxa_obs,
			coalesce(taxa_groups.vernacular_en, 'others') as group_en,
			coalesce(taxa_groups.vernacular_fr, 'autres') as group_fr
		from taxa_obs_group_lookup group_lookup
		left join taxa_groups on group_lookup.id_group = taxa_groups.id
		where taxa_groups.level = 1
	), vernacular_all as(
		select v_lookup.id_taxa_obs, taxa_vernacular.*, source_priority
		from taxa_obs_vernacular_lookup v_lookup
		left join taxa_vernacular on v_lookup.id_taxa_vernacular = taxa_vernacular.id
		JOIN api.taxa_vernacular_sources USING (source_name)
		where match_type is not null
		order by v_lookup.id_taxa_obs, source_priority
	), best_vernacular as (
		select
			ver_en.id_taxa_obs,
			ver_en.name as vernacular_en,
			ver_fr.name as vernacular_fr
		from (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'eng' order by id_taxa_obs, source_priority NULLS LAST) as ver_en
		left join (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'fra' order by id_taxa_obs, source_priority NULLS LAST) as ver_fr
			on ver_en.id_taxa_obs = ver_fr.id_taxa_obs
	), vernacular_group as (
		select 
			vernacular_all.id_taxa_obs,
			json_agg(json_build_object(
				'name', vernacular_all.name,
				'source', vernacular_all.source_name,
				'source_taxon_key', vernacular_all.source_record_id,
				'language', vernacular_all.language
			)) as vernacular
		from vernacular_all
		group by vernacular_all.id_taxa_obs
	)
	select
		best_ref.id_taxa_obs,
        taxa_obs.scientific_name observed_scientific_name,
		best_ref.valid_scientific_name,
		best_ref.rank,
		best_vernacular.vernacular_en,
		best_vernacular.vernacular_fr,
		obs_group.group_en,
		obs_group.group_fr,
		vernacular_group.vernacular,
		agg_ref.source_references
	from best_ref
	left join taxa_obs on taxa_obs.id = best_ref.id_taxa_obs
	left join vernacular_group
		on best_ref.id_taxa_obs = vernacular_group.id_taxa_obs
	left join obs_group
		on best_ref.id_taxa_obs = obs_group.id_taxa_obs
	left join best_vernacular
		on best_ref.id_taxa_obs = best_vernacular.id_taxa_obs
	left join agg_ref
		on best_ref.id_taxa_obs = agg_ref.id_taxa_obs
	ORDER BY
		best_ref.id_taxa_obs,
        best_vernacular.vernacular_en NULLS LAST
);

-- DROP FUNCTION if exists api.match_taxa CASCADE;
CREATE OR REPLACE FUNCTION api.match_taxa (taxa_name TEXT)
RETURNS SETOF api.taxa
AS $$
SELECT t.* FROM api.taxa t, public.match_taxa_obs(taxa_name) match_t
WHERE id_taxa_obs = match_t.id
$$ LANGUAGE SQL STABLE;

ALTER FUNCTION api.match_taxa(taxa_name text) OWNER TO postgres;

-- Autocomplete taxa_name
-- DROP FUNCTION IF EXISTS api.taxa_autocomplete (text);
CREATE OR REPLACE FUNCTION api.taxa_autocomplete(
    name text)
RETURNS json AS $$
	with qc_taxa_obs as 
		(
			select id_taxa_obs id from taxa_obs_group_lookup
			where id_group = 20
		)
	SELECT json_agg(DISTINCT(matched_name))
    FROM (
        (
            select taxa_ref.scientific_name matched_name
			from qc_taxa_obs, taxa_obs_ref_lookup ref_lu, taxa_ref
			where qc_taxa_obs.id = ref_lu.id_taxa_obs
				and ref_lu.id_taxa_ref = taxa_ref.id
        ) UNION (
            select taxa_vernacular.name matched_name
			from taxa_vernacular, taxa_obs_vernacular_lookup v_lu, qc_taxa_obs
			where qc_taxa_obs.id = v_lu.id_taxa_obs
				and v_lu.id_taxa_vernacular = taxa_vernacular.id
        )
    ) taxa
    WHERE LOWER(matched_name) like '%' || LOWER(name)
		OR LOWER(matched_name) like LOWER(name) || '%';
$$ LANGUAGE sql STABLE;


CREATE OR REPLACE FUNCTION api.get_taxa_groups(taxa_keys integer[]) RETURNS SETOF api.taxa
    LANGUAGE sql STABLE
    AS $$
SELECT *
	FROM api.taxa
	WHERE id_taxa_obs = ANY(taxa_keys);
$$;


CREATE OR REPLACE FUNCTION api.match_taxa_list (taxa_names TEXT[])
RETURNS SETOF api.taxa
AS $$
with _input as (
	SELECT unnest(taxa_names) taxa_name
)
SELECT t.*
FROM
	(SELECT unnest(taxa_names) taxa_name) _input,
	api.taxa t,
	public.match_taxa_obs(_input.taxa_name) match_t
WHERE id_taxa_obs = match_t.id
$$ LANGUAGE SQL STABLE;


-- CREATE FUNCTION taxa_branch_tips that takes a list of id_taxa_obs values and
-- returns the number of unique taxa observed based on the tip-of-the-branch method

-- This function is used by the api.taxa_richness function to compute the number of
-- unique taxa observed based on the tip-of-the-branch method


DROP FUNCTION IF EXISTS api.taxa_branch_tips(integer[]);
CREATE OR REPLACE FUNCTION api.taxa_branch_tips (
    taxa_obs_ids integer[]
) RETURNS integer[] AS $$
    WITH sum_filterid_ref AS (
        select
            min(id_taxa_obs) id_taxa_obs,
            id_taxa_ref_valid id_taxa_ref,
            count(id_taxa_ref_valid) count_taxa_ref,
            min(match_type) match_type
        from taxa_obs_ref_lookup obs_lookup
        WHERE (match_type != 'complex' or match_type is null)
            AND obs_lookup.id_taxa_obs = any(taxa_obs_ids)
        group by id_taxa_ref_valid
    )
    select
        array_agg(distinct(sum_filterid_ref.id_taxa_obs)) id_taxa_obs
    from sum_filterid_ref
    where count_taxa_ref = 1
        and match_type is not null
$$ LANGUAGE sql;

CREATE OR REPLACE AGGREGATE api.taxa_branch_tips (integer) (
	SFUNC = array_append,
	STYPE = integer[],
	FINALFUNC = api.taxa_branch_tips,
	INITCOND = '{}'
);