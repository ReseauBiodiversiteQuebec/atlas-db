-- DROP VIEW if exists api.taxa CASCADE;
CREATE OR REPLACE VIEW api.taxa AS (
	with obs_ref as (
		select
			obs_lookup.id_taxa_obs,
            MIN(taxa_obs.scientific_name) observed_scientific_name,
			taxa_ref.scientific_name valid_scientific_name,
			taxa_ref.rank,
			json_agg(json_build_object(
			   'source_name', taxa_ref.source_name,
			   'source_taxon_key', taxa_ref.source_record_id,
			   'source_scientific_name', taxa_ref.scientific_name)
			   ) as source_references
		from taxa_obs_ref_lookup obs_lookup
		join taxa_obs_group_lookup qc_lookup
			on obs_lookup.id_taxa_obs = qc_lookup.id_taxa_obs
        left join taxa_obs on obs_lookup.id_taxa_obs = taxa_obs.id
		left join taxa_ref on obs_lookup.id_taxa_ref_valid = taxa_ref.id
		where obs_lookup.match_type is not null
			and qc_lookup.id_group = 20
		group by (obs_lookup.id_taxa_obs, taxa_ref.scientific_name, taxa_ref.rank)
	), obs_group as (
		select
			group_lookup.id_taxa_obs,
			taxa_groups.vernacular_en as group_en,
			taxa_groups.vernacular_fr as group_fr
		from taxa_obs_group_lookup group_lookup
		left join taxa_groups on group_lookup.id_group = taxa_groups.id
		where taxa_groups.level = 1
	), status_group as (
		SELECT
			group_lookup.id_taxa_obs,
			taxa_groups.vernacular_en as vernacular_en,
			taxa_groups.vernacular_fr as vernacular_fr
		from taxa_obs_group_lookup group_lookup
		left join taxa_groups on group_lookup.id_group = taxa_groups.id
		where taxa_groups.id = ANY (ARRAY[21, 22, 23, 24])
	), vernacular_all as(
		select v_lookup.id_taxa_obs, taxa_vernacular.*
		from taxa_obs_vernacular_lookup v_lookup
		left join taxa_vernacular on v_lookup.id_taxa_vernacular = taxa_vernacular.id
		where match_type is not null
	), best_vernacular as (
		select
			ver_en.id_taxa_obs,
			ver_en.name as vernacular_en,
			ver_fr.name as vernacular_fr
		from (select distinct on (id_taxa_obs) id_taxa_obs, name from vernacular_all where language = 'eng') as ver_en
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
		distinct on (obs_ref.id_taxa_obs)
		obs_ref.id_taxa_obs,
        obs_ref.observed_scientific_name,
		obs_ref.valid_scientific_name,
		obs_ref.rank,
		best_vernacular.vernacular_en,
		best_vernacular.vernacular_fr,
		obs_group.group_en,
		obs_group.group_fr,
		status_group.vernacular_fr qc_status_fr,
		status_group.vernacular_en qc_status_en,
		vernacular_group.vernacular,
		obs_ref.source_references
	from
		obs_ref
	LEFT JOIN vernacular_group ON obs_ref.id_taxa_obs = vernacular_group.id_taxa_obs
	LEFT JOIN obs_group ON obs_ref.id_taxa_obs = obs_group.id_taxa_obs
	LEFT JOIN status_group ON obs_ref.id_taxa_obs = status_group.id_taxa_obs
	LEFT JOIN best_vernacular ON obs_ref.id_taxa_obs = best_vernacular.id_taxa_obs
	ORDER BY obs_ref.id_taxa_obs, obs_ref.valid_scientific_name,
        best_vernacular.vernacular_en NULLS LAST
);

-- DROP FUNCTION if exists api.match_taxa CASCADE;
CREATE OR REPLACE FUNCTION api.match_taxa (taxa_name TEXT)
RETURNS SETOF api.taxa
AS $$
SELECT t.* FROM api.taxa t, public.match_taxa_obs(taxa_name) match_t
WHERE id_taxa_obs = match_t.id
$$ LANGUAGE SQL STABLE;

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


CREATE FUNCTION api.match_taxa(taxa_name text) RETURNS SETOF api.taxa
    LANGUAGE sql STABLE
    AS $$
SELECT t.* FROM api.taxa t, public.match_taxa_obs(taxa_name) match_t
WHERE id_taxa_obs = match_t.id
$$;


ALTER FUNCTION api.match_taxa(taxa_name text) OWNER TO postgres;
