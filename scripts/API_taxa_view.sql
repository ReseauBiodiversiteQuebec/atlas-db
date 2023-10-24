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


-- -----------------------------------------------------
DROP FUNCTION IF EXISTS api.__taxa_join_attributes(integer[]);
CREATE OR REPLACE FUNCTION api.__taxa_join_attributes(
	taxa_obs_id integer[]
) RETURNS TABLE (
	id_taxa_obs INTEGER,
	observed_scientific_name TEXT,
	valid_scientific_name TEXT,
	rank TEXT,
	vernacular_en TEXT,
	vernacular_fr TEXT,
	group_en TEXT,
	group_fr TEXT,
	vernacular JSON,
	source_references JSON
)
AS $$
	with all_ref as (
		select
			obs_lookup.id_taxa_obs,
			taxa_ref.scientific_name valid_scientific_name,
			taxa_ref.rank,
			taxa_ref.source_name,
			coalesce(source_priority, 9999) source_priority,
			taxa_ref.source_record_id source_taxon_key
		from taxa_obs_ref_lookup obs_lookup
		left join taxa_ref on obs_lookup.id_taxa_ref_valid = taxa_ref.id
		left join api.taxa_ref_sources USING (source_id)
		WHERE obs_lookup.match_type is not null
			AND obs_lookup.match_type != 'complex'
			AND obs_lookup.id_taxa_obs = ANY($1)
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
			AND group_lookup.id_taxa_obs = ANY($1)
	), vernacular_all as(
		select
			v_lookup.id_taxa_obs, taxa_vernacular.*,
			coalesce(source_priority, 9999) source_priority,
			match_type,
			coalesce(taxa_vernacular.rank_order, -1) rank_order
		from taxa_obs_vernacular_lookup v_lookup
		left join taxa_vernacular on v_lookup.id_taxa_vernacular = taxa_vernacular.id
		LEFT JOIN api.taxa_vernacular_sources USING (source_name)
		where match_type is not null and match_type <> 'complex'
			AND v_lookup.id_taxa_obs = ANY($1)
		order by v_lookup.id_taxa_obs, match_type, taxa_vernacular.rank_order desc, source_priority
	), best_vernacular as (
		select
			ver_en.id_taxa_obs,
			ver_en.name as vernacular_en,
			ver_fr.name as vernacular_fr
		from (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'eng')  as ver_en
		left join (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'fra') as ver_fr
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
$$ LANGUAGE sql STABLE;



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
			coalesce(source_priority, 9999) source_priority,
			taxa_ref.source_record_id source_taxon_key
		from taxa_obs_ref_lookup obs_lookup
		left join taxa_ref on obs_lookup.id_taxa_ref_valid = taxa_ref.id
		left join api.taxa_ref_sources USING (source_id)
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
		select
			v_lookup.id_taxa_obs, taxa_vernacular.*,
			coalesce(source_priority, 9999) source_priority,
			match_type,
			coalesce(taxa_vernacular.rank_order, -1) rank_order
		from taxa_obs_vernacular_lookup v_lookup
		left join taxa_vernacular on v_lookup.id_taxa_vernacular = taxa_vernacular.id
		LEFT JOIN api.taxa_vernacular_sources USING (source_name)
		where match_type is not null and match_type <> 'complex'
		order by v_lookup.id_taxa_obs, match_type, taxa_vernacular.rank_order desc, source_priority
	), best_vernacular as (
		select
			ver_en.id_taxa_obs,
			ver_en.name as vernacular_en,
			ver_fr.name as vernacular_fr
		from (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'eng')  as ver_en
		left join (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'fra') as ver_fr
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
select *
from api.__taxa_join_attributes(match_taxa_obs_id($1))
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
			where short_group = 'ALL_SPECIES'
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

DROP FUNCTION IF EXISTS api.taxa_autocomplete_temp (text, integer);
CREATE OR REPLACE FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer DEFAULT 20)
RETURNS json AS $$
	with matches as (
		select
			id_taxa_obs, matched_name, rank,
			CASE
				WHEN match_type = 'parent'
					or match_type = 'complex_common_parent'
					or match_type = 'higherrank'
					or match_type is null THEN 'parent'
				WHEN match_type = 'complex' THEN 'complex'
				ELSE 'match'
			END as match_type,
			CASE
				WHEN matched_name ilike $1 THEN 0
				WHEN matched_name ilike $1 || '%' THEN 1
				WHEN matched_name ilike '% ' || $1 || '%' THEN 2
				ELSE 3
			END as order_rank
		from (
			(select
				distinct on (taxa_vernacular.name)
				id_taxa_obs, taxa_vernacular.name matched_name,
				coalesce(taxa_vernacular."rank", '') as rank,
				v_lu.match_type
			from taxa_vernacular
			join taxa_obs_vernacular_lookup v_lu on v_lu.id_taxa_vernacular = taxa_vernacular.id
			where taxa_vernacular.name ilike '%' || $1 || '%'
			order by taxa_vernacular.name, taxa_vernacular.rank nulls last)
			union
			(select
				distinct on (taxa_ref.scientific_name)
				ref_lu.id_taxa_obs, taxa_ref.scientific_name matched_name,
				coalesce(taxa_ref."rank", '') as rank,
				ref_lu.match_type
			from taxa_obs_ref_lookup ref_lu, taxa_ref
			where ref_lu.id_taxa_ref = taxa_ref.id
				and taxa_ref.scientific_name ilike '%' || $1 || '%'
			order by taxa_ref.scientific_name, taxa_ref.rank nulls last)
		) as sub_m
		order by order_rank, matched_name, rank nulls last
		LIMIT $2
	), vernacular_match as (
		SELECT
			matches.id_taxa_obs,
			matches.matched_name,
			v.name,
			v.language,
			COALESCE(v.rank, '') AS rank,
			source_priority
		FROM matches
		JOIN taxa_obs_vernacular_lookup v_lu ON v_lu.id_taxa_obs = matches.id_taxa_obs
		JOIN taxa_vernacular v ON v_lu.id_taxa_vernacular = v.id
		LEFT JOIN api.taxa_ref_sources ON v.source_name = api.taxa_ref_sources.source_name
		WHERE v.language IN ('eng', 'fra')
			AND matches.match_type = 'match'
			AND v_lu.match_type NOT IN ('parent', 'complex_common_parent', 'higherrank', 'complex')
	), vernacular_parent as (
		SELECT
			matches.id_taxa_obs,
			matches.matched_name,
			v.name,
			v.language,
			coalesce(v.rank, '') as rank,
			source_priority
		FROM matches
		JOIN taxa_obs_vernacular_lookup v_lu ON v_lu.id_taxa_obs = matches.id_taxa_obs
		JOIN taxa_vernacular v ON v_lu.id_taxa_vernacular = v.id
		LEFT JOIN api.taxa_ref_sources ON v.source_name = api.taxa_ref_sources.source_name
		where
			v.language in ('eng', 'fra')
			and matches.match_type = 'parent'
			and coalesce(v.rank = matches.rank, FALSE)
	), vernacular as (
		select
			distinct on (id_taxa_obs, matched_name, language) *
		from (
			select * from vernacular_match
			union
			select * from vernacular_parent
		) as sub_vernacular
		order by id_taxa_obs, matched_name, language, source_priority
	), ref_parent as (
		SELECT 
			ref_lu.id_taxa_obs,
			matches.matched_name,
			r.scientific_name,
			coalesce(r.rank, '') as rank,
			source_priority
		from matches, taxa_ref r, taxa_obs_ref_lookup ref_lu, api.taxa_ref_sources
		where ref_lu.id_taxa_obs = matches.id_taxa_obs
			and ref_lu.id_taxa_ref_valid = r.id
			and r.source_id = api.taxa_ref_sources.source_id
			and matches.match_type = 'parent'
			and coalesce(r.rank = matches.rank, FALSE)
			and (ref_lu.match_type in ('parent', 'complex_common_parent', 'higherrank') or ref_lu.match_type is null)
	), ref_match as (
		select
			rlu.id_taxa_obs,
			matches.matched_name,
			r.scientific_name,
			r.rank,
			source_priority
		from
			matches,
			taxa_obs_ref_lookup rlu,
			taxa_ref r,
			api.taxa_ref_sources
		where
			matches.id_taxa_obs = rlu.id_taxa_obs
			and rlu.id_taxa_ref_valid = r.id
			and r.source_id = api.taxa_ref_sources.source_id
			and matches.match_type = 'match'
			and rlu.match_type not in ('parent', 'complex_common_parent', 'higherrank', 'complex')
	), ref as (
		select distinct on (id_taxa_obs, matched_name)
			id_taxa_obs, matched_name, scientific_name, rank
		from (
			select * from ref_parent
			union
			select * from ref_match
		) as sub_ref
		order by id_taxa_obs, matched_name, rank nulls last, source_priority
	), vernacular_en as (
		select * from vernacular where language = 'eng'
	), vernacular_fr as (
		select * from vernacular where language = 'fra'
	), records as (
		SELECT
			matched_name as matched_name,
			ref.scientific_name as scientific_name,
			v_fr.name as vernacular_fr,
			v_en.name as vernacular_en,
			matches.rank as category_fr,
			matches.rank as category_en
		FROM matches
		LEFT JOIN ref USING (id_taxa_obs, matched_name)
		LEFT JOIN vernacular_fr v_fr USING (id_taxa_obs, matched_name)
		LEFT JOIN vernacular_en v_en USING (id_taxa_obs, matched_name)
		ORDER BY order_rank, matched_name
	)
	SELECT
		json_agg(json_build_object(
			'matched_name', matched_name,
			'scientific_name', scientific_name,
			'vernacular_fr', vernacular_fr,
			'vernacular_en', vernacular_en,
			'category_fr', category_fr,
			'category_en', category_en
		))
	FROM records
$$ LANGUAGE sql STABLE;

-- TEST FUNCTION
-- SELECT * FROM api.taxa_autocomplete_temp('Acer');
-- SELECT * FROM api.taxa_autocomplete('Acer', 1);
-- TEST FOR SPECIES OUT OF QUEBEC
-- SELECT * FROM api.taxa_autocomplete('


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
	with nodes AS (
		select
			id_taxa_ref_valid,
			bool_and((coalesce(match_type = 'complex_closest_parent', false) or is_parent is true) is false) is_tip,
			min(id_taxa_obs) id_taxa_obs,
			count(id_taxa_ref_valid) count_taxa_ref
		from taxa_obs_ref_lookup obs_lookup
		WHERE obs_lookup.id_taxa_obs = any(taxa_obs_ids)
			and (match_type != 'complex' or match_type is null)
		group by id_taxa_ref_valid
	)
	select array_agg(distinct(id_taxa_obs)) id
	from nodes
	where is_tip is true
$$ LANGUAGE sql;

CREATE OR REPLACE AGGREGATE api.taxa_branch_tips (integer) (
	SFUNC = array_append,
	STYPE = integer[],
	FINALFUNC = api.taxa_branch_tips,
	INITCOND = '{}'
);