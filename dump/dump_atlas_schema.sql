SET session_replication_role = 'replica';
--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE admins;
ALTER ROLE admins WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE atlas_remote;
ALTER ROLE atlas_remote WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE barman;
ALTER ROLE barman WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE belv1601;
ALTER ROLE belv1601 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE bres;
ALTER ROLE bres WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE cabw2601;
ALTER ROLE cabw2601 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE camv2202;
ALTER ROLE camv2202 WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE coleo;
ALTER ROLE coleo WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE coleo_remote;
ALTER ROLE coleo_remote WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE coleo_test_user;
ALTER ROLE coleo_test_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE dubr1504;
ALTER ROLE dubr1504 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE glaroc;
ALTER ROLE glaroc WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE merb2202;
ALTER ROLE merb2202 WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE read_only_all;
ALTER ROLE read_only_all WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE read_only_public;
ALTER ROLE read_only_public WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE read_write_all;
ALTER ROLE read_write_all WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE read_write_all_staging;
ALTER ROLE read_write_all_staging WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE strapidbuser;
ALTER ROLE strapidbuser WITH SUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE sviss;
ALTER ROLE sviss WITH SUPERUSER INHERIT CREATEROLE CREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE vals;
ALTER ROLE vals WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE vbeaure;
ALTER ROLE vbeaure WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE will;
ALTER ROLE will WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
--
-- User Configurations
--

--
-- User Config "postgres"
--



--
-- Role memberships
--

GRANT admins TO glaroc GRANTED BY postgres;
GRANT admins TO postgres GRANTED BY postgres;
GRANT pg_read_all_settings TO barman GRANTED BY postgres;
GRANT pg_read_all_stats TO barman GRANTED BY postgres;
GRANT postgres TO cabw2601 GRANTED BY postgres;
GRANT postgres TO camv2202 GRANTED BY postgres;
GRANT postgres TO glaroc GRANTED BY postgres;
GRANT postgres TO vbeaure GRANTED BY postgres;
GRANT read_only_all TO atlas_remote GRANTED BY postgres;
GRANT read_only_all TO bres GRANTED BY postgres;
GRANT read_only_all TO dubr1504 GRANTED BY postgres;
GRANT read_only_all TO merb2202 GRANTED BY postgres;
GRANT read_only_public TO read_only_all GRANTED BY postgres;
GRANT read_only_public TO read_write_all GRANTED BY postgres;
GRANT read_only_public TO vbeaure GRANTED BY postgres;
GRANT read_write_all TO belv1601 GRANTED BY coleo;
GRANT read_write_all TO cabw2601 GRANTED BY postgres;
GRANT read_write_all TO dubr1504 GRANTED BY postgres;
GRANT read_write_all TO glaroc GRANTED BY postgres;
GRANT read_write_all TO merb2202 GRANTED BY postgres;
GRANT read_write_all TO vals GRANTED BY postgres;
GRANT read_write_all TO vbeaure GRANTED BY postgres;
GRANT read_write_all_staging TO dubr1504 GRANTED BY postgres;
GRANT read_write_all_staging TO merb2202 GRANTED BY postgres;


--
-- PostgreSQL database cluster dump complete
--

CREATE EXTENSION postgis;
CREATE EXTENSION plpython3u;
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.10 (Ubuntu 13.10-1.pgdg20.04+1)
-- Dumped by pg_dump version 13.10 (Ubuntu 13.10-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: api; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA api;


ALTER SCHEMA api OWNER TO postgres;

--
-- Name: atlas_api; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA atlas_api;


ALTER SCHEMA atlas_api OWNER TO postgres;

--
-- Name: observations_partitions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA observations_partitions;


ALTER SCHEMA observations_partitions OWNER TO postgres;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: enum_datasets_type_obs; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_datasets_type_obs AS ENUM (
    'living specimen',
    'preserved specimen',
    'fossil specimen',
    'human observation',
    'machine observation',
    'literature'
);


ALTER TYPE public.enum_datasets_type_obs OWNER TO postgres;

--
-- Name: enum_taxa_family; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_taxa_family AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_Invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.enum_taxa_family OWNER TO postgres;

--
-- Name: enum_taxa_qc_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_taxa_qc_status AS ENUM (
    'Menacée',
    'Susceptible',
    'Vulnérable',
    'Vulnérable à la récolte'
);


ALTER TYPE public.enum_taxa_qc_status OWNER TO postgres;

--
-- Name: enum_taxa_rank; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_taxa_rank AS ENUM (
    'superkingdom',
    'kingdom',
    'subkingdom',
    'infrakingdom',
    'superphylum',
    'phylum',
    'division',
    'subphylum',
    'subdivision',
    'infradivision',
    'superclass',
    'class',
    'subclass',
    'infraclass',
    'superorder',
    'cohort',
    'order',
    'suborder',
    'infraorder',
    'parvorder',
    'superfamily',
    'family',
    'subfamily',
    'tribe',
    'subtribe',
    'genus',
    'subgenus',
    'section',
    'subsection',
    'species group',
    'species',
    'infraspecies',
    'subspecies',
    'variety',
    'subvariety',
    'race',
    'stirp',
    'form',
    'morph',
    'hybrid',
    'aberration',
    'subform',
    'unspecified',
    'no rank'
);


ALTER TYPE public.enum_taxa_rank OWNER TO postgres;

--
-- Name: enum_taxa_sp_group; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_taxa_sp_group AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.enum_taxa_sp_group OWNER TO postgres;

--
-- Name: enum_taxa_species_gr; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_taxa_species_gr AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.enum_taxa_species_gr OWNER TO postgres;

--
-- Name: enum_users_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enum_users_role AS ENUM (
    'user',
    'admin',
    'reader'
);


ALTER TYPE public.enum_users_role OWNER TO postgres;

--
-- Name: groups; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.groups AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_Invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.groups OWNER TO postgres;

--
-- Name: groups_sp; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.groups_sp AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_Invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.groups_sp OWNER TO postgres;

--
-- Name: levels; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.levels AS ENUM (
    'superkingdom',
    'kingdom',
    'subkingdom',
    'infrakingdom',
    'superphylum',
    'phylum',
    'division',
    'subphylum',
    'subdivision',
    'infradivision',
    'superclass',
    'class',
    'subclass',
    'infraclass',
    'superorder',
    'cohort',
    'order',
    'suborder',
    'infraorder',
    'parvorder',
    'superfamily',
    'family',
    'subfamily',
    'tribe',
    'subtribe',
    'genus',
    'subgenus',
    'section',
    'subsection',
    'species group',
    'species',
    'infraspecies',
    'subspecies',
    'variety',
    'subvariety',
    'race',
    'stirp',
    'form',
    'morph',
    'hybrid',
    'aberration',
    'subform',
    'unspecified',
    'no rank'
);


ALTER TYPE public.levels OWNER TO postgres;

--
-- Name: qc; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.qc AS ENUM (
    'Menacée',
    'Susceptible',
    'Vulnérable',
    'Vulnérable à la récolte'
);


ALTER TYPE public.qc OWNER TO postgres;

--
-- Name: ranks; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ranks AS ENUM (
    'superkingdom',
    'kingdom',
    'subkingdom',
    'infrakingdom',
    'superphylum',
    'phylum',
    'division',
    'subphylum',
    'subdivision',
    'infradivision',
    'superclass',
    'class',
    'subclass',
    'infraclass',
    'superorder',
    'cohort',
    'order',
    'suborder',
    'infraorder',
    'parvorder',
    'superfamily',
    'family',
    'subfamily',
    'tribe',
    'subtribe',
    'genus',
    'subgenus',
    'section',
    'subsection',
    'species group',
    'species',
    'infraspecies',
    'subspecies',
    'variety',
    'subvariety',
    'race',
    'stirp',
    'form',
    'morph',
    'hybrid',
    'aberration',
    'subform',
    'unspecified',
    'no rank'
);


ALTER TYPE public.ranks OWNER TO postgres;

--
-- Name: sp_categories; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sp_categories AS ENUM (
    'Amphibiens',
    'Oiseaux',
    'Mammifères',
    'Reptiles',
    'Poissons',
    'Tuniciers',
    'Céphalocordés',
    'Arthropodes',
    'Autres_invertébrés',
    'Autres_taxons',
    'Mycètes',
    'Angiospermes',
    'Conifères',
    'Cryptogames_vasculaires',
    'Autres_gymnospermes',
    'Algues',
    'Bryophytes',
    'Autres_plantes'
);


ALTER TYPE public.sp_categories OWNER TO postgres;

--
-- Name: type_observation; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.type_observation AS ENUM (
    'living specimen',
    'preserved specimen',
    'fossil specimen',
    'human observation',
    'machine observation',
    'literature',
    'material sample',
    'others',
    'material citation'
);


ALTER TYPE public.type_observation OWNER TO postgres;

--
-- Name: __taxa_join_attributes(integer[]); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.__taxa_join_attributes(taxa_obs_id integer[]) RETURNS TABLE(id_taxa_obs integer, observed_scientific_name text, valid_scientific_name text, rank text, vernacular_en text, vernacular_fr text, group_en text, group_fr text, vernacular json, source_references json)
    LANGUAGE sql STABLE
    AS $_$
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
$_$;


ALTER FUNCTION api.__taxa_join_attributes(taxa_obs_id integer[]) OWNER TO vbeaure;

--
-- Name: autocomplete_taxa_name(text); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.autocomplete_taxa_name(name text) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT json_agg(DISTINCT(matched_name))
    FROM (
        (
            select scientific_name matched_name from taxa_ref
        ) UNION (
            select name matched_name from taxa_vernacular
        )
    ) taxa
    WHERE LOWER(name) like '%' || LOWER(name)
		OR LOWER(name) like LOWER(name) || '%'
$$;


ALTER FUNCTION api.autocomplete_taxa_name(name text) OWNER TO vbeaure;

--
-- Name: get_bird_presence(text); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.get_bird_presence(taxa_name text) RETURNS TABLE(lat double precision, long double precision, x_32198 double precision, y_32198 double precision, doy integer, presence boolean)
    LANGUAGE sql STABLE
    AS $$
with taxa_obs as (select id from match_taxa_obs(taxa_name))
select
-- lat, long in WGS84
st_x(pts.geom) as lat,
st_y(pts.geom) as long,
-- x, y in Quebec Lambert
st_x(st_transform(pts.geom, 32198)) as x_32198,
st_y(st_transform(pts.geom, 32198)) as y_32198,
    extract(doy from to_date(pts.year_obs || '-' || pts.month_obs || '-' || pts.day_obs, 'YYYY-MM-DD')) as doy,
    TRUE as presence
from api.bird_sampling_observations_lookup lookup,
api.bird_sampling_points pts,
taxa_obs
where lookup.id_taxa_obs = taxa_obs.id
and lookup.id_sampling_points = pts.id
$$;


ALTER FUNCTION api.get_bird_presence(taxa_name text) OWNER TO vbeaure;

--
-- Name: get_bird_presence_absence(text, integer, integer); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.get_bird_presence_absence(taxa_name text, page_limit integer DEFAULT NULL::integer, page_offset integer DEFAULT NULL::integer) RETURNS TABLE(lat double precision, long double precision, x_32198 double precision, y_32198 double precision, year_obs integer, month_obs integer, day_obs integer, time_obs time without time zone, doy integer, dataset_id integer, dataset_name character varying, taxa_ref_id integer, taxa_scientific_name character varying, occurrence boolean)
    LANGUAGE sql STABLE
    AS $$
with 
taxa_lookup as (
select distinct on (ref_lookup.id_taxa_obs)
ref_lookup.id_taxa_obs,
taxa_ref.id taxa_ref_id,
taxa_ref.scientific_name taxa_scientific_name
from match_taxa_obs(taxa_name) taxa_obs
left join taxa_obs_ref_lookup ref_lookup
on taxa_obs.id = ref_lookup.id_taxa_obs
left join taxa_ref
on ref_lookup.id_taxa_ref_valid = taxa_ref.id
where ref_lookup.match_type is not NULL
),
sampling_pts as (
select *
from api.bird_sampling_points
order by id
        limit (page_limit) offset (page_offset)
),
pts_lookup as (
select distinct on (lookup.id_sampling_points)
lookup.*, 
taxa_lookup.taxa_ref_id,
taxa_lookup.taxa_scientific_name
from api.bird_sampling_observations_lookup lookup
join taxa_lookup
on lookup.id_taxa_obs = taxa_lookup.id_taxa_obs
where lookup.id_sampling_points in (select id from sampling_pts)
)
select
st_x(pts.geom) as lat,
st_y(pts.geom) as long,
st_x(st_transform(pts.geom, 32198)) as x_32198,
st_y(st_transform(pts.geom, 32198)) as y_32198,
pts.year_obs,
pts.month_obs,
pts.day_obs,
pts.time_obs,
extract(doy from to_date(pts.year_obs || '-' || pts.month_obs || '-' || pts.day_obs, 'YYYY-MM-DD')) as doy,
pts_lookup.id_datasets as dataset_id,
ds.title as dataset_title,
pts_lookup.taxa_ref_id,
    pts_lookup.taxa_scientific_name,
(CASE WHEN pts_lookup.id_observations IS NULL THEN
FALSE
ELSE
TRUE
END) AS occurrence
from pts_lookup
left join datasets ds on pts_lookup.id_datasets = ds.id
right join sampling_pts pts
on pts_lookup.id_sampling_points = pts.id
$$;


ALTER FUNCTION api.get_bird_presence_absence(taxa_name text, page_limit integer, page_offset integer) OWNER TO vbeaure;

--
-- Name: get_mtl_bird_presence_absence(text); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.get_mtl_bird_presence_absence(taxa_name text) RETURNS TABLE(geom text, year_obs integer, month_obs integer, day_obs integer, time_obs time without time zone, dataset_id integer, dataset_name character varying, taxa_ref_id integer, taxa_scientific_name character varying, occurrence boolean)
    LANGUAGE sql STABLE
    AS $$
with 
	taxa_lookup as (
		select distinct on (ref_lookup.id_taxa_obs)
			ref_lookup.id_taxa_obs,
			taxa_ref.id taxa_ref_id,
			taxa_ref.scientific_name taxa_scientific_name
		from match_taxa_obs(taxa_name) taxa_obs
		left join taxa_obs_ref_lookup ref_lookup
			on taxa_obs.id = ref_lookup.id_taxa_obs
		left join taxa_ref
			on ref_lookup.id_taxa_ref_valid = taxa_ref.id
		where ref_lookup.match_type is not NULL
	),
	sampling_pts as (
		select *
		from api.bird_sampling_points
		where public.st_within (geom , (
			select public.ST_UNION (wkb_geometry)
			from montreal_terrestrial_limits))
	),
	pts_lookup as (
		select distinct on (lookup.id_sampling_points)
			lookup.*, 
			taxa_lookup.taxa_ref_id,
			taxa_lookup.taxa_scientific_name
		from api.bird_sampling_observations_lookup lookup
		join taxa_lookup
			on lookup.id_taxa_obs = taxa_lookup.id_taxa_obs
		where lookup.id_sampling_points in (select id from sampling_pts)
	)
select
	public.st_asewkt(
		pts.geom
	) as geom,
	pts.year_obs,
	pts.month_obs,
	pts.day_obs,
	pts.time_obs,
	pts_lookup.id_datasets as dataset_id,
	ds.title as dataset_title,
	pts_lookup.taxa_ref_id,
    pts_lookup.taxa_scientific_name,
	(CASE WHEN pts_lookup.id_observations IS NULL THEN
		FALSE
	ELSE
		TRUE
	END) AS occurrence
from pts_lookup
left join datasets ds on pts_lookup.id_datasets = ds.id
right join sampling_pts pts
	on pts_lookup.id_sampling_points = pts.id
$$;


ALTER FUNCTION api.get_mtl_bird_presence_absence(taxa_name text) OWNER TO postgres;

SET default_tablespace = ssdpool;

SET default_table_access_method = heap;

--
-- Name: taxa_obs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE TABLE public.taxa_obs (
    id integer NOT NULL,
    scientific_name text NOT NULL,
    authorship text DEFAULT ''::text NOT NULL,
    rank text DEFAULT ''::text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by text DEFAULT CURRENT_USER NOT NULL,
    parent_scientific_name text
);


ALTER TABLE public.taxa_obs OWNER TO postgres;

--
-- Name: taxa_old; Type: VIEW; Schema: api; Owner: postgres
--

CREATE VIEW api.taxa_old AS
 SELECT __taxa_join_attributes.id_taxa_obs,
    __taxa_join_attributes.observed_scientific_name,
    __taxa_join_attributes.valid_scientific_name,
    __taxa_join_attributes.rank,
    __taxa_join_attributes.vernacular_en,
    __taxa_join_attributes.vernacular_fr,
    __taxa_join_attributes.group_en,
    __taxa_join_attributes.group_fr,
    __taxa_join_attributes.vernacular,
    __taxa_join_attributes.source_references
   FROM api.__taxa_join_attributes(( SELECT array_agg(taxa_obs.id) AS array_agg
           FROM public.taxa_obs)) __taxa_join_attributes(id_taxa_obs, observed_scientific_name, valid_scientific_name, rank, vernacular_en, vernacular_fr, group_en, group_fr, vernacular, source_references);


ALTER TABLE api.taxa_old OWNER TO postgres;

--
-- Name: get_taxa_groups(integer[]); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.get_taxa_groups(taxa_keys integer[]) RETURNS SETOF api.taxa_old
    LANGUAGE sql STABLE
    AS $$
SELECT *
	FROM api.taxa
	WHERE id_taxa_obs = ANY(taxa_keys);
$$;


ALTER FUNCTION api.get_taxa_groups(taxa_keys integer[]) OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: taxa_ref_sources; Type: TABLE; Schema: api; Owner: vbeaure
--

CREATE TABLE api.taxa_ref_sources (
    source_id integer NOT NULL,
    source_name character varying(255) NOT NULL,
    source_priority integer NOT NULL
);


ALTER TABLE api.taxa_ref_sources OWNER TO vbeaure;

--
-- Name: taxa_vernacular_sources; Type: TABLE; Schema: api; Owner: vbeaure
--

CREATE TABLE api.taxa_vernacular_sources (
    source_name character varying(255) NOT NULL,
    source_priority integer NOT NULL
);


ALTER TABLE api.taxa_vernacular_sources OWNER TO vbeaure;

--
-- Name: observations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.observations (
    id bigint NOT NULL,
    org_parent_event character varying,
    org_event character varying,
    org_id_obs character varying,
    id_datasets integer NOT NULL,
    geom public.geometry(Point,4326) NOT NULL,
    year_obs integer NOT NULL,
    month_obs integer,
    day_obs integer,
    time_obs time without time zone,
    id_taxa integer,
    id_variables integer NOT NULL,
    obs_value numeric NOT NULL,
    issue character varying,
    created_by character varying DEFAULT CURRENT_USER,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by character varying DEFAULT CURRENT_USER,
    id_taxa_obs integer NOT NULL,
    within_quebec boolean DEFAULT false NOT NULL,
    dwc_event_date text DEFAULT ''::text NOT NULL,
    coordinate_uncertainty text,
    coordinate_uncertainty_id_variables integer,
    record_by text
)
PARTITION BY LIST (within_quebec);


ALTER TABLE public.observations OWNER TO postgres;

SET default_tablespace = ssdpool;

--
-- Name: outside_quebec; Type: TABLE; Schema: observations_partitions; Owner: postgres; Tablespace: ssdpool
--

CREATE TABLE observations_partitions.outside_quebec (
    id bigint NOT NULL,
    org_parent_event character varying,
    org_event character varying,
    org_id_obs character varying,
    id_datasets integer NOT NULL,
    geom public.geometry(Point,4326) NOT NULL,
    year_obs integer NOT NULL,
    month_obs integer,
    day_obs integer,
    time_obs time without time zone,
    id_taxa integer,
    id_variables integer NOT NULL,
    obs_value numeric NOT NULL,
    issue character varying,
    created_by character varying DEFAULT CURRENT_USER,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by character varying DEFAULT CURRENT_USER,
    id_taxa_obs integer NOT NULL,
    within_quebec boolean DEFAULT false NOT NULL,
    dwc_event_date text DEFAULT ''::text NOT NULL,
    coordinate_uncertainty text,
    coordinate_uncertainty_id_variables integer,
    record_by text
);
ALTER TABLE ONLY public.observations ATTACH PARTITION observations_partitions.outside_quebec FOR VALUES IN (false);


ALTER TABLE observations_partitions.outside_quebec OWNER TO postgres;

--
-- Name: observations_id_seq; Type: SEQUENCE; Schema: observations_partitions; Owner: postgres
--

CREATE SEQUENCE observations_partitions.observations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE observations_partitions.observations_id_seq OWNER TO postgres;

--
-- Name: observations_id_seq; Type: SEQUENCE OWNED BY; Schema: observations_partitions; Owner: postgres
--

ALTER SEQUENCE observations_partitions.observations_id_seq OWNED BY observations_partitions.outside_quebec.id;


SET default_tablespace = '';

--
-- Name: within_quebec; Type: TABLE; Schema: observations_partitions; Owner: postgres
--

CREATE TABLE observations_partitions.within_quebec (
    id bigint DEFAULT nextval('observations_partitions.observations_id_seq'::regclass) NOT NULL,
    org_parent_event character varying,
    org_event character varying,
    org_id_obs character varying,
    id_datasets integer NOT NULL,
    geom public.geometry(Point,4326) NOT NULL,
    year_obs integer NOT NULL,
    month_obs integer,
    day_obs integer,
    time_obs time without time zone,
    id_taxa integer,
    id_variables integer NOT NULL,
    obs_value numeric NOT NULL,
    issue character varying,
    created_by character varying DEFAULT CURRENT_USER,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by character varying DEFAULT CURRENT_USER,
    id_taxa_obs integer NOT NULL,
    within_quebec boolean DEFAULT false NOT NULL,
    dwc_event_date text DEFAULT ''::text NOT NULL,
    coordinate_uncertainty text,
    coordinate_uncertainty_id_variables integer,
    record_by text
);
ALTER TABLE ONLY public.observations ATTACH PARTITION observations_partitions.within_quebec FOR VALUES IN (true);


ALTER TABLE observations_partitions.within_quebec OWNER TO postgres;

--
-- Name: taxa_group_members; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.taxa_group_members (
    short character varying(20),
    scientific_name text
);


ALTER TABLE public.taxa_group_members OWNER TO vbeaure;

--
-- Name: taxa_groups; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.taxa_groups (
    id integer NOT NULL,
    short character varying(20),
    vernacular_fr text,
    vernacular_en text,
    level integer,
    source_desc text,
    groups_within text[]
);


ALTER TABLE public.taxa_groups OWNER TO vbeaure;

SET default_tablespace = ssdpool;

--
-- Name: taxa_obs_ref_lookup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE TABLE public.taxa_obs_ref_lookup (
    id_taxa_obs integer NOT NULL,
    id_taxa_ref integer NOT NULL,
    id_taxa_ref_valid integer NOT NULL,
    match_type text,
    is_parent boolean
);


ALTER TABLE public.taxa_obs_ref_lookup OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: taxa_ref; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxa_ref (
    id integer NOT NULL,
    source_name text NOT NULL,
    source_id numeric,
    source_record_id text NOT NULL,
    scientific_name text NOT NULL,
    authorship text,
    rank text NOT NULL,
    valid boolean NOT NULL,
    valid_srid text NOT NULL,
    classification_srids text[],
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.taxa_ref OWNER TO postgres;

--
-- Name: taxa_obs_group_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: vbeaure
--

CREATE MATERIALIZED VIEW public.taxa_obs_group_lookup AS
 WITH level_1_2_lookup AS (
         SELECT DISTINCT group_m.short,
            obs_lookup.id_taxa_obs,
            taxa_groups.id AS id_group
           FROM (((public.taxa_group_members group_m
             JOIN public.taxa_groups USING (short))
             LEFT JOIN public.taxa_ref ON ((group_m.scientific_name = taxa_ref.scientific_name)))
             LEFT JOIN public.taxa_obs_ref_lookup obs_lookup ON ((taxa_ref.id = obs_lookup.id_taxa_ref)))
          WHERE (taxa_groups.level = ANY (ARRAY[1, 2]))
        )
 SELECT level_1_2_lookup.id_taxa_obs,
    level_1_2_lookup.id_group,
    level_1_2_lookup.short AS short_group
   FROM level_1_2_lookup
UNION
 SELECT DISTINCT ON (within_quebec.id_taxa_obs) within_quebec.id_taxa_obs,
    taxa_groups.id AS id_group,
    taxa_groups.short AS short_group
   FROM observations_partitions.within_quebec,
    public.taxa_groups
  WHERE (taxa_groups.level = 0)
UNION
 SELECT level_1_2_lookup.id_taxa_obs,
    level_3_groups.id AS id_group,
    level_3_groups.short AS short_group
   FROM public.taxa_groups level_3_groups,
    level_1_2_lookup
  WHERE ((level_3_groups.level = 3) AND ((level_1_2_lookup.short)::text = ANY (level_3_groups.groups_within)))
  WITH NO DATA;


ALTER TABLE public.taxa_obs_group_lookup OWNER TO vbeaure;

--
-- Name: taxa_obs_vernacular_lookup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxa_obs_vernacular_lookup (
    id_taxa_obs integer NOT NULL,
    id_taxa_vernacular integer NOT NULL,
    match_type text,
    rank_order integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.taxa_obs_vernacular_lookup OWNER TO postgres;

--
-- Name: taxa_vernacular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.taxa_vernacular (
    id integer NOT NULL,
    source_name text NOT NULL,
    source_record_id text NOT NULL,
    name text NOT NULL,
    language text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by text DEFAULT CURRENT_USER NOT NULL,
    rank text,
    rank_order integer DEFAULT 9999 NOT NULL
);


ALTER TABLE public.taxa_vernacular OWNER TO postgres;

--
-- Name: taxa; Type: MATERIALIZED VIEW; Schema: api; Owner: vbeaure
--

CREATE MATERIALIZED VIEW api.taxa AS
 WITH all_ref AS (
         SELECT obs_lookup.id_taxa_obs,
            taxa_ref.scientific_name AS valid_scientific_name,
            taxa_ref.rank,
            taxa_ref.source_name,
            COALESCE(taxa_ref_sources.source_priority, 9999) AS source_priority,
            taxa_ref.source_record_id AS source_taxon_key
           FROM ((public.taxa_obs_ref_lookup obs_lookup
             LEFT JOIN public.taxa_ref ON ((obs_lookup.id_taxa_ref_valid = taxa_ref.id)))
             LEFT JOIN api.taxa_ref_sources USING (source_id))
          WHERE ((obs_lookup.match_type IS NOT NULL) AND (obs_lookup.match_type <> 'complex'::text))
          ORDER BY obs_lookup.id_taxa_obs, COALESCE(taxa_ref_sources.source_priority, 9999)
        ), agg_ref AS (
         SELECT all_ref.id_taxa_obs,
            json_agg(json_build_object('source_name', all_ref.source_name, 'valid_scientific_name', all_ref.valid_scientific_name, 'rank', all_ref.rank, 'source_taxon_key', all_ref.source_taxon_key)) AS source_references
           FROM all_ref
          GROUP BY all_ref.id_taxa_obs
        ), best_ref AS (
         SELECT DISTINCT ON (all_ref.id_taxa_obs) all_ref.id_taxa_obs,
            all_ref.valid_scientific_name,
            all_ref.rank
           FROM all_ref
          ORDER BY all_ref.id_taxa_obs, all_ref.source_priority
        ), obs_group AS (
         SELECT DISTINCT ON (group_lookup.id_taxa_obs) group_lookup.id_taxa_obs,
            COALESCE(taxa_groups.vernacular_en, 'others'::text) AS group_en,
            COALESCE(taxa_groups.vernacular_fr, 'autres'::text) AS group_fr
           FROM (public.taxa_obs_group_lookup group_lookup
             LEFT JOIN public.taxa_groups ON ((group_lookup.id_group = taxa_groups.id)))
          WHERE (taxa_groups.level = 1)
        ), vernacular_all AS (
         SELECT v_lookup.id_taxa_obs,
            taxa_vernacular.id,
            taxa_vernacular.source_name,
            taxa_vernacular.source_record_id,
            taxa_vernacular.name,
            taxa_vernacular.language,
            taxa_vernacular.created_at,
            taxa_vernacular.modified_at,
            taxa_vernacular.modified_by,
            taxa_vernacular.rank,
            taxa_vernacular.rank_order,
            COALESCE(taxa_vernacular_sources.source_priority, 9999) AS source_priority,
            v_lookup.match_type,
            COALESCE(taxa_vernacular.rank_order, '-1'::integer) AS rank_order
           FROM ((public.taxa_obs_vernacular_lookup v_lookup
             LEFT JOIN public.taxa_vernacular ON ((v_lookup.id_taxa_vernacular = taxa_vernacular.id)))
             LEFT JOIN api.taxa_vernacular_sources USING (source_name))
          WHERE ((v_lookup.match_type IS NOT NULL) AND (v_lookup.match_type <> 'complex'::text))
          ORDER BY v_lookup.id_taxa_obs, v_lookup.match_type, taxa_vernacular.rank_order DESC, COALESCE(taxa_vernacular_sources.source_priority, 9999)
        ), best_vernacular AS (
         SELECT ver_en.id_taxa_obs,
            ver_en.name AS vernacular_en,
            ver_fr.name AS vernacular_fr
           FROM (( SELECT DISTINCT ON (vernacular_all.id_taxa_obs) vernacular_all.id_taxa_obs,
                    vernacular_all.name
                   FROM vernacular_all vernacular_all(id_taxa_obs, id, source_name, source_record_id, name, language, created_at, modified_at, modified_by, rank, rank_order, source_priority, match_type, rank_order_1)
                  WHERE (vernacular_all.language = 'eng'::text)) ver_en
             LEFT JOIN ( SELECT DISTINCT ON (vernacular_all.id_taxa_obs) vernacular_all.id_taxa_obs,
                    vernacular_all.name
                   FROM vernacular_all vernacular_all(id_taxa_obs, id, source_name, source_record_id, name, language, created_at, modified_at, modified_by, rank, rank_order, source_priority, match_type, rank_order_1)
                  WHERE (vernacular_all.language = 'fra'::text)) ver_fr ON ((ver_en.id_taxa_obs = ver_fr.id_taxa_obs)))
        ), vernacular_group AS (
         SELECT vernacular_all.id_taxa_obs,
            json_agg(json_build_object('name', vernacular_all.name, 'source', vernacular_all.source_name, 'source_taxon_key', vernacular_all.source_record_id, 'language', vernacular_all.language)) AS vernacular
           FROM vernacular_all vernacular_all(id_taxa_obs, id, source_name, source_record_id, name, language, created_at, modified_at, modified_by, rank, rank_order, source_priority, match_type, rank_order_1)
          GROUP BY vernacular_all.id_taxa_obs
        )
 SELECT best_ref.id_taxa_obs,
    taxa_obs.scientific_name AS observed_scientific_name,
    best_ref.valid_scientific_name,
    best_ref.rank,
    best_vernacular.vernacular_en,
    best_vernacular.vernacular_fr,
    obs_group.group_en,
    obs_group.group_fr,
    vernacular_group.vernacular,
    agg_ref.source_references
   FROM (((((best_ref
     LEFT JOIN public.taxa_obs ON ((taxa_obs.id = best_ref.id_taxa_obs)))
     LEFT JOIN vernacular_group ON ((best_ref.id_taxa_obs = vernacular_group.id_taxa_obs)))
     LEFT JOIN obs_group ON ((best_ref.id_taxa_obs = obs_group.id_taxa_obs)))
     LEFT JOIN best_vernacular ON ((best_ref.id_taxa_obs = best_vernacular.id_taxa_obs)))
     LEFT JOIN agg_ref ON ((best_ref.id_taxa_obs = agg_ref.id_taxa_obs)))
  ORDER BY best_ref.id_taxa_obs, best_vernacular.vernacular_en
  WITH NO DATA;


ALTER TABLE api.taxa OWNER TO vbeaure;

--
-- Name: match_taxa(text); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.match_taxa(taxa_name text) RETURNS SETOF api.taxa
    LANGUAGE sql STABLE
    AS $_$
select taxa.* from api.taxa, match_taxa_obs($1) taxa_obs
WHERE id_taxa_obs = taxa_obs.id
$_$;


ALTER FUNCTION api.match_taxa(taxa_name text) OWNER TO postgres;

--
-- Name: match_taxa_list(text[]); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.match_taxa_list(taxa_names text[]) RETURNS SETOF api.taxa_old
    LANGUAGE sql STABLE
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
$$;


ALTER FUNCTION api.match_taxa_list(taxa_names text[]) OWNER TO postgres;

--
-- Name: refresh_bird_cadre_eco_counts(); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.refresh_bird_cadre_eco_counts() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM api.bird_cadre_eco_counts;

    WITH taxa_obs AS (
            SELECT match_taxa_obs.id,
                match_taxa_obs.scientific_name,
                match_taxa_obs.authorship,
                match_taxa_obs.rank,
                match_taxa_obs.created_at,
                match_taxa_obs.modified_at,
                match_taxa_obs.modified_by
            FROM match_taxa_obs('Aves'::text) match_taxa_obs(id, scientific_name, authorship, rank, created_at, modified_at, modified_by)
            ), distinct_obs AS (
            SELECT DISTINCT ON (obs.id_taxa_obs, obs.dwc_event_date, obs.geom) r.fid AS region_fid,
                obs.id AS obs_id,
                obs.id_taxa_obs,
                obs.month_obs AS month,
                obs.year_obs AS year
            FROM regions r,
                observations obs,
                taxa_obs
            WHERE st_within(obs.geom, r.geom)
                AND taxa_obs.id = obs.id_taxa_obs
                AND obs.within_quebec IS TRUE
                AND r.type::text = 'cadre_eco'::text
            )
    INSERT INTO api.bird_cadre_eco_counts
    SELECT distinct_obs.region_fid,
        distinct_obs.id_taxa_obs,
        distinct_obs.month,
        distinct_obs.year,
        count(distinct_obs.obs_id) AS count_obs
    FROM distinct_obs
    GROUP BY distinct_obs.region_fid, distinct_obs.id_taxa_obs, distinct_obs.month, distinct_obs.year;
END;
$$;


ALTER FUNCTION api.refresh_bird_cadre_eco_counts() OWNER TO postgres;

--
-- Name: taxa_autocomplete(text); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.taxa_autocomplete(name text) RETURNS json
    LANGUAGE sql STABLE
    AS $$
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
$$;


ALTER FUNCTION api.taxa_autocomplete(name text) OWNER TO vbeaure;

--
-- Name: taxa_autocomplete_temp(text, integer); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer DEFAULT 20) RETURNS json
    LANGUAGE sql STABLE
    AS $_$
	with ref_matches as (
			select
				distinct on (taxa_ref.scientific_name)
				ref_lu.id_taxa_obs, taxa_ref.scientific_name matched_name,
				coalesce(taxa_ref."rank", '') as rank,
				ref_lu.match_type
			from taxa_obs_ref_lookup ref_lu, taxa_ref
			where ref_lu.id_taxa_ref = taxa_ref.id
				and taxa_ref.scientific_name ilike '%' || $1 || '%'
			order by taxa_ref.scientific_name, taxa_ref.rank nulls last
	), vernacular_matches as (
		select
				distinct on (taxa_vernacular.name)
				id_taxa_obs, taxa_vernacular.name matched_name,
				coalesce(taxa_vernacular."rank", '') as rank,
				v_lu.match_type
			from taxa_vernacular
			join taxa_obs_vernacular_lookup v_lu on v_lu.id_taxa_vernacular = taxa_vernacular.id
			where taxa_vernacular.name ilike '%' || $1 || '%'
			order by taxa_vernacular.name, taxa_vernacular.rank nulls last
	), matches as (
		select
			sub_m.id_taxa_obs, sub_m.matched_name, sub_m.rank,
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
            SELECT * FROM ref_matches union SELECT * FROM vernacular_matches
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
$_$;


ALTER FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer) OWNER TO vbeaure;

--
-- Name: taxa_branch_tips(integer[]); Type: FUNCTION; Schema: api; Owner: vbeaure
--

CREATE FUNCTION api.taxa_branch_tips(taxa_obs_ids integer[]) RETURNS integer[]
    LANGUAGE sql
    AS $$
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
$$;


ALTER FUNCTION api.taxa_branch_tips(taxa_obs_ids integer[]) OWNER TO vbeaure;

--
-- Name: test_get_bird_presence_absence(); Type: FUNCTION; Schema: api; Owner: postgres
--

CREATE FUNCTION api.test_get_bird_presence_absence() RETURNS TABLE(geom text, year_obs integer, month_obs integer, day_obs integer, time_obs time without time zone, dataset_id integer, dataset_name character varying, taxa_ref_id integer, taxa_scientific_name character varying, occurrence boolean)
    LANGUAGE sql STABLE
    AS $$ select * from api.get_bird_presence_absence(10609);$$;


ALTER FUNCTION api.test_get_bird_presence_absence() OWNER TO postgres;

--
-- Name: get_scale(text, integer, boolean); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.get_scale(type text, zoom integer, is_sensitive boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
    best_scale integer;
    lower_scale integer;
BEGIN
    SELECT scale
    INTO best_scale
    FROM atlas_api.regions_zoom_lookup
    WHERE
        regions_zoom_lookup.type = $1
        AND regions_zoom_lookup.zoom <= $2
        AND (show_sensitive IS TRUE OR $3 IS FALSE)
    ORDER BY regions_zoom_lookup.zoom DESC
    LIMIT 1;

    SELECT scale
    INTO lower_scale
    FROM atlas_api.regions_zoom_lookup
    WHERE regions_zoom_lookup.type = $1
    ORDER BY regions_zoom_lookup.zoom ASC
    LIMIT 1;

    RETURN CASE WHEN best_scale IS NULL THEN lower_scale ELSE best_scale END;
END;
$_$;


ALTER FUNCTION atlas_api.get_scale(type text, zoom integer, is_sensitive boolean) OWNER TO vbeaure;

--
-- Name: get_year_counts(integer[], integer); Type: FUNCTION; Schema: atlas_api; Owner: postgres
--

CREATE FUNCTION atlas_api.get_year_counts(taxakeys integer[] DEFAULT NULL::integer[], taxagroupkey integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
    DECLARE
        out_json json;
        region_fid integer;
    BEGIN
        IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
            taxaGroupKey := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
        WITH year_counts as (
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM atlas_api.obs_region_counts o
                WHERE o.fid = region_fid
                    AND o.id_taxa_obs = ANY(taxaKeys)
                GROUP BY o.year_obs
            UNION
            SELECT
                    o.year_obs as year,
                    sum(o.count_obs) count_obs,
                    count(distinct(o.id_taxa_obs)) count_species
                FROM atlas_api.obs_region_counts o,
                    taxa_obs_group_lookup glu
                WHERE o.fid = region_fid
                    AND glu.id_group = taxaGroupKey
                    AND glu.id_taxa_obs = o.id_taxa_obs
                GROUP BY o.year_obs
        ), year_range as (
            select
                generate_series(
                    1950,
                    max(year_obs)
                ) as year
            from atlas_api.obs_region_counts	
        ), all_year_counts as (
            SELECT
                year_range.year,
                coalesce(year_counts.count_obs, 0) count_obs,
                coalesce(year_counts.count_species, 0) count_species
            FROM year_range
            LEFT JOIN year_counts on year_range.year = year_counts.year
            ORDER BY year_range.year
        )
        SELECT
            json_agg(all_year_counts.*)
            INTO out_json
            FROM all_year_counts;
        RETURN out_json;
    END;
    $$;


ALTER FUNCTION atlas_api.get_year_counts(taxakeys integer[], taxagroupkey integer) OWNER TO postgres;

--
-- Name: list_species(integer[]); Type: FUNCTION; Schema: atlas_api; Owner: postgres
--

CREATE FUNCTION atlas_api.list_species(taxakeys integer[]) RETURNS TABLE(id_taxa_obs integer[], valid_scientific_name text, vernacular_en text, vernacular_fr text, rank text)
    LANGUAGE sql STABLE
    AS $$
with taxas as (
select *
from api.taxa
where id_taxa_obs = ANY(taxakeys)
and rank = 'species'
)
select
array_agg(taxas.id_taxa_obs) id_taxa_obs,
valid_scientific_name,
vernacular_en,
vernacular_fr,
rank
from taxas
group by valid_scientific_name, vernacular_en, vernacular_fr, rank
$$;


ALTER FUNCTION atlas_api.list_species(taxakeys integer[]) OWNER TO postgres;

--
-- Name: obs_dataset_summary(integer, text, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_dataset_summary(region_fid integer DEFAULT NULL::integer, region_type text DEFAULT NULL::text, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS TABLE(dataset text, dataset_publisher text, dataset_creator text, dataset_doi text, dataset_license text, count_obs integer, count_species integer, first_year integer, last_year integer, taxa_groups_fr text, taxa_groups_en text)
    LANGUAGE plpgsql STABLE
    AS $_$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        )
        SELECT
            min(d.title) AS dataset,
            min(d.publisher) AS dataset_publisher,
            min(d.creator) AS dataset_creator,
            min(d.doi) AS dataset_doi,
            min(d.license) AS dataset_license,
            sum(counts.count_obs)::integer AS count_obs,
            array_length(api.taxa_branch_tips(counts.id_taxa_obs), 1) AS count_species,
            min(counts.min_year) AS first_year,
            max(counts.max_year) AS last_year,
            string_agg(DISTINCT tg_out.vernacular_fr, ', ') AS taxa_groups_fr,
            string_agg(DISTINCT tg_out.vernacular_en, ', ') AS taxa_groups_en
        FROM
            atlas_api.obs_regions_taxa_datasets_counts counts,
            datasets d,
            taxa,
            taxa_obs_group_lookup tg_out_lu,
            taxa_groups tg_out
        WHERE
            counts.fid = $1
            AND counts.type = $2
            AND counts.id_taxa_obs = taxa.id_taxa_obs
            AND counts.min_year <= $6
            AND counts.max_year >= $5
            AND counts.id_datasets = d.id
            AND tg_out_lu.id_taxa_obs = counts.id_taxa_obs
            AND tg_out_lu.id_group = tg_out.id
			AND tg_out.level = 1
        GROUP BY
            (d.title, d.publisher, d.creator);
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_dataset_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_map(text, integer, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_map(region_type text, zoom integer, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), scale as (
            select atlas_api.get_scale(region_type, $2, sensitive) as scale
            from sensitive
        ), map_regions as (
        SELECT
            web_regions.fid,
            web_regions.type,
            web_regions.scale,
            regions.scale_desc,
            regions.name,
            regions.extra,
            web_regions.geom
        FROM atlas_api.web_regions, regions, scale
        WHERE
            web_regions.type = $1
            AND ST_Intersects(
                web_regions.geom,
                ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))
            AND web_regions.scale = scale.scale
            AND web_regions.fid = regions.fid
            AND web_regions.type = regions.type
        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE type = region_type and scale = (select scale from scale)
                AND year_obs >= $9 and year_obs <= $10
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.name,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            row_to_json(features)
        INTO out_json
        FROM features;
        RETURN json_agg(out_json);
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_map(region_type text, zoom integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_map(text, integer, double precision, double precision, double precision, double precision, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: postgres
--

CREATE FUNCTION atlas_api.obs_map(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), scale as (
            select atlas_api.get_scale(region_type, $2, sensitive) as scale
            from sensitive
        ), map_regions as (
        SELECT
            web_regions.fid,
            web_regions.type,
            web_regions.scale,
            regions.scale_desc,
            regions.name,
            regions.extra,
            web_regions.geom
        FROM atlas_api.web_regions, regions, scale
        WHERE
            web_regions.type = $1
            AND ST_Intersects(
                web_regions.geom,
                ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))
            AND web_regions.scale = scale.scale
            AND web_regions.fid = regions.fid
            AND web_regions.type = regions.type
        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE type = region_type and scale = (select scale from scale)
                AND year_obs >= $9 and year_obs <= $10
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.scale_desc,
            map_regions.name,
            map_regions.extra,
            map_regions.geom,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_build_object(
                'type', 'FeatureCollection',
                'features', json_agg(ST_AsGeoJSON(features.*)::json),
                'sensitive', (SELECT sensitive from sensitive)
            )
        INTO out_json
        FROM features;
        RETURN json_agg(out_json);
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_map(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO postgres;

--
-- Name: obs_map_values(text, integer, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_map_values(region_type text, scale integer, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), map_regions as (
        SELECT
            regions.fid,
            regions.type,
            regions.scale,
            regions.scale_desc,
            regions.name
        FROM regions
        WHERE
            regions.type = $1
            AND regions.scale = $2
        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE counts.type = $1 and counts.scale = $2
                AND counts.year_obs >= $5 and counts.year_obs <= $6
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.name,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_agg(row_to_json(features))
        INTO out_json
        FROM features;
        RETURN out_json;
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_map_values(region_type text, scale integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_map_values_slippy(text, integer, double precision, double precision, double precision, double precision, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_map_values_slippy(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE
        out_json json;
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), sensitive as (
            SELECT
                bool_and(id_group is not null) sensitive -- ALL belongs to sensitive group
            FROM taxa
            LEFT JOIN (
                SELECT * FROM taxa_obs_group_lookup
                WHERE short_group = 'SENSITIVE'
            ) as sensitive_group USING (id_taxa_obs)
        ), map_regions as (
        SELECT
            regions.fid,
            regions.type,
            regions.scale,
            regions.scale_desc,
            regions.name
        FROM regions
        WHERE
            regions.type = $1
            AND regions.scale = $2
            AND ST_Intersects(
                geom,
                ST_MakeEnvelope(x_min, y_min, x_max, y_max, 4326))

        ), obs_summary as (
            SELECT
                fid,
                count(distinct(id_taxa_obs)) AS count_species,
                sum(count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts 
            JOIN taxa using (id_taxa_obs)
            WHERE counts.type = $1 and counts.scale = $2
                AND counts.year_obs >= $9 and counts.year_obs <= $10
            GROUP BY fid
        ), features as (
        SELECT
            map_regions.fid,
            map_regions.type,
            map_regions.scale,
            map_regions.name,
            obs_summary.count_species,
            obs_summary.count_obs
        FROM map_regions
        LEFT JOIN obs_summary ON map_regions.fid = obs_summary.fid
        )
        -- Make the results into a geojson
        SELECT
            json_agg(row_to_json(features))
        INTO out_json
        FROM features;
        RETURN out_json;
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_map_values_slippy(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_region_counts_refresh(); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_region_counts_refresh() RETURNS void
    LANGUAGE plpgsql
    AS $$
        BEGIN
            DELETE FROM atlas_api.obs_region_counts;
            INSERT INTO atlas_api.obs_region_counts (
                type,
                scale,
                fid,
                id_taxa_obs,
                year_obs,
                count_obs
            )
            SELECT
                regions.type,
                regions.scale,
                regions.fid,
                o.id_taxa_obs,
                o.year_obs,
                count(o.id) AS count_obs
            FROM 
                regions,
                observations o,
                -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
                atlas_api.regions_zoom_lookup
            WHERE st_within(o.geom, regions.geom)
                AND o.within_quebec = regions.within_quebec
                AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
            GROUP BY regions.type, regions.fid, o.id_taxa_obs, o.year_obs;
        END;
        $$;


ALTER FUNCTION atlas_api.obs_region_counts_refresh() OWNER TO vbeaure;

--
-- Name: obs_regions_taxa_datasets_counts_refresh(); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_regions_taxa_datasets_counts_refresh() RETURNS void
    LANGUAGE plpgsql
    AS $$
        BEGIN
            DELETE FROM atlas_api.obs_regions_taxa_datasets_counts;
            INSERT INTO atlas_api.obs_regions_taxa_datasets_counts (
                fid,
                type,
                id_taxa_obs,
                id_datasets,
                min_year,
                max_year,
                count_obs
            )
            SELECT
                regions.fid,
                regions.type,
                o.id_taxa_obs,
                o.id_datasets,
                min(o.year_obs) AS min_year,
                max(o.year_obs) AS max_year,
                count(o.id) AS count_obs
            FROM 
                regions,
                observations o,
                -- FILTER AVAILABLE regions and scale using atlas_api.regions_zoom_lookup
                atlas_api.regions_zoom_lookup
            WHERE st_within(o.geom, regions.geom) AND o.within_quebec = regions.within_quebec
                AND regions.type = regions_zoom_lookup.type AND regions.scale = regions_zoom_lookup.scale
            GROUP BY regions.fid, o.id_datasets, o.id_taxa_obs;
        END;
        $$;


ALTER FUNCTION atlas_api.obs_regions_taxa_datasets_counts_refresh() OWNER TO vbeaure;

--
-- Name: obs_species_summary(integer, integer, text, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_species_summary(taxa_key integer, region_fid integer DEFAULT NULL::integer, region_type text DEFAULT NULL::text, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE out json;
    BEGIN
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        WITH taxa as (
            SELECT
                valid_scientific_name,
                vernacular_en,
                vernacular_fr
            FROM api.__taxa_join_attributes(ARRAY[$1])
        ), counts as (
            SELECT
                sum(counts.count_obs) as obs_count
            FROM atlas_api.obs_region_counts counts
            WHERE counts.fid = $2
                AND counts.type = $3
                AND counts.id_taxa_obs = $1
                AND counts.year_obs >= $4
                AND counts.year_obs <= $5
        ), taxa_groups as (
            SELECT
                array_agg(vernacular_fr) as groups_fr,
                array_agg(vernacular_en) as groups_en
            FROM match_taxa_groups(ARRAY[$1])
            WHERE level = 1 OR
                source_desc = 'CDPNQ'
        ), attributes as (
            SELECT
                taxa.*,
                counts.obs_count,
                taxa_groups.*
            FROM taxa, counts, taxa_groups
        )
        SELECT row_to_json(attributes)
        FROM attributes
        INTO out;
        RETURN out;
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_species_summary(taxa_key integer, region_fid integer, region_type text, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_summary(integer, text, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_summary(region_fid integer DEFAULT NULL::integer, region_type text DEFAULT NULL::text, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS TABLE(fid integer, taxa_filter_tags json, region_filter_tags json, obs_count integer, taxa_count integer, taxa_id_list integer[])
    LANGUAGE plpgsql STABLE
    AS $_$
    DECLARE
        region_type_fr text;
        region_type_en text;
    BEGIN
        -- Group is all species (level = 0) if no group
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;

        -- Only one of taxa_group_key or taxa_keys can be specified
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;

        -- Set region_fid and region_type to default (all quebec) if not specified
        -- We must first store region type tags that will be returned
        SELECT name_fr, name_en INTO region_type_fr, region_type_en
        FROM atlas_api.regions_zoom_lookup
        WHERE type = region_type
        LIMIT 1;

        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), region_type_scale as (
            select
                show_sensitive,
                regions.scale_desc_fr as tag_fr,
                regions.scale_desc_en as tag_en,
                regions.name as name_fr,
                regions.name as name_en
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_counts as (
            SELECT
                counts.fid,
                counts.type,
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list,
                sum(counts.count_obs) AS count_obs
            FROM atlas_api.obs_region_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), taxa_list as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_counts
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        ), taxa_groups as (
            SELECT 
                array_agg(vernacular_fr) groups_fr,
                array_agg(vernacular_en) groups_en
            FROM taxa_list, match_taxa_groups(taxa_list.taxa_list)
            WHERE level = 1 or (21 <= id and id >= 25)
        )
        SELECT
            region_fid,
            json_build_object(
                'taxa_tags_fr', groups_fr,
                'taxa_tags_en', groups_en
            ) AS taxa_filter_tags,
            json_build_object(
                'tags_fr', region_type_scale.tag_fr,
                'tags_en', region_type_scale.tag_en,
                -- name is the string before parenthesis in the name field
                'name_fr', regexp_replace(region_type_scale.name_fr, ' \(.+\)', ''),
                'name_en', regexp_replace(region_type_scale.name_en, ' \(.+\)', '')
            ) AS region_filter_tags,
            coalesce(obs_counts.count_obs::integer, 0),
            coalesce(array_length(obs_counts.taxa_list, 1)::integer, 0) as taxa_count,
            taxa_list.taxa_list
        FROM region_type_scale, taxa_list, taxa_groups
        LEFT JOIN obs_counts ON TRUE;
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: obs_taxa_list(integer, text, integer[], integer, integer, integer); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.obs_taxa_list(region_fid integer DEFAULT NULL::integer, region_type text DEFAULT NULL::text, taxa_keys integer[] DEFAULT NULL::integer[], taxa_group_key integer DEFAULT NULL::integer, min_year integer DEFAULT 0, max_year integer DEFAULT 9999) RETURNS SETOF api.taxa_old
    LANGUAGE plpgsql STABLE
    AS $_$
    BEGIN
        IF (taxa_group_key IS NULL AND taxa_keys IS NULL) THEN
            taxa_group_key := (SELECT id from taxa_groups where level = 0);
        END IF;
        IF (taxa_group_key IS NOT NULL AND taxa_keys IS NOT NULL) THEN
            RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
        END IF;
        IF (region_fid IS NULL) THEN
            region_fid := (SELECT regions.fid from regions where regions.type = 'admin' and regions.scale = 1);
            region_type := 'admin';
        END IF;
        RETURN QUERY
        WITH taxa as (
            SELECT UNNEST(taxa_keys) as id_taxa_obs
            UNION
            SELECT id_taxa_obs
            FROM taxa_obs_group_lookup
            where id_group = taxa_group_key
        ), region_type_scale as (
            select show_sensitive
            from atlas_api.regions_zoom_lookup rlu, regions
            where regions.fid = region_fid and regions.type = region_type
                and rlu.type = region_type and rlu.scale = regions.scale
        ), obs_taxa as (
            SELECT
                api.taxa_branch_tips(counts.id_taxa_obs) AS taxa_list
            FROM atlas_api.obs_region_counts counts, taxa
            WHERE counts.fid = $1
                AND counts.type = $2
                AND counts.id_taxa_obs = taxa.id_taxa_obs
                AND counts.year_obs >= $5
                AND counts.year_obs <= $6
            GROUP BY counts.fid, counts.type
        ), not_sensitive_taxa as (
            SELECT
                array_agg(taxa.id_taxa_obs) taxa_list
            FROM (
                SELECT UNNEST(taxa_list) as id_taxa_obs FROM obs_taxa
                ) as taxa
            LEFT JOIN (
                    select id_taxa_obs, id_group as sensitive_group from taxa_obs_group_lookup where short_group = 'SENSITIVE'
                ) as sensitive_group ON sensitive_group.id_taxa_obs = taxa.id_taxa_obs
            JOIN region_type_scale ON true
            WHERE (show_sensitive is false and sensitive_group is not null) is false
        )
        SELECT
            taxa.*
        FROM api.taxa, not_sensitive_taxa
        WHERE taxa.id_taxa_obs = ANY (not_sensitive_taxa.taxa_list);
    END;
    $_$;


ALTER FUNCTION atlas_api.obs_taxa_list(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) OWNER TO vbeaure;

--
-- Name: regions_autocomplete(text); Type: FUNCTION; Schema: atlas_api; Owner: vbeaure
--

CREATE FUNCTION atlas_api.regions_autocomplete(name text) RETURNS json
    LANGUAGE sql STABLE
    AS $_$
WITH matched AS (
    select
        regions.name as name_fr,
        regions.name as name_en,
        CASE
            WHEN regions.type = 'admin' THEN scale_desc
            WHEN regions.type = 'cadre_eco' THEN 'Région écologique'
        END as type_fr,
        CASE
            WHEN regions.type = 'admin' AND scale_desc = 'Province'
                THEN 'Province'
            WHEN regions.type = 'admin' AND scale_desc = 'Région administrative'
                THEN 'Administrative region'
            WHEN regions.type = 'admin' AND scale_desc = 'Municipalité régionale de comté géographique'
                THEN 'Geographic county municipality'
            WHEN regions.type = 'admin' AND scale_desc = 'MRC (incluant les territoires autochtones)'
                THEN 'County municipality (including indigenous territories)'
            WHEN regions.type = 'admin' AND scale_desc = 'Municipalité régionale de comté'
                THEN 'County municipality'
            WHEN regions.type = 'admin' AND scale_desc = 'Municipalité'
                THEN 'Municipality'
            WHEN regions.type = 'admin' AND scale_desc = 'Territoire autochtone'
                THEN 'Indigenous territory'
            WHEN regions.type = 'admin' AND scale_desc = 'Territoire non organisé'
                THEN 'Unorganized territory'
            WHEN regions.type = 'cadre_eco' THEN 'Ecological region'
        END as type_en,
        regions.fid,
        regions.type as region_type,
        regions_zoom_lookup.zoom,
        -- Center coordinates if format `-49.30540200534417,-69.37316894531251` as map_center
        format('%s,%s', st_x(st_centroid(regions.geom)), st_y(st_centroid(regions.geom))) as map_center
        
    from
        regions, atlas_api.regions_zoom_lookup
    where (regions.name ilike $1 || '%'
        OR regions.name ilike '%' || $1 || '%')
        and regions.type in ('admin', 'cadre_eco')
        and regions.type = regions_zoom_lookup.type
        and regions.scale = regions_zoom_lookup.scale
    ORDER BY
        CASE
            WHEN regions.name ilike $1 || '%' THEN 0
            WHEN regions.name ilike '% ' || $1 || '%' THEN 1
            ELSE 2
        END, regions.name
    LIMIT 50
)
SELECT json_agg(row_to_json(matched)) FROM matched;
$_$;


ALTER FUNCTION atlas_api.regions_autocomplete(name text) OWNER TO vbeaure;

--
-- Name: autocomplete_taxa_name(text); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.autocomplete_taxa_name(name text) RETURNS json
    LANGUAGE sql
    AS $$
    SELECT json_agg(DISTINCT(matched_name))
    FROM (
        (
            select scientific_name matched_name from taxa_ref
        ) UNION (
            select name matched_name from taxa_vernacular
        )
    ) taxa
    WHERE LOWER(name) like '%' || LOWER(name)
$$;


ALTER FUNCTION public.autocomplete_taxa_name(name text) OWNER TO vbeaure;

--
-- Name: count_distinct_species(integer[]); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.count_distinct_species(taxa_obs_keys integer[]) RETURNS integer
    LANGUAGE sql
    AS $$
with distinct_species as (
	select
		distinct on (scientific_name)
		ref_lookup.id_taxa_obs
	from
		taxa_obs_ref_lookup ref_lookup,
		taxa_ref
	where
		ref_lookup.id_taxa_obs = any(taxa_obs_keys)
		and ref_lookup.id_taxa_ref = taxa_ref.id
		and taxa_ref.valid is true
		and taxa_ref.rank = 'species')
select
	count(distinct(id_taxa_obs))
from distinct_species
$$;


ALTER FUNCTION public.count_distinct_species(taxa_obs_keys integer[]) OWNER TO vbeaure;

--
-- Name: filter_qc_obs_from_taxa_match(text); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.filter_qc_obs_from_taxa_match(name text) RETURNS SETOF observations_partitions.outside_quebec
    LANGUAGE sql
    AS $$
    SELECT obs.*
    FROM observations obs
    WHERE obs.id_taxa_obs in (select id from match_taxa_obs(name));
        -- and obs.within_quebec is TRUE;
$$;


ALTER FUNCTION public.filter_qc_obs_from_taxa_match(name text) OWNER TO vbeaure;

--
-- Name: fix_taxa_obs_parent_scientific_name(integer, text); Type: FUNCTION; Schema: public; Owner: camv2202
--

CREATE FUNCTION public.fix_taxa_obs_parent_scientific_name(id_taxa_obs integer, parent_scientific_name text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  taxa_obs_record RECORD;
  scientific_name_rec record;
BEGIN
    -- Update taxa_ref
    UPDATE public.taxa_obs SET parent_scientific_name = $2 WHERE taxa_obs.id = $1;

    FOR taxa_obs_record IN SELECT * FROM public.taxa_obs WHERE taxa_obs.id = $1
    LOOP
        DELETE FROM public.taxa_obs_ref_lookup WHERE public.taxa_obs_ref_lookup.id_taxa_obs = taxa_obs_record.id;

        PERFORM public.insert_taxa_ref_from_taxa_obs(
            taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
        );
    END LOOP;
    -- Update taxa_vernacular
    FOR scientific_name_rec IN
        SELECT
            distinct on (taxa_ref.scientific_name, taxa_ref.rank)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank),
            taxa_obs_vernacular_lookup.id_taxa_vernacular
        FROM taxa_ref, taxa_obs_ref_lookup, taxa_obs_vernacular_lookup, taxa_obs
        where taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
            and taxa_obs_ref_lookup.id_taxa_obs = taxa_obs.id
            and taxa_obs_vernacular_lookup.id_taxa_obs = taxa_obs.id
            and taxa_obs.id = $1
    LOOP
        BEGIN
            DELETE from taxa_obs_vernacular_lookup where taxa_obs_vernacular_lookup.id_taxa_vernacular = scientific_name_rec.id_taxa_vernacular;
            DELETE from taxa_vernacular where taxa_vernacular.id = scientific_name_rec.id_taxa_vernacular;

            PERFORM insert_taxa_vernacular_using_ref(scientific_name_rec.id);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'insert_taxa_vernacular_using_ref(%s) failed for taxa (%s): %', scientific_name_rec.id, scientific_name_rec.scientific_name, SQLERRM;
        END;
    END LOOP;
END;
$_$;


ALTER FUNCTION public.fix_taxa_obs_parent_scientific_name(id_taxa_obs integer, parent_scientific_name text) OWNER TO camv2202;

--
-- Name: fix_taxa_obs_parent_scientific_name(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  taxa_obs_record RECORD;
BEGIN
    UPDATE public.taxa_obs SET parent_scientific_name = $2 WHERE taxa_obs.scientific_name = $1;

    FOR taxa_obs_record IN SELECT * FROM public.taxa_obs WHERE taxa_obs.scientific_name = $1
    LOOP
        DELETE FROM public.taxa_obs_ref_lookup WHERE id_taxa_obs = taxa_obs_record.id;

        PERFORM public.insert_taxa_ref_from_taxa_obs(
            taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
        );
    END LOOP;
END;
$_$;


ALTER FUNCTION public.fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text) OWNER TO postgres;

--
-- Name: format_dwc_datetime(integer, integer, integer, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.format_dwc_datetime(year integer DEFAULT NULL::integer, month integer DEFAULT NULL::integer, day integer DEFAULT NULL::integer, time_obs time without time zone DEFAULT NULL::time without time zone) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE out text := LPAD(year::text, 4, '0');
BEGIN
IF month is not null THEN
	out := out || '-' || LPAD(month::text, 2, '0');

END IF;
IF day is not null THEN
	out := out || '-' || LPAD(day::text, 2, '0');
END IF;
IF time_obs is not null THEN
	out := out || 'T' || time_obs;
END IF;
RETURN out;
END;
$$;


ALTER FUNCTION public.format_dwc_datetime(year integer, month integer, day integer, time_obs time without time zone) OWNER TO postgres;

--
-- Name: get_taxa_ref_gnames(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_taxa_ref_gnames(name text, name_authorship text DEFAULT NULL::text) RETURNS TABLE(source_name text, source_id numeric, source_record_id text, scientific_name text, authorship text, rank text, rank_order integer, valid boolean, valid_srid text, classification_srids text[], match_type text)
    LANGUAGE plpython3u
    AS $$
# def get_taxa_ref_gnames(name, name_authorship):
    from urllib.request import Request, urlopen, URLError, HTTPError
    from urllib.parse import urlencode, quote_plus
    import json
    import re

    def find_authorship(name, name_simple):
        authorship = name.replace(name_simple, '')
        authorship = authorship.strip()
        try:
            if authorship[0] == '(' and authorship[-1] == ')':
                authorship = authorship.lstrip('(').rstrip(')')
        except IndexError:
            pass
        return authorship

    def to_taxa_ref(gn_result):
        is_valid = gn_result["currentRecordId"] == gn_result["recordId"]
        out = []
        if not is_valid:
            out.append({
                "source_id": gn_result["dataSourceId"],
                "source_record_id": gn_result["recordId"],
                "source_name": gn_result["dataSourceTitleShort"],
                "scientific_name": gn_result["matchedCanonicalFull"],
                "authorship": find_authorship(
                    gn_result["matchedName"],
                    gn_result["matchedCanonicalFull"]),
                "rank": gn_result["classificationRanks"].split("|")[-1],
                "rank_order": gn_result["classificationRanks"].count("|") + 1,
                "classification_srids":
                    gn_result["classificationIds"].split("|"),
                "valid": is_valid,
                "valid_srid": gn_result["currentRecordId"],
                "match_type": gn_result["matchType"].lower()
            })
        for rank_order, taxa_attributes in enumerate(zip(
            gn_result["classificationPath"].split("|"),
            gn_result["classificationRanks"].split("|"),
            gn_result["classificationIds"].split("|"))
        ):
            taxa, rank, srid = taxa_attributes
            match_type = None
            if rank == gn_result["classificationRanks"].split("|")[-1]:
                valid_authorship = find_authorship(
                    gn_result["matchedName"],
                    gn_result["matchedCanonicalFull"])
                if is_valid:
                    match_type = gn_result["matchType"].lower()
            else:
                valid_authorship = None
            out.append(
                {
                    "source_id": gn_result["dataSourceId"],
                    "source_record_id": srid,
                    "source_name": gn_result["dataSourceTitleShort"],
                    "scientific_name": taxa,
                    "authorship": valid_authorship,
                    "rank": rank,
                    "rank_order": rank_order,
                    "classification_srids":
                        gn_result["classificationIds"].split("|")[:rank_order + 1],
                    "valid": True,
                    "valid_srid": srid,
                    "match_type": match_type
                }
            )
        return out

    
    host = "https://verifier.globalnames.org"
    path_prefix = "api/v1/verifications"
    if isinstance(name_authorship, str) and name_authorship.strip():
        path_name = quote_plus(" ".join([name, name_authorship]))
    else:
        path_name = quote_plus(name)
    path_name = path_name.lower()
    params = urlencode(
        {'pref_sources': "|".join(['%.0f' % v for v in [1, 3, 11, 147]]),
         'capitalize': "true"}
    )

    req = Request(
        url = "/".join([host, path_prefix, path_name]) + "?" + params,
        headers = {"Content-Type": "application/json"}
    )
    try:
        data = urlopen(req)
    except HTTPError as e:
        return e
    except URLError as e:
        if hasattr(e, 'reason'):
            return e.reason
        elif hasattr(e, 'code'):
            return e.code
        else:
            return e
    else:
        try:
            out = json.loads(data.read().decode('utf-8'))
            out = [taxa_ref for species in out
                for rec in species['preferredResults']
                for taxa_ref in to_taxa_ref(rec)]
            return out
        except KeyError:
            return [None]

$$;


ALTER FUNCTION public.get_taxa_ref_gnames(name text, name_authorship text) OWNER TO postgres;

--
-- Name: insert_taxa_ref_from_taxa_obs(integer, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text DEFAULT NULL::text, taxa_obs_parent_scientific_name text DEFAULT NULL::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DROP TABLE IF EXISTS temp_src_ref;
    CREATE TEMPORARY TABLE temp_src_ref AS (
        SELECT *
        FROM public.match_taxa_sources(taxa_obs_scientific_name, taxa_obs_authorship, taxa_obs_parent_scientific_name)
    );

    INSERT INTO public.taxa_ref (
        source_name,
        source_id,
        source_record_id,
        scientific_name,
        authorship,
        rank,
        valid,
        valid_srid,
        classification_srids
    )
    SELECT
        source_name,
        source_id,
        source_record_id,
        scientific_name,
        authorship,
        rank,
        valid,
        valid_srid,
        classification_srids
    FROM temp_src_ref
    ON CONFLICT DO NOTHING;

    INSERT INTO public.taxa_obs_ref_lookup (
            id_taxa_obs, id_taxa_ref, id_taxa_ref_valid, match_type, is_parent)
        SELECT
            taxa_obs_id AS id_taxa_obs,
            taxa_ref.id AS id_taxa_ref,
            valid_taxa_ref.id AS id_taxa_ref_valid,
            temp_src_ref.match_type AS match_type, 
            temp_src_ref.is_parent AS is_parent
        FROM
            temp_src_ref,
            taxa_ref,
            taxa_ref as valid_taxa_ref
        WHERE  
            temp_src_ref.source_id = taxa_ref.source_id
            AND temp_src_ref.source_record_id = taxa_ref.source_record_id
            and temp_src_ref.source_id = valid_taxa_ref.source_id
            and temp_src_ref.valid_srid = valid_taxa_ref.source_record_id
        ON CONFLICT DO NOTHING;
END;
$$;


ALTER FUNCTION public.insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text, taxa_obs_parent_scientific_name text) OWNER TO postgres;

--
-- Name: insert_taxa_vernacular_using_all_ref(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.insert_taxa_vernacular_using_all_ref() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    scientific_name_rec record;
BEGIN
    FOR scientific_name_rec IN
        SELECT
            distinct on (taxa_ref.scientific_name, taxa_ref.rank)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank)
        FROM taxa_ref
    LOOP
        BEGIN
            PERFORM insert_taxa_vernacular_using_ref(scientific_name_rec.id);
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE 'insert_taxa_vernacular_using_ref(%s) failed for taxa (%s): %', scientific_name_rec.id, scientific_name_rec.scientific_name, SQLERRM;
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION public.insert_taxa_vernacular_using_all_ref() OWNER TO vbeaure;

--
-- Name: insert_taxa_vernacular_using_ref(integer); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.insert_taxa_vernacular_using_ref(id_taxa_ref integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
    scientific_name_rec record;
BEGIN
    CREATE TEMPORARY TABLE distinct_taxa_ref as
        select distinct on (scientific_name)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank)
        from taxa_ref
        where taxa_ref.id = $1;

    FOR scientific_name_rec IN
        SELECT scientific_name FROM distinct_taxa_ref
    LOOP
        WITH related_taxa_obs as (
            select
                id_taxa_obs,
                match_type
            from taxa_obs_ref_lookup ref_lu, distinct_taxa_ref
            where ref_lu.id_taxa_ref = distinct_taxa_ref.id
        ), ins_taxa_vernacular as (
            INSERT INTO taxa_vernacular (
                source_name,
                source_record_id,
                name,
                language,
                rank,
                rank_order
            )
            SELECT
                source,
                source_taxon_key,
                name,
                language,
                rank,
                rank_order
            FROM taxa_vernacular_from_match(scientific_name_rec.scientific_name)
            ON CONFLICT (source_name, source_record_id, language) DO NOTHING
            RETURNING id as taxa_vernacular_id
        )
        INSERT INTO taxa_obs_vernacular_lookup (
            id_taxa_obs,
            id_taxa_vernacular,
            match_type
        )
        SELECT
            related_taxa_obs.id_taxa_obs,
            ins_taxa_vernacular.taxa_vernacular_id,
            coalesce(related_taxa_obs.match_type, 'parent')
        FROM related_taxa_obs,
            ins_taxa_vernacular
        ON CONFLICT (id_taxa_obs, id_taxa_vernacular) DO NOTHING;
    END LOOP;
    DROP TABLE distinct_taxa_ref;
END;
$_$;


ALTER FUNCTION public.insert_taxa_vernacular_using_ref(id_taxa_ref integer) OWNER TO vbeaure;

--
-- Name: log_action_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_action_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
	begin
		NEW.modified_by = current_user;
		NEW.modified_at = NOW();
		return NEW;
	end;
$$;


ALTER FUNCTION public.log_action_user() OWNER TO postgres;

--
-- Name: match_taxa_groups(integer[]); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.match_taxa_groups(id_taxa_obs integer[]) RETURNS SETOF public.taxa_groups
    LANGUAGE sql
    AS $_$
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
$_$;


ALTER FUNCTION public.match_taxa_groups(id_taxa_obs integer[]) OWNER TO vbeaure;

--
-- Name: match_taxa_obs(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_taxa_obs(taxa_name text) RETURNS SETOF public.taxa_obs
    LANGUAGE sql
    AS $_$
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
$_$;


ALTER FUNCTION public.match_taxa_obs(taxa_name text) OWNER TO postgres;

--
-- Name: match_taxa_ref_relatives(text); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.match_taxa_ref_relatives(taxa_name text) RETURNS SETOF public.taxa_ref
    LANGUAGE sql
    AS $$
    select distinct taxa_ref.*
    from taxa_ref search_ref
    left join taxa_obs_ref_lookup search_lookup
        on search_ref.id = search_lookup.id_taxa_ref
    left join taxa_obs_ref_lookup synonym_lookup
        on search_lookup.id_taxa_ref_valid = synonym_lookup.id_taxa_ref_valid
    left join taxa_ref
        on synonym_lookup.id_taxa_ref = taxa_ref.id
    where search_ref.scientific_name = taxa_name
    $$;


ALTER FUNCTION public.match_taxa_ref_relatives(taxa_name text) OWNER TO vbeaure;

--
-- Name: match_taxa_sources(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.match_taxa_sources(name text, name_authorship text DEFAULT NULL::text, parent_scientific_name text DEFAULT NULL::text) RETURNS TABLE(source_name text, source_id numeric, source_record_id text, scientific_name text, authorship text, rank text, rank_order integer, valid boolean, valid_srid text, classification_srids text[], match_type text, is_parent boolean)
    LANGUAGE plpython3u
    AS $$
from bdqc_taxa.taxa_ref import TaxaRef
import plpy
try:
  return TaxaRef.from_all_sources(name, name_authorship, parent_scientific_name)
except Exception as e:
  plpy.notice(f'Failed to match_taxa_sources: {name} {name_authorship}')
  raise Exception(e)
out = TaxaRef.from_all_sources(name, name_authorship)
return out
$$;


ALTER FUNCTION public.match_taxa_sources(name text, name_authorship text, parent_scientific_name text) OWNER TO postgres;

--
-- Name: observations_set_within_quebec_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.observations_set_within_quebec_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
SELECT
bool_or(ST_WITHIN(NEW.geom, qc_region_limit.wkb_geometry))
INTO NEW.within_quebec
FROM qc_region_limit;

    IF (NEW.within_quebec IS TRUE) THEN
        INSERT INTO observations_partitions.within_quebec VALUES (NEW.*);
    ELSE
        RAISE NOTICE 'Will update outside_quebec !';
        -- INSERT INTO observations_partitions.outside_quebec VALUES (NEW.*);
    END IF;
RETURN NULL;
END;
$$;


ALTER FUNCTION public.observations_set_within_quebec_trigger() OWNER TO postgres;

--
-- Name: refresh_taxa_group_members_quebec(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.refresh_taxa_group_members_quebec() RETURNS void
    LANGUAGE sql
    AS $$
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
$$;


ALTER FUNCTION public.refresh_taxa_group_members_quebec() OWNER TO postgres;

--
-- Name: refresh_taxa_ref(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.refresh_taxa_ref() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    taxa_obs_record RECORD;
BEGIN
    DELETE FROM public.taxa_obs_ref_lookup;
    DELETE FROM public.taxa_ref;
    FOR taxa_obs_record IN SELECT * FROM public.taxa_obs LOOP
        BEGIN
            PERFORM public.insert_taxa_ref_from_taxa_obs(
            taxa_obs_record.id, taxa_obs_record.scientific_name, taxa_obs_record.authorship, taxa_obs_record.parent_scientific_name
            );
        EXCEPTION
            WHEN OTHERS THEN
            RAISE NOTICE 'Error inserting record with id % and scientific name %', taxa_obs_record.id, taxa_obs_record.scientific_name;
            CONTINUE;
        END;
    END LOOP;
END;
$$;


ALTER FUNCTION public.refresh_taxa_ref() OWNER TO postgres;

--
-- Name: refresh_taxa_vernacular(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.refresh_taxa_vernacular() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM taxa_obs_vernacular_lookup;
    DELETE FROM taxa_vernacular;
    PERFORM insert_taxa_vernacular_using_all_ref() ;
    PERFORM taxa_vernacular_fix_caribou();
END;
$$;


ALTER FUNCTION public.refresh_taxa_vernacular() OWNER TO vbeaure;

--
-- Name: refresh_taxa_vernacular_using_ref(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.refresh_taxa_vernacular_using_ref() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    scientific_name_rec record;
BEGIN
    CREATE TEMP TABLE distinct_taxa_ref as
        select distinct on (scientific_name)
            taxa_ref.id,
            taxa_ref.scientific_name,
            LOWER(taxa_ref.rank)
        from taxa_ref;

    FOR scientific_name_rec IN
        SELECT scientific_name FROM distinct_taxa_ref
    LOOP
        WITH related_taxa_obs as (
            select
                id_taxa_obs,
                match_type
            from taxa_obs_ref_lookup ref_lu, distinct_taxa_ref
            where ref_lu.id_taxa_ref = distinct_taxa_ref.id
        ), ins_taxa_vernacular as (
            INSERT INTO taxa_vernacular (
                source_name,
                source_record_id,
                name,
                language,
                rank,
                rank_order
            )
            SELECT
                source,
                source_taxon_key,
                name,
                language,
                rank,
                rank_order
            FROM taxa_vernacular_from_match(scientific_name_rec.scientific_name)
            ON CONFLICT (source_name, source_record_id, language) DO NOTHING
            RETURNING id as taxa_vernacular_id
        )
        INSERT INTO taxa_obs_vernacular_lookup (
            id_taxa_obs,
            id_taxa_vernacular,
            match_type
        )
        SELECT
            related_taxa_obs.id_taxa_obs,
            ins_taxa_vernacular.taxa_vernacular_id,
            coalesce(related_taxa_obs.match_type, 'parent')
        FROM related_taxa_obs,
            ins_taxa_vernacular
        ON CONFLICT (id_taxa_obs, id_taxa_vernacular) DO NOTHING;
    END LOOP;
END;
$$;


ALTER FUNCTION public.refresh_taxa_vernacular_using_ref() OWNER TO postgres;

--
-- Name: set_dwc_event_date(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_dwc_event_date() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.dwc_event_date := format_dwc_datetime(
        NEW.year_obs,
        NEW.month_obs,
        NEW.day_obs,
        NEW.time_obs);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_dwc_event_date() OWNER TO postgres;

--
-- Name: taxa_vernacular_fix_caribou(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.taxa_vernacular_fix_caribou() RETURNS void
    LANGUAGE sql
    AS $$
delete from taxa_obs_vernacular_lookup vlu
using taxa_ref, taxa_obs_ref_lookup, taxa_vernacular, taxa_obs
where taxa_ref.scientific_name <> 'Rangifer tarandus'
and taxa_obs.scientific_name <> 'Rangifer tarandus'
and taxa_ref.id = taxa_obs_ref_lookup.id_taxa_ref
and taxa_obs.id = taxa_obs_ref_lookup.id_taxa_obs
and taxa_vernacular.name = 'caribou'
and taxa_vernacular.id = vlu.id_taxa_vernacular
and vlu.id_taxa_obs = taxa_obs.id;
$$;


ALTER FUNCTION public.taxa_vernacular_fix_caribou() OWNER TO postgres;

--
-- Name: taxa_vernacular_from_gbif(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.taxa_vernacular_from_gbif(gbif_taxon_key text) RETURNS TABLE(source text, source_taxon_key text, name text, language text)
    LANGUAGE plpython3u
    AS $$
from bdqc_taxa.vernacular import Vernacular
out = Vernacular.from_gbif(int(gbif_taxon_key))
return out
$$;


ALTER FUNCTION public.taxa_vernacular_from_gbif(gbif_taxon_key text) OWNER TO postgres;

--
-- Name: taxa_vernacular_from_match(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.taxa_vernacular_from_match(observed_scientific_name text) RETURNS TABLE(source text, source_taxon_key text, name text, language text, rank text, rank_order integer)
    LANGUAGE plpython3u
    AS $$
from bdqc_taxa.vernacular import Vernacular
out = Vernacular.from_match(observed_scientific_name)
return out
$$;


ALTER FUNCTION public.taxa_vernacular_from_match(observed_scientific_name text) OWNER TO postgres;

--
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.modified_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO postgres;

--
-- Name: update_area(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.update_area() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.area_km2 := ST_Area(ST_Transform(NEW.geom, 32198)) / 1000000;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_area() OWNER TO vbeaure;

--
-- Name: update_generated_tables_metadata(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.update_generated_tables_metadata() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    generated_table RECORD;
    source_table RECORD;
    update_statement TEXT;
    return_message TEXT;
BEGIN
    -- Update source tables last modified date
    FOR source_table IN
        SELECT DISTINCT source_table_name, source_table_last_modified_column
        FROM generated_tables_metadata
    LOOP
        EXECUTE format(
            'UPDATE generated_tables_metadata
            SET source_table_last_modified = (SELECT MAX(%I) FROM %s)
            WHERE source_table_name = %L',
            source_table.source_table_last_modified_column,
            source_table.source_table_name,
            source_table.source_table_name
        );
    END LOOP;

    -- Update generated tables and last update date
    -- Try updating using statement stored in generated_tables_metadata
    -- If it fails, create warning and continue

    FOR generated_table IN
        SELECT
            id,
            generated_table_name,
            max(source_table_last_modified) source_table_last_modified,
            generated_table_last_update,
            update_statement
        FROM generated_tables_metadata
        GROUP BY generated_table_name, generated_table_last_update, update_statement
    LOOP
        -- If generated table last update is before source table, update it
        IF generated_table.generated_table_last_update < generated_table.source_table_last_modified THEN
            BEGIN
                -- STORE EXECUTE RESULT IN VARIABLE
                EXECUTE generated_table.update_statement INTO return_message;
                -- UPDATE GENERATED TABLE LAST UPDATE AND STATUS
                EXECUTE format('UPDATE generated_tables_metadata SET generated_table_last_update = NOW(), status = %L, return_message = %L WHERE id = %L', 'success', return_message, generated_table.id);
            EXCEPTION WHEN OTHERS THEN
                -- UPDATE GENERATED TABLE STATUS AND RETURN MESSAGE
                EXECUTE format('UPDATE generated_tables_metadata SET status = %L, return_message = %L WHERE id = %L', 'error', SQLERRM, generated_table.id);
            END;
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION public.update_generated_tables_metadata() OWNER TO vbeaure;

--
-- Name: update_longitude_diff(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.update_longitude_diff() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.longitude_diff := ST_XMax(NEW.geom) - ST_XMin(NEW.geom);
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_longitude_diff() OWNER TO vbeaure;

--
-- Name: update_width_km(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.update_width_km() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    proj_geom geometry;
BEGIN
    proj_geom := ST_Transform(NEW.geom, 32198);
    NEW.width_km := (ST_XMax(proj_geom) - ST_XMin(proj_geom)) / 1000;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_width_km() OWNER TO vbeaure;

--
-- Name: update_within_quebec(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.update_within_quebec() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
    NEW.within_quebec := ST_Within(NEW.geom, (SELECT geom FROM regions WHERE type = 'admin' AND scale = 1));
    IF (NEW.within_quebec IS NULL) THEN
        RAISE EXCEPTION 'within_quebec is NULL';
    ELSIF (NEW.within_quebec IS TRUE) THEN
        INSERT INTO observations_partitions.within_quebec VALUES (NEW.*);
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$;


ALTER FUNCTION public.update_within_quebec() OWNER TO vbeaure;

--
-- Name: width_km(); Type: FUNCTION; Schema: public; Owner: vbeaure
--

CREATE FUNCTION public.width_km() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    proj_geom geometry;
BEGIN
    proj_geom := ST_Transform(NEW.geom, 32198);
    NEW.width_km := (ST_XMax(proj_geom) - ST_XMin(proj_geom)) / 1000;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.width_km() OWNER TO vbeaure;

--
-- Name: taxa_branch_tips(integer); Type: AGGREGATE; Schema: api; Owner: vbeaure
--

CREATE AGGREGATE api.taxa_branch_tips(integer) (
    SFUNC = array_append,
    STYPE = integer[],
    INITCOND = '{}',
    FINALFUNC = api.taxa_branch_tips
);


ALTER AGGREGATE api.taxa_branch_tips(integer) OWNER TO vbeaure;

--
-- Name: bird_cadre_eco_counts; Type: TABLE; Schema: api; Owner: postgres
--

CREATE TABLE api.bird_cadre_eco_counts (
    region_fid integer,
    id_taxa_obs integer,
    month integer,
    year integer,
    count_obs bigint
);


ALTER TABLE api.bird_cadre_eco_counts OWNER TO postgres;

--
-- Name: datasets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.datasets (
    id integer NOT NULL,
    original_source character varying NOT NULL,
    org_dataset_id character varying,
    creator character varying,
    title character varying NOT NULL,
    publisher character varying,
    modified date NOT NULL,
    keywords character varying[],
    abstract text,
    type_sampling character varying,
    type_obs public.type_observation,
    intellectual_rights character varying,
    license character varying,
    owner character varying,
    methods text,
    open_data boolean NOT NULL,
    exhaustive boolean NOT NULL,
    direct_obs boolean NOT NULL,
    centroid boolean DEFAULT false,
    doi text DEFAULT ''::text,
    citation text DEFAULT ''::text,
    eml json,
    eml_url text
);


ALTER TABLE public.datasets OWNER TO postgres;

--
-- Name: bird_sampling_points; Type: MATERIALIZED VIEW; Schema: api; Owner: vbeaure
--

CREATE MATERIALIZED VIEW api.bird_sampling_points AS
 SELECT row_number() OVER (ORDER BY pts.geom, pts.year_obs, pts.month_obs, pts.day_obs, pts.time_obs) AS id,
    pts.geom,
    pts.year_obs,
    pts.month_obs,
    pts.day_obs,
    pts.time_obs
   FROM ( SELECT DISTINCT obs.geom,
            obs.year_obs,
            obs.month_obs,
            obs.day_obs,
            obs.time_obs
           FROM (public.observations obs
             LEFT JOIN public.datasets ds ON ((obs.id_datasets = ds.id)))
          WHERE (((ds.title)::text = ANY ((ARRAY['Atlas des Oiseaux Nicheurs du Québec'::character varying, 'eBird Basic Dataset'::character varying])::text[])) AND (ds.exhaustive = true))) pts
  ORDER BY (row_number() OVER (ORDER BY pts.geom, pts.year_obs, pts.month_obs, pts.day_obs, pts.time_obs))
  WITH NO DATA;


ALTER TABLE api.bird_sampling_points OWNER TO vbeaure;

--
-- Name: bird_sampling_observations_lookup; Type: MATERIALIZED VIEW; Schema: api; Owner: vbeaure
--

CREATE MATERIALIZED VIEW api.bird_sampling_observations_lookup AS
 WITH ds AS (
         SELECT datasets.id
           FROM public.datasets
          WHERE (((datasets.title)::text = ANY ((ARRAY['Atlas des Oiseaux Nicheurs du Québec'::character varying, 'eBird Basic Dataset'::character varying])::text[])) AND (datasets.exhaustive = true))
        ), obs AS (
         SELECT obs_1.id,
            obs_1.org_parent_event,
            obs_1.org_event,
            obs_1.org_id_obs,
            obs_1.id_datasets,
            obs_1.geom,
            obs_1.year_obs,
            obs_1.month_obs,
            obs_1.day_obs,
            obs_1.time_obs,
            obs_1.id_taxa,
            obs_1.id_variables,
            obs_1.obs_value,
            obs_1.issue,
            obs_1.created_by,
            obs_1.modified_at,
            obs_1.modified_by,
            obs_1.id_taxa_obs,
            obs_1.within_quebec,
            obs_1.dwc_event_date
           FROM public.observations obs_1
          WHERE (obs_1.id_datasets IN ( SELECT ds.id
                   FROM ds))
        )
 SELECT DISTINCT ON (obs.id, pts.id, obs.id_taxa_obs) obs.id AS id_observations,
    pts.id AS id_sampling_points,
    obs.id_taxa_obs,
    obs.id_datasets
   FROM (obs
     LEFT JOIN api.bird_sampling_points pts ON (((obs.geom OPERATOR(public.=) pts.geom) AND (obs.year_obs = pts.year_obs) AND (obs.month_obs = pts.month_obs) AND (obs.day_obs = pts.day_obs) AND (obs.time_obs = pts.time_obs))))
  WHERE (obs.obs_value IS NOT NULL)
  WITH NO DATA;


ALTER TABLE api.bird_sampling_observations_lookup OWNER TO vbeaure;

--
-- Name: variables; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.variables (
    id integer NOT NULL,
    name character varying NOT NULL,
    unit character varying DEFAULT ''::character varying NOT NULL,
    description text
);


ALTER TABLE public.variables OWNER TO postgres;

--
-- Name: COLUMN variables.unit; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.variables.unit IS 'Site location';


--
-- Name: observations; Type: VIEW; Schema: api; Owner: postgres
--

CREATE VIEW api.observations AS
 SELECT obs.id,
    obs.geom,
    obs.year_obs,
    obs.month_obs,
    obs.day_obs,
    obs.time_obs,
    obs.obs_value AS value,
    obs.within_quebec,
    var.name AS variable,
    var.unit AS variable_unit,
    obs.id_taxa_obs,
    taxa.observed_scientific_name AS taxa_observed_scientific_name,
    taxa.valid_scientific_name AS taxa_valid_scientific_name,
    taxa.vernacular_en AS taxa_vernacular_en,
    taxa.vernacular_fr AS taxa_vernacular_fr,
    taxa.group_en AS taxa_group_en,
    taxa.group_fr AS taxa_group_fr,
    taxa.vernacular AS taxa_vernacular_sources,
    taxa.source_references AS taxa_reference_sources,
    ds.type_sampling,
    ds.type_obs,
    obs.id_datasets,
    ds.title AS dataset,
    ds.original_source AS source,
    obs.org_id_obs AS source_record_id,
    obs.org_parent_event AS source_parent_event,
    obs.org_event AS source_event
   FROM (((public.observations obs
     LEFT JOIN api.taxa ON ((obs.id_taxa_obs = taxa.id_taxa_obs)))
     LEFT JOIN public.datasets ds ON ((obs.id_datasets = ds.id)))
     LEFT JOIN public.variables var ON ((obs.id_variables = var.id)));


ALTER TABLE api.observations OWNER TO postgres;

--
-- Name: regions; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.regions (
    fid integer NOT NULL,
    type character varying(50) NOT NULL,
    name text NOT NULL,
    scale integer NOT NULL,
    scale_desc text,
    geom public.geometry(MultiPolygon,4326) NOT NULL,
    source_table character varying(50),
    source_record_id character varying(50),
    source_updated_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    area_km2 numeric,
    width_km numeric,
    extra jsonb,
    within_quebec boolean,
    source_dataset_name text,
    source_creator text,
    scale_desc_fr text,
    scale_desc_en text
);


ALTER TABLE public.regions OWNER TO vbeaure;

--
-- Name: observations_regions; Type: VIEW; Schema: api; Owner: vbeaure
--

CREATE VIEW api.observations_regions AS
 SELECT obs.id,
    obs.geom,
    obs.year_obs,
    obs.month_obs,
    obs.day_obs,
    obs.time_obs,
    obs.obs_value AS value,
    obs.within_quebec,
    var.name AS variable,
    var.unit AS variable_unit,
    obs.id_taxa_obs,
    taxa_old.observed_scientific_name AS taxa_observed_scientific_name,
    taxa_old.valid_scientific_name AS taxa_valid_scientific_name,
    taxa_old.vernacular_en AS taxa_vernacular_en,
    taxa_old.vernacular_fr AS taxa_vernacular_fr,
    taxa_old.group_en AS taxa_group_en,
    taxa_old.group_fr AS taxa_group_fr,
    taxa_old.vernacular AS taxa_vernacular_sources,
    taxa_old.source_references AS taxa_reference_sources,
    ds.type_sampling,
    ds.type_obs,
    obs.id_datasets,
    ds.title AS dataset,
    ds.original_source AS source,
    obs.org_id_obs AS source_record_id,
    obs.org_parent_event AS source_parent_event,
    obs.org_event AS source_event,
    regions.fid AS region_fid
   FROM ((((public.observations obs
     LEFT JOIN api.taxa_old ON ((obs.id_taxa_obs = taxa_old.id_taxa_obs)))
     LEFT JOIN public.datasets ds ON ((obs.id_datasets = ds.id)))
     LEFT JOIN public.variables var ON ((obs.id_variables = var.id)))
     JOIN public.regions ON (public.st_intersects(obs.geom, regions.geom)))
  WHERE (obs.within_quebec = regions.within_quebec);


ALTER TABLE api.observations_regions OWNER TO vbeaure;

--
-- Name: taxa_groups; Type: VIEW; Schema: api; Owner: vbeaure
--

CREATE VIEW api.taxa_groups AS
 WITH taxa_obs_agg AS (
         SELECT taxa_obs_group_lookup.id_group,
            array_agg(taxa_obs_group_lookup.id_taxa_obs) AS id_taxa_obs
           FROM public.taxa_obs_group_lookup
          WHERE (taxa_obs_group_lookup.id_taxa_obs IS NOT NULL)
          GROUP BY taxa_obs_group_lookup.id_group
        )
 SELECT taxa_groups.id,
    taxa_groups.level,
    taxa_groups.vernacular_en,
    taxa_groups.vernacular_fr,
    taxa_obs_agg.id_taxa_obs
   FROM (public.taxa_groups
     LEFT JOIN taxa_obs_agg ON ((taxa_groups.id = taxa_obs_agg.id_group)))
  ORDER BY taxa_groups.level, taxa_groups.id;


ALTER TABLE api.taxa_groups OWNER TO vbeaure;

--
-- Name: time_series; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.time_series (
    id integer NOT NULL,
    id_datasets integer NOT NULL,
    dataset_record_id integer,
    id_taxa integer,
    unit text,
    years integer[],
    "values" numeric[],
    geom public.geometry(MultiPoint,4326) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    modified_at timestamp without time zone DEFAULT now() NOT NULL,
    id_taxa_obs integer
);


ALTER TABLE public.time_series OWNER TO postgres;

--
-- Name: time_series; Type: VIEW; Schema: api; Owner: postgres
--

CREATE VIEW api.time_series AS
 SELECT ts.id,
    ts.id_datasets,
    ts.dataset_record_id,
    ts.id_taxa,
    ts.unit,
    ts.years,
    ts."values",
    ts.geom,
    ts.created_at,
    ts.modified_at,
    ts.id_taxa_obs,
    taxa_old.observed_scientific_name AS taxa_observed_scientific_name,
    taxa_old.valid_scientific_name AS taxa_valid_scientific_name,
    taxa_old.vernacular_en AS taxa_vernacular_en,
    taxa_old.vernacular_fr AS taxa_vernacular_fr,
    taxa_old.group_en AS taxa_group_en,
    taxa_old.group_fr AS taxa_group_fr,
    ds.type_sampling,
    ds.type_obs,
    ds.title AS dataset,
    ds.original_source AS source
   FROM ((public.time_series ts
     LEFT JOIN api.taxa_old ON ((ts.id_taxa_obs = taxa_old.id_taxa_obs)))
     LEFT JOIN public.datasets ds ON ((ts.id_datasets = ds.id)));


ALTER TABLE api.time_series OWNER TO postgres;

--
-- Name: obs_region_counts; Type: TABLE; Schema: atlas_api; Owner: postgres
--

CREATE TABLE atlas_api.obs_region_counts (
    type text,
    scale integer,
    fid integer,
    id_taxa_obs integer,
    year_obs integer,
    count_obs integer
);


ALTER TABLE atlas_api.obs_region_counts OWNER TO postgres;

--
-- Name: obs_regions_taxa_datasets_counts; Type: TABLE; Schema: atlas_api; Owner: vbeaure
--

CREATE TABLE atlas_api.obs_regions_taxa_datasets_counts (
    fid integer,
    type text,
    id_taxa_obs integer,
    id_datasets integer,
    min_year integer,
    max_year integer,
    count_obs integer
);


ALTER TABLE atlas_api.obs_regions_taxa_datasets_counts OWNER TO vbeaure;

--
-- Name: regions_zoom_lookup; Type: TABLE; Schema: atlas_api; Owner: vbeaure
--

CREATE TABLE atlas_api.regions_zoom_lookup (
    type text,
    scale integer,
    zoom integer,
    name_en character varying(50) DEFAULT NULL::character varying,
    name_fr character varying(50) DEFAULT NULL::character varying,
    show_sensitive boolean DEFAULT false,
    scale_desc_fr character varying(50) DEFAULT NULL::character varying,
    scale_desc_en character varying(50) DEFAULT NULL::character varying
);


ALTER TABLE atlas_api.regions_zoom_lookup OWNER TO vbeaure;

--
-- Name: region_types; Type: VIEW; Schema: atlas_api; Owner: vbeaure
--

CREATE VIEW atlas_api.region_types AS
 SELECT DISTINCT regions_zoom_lookup.type,
    regions_zoom_lookup.name_en,
    regions_zoom_lookup.name_fr
   FROM atlas_api.regions_zoom_lookup
  WHERE (regions_zoom_lookup.type = ANY (ARRAY['admin'::text, 'hex'::text, 'cadre_eco'::text]));


ALTER TABLE atlas_api.region_types OWNER TO vbeaure;

--
-- Name: sensitive_taxa_max_scale; Type: TABLE; Schema: atlas_api; Owner: vbeaure
--

CREATE TABLE atlas_api.sensitive_taxa_max_scale (
    type text,
    scale integer
);


ALTER TABLE atlas_api.sensitive_taxa_max_scale OWNER TO vbeaure;

--
-- Name: temp_obs_region_counts; Type: TABLE; Schema: atlas_api; Owner: vbeaure
--

CREATE TABLE atlas_api.temp_obs_region_counts (
    type character varying(50),
    scale integer,
    fid integer,
    id_taxa_obs integer,
    year_obs integer,
    count_obs bigint
);


ALTER TABLE atlas_api.temp_obs_region_counts OWNER TO vbeaure;

--
-- Name: temp_obs_regions_taxa_year_counts; Type: TABLE; Schema: atlas_api; Owner: vbeaure
--

CREATE TABLE atlas_api.temp_obs_regions_taxa_year_counts (
    type character varying(50),
    fid integer,
    id_taxa_obs integer,
    year_obs integer,
    count_obs bigint,
    scale integer
);


ALTER TABLE atlas_api.temp_obs_regions_taxa_year_counts OWNER TO vbeaure;

--
-- Name: web_regions; Type: MATERIALIZED VIEW; Schema: atlas_api; Owner: vbeaure
--

CREATE MATERIALIZED VIEW atlas_api.web_regions AS
 SELECT regions.fid,
    regions.type,
    regions.scale,
        CASE
            WHEN (regions_zoom_lookup.zoom = 3) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.17578)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 4) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.08789)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 5) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.04395)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 6) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.02197)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 7) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.01099)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 8) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.00549)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 9) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.00274)::double precision), 4326)))
            WHEN (regions_zoom_lookup.zoom = 10) THEN public.st_forcepolygonccw(public.st_makevalid(public.st_transform(public.st_simplifypreservetopology(regions.geom, (0.00137)::double precision), 4326)))
            ELSE NULL::public.geometry
        END AS geom
   FROM (public.regions
     JOIN atlas_api.regions_zoom_lookup ON ((((regions.type)::text = regions_zoom_lookup.type) AND (regions.scale = regions_zoom_lookup.scale))))
  WITH NO DATA;


ALTER TABLE atlas_api.web_regions OWNER TO vbeaure;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.api_keys OWNER TO postgres;

--
-- Name: COLUMN api_keys.token; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.api_keys.token IS 'token used by a user';


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO postgres;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: cdpnq_ranges; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.cdpnq_ranges (
    id integer NOT NULL,
    taxa_scientific_name character varying(255) NOT NULL,
    geom public.geometry NOT NULL,
    source_modified_at date NOT NULL
);


ALTER TABLE public.cdpnq_ranges OWNER TO vbeaure;

--
-- Name: cdpnq_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: vbeaure
--

CREATE SEQUENCE public.cdpnq_ranges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cdpnq_ranges_id_seq OWNER TO vbeaure;

--
-- Name: cdpnq_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vbeaure
--

ALTER SEQUENCE public.cdpnq_ranges_id_seq OWNED BY public.cdpnq_ranges.id;


--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.datasets_id_seq OWNER TO postgres;

--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: efforts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.efforts (
    id integer NOT NULL,
    id_variables integer NOT NULL,
    effort_value numeric NOT NULL
);


ALTER TABLE public.efforts OWNER TO postgres;

--
-- Name: efforts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.efforts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.efforts_id_seq OWNER TO postgres;

--
-- Name: efforts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.efforts_id_seq OWNED BY public.efforts.id;


--
-- Name: generated_tables_metadata; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.generated_tables_metadata (
    id integer NOT NULL,
    source_table_name text NOT NULL,
    source_table_last_modified_column text NOT NULL,
    source_table_last_modified timestamp without time zone,
    generated_table_name text NOT NULL,
    generated_table_last_update timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    update_statement text NOT NULL,
    status text,
    return_message text
);


ALTER TABLE public.generated_tables_metadata OWNER TO vbeaure;

--
-- Name: generated_tables_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: vbeaure
--

CREATE SEQUENCE public.generated_tables_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.generated_tables_metadata_id_seq OWNER TO vbeaure;

--
-- Name: generated_tables_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vbeaure
--

ALTER SEQUENCE public.generated_tables_metadata_id_seq OWNED BY public.generated_tables_metadata.id;


--
-- Name: mat_view_dependencies; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mat_view_dependencies AS
 WITH RECURSIVE s(start_schemaname, start_relname, start_relkind, schemaname, relname, relkind, reloid, owneroid, ownername, depth) AS (
         SELECT n.nspname AS start_schemaname,
            c.relname AS start_relname,
            c.relkind AS start_relkind,
            n2.nspname AS schemaname,
            c2.relname,
            c2.relkind,
            c2.oid AS reloid,
            au.oid AS owneroid,
            au.rolname AS ownername,
            0 AS depth
           FROM ((((((pg_class c
             JOIN pg_namespace n ON (((c.relnamespace = n.oid) AND (c.relkind = ANY (ARRAY['r'::"char", 'm'::"char", 'v'::"char", 't'::"char", 'f'::"char", 'p'::"char"])))))
             JOIN pg_depend d ON ((c.oid = d.refobjid)))
             JOIN pg_rewrite r ON ((d.objid = r.oid)))
             JOIN pg_class c2 ON ((r.ev_class = c2.oid)))
             JOIN pg_namespace n2 ON ((n2.oid = c2.relnamespace)))
             JOIN pg_authid au ON ((au.oid = c2.relowner)))
        UNION
         SELECT s_1.start_schemaname,
            s_1.start_relname,
            s_1.start_relkind,
            n.nspname AS schemaname,
            c2.relname,
            c2.relkind,
            c2.oid,
            au.oid AS owneroid,
            au.rolname AS ownername,
            (s_1.depth + 1) AS depth
           FROM (((((s s_1
             JOIN pg_depend d ON ((s_1.reloid = d.refobjid)))
             JOIN pg_rewrite r ON ((d.objid = r.oid)))
             JOIN pg_class c2 ON (((r.ev_class = c2.oid) AND (c2.relkind = ANY (ARRAY['m'::"char", 'v'::"char"])))))
             JOIN pg_namespace n ON ((n.oid = c2.relnamespace)))
             JOIN pg_authid au ON ((au.oid = c2.relowner)))
          WHERE (s_1.reloid <> c2.oid)
        )
 SELECT s.start_schemaname,
    s.start_relname,
    s.start_relkind,
    s.schemaname,
    s.relname,
    s.relkind,
    s.reloid,
    s.owneroid,
    s.ownername,
    s.depth
   FROM s;


ALTER TABLE public.mat_view_dependencies OWNER TO postgres;

--
-- Name: mat_view_refresh_order; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.mat_view_refresh_order AS
 WITH b AS (
         SELECT DISTINCT ON (mat_view_dependencies.schemaname, mat_view_dependencies.relname) mat_view_dependencies.schemaname,
            mat_view_dependencies.relname,
            mat_view_dependencies.ownername,
            mat_view_dependencies.depth
           FROM public.mat_view_dependencies
          WHERE (mat_view_dependencies.relkind = 'm'::"char")
          ORDER BY mat_view_dependencies.schemaname, mat_view_dependencies.relname, mat_view_dependencies.depth DESC
        )
 SELECT b.schemaname,
    b.relname,
    b.ownername,
    b.depth AS refresh_order
   FROM b
  ORDER BY b.depth, b.schemaname, b.relname;


ALTER TABLE public.mat_view_refresh_order OWNER TO postgres;

--
-- Name: montreal_terrestrial_limits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.montreal_terrestrial_limits (
    ogc_fid integer NOT NULL,
    wkb_geometry public.geometry(MultiPolygon,4326),
    defaultatt character varying(5)
);


ALTER TABLE public.montreal_terrestrial_limits OWNER TO postgres;

--
-- Name: montreal_terrestrial_limits_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.montreal_terrestrial_limits_ogc_fid_seq OWNER TO postgres;

--
-- Name: montreal_terrestrial_limits_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq OWNED BY public.montreal_terrestrial_limits.ogc_fid;


--
-- Name: obs_efforts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.obs_efforts (
    id_obs bigint NOT NULL,
    id_efforts integer NOT NULL
);


ALTER TABLE public.obs_efforts OWNER TO postgres;

--
-- Name: observations_qc; Type: VIEW; Schema: public; Owner: vbeaure
--

CREATE VIEW public.observations_qc AS
 SELECT observations.id,
    observations.org_parent_event,
    observations.org_event,
    observations.org_id_obs,
    observations.id_datasets,
    observations.geom,
    observations.year_obs,
    observations.month_obs,
    observations.day_obs,
    observations.time_obs,
    observations.id_taxa,
    observations.id_variables,
    observations.obs_value,
    observations.issue,
    observations.created_by,
    observations.modified_at,
    observations.modified_by,
    observations.id_taxa_obs,
    observations.within_quebec,
    observations.dwc_event_date
   FROM public.observations
  WHERE (observations.within_quebec IS TRUE);


ALTER TABLE public.observations_qc OWNER TO vbeaure;

--
-- Name: qc_limit; Type: TABLE; Schema: public; Owner: vbeaure
--

CREATE TABLE public.qc_limit (
    fid bigint NOT NULL,
    geom public.geometry(MultiPolygon,4269),
    area double precision,
    name character varying
);


ALTER TABLE public.qc_limit OWNER TO vbeaure;

--
-- Name: qc_region_limit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.qc_region_limit (
    ogc_fid integer NOT NULL,
    wkb_geometry public.geometry(MultiPolygon,4326),
    area numeric(19,11),
    perimeter numeric(19,11),
    regio_s_ numeric(10,0),
    regio_s_id numeric(10,0),
    res_no_ind character varying(14),
    res_de_ind character varying(40),
    res_co_reg character varying(2),
    res_nm_reg character varying(64),
    res_co_ref character varying(8),
    res_co_ver character varying(8),
    geom_simple public.geometry(Polygon,4326)
);


ALTER TABLE public.qc_region_limit OWNER TO postgres;

--
-- Name: qc_region_limit_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.qc_region_limit_ogc_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.qc_region_limit_ogc_fid_seq OWNER TO postgres;

--
-- Name: qc_region_limit_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.qc_region_limit_ogc_fid_seq OWNED BY public.qc_region_limit.ogc_fid;


--
-- Name: regions_fid_seq; Type: SEQUENCE; Schema: public; Owner: vbeaure
--

CREATE SEQUENCE public.regions_fid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.regions_fid_seq OWNER TO vbeaure;

--
-- Name: regions_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vbeaure
--

ALTER SEQUENCE public.regions_fid_seq OWNED BY public.regions.fid;


SET default_tablespace = ssdpool;

--
-- Name: taxa; Type: TABLE; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE TABLE public.taxa (
    id integer NOT NULL,
    scientific_name character varying NOT NULL,
    rank public.ranks NOT NULL,
    valid boolean NOT NULL,
    valid_taxa_id bigint,
    gbif bigint,
    col bigint,
    family character varying,
    species_gr public.sp_categories,
    authorship character varying NOT NULL,
    updated_at date NOT NULL,
    qc_status public.qc,
    exotic boolean
);


ALTER TABLE public.taxa OWNER TO postgres;

--
-- Name: COLUMN taxa.rank; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.taxa.rank IS 'Site location';


--
-- Name: taxa_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: vbeaure
--

CREATE SEQUENCE public.taxa_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_groups_id_seq OWNER TO vbeaure;

--
-- Name: taxa_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vbeaure
--

ALTER SEQUENCE public.taxa_groups_id_seq OWNED BY public.taxa_groups.id;


--
-- Name: taxa_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_id_seq OWNER TO postgres;

--
-- Name: taxa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxa_id_seq OWNED BY public.taxa.id;


--
-- Name: taxa_obs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxa_obs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_obs_id_seq OWNER TO postgres;

--
-- Name: taxa_obs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxa_obs_id_seq OWNED BY public.taxa_obs.id;


--
-- Name: taxa_obs_synonym_lookup; Type: VIEW; Schema: public; Owner: vbeaure
--

CREATE VIEW public.taxa_obs_synonym_lookup AS
 SELECT DISTINCT match_obs.id_taxa_obs,
    synonym_obs.id_taxa_obs AS id_taxa_obs_synonym
   FROM (public.taxa_obs_ref_lookup match_obs
     LEFT JOIN public.taxa_obs_ref_lookup synonym_obs ON ((match_obs.id_taxa_ref_valid = synonym_obs.id_taxa_ref)))
  WHERE ((match_obs.is_parent IS FALSE) AND (synonym_obs.is_parent IS FALSE) AND (match_obs.id_taxa_obs <> synonym_obs.id_taxa_obs));


ALTER TABLE public.taxa_obs_synonym_lookup OWNER TO vbeaure;

--
-- Name: taxa_ref_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxa_ref_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_ref_id_seq OWNER TO postgres;

--
-- Name: taxa_ref_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxa_ref_id_seq OWNED BY public.taxa_ref.id;


--
-- Name: taxa_vernacular_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.taxa_vernacular_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_vernacular_id_seq OWNER TO postgres;

--
-- Name: taxa_vernacular_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.taxa_vernacular_id_seq OWNED BY public.taxa_vernacular.id;


SET default_tablespace = '';

--
-- Name: time_series_from_obs; Type: MATERIALIZED VIEW; Schema: public; Owner: vbeaure
--

CREATE MATERIALIZED VIEW public.time_series_from_obs AS
 SELECT obs.id_datasets,
    obs.id_taxa_obs,
    obs.id_variables,
    obs_efforts.id_efforts,
    obs.geom,
    array_agg(obs.dwc_event_date) AS dates,
    array_agg(obs.obs_value) AS obs_values,
    count(DISTINCT obs.id) AS count_obs
   FROM public.observations obs,
    public.obs_efforts,
    public.taxa_obs,
    public.datasets ds
  WHERE ((obs.within_quebec IS TRUE) AND (obs.id = obs_efforts.id_obs) AND (obs.id_datasets = ds.id) AND (obs.id_taxa_obs = taxa_obs.id))
  GROUP BY obs.id_datasets, obs.id_taxa_obs, obs.geom, obs_efforts.id_efforts, obs.id_variables
 HAVING (count(DISTINCT obs.id) > 1)
  ORDER BY (count(DISTINCT obs.id)) DESC
  WITH NO DATA;


ALTER TABLE public.time_series_from_obs OWNER TO vbeaure;

--
-- Name: time_series_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.time_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.time_series_id_seq OWNER TO postgres;

--
-- Name: time_series_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.time_series_id_seq OWNED BY public.time_series.id;


--
-- Name: tmpc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tmpc (
    fid numeric(11,0),
    "group" text[]
);


ALTER TABLE public.tmpc OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    lastname character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role public.enum_users_role DEFAULT 'user'::public.enum_users_role NOT NULL,
    organization character varying(255),
    password character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.name IS 'Nom de l''utilisateur';


--
-- Name: COLUMN users.lastname; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.lastname IS 'Prénom de l''utilisateur';


--
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.email IS 'Adresse courriel de l''utilisateur';


--
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.role IS 'role de l''utilisateur';


--
-- Name: COLUMN users.organization; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.organization IS 'Organisme d''attache de l''utilisateur';


--
-- Name: COLUMN users.password; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.password IS 'Mot de passe de l''utilisateur';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: variables_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variables_id_seq OWNER TO postgres;

--
-- Name: variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.variables_id_seq OWNED BY public.variables.id;


--
-- Name: outside_quebec id; Type: DEFAULT; Schema: observations_partitions; Owner: postgres
--

ALTER TABLE ONLY observations_partitions.outside_quebec ALTER COLUMN id SET DEFAULT nextval('observations_partitions.observations_id_seq'::regclass);


--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: cdpnq_ranges id; Type: DEFAULT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.cdpnq_ranges ALTER COLUMN id SET DEFAULT nextval('public.cdpnq_ranges_id_seq'::regclass);


--
-- Name: datasets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: efforts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.efforts ALTER COLUMN id SET DEFAULT nextval('public.efforts_id_seq'::regclass);


--
-- Name: generated_tables_metadata id; Type: DEFAULT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.generated_tables_metadata ALTER COLUMN id SET DEFAULT nextval('public.generated_tables_metadata_id_seq'::regclass);


--
-- Name: montreal_terrestrial_limits ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.montreal_terrestrial_limits ALTER COLUMN ogc_fid SET DEFAULT nextval('public.montreal_terrestrial_limits_ogc_fid_seq'::regclass);


--
-- Name: observations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations ALTER COLUMN id SET DEFAULT nextval('observations_partitions.observations_id_seq'::regclass);


--
-- Name: qc_region_limit ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qc_region_limit ALTER COLUMN ogc_fid SET DEFAULT nextval('public.qc_region_limit_ogc_fid_seq'::regclass);


--
-- Name: regions fid; Type: DEFAULT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.regions ALTER COLUMN fid SET DEFAULT nextval('public.regions_fid_seq'::regclass);


--
-- Name: taxa id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa ALTER COLUMN id SET DEFAULT nextval('public.taxa_id_seq'::regclass);


--
-- Name: taxa_groups id; Type: DEFAULT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.taxa_groups ALTER COLUMN id SET DEFAULT nextval('public.taxa_groups_id_seq'::regclass);


--
-- Name: taxa_obs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_obs ALTER COLUMN id SET DEFAULT nextval('public.taxa_obs_id_seq'::regclass);


--
-- Name: taxa_ref id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_ref ALTER COLUMN id SET DEFAULT nextval('public.taxa_ref_id_seq'::regclass);


--
-- Name: taxa_vernacular id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_vernacular ALTER COLUMN id SET DEFAULT nextval('public.taxa_vernacular_id_seq'::regclass);


--
-- Name: time_series id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_series ALTER COLUMN id SET DEFAULT nextval('public.time_series_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: variables id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variables ALTER COLUMN id SET DEFAULT nextval('public.variables_id_seq'::regclass);


--
-- Name: taxa_ref_sources taxa_ref_sources_pkey; Type: CONSTRAINT; Schema: api; Owner: vbeaure
--

ALTER TABLE ONLY api.taxa_ref_sources
    ADD CONSTRAINT taxa_ref_sources_pkey PRIMARY KEY (source_id);


--
-- Name: taxa_vernacular_sources taxa_vernacular_sources_pkey; Type: CONSTRAINT; Schema: api; Owner: vbeaure
--

ALTER TABLE ONLY api.taxa_vernacular_sources
    ADD CONSTRAINT taxa_vernacular_sources_pkey PRIMARY KEY (source_name);


--
-- Name: observations observations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id, within_quebec);


--
-- Name: outside_quebec outside_quebec_pkey; Type: CONSTRAINT; Schema: observations_partitions; Owner: postgres
--

ALTER TABLE ONLY observations_partitions.outside_quebec
    ADD CONSTRAINT outside_quebec_pkey PRIMARY KEY (id, within_quebec);


--
-- Name: outside_quebec outside_quebec_unique_id; Type: CONSTRAINT; Schema: observations_partitions; Owner: postgres
--

ALTER TABLE ONLY observations_partitions.outside_quebec
    ADD CONSTRAINT outside_quebec_unique_id UNIQUE (id);


--
-- Name: within_quebec within_quebec_pkey; Type: CONSTRAINT; Schema: observations_partitions; Owner: postgres
--

ALTER TABLE ONLY observations_partitions.within_quebec
    ADD CONSTRAINT within_quebec_pkey PRIMARY KEY (id, within_quebec);


--
-- Name: within_quebec within_quebec_unique_id; Type: CONSTRAINT; Schema: observations_partitions; Owner: postgres
--

ALTER TABLE ONLY observations_partitions.within_quebec
    ADD CONSTRAINT within_quebec_unique_id UNIQUE (id);


--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: api_keys api_keys_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_token_key UNIQUE (token);


--
-- Name: cdpnq_ranges cdpnq_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.cdpnq_ranges
    ADD CONSTRAINT cdpnq_ranges_pkey PRIMARY KEY (id);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: efforts efforts_id_variables_effort_value_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_id_variables_effort_value_key UNIQUE (id_variables, effort_value);


--
-- Name: efforts efforts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_pkey PRIMARY KEY (id);


--
-- Name: generated_tables_metadata generated_tables_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.generated_tables_metadata
    ADD CONSTRAINT generated_tables_metadata_pkey PRIMARY KEY (id);


--
-- Name: montreal_terrestrial_limits montreal_terrestrial_limits_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.montreal_terrestrial_limits
    ADD CONSTRAINT montreal_terrestrial_limits_pk PRIMARY KEY (ogc_fid);


--
-- Name: obs_efforts obs_efforts_id_obs_id_efforts_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obs_efforts
    ADD CONSTRAINT obs_efforts_id_obs_id_efforts_key UNIQUE (id_obs, id_efforts);


--
-- Name: qc_limit qc_limit_pkey; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.qc_limit
    ADD CONSTRAINT qc_limit_pkey PRIMARY KEY (fid);


--
-- Name: qc_region_limit qc_region_limit_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.qc_region_limit
    ADD CONSTRAINT qc_region_limit_pk PRIMARY KEY (ogc_fid);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (fid);


SET default_tablespace = ssdpool;

--
-- Name: taxa taxa_col_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_col_key UNIQUE (col);


--
-- Name: taxa taxa_gbif_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_gbif_key UNIQUE (gbif);


SET default_tablespace = '';

--
-- Name: taxa_groups taxa_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.taxa_groups
    ADD CONSTRAINT taxa_groups_pkey PRIMARY KEY (id);


SET default_tablespace = ssdpool;

--
-- Name: taxa_obs taxa_obs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa_obs
    ADD CONSTRAINT taxa_obs_pkey PRIMARY KEY (id);


--
-- Name: taxa_obs_ref_lookup taxa_obs_ref_lookup_id_taxa_obs_id_taxa_ref_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa_obs_ref_lookup
    ADD CONSTRAINT taxa_obs_ref_lookup_id_taxa_obs_id_taxa_ref_key UNIQUE (id_taxa_obs, id_taxa_ref);


SET default_tablespace = '';

--
-- Name: taxa_obs taxa_obs_unique_rows; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_obs
    ADD CONSTRAINT taxa_obs_unique_rows UNIQUE (scientific_name, authorship, rank, parent_scientific_name);


--
-- Name: taxa_obs_vernacular_lookup taxa_obs_vernacular_lookup_id_taxa_obs_id_taxa_vernacular_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_obs_vernacular_lookup
    ADD CONSTRAINT taxa_obs_vernacular_lookup_id_taxa_obs_id_taxa_vernacular_key UNIQUE (id_taxa_obs, id_taxa_vernacular);


SET default_tablespace = ssdpool;

--
-- Name: taxa taxa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_pkey PRIMARY KEY (id);


SET default_tablespace = '';

--
-- Name: taxa_ref taxa_ref_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_ref
    ADD CONSTRAINT taxa_ref_pkey PRIMARY KEY (id);


--
-- Name: taxa_ref taxa_ref_source_name_source_record_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_ref
    ADD CONSTRAINT taxa_ref_source_name_source_record_id_key UNIQUE (source_name, source_record_id);


SET default_tablespace = ssdpool;

--
-- Name: taxa taxa_scientific_name_authorship_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: ssdpool
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_scientific_name_authorship_key UNIQUE (scientific_name, authorship);


SET default_tablespace = '';

--
-- Name: taxa_vernacular taxa_vernacular_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_vernacular
    ADD CONSTRAINT taxa_vernacular_pkey PRIMARY KEY (id);


--
-- Name: taxa_vernacular taxa_vernacular_source_name_source_record_id_language_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_vernacular
    ADD CONSTRAINT taxa_vernacular_source_name_source_record_id_language_key UNIQUE (source_name, source_record_id, language);


--
-- Name: time_series time_series_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_series
    ADD CONSTRAINT time_series_pkey PRIMARY KEY (id);


--
-- Name: datasets unique_dataset; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT unique_dataset UNIQUE (original_source, org_dataset_id);


--
-- Name: cdpnq_ranges unique_taxa_scientific_name; Type: CONSTRAINT; Schema: public; Owner: vbeaure
--

ALTER TABLE ONLY public.cdpnq_ranges
    ADD CONSTRAINT unique_taxa_scientific_name UNIQUE (taxa_scientific_name);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_name_lastname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_name_lastname_key UNIQUE (name, lastname);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variables variables_name_unit_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_name_unit_key UNIQUE (name, unit);


--
-- Name: variables variables_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);


--
-- Name: bird_cadre_eco_counts_id_taxa_obs_idx; Type: INDEX; Schema: api; Owner: postgres
--

CREATE INDEX bird_cadre_eco_counts_id_taxa_obs_idx ON api.bird_cadre_eco_counts USING btree (id_taxa_obs);


--
-- Name: bird_cadre_eco_counts_month_idx; Type: INDEX; Schema: api; Owner: postgres
--

CREATE INDEX bird_cadre_eco_counts_month_idx ON api.bird_cadre_eco_counts USING btree (month);


--
-- Name: bird_cadre_eco_counts_region_fid_idx; Type: INDEX; Schema: api; Owner: postgres
--

CREATE INDEX bird_cadre_eco_counts_region_fid_idx ON api.bird_cadre_eco_counts USING btree (region_fid);


--
-- Name: bird_cadre_eco_counts_year_idx; Type: INDEX; Schema: api; Owner: postgres
--

CREATE INDEX bird_cadre_eco_counts_year_idx ON api.bird_cadre_eco_counts USING btree (year);


--
-- Name: bird_sampling_observations_lookup_id_observations_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_observations_lookup_id_observations_idx ON api.bird_sampling_observations_lookup USING btree (id_observations);


--
-- Name: bird_sampling_observations_lookup_id_sampling_points_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_observations_lookup_id_sampling_points_idx ON api.bird_sampling_observations_lookup USING btree (id_sampling_points);


--
-- Name: bird_sampling_observations_lookup_id_taxa_obs_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_observations_lookup_id_taxa_obs_idx ON api.bird_sampling_observations_lookup USING btree (id_taxa_obs);


--
-- Name: bird_sampling_points_geom_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_points_geom_idx ON api.bird_sampling_points USING gist (geom);


--
-- Name: bird_sampling_points_id_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_points_id_idx ON api.bird_sampling_points USING btree (id);


--
-- Name: bird_sampling_points_points_geom_date_time_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX bird_sampling_points_points_geom_date_time_idx ON api.bird_sampling_points USING btree (geom, year_obs, month_obs, day_obs, time_obs);


--
-- Name: taxa_observed_scientific_name_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX taxa_observed_scientific_name_idx ON api.taxa USING btree (observed_scientific_name);


--
-- Name: taxa_rank_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX taxa_rank_idx ON api.taxa USING btree (rank);


--
-- Name: taxa_valid_scientific_name_idx; Type: INDEX; Schema: api; Owner: vbeaure
--

CREATE INDEX taxa_valid_scientific_name_idx ON api.taxa USING btree (valid_scientific_name);


--
-- Name: obs_region_counts_fid_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_fid_idx ON atlas_api.obs_region_counts USING btree (fid);


--
-- Name: obs_region_counts_id_taxa_obs_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_id_taxa_obs_idx ON atlas_api.obs_region_counts USING btree (id_taxa_obs);


--
-- Name: obs_region_counts_type_fid_id_taxa_obs_year_obs_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE UNIQUE INDEX obs_region_counts_type_fid_id_taxa_obs_year_obs_idx ON atlas_api.obs_region_counts USING btree (fid, id_taxa_obs, year_obs);


--
-- Name: obs_region_counts_type_fid_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_type_fid_idx ON atlas_api.obs_region_counts USING btree (type, fid);


--
-- Name: obs_region_counts_type_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_type_idx ON atlas_api.obs_region_counts USING btree (type);


--
-- Name: obs_region_counts_type_scale_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_type_scale_idx ON atlas_api.obs_region_counts USING btree (type, scale);


--
-- Name: obs_region_counts_year_obs_idx; Type: INDEX; Schema: atlas_api; Owner: postgres
--

CREATE INDEX obs_region_counts_year_obs_idx ON atlas_api.obs_region_counts USING btree (year_obs);


--
-- Name: obs_regions_taxa_datasets_counts_fid_id_taxa_obs_id_datasets_id; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE UNIQUE INDEX obs_regions_taxa_datasets_counts_fid_id_taxa_obs_id_datasets_id ON atlas_api.obs_regions_taxa_datasets_counts USING btree (fid, id_taxa_obs, id_datasets);


--
-- Name: obs_regions_taxa_datasets_counts_fid_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_fid_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (fid);


--
-- Name: obs_regions_taxa_datasets_counts_id_datasets_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_id_datasets_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (id_datasets);


--
-- Name: obs_regions_taxa_datasets_counts_id_taxa_obs_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_id_taxa_obs_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (id_taxa_obs);


--
-- Name: obs_regions_taxa_datasets_counts_max_year_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_max_year_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (max_year);


--
-- Name: obs_regions_taxa_datasets_counts_min_year_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_min_year_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (min_year);


--
-- Name: obs_regions_taxa_datasets_counts_type_fid_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX obs_regions_taxa_datasets_counts_type_fid_idx ON atlas_api.obs_regions_taxa_datasets_counts USING btree (type, fid);


--
-- Name: regions_zoom_lookup_show_sensitive_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX regions_zoom_lookup_show_sensitive_idx ON atlas_api.regions_zoom_lookup USING btree (show_sensitive);


--
-- Name: regions_zoom_lookup_type_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX regions_zoom_lookup_type_idx ON atlas_api.regions_zoom_lookup USING btree (type);


--
-- Name: regions_zoom_lookup_zoom_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX regions_zoom_lookup_zoom_idx ON atlas_api.regions_zoom_lookup USING btree (zoom);


--
-- Name: temp_obs_regions_taxa_year_counts_fid_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_fid_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (fid);


--
-- Name: temp_obs_regions_taxa_year_counts_id_taxa_obs_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_id_taxa_obs_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (id_taxa_obs);


--
-- Name: temp_obs_regions_taxa_year_counts_scale_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_scale_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (scale);


--
-- Name: temp_obs_regions_taxa_year_counts_type_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_type_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (type);


--
-- Name: temp_obs_regions_taxa_year_counts_type_scale_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_type_scale_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (type, scale);


--
-- Name: temp_obs_regions_taxa_year_counts_year_obs_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX temp_obs_regions_taxa_year_counts_year_obs_idx ON atlas_api.temp_obs_regions_taxa_year_counts USING btree (year_obs);


--
-- Name: web_regions_fid_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE UNIQUE INDEX web_regions_fid_idx ON atlas_api.web_regions USING btree (fid);


--
-- Name: web_regions_geom_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX web_regions_geom_idx ON atlas_api.web_regions USING gist (geom);


--
-- Name: web_regions_scale_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX web_regions_scale_idx ON atlas_api.web_regions USING btree (scale);


--
-- Name: web_regions_type_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX web_regions_type_idx ON atlas_api.web_regions USING btree (type);


--
-- Name: web_regions_type_scale_idx; Type: INDEX; Schema: atlas_api; Owner: vbeaure
--

CREATE INDEX web_regions_type_scale_idx ON atlas_api.web_regions USING btree (type, scale);


--
-- Name: observations_geom_date_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_geom_date_time_idx ON ONLY public.observations USING btree (geom, year_obs, month_obs, day_obs, time_obs);


--
-- Name: observations_geom_date_time_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX observations_geom_date_time_idx ON observations_partitions.within_quebec USING btree (geom, year_obs, month_obs, day_obs, time_obs);


--
-- Name: observations_id_taxa_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX observations_id_taxa_obs_idx ON observations_partitions.within_quebec USING btree (id_taxa_obs);


--
-- Name: outside_quebec_geom_year_obs_month_obs_day_obs_time_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_geom_year_obs_month_obs_day_obs_time_obs_idx ON observations_partitions.outside_quebec USING btree (geom, year_obs, month_obs, day_obs, time_obs);


--
-- Name: observations_id_datasets_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_id_datasets_idx ON ONLY public.observations USING btree (id_datasets);


--
-- Name: outside_quebec_id_datasets_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_id_datasets_idx ON observations_partitions.outside_quebec USING btree (id_datasets);


--
-- Name: observations_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_id_idx ON ONLY public.observations USING btree (id);


--
-- Name: outside_quebec_id_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_id_idx ON observations_partitions.outside_quebec USING btree (id);


--
-- Name: observations_id_taxa_obs_dwc_event_date_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_id_taxa_obs_dwc_event_date_geom_idx ON ONLY public.observations USING btree (id_taxa_obs, dwc_event_date, geom);


--
-- Name: outside_quebec_id_taxa_obs_dwc_event_date_geom_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_id_taxa_obs_dwc_event_date_geom_idx ON observations_partitions.outside_quebec USING btree (id_taxa_obs, dwc_event_date, geom);


--
-- Name: observations_id_taxa_obs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_id_taxa_obs_idx ON ONLY public.observations USING btree (id_taxa_obs);


--
-- Name: outside_quebec_id_taxa_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_id_taxa_obs_idx ON observations_partitions.outside_quebec USING btree (id_taxa_obs);


--
-- Name: observations_modified_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_modified_at_idx ON ONLY public.observations USING btree (modified_at);


--
-- Name: outside_quebec_modified_at_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_modified_at_idx ON observations_partitions.outside_quebec USING btree (modified_at);


--
-- Name: org_id_obs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX org_id_obs_idx ON ONLY public.observations USING btree (org_id_obs);


--
-- Name: outside_quebec_org_id_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX outside_quebec_org_id_obs_idx ON observations_partitions.outside_quebec USING btree (org_id_obs);


--
-- Name: within_quebec_id_datasets_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_id_datasets_idx ON observations_partitions.within_quebec USING btree (id_datasets);


--
-- Name: within_quebec_id_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_id_idx ON observations_partitions.within_quebec USING btree (id);


--
-- Name: within_quebec_id_taxa_obs_dwc_event_date_geom_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_id_taxa_obs_dwc_event_date_geom_idx ON observations_partitions.within_quebec USING btree (id_taxa_obs, dwc_event_date, geom);


--
-- Name: within_quebec_id_taxa_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_id_taxa_obs_idx ON observations_partitions.within_quebec USING btree (id_taxa_obs);


--
-- Name: within_quebec_modified_at_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_modified_at_idx ON observations_partitions.within_quebec USING btree (modified_at);


--
-- Name: within_quebec_org_id_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_org_id_obs_idx ON observations_partitions.within_quebec USING btree (org_id_obs);


--
-- Name: within_quebec_year_obs_idx; Type: INDEX; Schema: observations_partitions; Owner: postgres
--

CREATE INDEX within_quebec_year_obs_idx ON observations_partitions.within_quebec USING btree (year_obs);


--
-- Name: dwc_event_date_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX dwc_event_date_idx ON ONLY public.observations USING btree (dwc_event_date);


--
-- Name: generated_tables_metadata_unique_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE UNIQUE INDEX generated_tables_metadata_unique_idx ON public.generated_tables_metadata USING btree (generated_table_name, source_table_name, update_statement);


--
-- Name: id_taxa_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX id_taxa_idx ON public.time_series USING btree (id_taxa);


SET default_tablespace = ssdpool;

--
-- Name: id_taxa_obs_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE INDEX id_taxa_obs_idx ON public.taxa_obs_ref_lookup USING btree (id_taxa_obs);


--
-- Name: id_taxa_ref_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE INDEX id_taxa_ref_idx ON public.taxa_obs_ref_lookup USING btree (id_taxa_ref);


--
-- Name: id_taxa_ref_valid_idx; Type: INDEX; Schema: public; Owner: postgres; Tablespace: ssdpool
--

CREATE INDEX id_taxa_ref_valid_idx ON public.taxa_obs_ref_lookup USING btree (id_taxa_ref_valid);


SET default_tablespace = '';

--
-- Name: montreal_terrestrial_limits_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX montreal_terrestrial_limits_wkb_geometry_geom_idx ON public.montreal_terrestrial_limits USING gist (wkb_geometry);


--
-- Name: observations_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_geom_idx ON ONLY public.observations USING gist (geom);


--
-- Name: observations_id_datasets_id_taxa_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_id_datasets_id_taxa_idx ON ONLY public.observations USING btree (id_datasets, id_taxa);


--
-- Name: observations_unique_rows; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_unique_rows ON ONLY public.observations USING btree (geom, dwc_event_date, id_taxa_obs, obs_value, id_variables, within_quebec);


--
-- Name: observations_year_obs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_year_obs_idx ON ONLY public.observations USING btree (year_obs);


--
-- Name: qc_region_limit_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX qc_region_limit_wkb_geometry_geom_idx ON public.qc_region_limit USING gist (wkb_geometry);


--
-- Name: regions_geom_gist; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_geom_gist ON public.regions USING gist (geom);


--
-- Name: regions_name_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_name_idx ON public.regions USING btree (name);


--
-- Name: regions_scale_desc_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_scale_desc_idx ON public.regions USING btree (scale_desc);


--
-- Name: regions_type_fid_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_type_fid_idx ON public.regions USING btree (type, fid);


--
-- Name: regions_type_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_type_idx ON public.regions USING btree (type);


--
-- Name: regions_type_scale_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX regions_type_scale_idx ON public.regions USING btree (type, scale);


--
-- Name: regions_type_source_table_source_record_id_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE UNIQUE INDEX regions_type_source_table_source_record_id_idx ON public.regions USING btree (type, source_table, source_record_id);


--
-- Name: scientific_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX scientific_name_idx ON public.taxa_ref USING btree (scientific_name);


--
-- Name: source_id_srid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX source_id_srid_idx ON public.taxa_ref USING btree (source_id, valid_srid);


--
-- Name: taxa_groups_short_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX taxa_groups_short_idx ON public.taxa_groups USING btree (short);


--
-- Name: taxa_groups_short_unique_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE UNIQUE INDEX taxa_groups_short_unique_idx ON public.taxa_groups USING btree (short);


--
-- Name: taxa_obs_group_lookup_id_group_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX taxa_obs_group_lookup_id_group_idx ON public.taxa_obs_group_lookup USING btree (id_group);


--
-- Name: taxa_obs_group_lookup_id_taxa_obs_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX taxa_obs_group_lookup_id_taxa_obs_idx ON public.taxa_obs_group_lookup USING btree (id_taxa_obs);


--
-- Name: taxa_obs_group_lookup_short_group_idx; Type: INDEX; Schema: public; Owner: vbeaure
--

CREATE INDEX taxa_obs_group_lookup_short_group_idx ON public.taxa_obs_group_lookup USING btree (short_group);


--
-- Name: taxa_obs_scientific_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_obs_scientific_name_idx ON public.taxa_obs USING btree (scientific_name);


--
-- Name: taxa_obs_vernacular_lookup_id_taxa_obs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_obs_vernacular_lookup_id_taxa_obs_idx ON public.taxa_obs_vernacular_lookup USING btree (id_taxa_obs);


--
-- Name: taxa_obs_vernacular_lookup_id_taxa_vernacular_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_obs_vernacular_lookup_id_taxa_vernacular_idx ON public.taxa_obs_vernacular_lookup USING btree (id_taxa_vernacular);


--
-- Name: taxa_obs_vernacular_lookup_match_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_obs_vernacular_lookup_match_type_idx ON public.taxa_obs_vernacular_lookup USING btree (match_type);


--
-- Name: taxa_obs_vernacular_lookup_rank_order_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_obs_vernacular_lookup_rank_order_idx ON public.taxa_vernacular USING btree (rank_order);


--
-- Name: taxa_vernacular_language_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_vernacular_language_idx ON public.taxa_vernacular USING btree (language);


--
-- Name: taxa_vernacular_source_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_vernacular_source_name_idx ON public.taxa_vernacular USING btree (source_name);


--
-- Name: taxa_vernacular_source_record_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX taxa_vernacular_source_record_id_idx ON public.taxa_vernacular USING btree (source_record_id);


--
-- Name: time_series_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX time_series_geom_idx ON public.time_series USING gist (geom);


--
-- Name: time_series_id_taxa_obs_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX time_series_id_taxa_obs_idx ON public.time_series USING btree (id_taxa_obs);


--
-- Name: tmpc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX tmpc_id ON public.tmpc USING btree (fid);


--
-- Name: observations_geom_date_time_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_geom_date_time_idx ATTACH PARTITION observations_partitions.observations_geom_date_time_idx;


--
-- Name: outside_quebec_geom_year_obs_month_obs_day_obs_time_obs_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_geom_date_time_idx ATTACH PARTITION observations_partitions.outside_quebec_geom_year_obs_month_obs_day_obs_time_obs_idx;


--
-- Name: outside_quebec_id_datasets_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_datasets_idx ATTACH PARTITION observations_partitions.outside_quebec_id_datasets_idx;


--
-- Name: outside_quebec_id_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_idx ATTACH PARTITION observations_partitions.outside_quebec_id_idx;


--
-- Name: outside_quebec_id_taxa_obs_dwc_event_date_geom_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_taxa_obs_dwc_event_date_geom_idx ATTACH PARTITION observations_partitions.outside_quebec_id_taxa_obs_dwc_event_date_geom_idx;


--
-- Name: outside_quebec_id_taxa_obs_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_taxa_obs_idx ATTACH PARTITION observations_partitions.outside_quebec_id_taxa_obs_idx;


--
-- Name: outside_quebec_modified_at_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_modified_at_idx ATTACH PARTITION observations_partitions.outside_quebec_modified_at_idx;


--
-- Name: outside_quebec_org_id_obs_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.org_id_obs_idx ATTACH PARTITION observations_partitions.outside_quebec_org_id_obs_idx;


--
-- Name: outside_quebec_pkey; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_pkey ATTACH PARTITION observations_partitions.outside_quebec_pkey;


--
-- Name: within_quebec_id_datasets_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_datasets_idx ATTACH PARTITION observations_partitions.within_quebec_id_datasets_idx;


--
-- Name: within_quebec_id_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_idx ATTACH PARTITION observations_partitions.within_quebec_id_idx;


--
-- Name: within_quebec_id_taxa_obs_dwc_event_date_geom_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_taxa_obs_dwc_event_date_geom_idx ATTACH PARTITION observations_partitions.within_quebec_id_taxa_obs_dwc_event_date_geom_idx;


--
-- Name: within_quebec_id_taxa_obs_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_id_taxa_obs_idx ATTACH PARTITION observations_partitions.within_quebec_id_taxa_obs_idx;


--
-- Name: within_quebec_modified_at_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_modified_at_idx ATTACH PARTITION observations_partitions.within_quebec_modified_at_idx;


--
-- Name: within_quebec_org_id_obs_idx; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.org_id_obs_idx ATTACH PARTITION observations_partitions.within_quebec_org_id_obs_idx;


--
-- Name: within_quebec_pkey; Type: INDEX ATTACH; Schema: observations_partitions; Owner: postgres
--

ALTER INDEX public.observations_pkey ATTACH PARTITION observations_partitions.within_quebec_pkey;


--
-- Name: outside_quebec action_user_logger; Type: TRIGGER; Schema: observations_partitions; Owner: postgres
--

CREATE TRIGGER action_user_logger BEFORE INSERT OR UPDATE ON observations_partitions.outside_quebec FOR EACH ROW EXECUTE FUNCTION public.log_action_user();


--
-- Name: outside_quebec update_within_quebec_trigger; Type: TRIGGER; Schema: observations_partitions; Owner: postgres
--

CREATE TRIGGER update_within_quebec_trigger BEFORE INSERT ON observations_partitions.outside_quebec FOR EACH ROW EXECUTE FUNCTION public.update_within_quebec();


--
-- Name: observations set_dwc_event_date_trggr; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER set_dwc_event_date_trggr BEFORE INSERT ON public.observations FOR EACH ROW EXECUTE FUNCTION public.set_dwc_event_date();


--
-- Name: time_series time_series_update_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER time_series_update_at BEFORE UPDATE ON public.time_series FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: regions update_area; Type: TRIGGER; Schema: public; Owner: vbeaure
--

CREATE TRIGGER update_area BEFORE INSERT OR UPDATE ON public.regions FOR EACH ROW EXECUTE FUNCTION public.update_area();


--
-- Name: observations update_modified_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_modified_at BEFORE UPDATE ON public.observations FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: taxa_obs update_modified_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_modified_at BEFORE UPDATE ON public.taxa_obs FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: taxa_ref update_modified_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_modified_at BEFORE UPDATE ON public.taxa_ref FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: taxa_vernacular update_modified_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_modified_at BEFORE UPDATE ON public.taxa_vernacular FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: regions update_width_km; Type: TRIGGER; Schema: public; Owner: vbeaure
--

CREATE TRIGGER update_width_km BEFORE INSERT OR UPDATE ON public.regions FOR EACH ROW EXECUTE FUNCTION public.update_width_km();


--
-- Name: api_keys api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: efforts efforts_id_variables_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_id_variables_fkey FOREIGN KEY (id_variables) REFERENCES public.variables(id);


--
-- Name: time_series fk_datasets; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_series
    ADD CONSTRAINT fk_datasets FOREIGN KEY (id_datasets) REFERENCES public.datasets(id) ON UPDATE CASCADE;


--
-- Name: time_series fk_taxa; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_series
    ADD CONSTRAINT fk_taxa FOREIGN KEY (id_taxa) REFERENCES public.taxa(id) ON UPDATE CASCADE;


--
-- Name: obs_efforts obs_efforts_id_efforts_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.obs_efforts
    ADD CONSTRAINT obs_efforts_id_efforts_fkey FOREIGN KEY (id_efforts) REFERENCES public.efforts(id);


--
-- Name: observations observations_coordinate_uncertainty_id_variables_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.observations
    ADD CONSTRAINT observations_coordinate_uncertainty_id_variables_fkey FOREIGN KEY (coordinate_uncertainty_id_variables) REFERENCES public.variables(id);


--
-- Name: observations observations_id_datasets_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.observations
    ADD CONSTRAINT observations_id_datasets_fkey FOREIGN KEY (id_datasets) REFERENCES public.datasets(id) ON DELETE CASCADE;


--
-- Name: observations observations_id_taxa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.observations
    ADD CONSTRAINT observations_id_taxa_fkey FOREIGN KEY (id_taxa) REFERENCES public.taxa(id);


--
-- Name: observations observations_id_taxa_obs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.observations
    ADD CONSTRAINT observations_id_taxa_obs_fkey FOREIGN KEY (id_taxa_obs) REFERENCES public.taxa_obs(id);


--
-- Name: observations observations_id_variables_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.observations
    ADD CONSTRAINT observations_id_variables_fkey FOREIGN KEY (id_variables) REFERENCES public.variables(id);


--
-- Name: taxa_obs_ref_lookup taxa_obs_ref_lookup_id_taxa_obs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_obs_ref_lookup
    ADD CONSTRAINT taxa_obs_ref_lookup_id_taxa_obs_fkey FOREIGN KEY (id_taxa_obs) REFERENCES public.taxa_obs(id);


--
-- Name: taxa_obs_ref_lookup taxa_obs_ref_lookup_id_taxa_ref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.taxa_obs_ref_lookup
    ADD CONSTRAINT taxa_obs_ref_lookup_id_taxa_ref_fkey FOREIGN KEY (id_taxa_ref) REFERENCES public.taxa_ref(id);


--
-- Name: time_series time_series_id_taxa_obs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.time_series
    ADD CONSTRAINT time_series_id_taxa_obs_fkey FOREIGN KEY (id_taxa_obs) REFERENCES public.taxa_obs(id);


--
-- Name: SCHEMA api; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA api TO read_only_all;
GRANT USAGE ON SCHEMA api TO read_write_all;
GRANT USAGE ON SCHEMA api TO read_only_public;


--
-- Name: SCHEMA atlas_api; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA atlas_api TO coleo;
GRANT USAGE ON SCHEMA atlas_api TO read_only_all;
GRANT USAGE ON SCHEMA atlas_api TO read_only_public;
GRANT USAGE ON SCHEMA atlas_api TO read_write_all;


--
-- Name: SCHEMA observations_partitions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA observations_partitions TO read_write_all;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT USAGE ON SCHEMA public TO read_only_all;
GRANT USAGE ON SCHEMA public TO read_only_public;
GRANT USAGE ON SCHEMA public TO read_write_all;


--
-- Name: FUNCTION __taxa_join_attributes(taxa_obs_id integer[]); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.__taxa_join_attributes(taxa_obs_id integer[]) TO read_only_all;
GRANT ALL ON FUNCTION api.__taxa_join_attributes(taxa_obs_id integer[]) TO read_write_all;
GRANT ALL ON FUNCTION api.__taxa_join_attributes(taxa_obs_id integer[]) TO read_only_public;


--
-- Name: FUNCTION autocomplete_taxa_name(name text); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.autocomplete_taxa_name(name text) TO read_only_public;
GRANT ALL ON FUNCTION api.autocomplete_taxa_name(name text) TO read_only_all;
GRANT ALL ON FUNCTION api.autocomplete_taxa_name(name text) TO read_write_all;


--
-- Name: FUNCTION get_bird_presence(taxa_name text); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.get_bird_presence(taxa_name text) TO read_only_all;
GRANT ALL ON FUNCTION api.get_bird_presence(taxa_name text) TO read_write_all;
GRANT ALL ON FUNCTION api.get_bird_presence(taxa_name text) TO read_only_public;


--
-- Name: FUNCTION get_bird_presence_absence(taxa_name text, page_limit integer, page_offset integer); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.get_bird_presence_absence(taxa_name text, page_limit integer, page_offset integer) TO read_only_all;
GRANT ALL ON FUNCTION api.get_bird_presence_absence(taxa_name text, page_limit integer, page_offset integer) TO read_write_all;
GRANT ALL ON FUNCTION api.get_bird_presence_absence(taxa_name text, page_limit integer, page_offset integer) TO read_only_public;


--
-- Name: FUNCTION get_mtl_bird_presence_absence(taxa_name text); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.get_mtl_bird_presence_absence(taxa_name text) TO read_only_all;
GRANT ALL ON FUNCTION api.get_mtl_bird_presence_absence(taxa_name text) TO read_write_all;
GRANT ALL ON FUNCTION api.get_mtl_bird_presence_absence(taxa_name text) TO read_only_public;


--
-- Name: TABLE taxa_obs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.taxa_obs TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_obs TO read_write_all;
GRANT SELECT ON TABLE public.taxa_obs TO PUBLIC;


--
-- Name: TABLE taxa_old; Type: ACL; Schema: api; Owner: postgres
--

GRANT SELECT ON TABLE api.taxa_old TO PUBLIC;
GRANT SELECT ON TABLE api.taxa_old TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.taxa_old TO read_write_all;
GRANT SELECT ON TABLE api.taxa_old TO read_only_public;


--
-- Name: FUNCTION get_taxa_groups(taxa_keys integer[]); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.get_taxa_groups(taxa_keys integer[]) TO read_only_all;
GRANT ALL ON FUNCTION api.get_taxa_groups(taxa_keys integer[]) TO read_write_all;
GRANT ALL ON FUNCTION api.get_taxa_groups(taxa_keys integer[]) TO read_only_public;


--
-- Name: TABLE taxa_ref_sources; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.taxa_ref_sources TO PUBLIC;
GRANT SELECT ON TABLE api.taxa_ref_sources TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.taxa_ref_sources TO read_write_all;
GRANT SELECT ON TABLE api.taxa_ref_sources TO read_only_public;


--
-- Name: TABLE taxa_vernacular_sources; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.taxa_vernacular_sources TO PUBLIC;
GRANT SELECT ON TABLE api.taxa_vernacular_sources TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.taxa_vernacular_sources TO read_write_all;
GRANT SELECT ON TABLE api.taxa_vernacular_sources TO read_only_public;


--
-- Name: TABLE observations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.observations TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.observations TO read_write_all;
GRANT SELECT ON TABLE public.observations TO PUBLIC;


--
-- Name: TABLE outside_quebec; Type: ACL; Schema: observations_partitions; Owner: postgres
--

GRANT ALL ON TABLE observations_partitions.outside_quebec TO admins;
GRANT ALL ON TABLE observations_partitions.outside_quebec TO coleo;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE observations_partitions.outside_quebec TO read_write_all;


--
-- Name: SEQUENCE observations_id_seq; Type: ACL; Schema: observations_partitions; Owner: postgres
--

GRANT ALL ON SEQUENCE observations_partitions.observations_id_seq TO read_write_all;


--
-- Name: TABLE within_quebec; Type: ACL; Schema: observations_partitions; Owner: postgres
--

GRANT SELECT ON TABLE observations_partitions.within_quebec TO PUBLIC;
GRANT SELECT ON TABLE observations_partitions.within_quebec TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE observations_partitions.within_quebec TO read_write_all;


--
-- Name: TABLE taxa_group_members; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.taxa_group_members TO PUBLIC;
GRANT SELECT ON TABLE public.taxa_group_members TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_group_members TO read_write_all;


--
-- Name: TABLE taxa_groups; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.taxa_groups TO PUBLIC;
GRANT SELECT ON TABLE public.taxa_groups TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_groups TO read_write_all;


--
-- Name: TABLE taxa_obs_ref_lookup; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.taxa_obs_ref_lookup TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_obs_ref_lookup TO read_write_all;
GRANT SELECT ON TABLE public.taxa_obs_ref_lookup TO PUBLIC;


--
-- Name: TABLE taxa_ref; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.taxa_ref TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_ref TO read_write_all;
GRANT SELECT ON TABLE public.taxa_ref TO PUBLIC;


--
-- Name: TABLE taxa_obs_group_lookup; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.taxa_obs_group_lookup TO PUBLIC;
GRANT SELECT ON TABLE public.taxa_obs_group_lookup TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_obs_group_lookup TO read_write_all;


--
-- Name: TABLE taxa_obs_vernacular_lookup; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.taxa_obs_vernacular_lookup TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_obs_vernacular_lookup TO read_write_all;
GRANT SELECT ON TABLE public.taxa_obs_vernacular_lookup TO PUBLIC;


--
-- Name: TABLE taxa_vernacular; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.taxa_vernacular TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_vernacular TO read_write_all;
GRANT SELECT ON TABLE public.taxa_vernacular TO PUBLIC;


--
-- Name: TABLE taxa; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.taxa TO PUBLIC;
GRANT SELECT ON TABLE api.taxa TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.taxa TO read_write_all;
GRANT SELECT ON TABLE api.taxa TO read_only_public;


--
-- Name: FUNCTION match_taxa(taxa_name text); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.match_taxa(taxa_name text) TO read_only_all;
GRANT ALL ON FUNCTION api.match_taxa(taxa_name text) TO read_write_all;
GRANT ALL ON FUNCTION api.match_taxa(taxa_name text) TO read_only_public;


--
-- Name: FUNCTION match_taxa_list(taxa_names text[]); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.match_taxa_list(taxa_names text[]) TO read_only_all;
GRANT ALL ON FUNCTION api.match_taxa_list(taxa_names text[]) TO read_write_all;
GRANT ALL ON FUNCTION api.match_taxa_list(taxa_names text[]) TO read_only_public;


--
-- Name: FUNCTION refresh_bird_cadre_eco_counts(); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_only_all;
GRANT ALL ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_write_all;
GRANT ALL ON FUNCTION api.refresh_bird_cadre_eco_counts() TO read_only_public;


--
-- Name: FUNCTION taxa_autocomplete(name text); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.taxa_autocomplete(name text) TO read_only_all;
GRANT ALL ON FUNCTION api.taxa_autocomplete(name text) TO read_write_all;
GRANT ALL ON FUNCTION api.taxa_autocomplete(name text) TO read_only_public;


--
-- Name: FUNCTION taxa_autocomplete_temp(name text, out_limit integer); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer) TO read_only_all;
GRANT ALL ON FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer) TO read_write_all;
GRANT ALL ON FUNCTION api.taxa_autocomplete_temp(name text, out_limit integer) TO read_only_public;


--
-- Name: FUNCTION taxa_branch_tips(taxa_obs_ids integer[]); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.taxa_branch_tips(taxa_obs_ids integer[]) TO read_only_all;
GRANT ALL ON FUNCTION api.taxa_branch_tips(taxa_obs_ids integer[]) TO read_write_all;
GRANT ALL ON FUNCTION api.taxa_branch_tips(taxa_obs_ids integer[]) TO read_only_public;


--
-- Name: FUNCTION test_get_bird_presence_absence(); Type: ACL; Schema: api; Owner: postgres
--

GRANT ALL ON FUNCTION api.test_get_bird_presence_absence() TO read_only_all;
GRANT ALL ON FUNCTION api.test_get_bird_presence_absence() TO read_write_all;
GRANT ALL ON FUNCTION api.test_get_bird_presence_absence() TO read_only_public;


--
-- Name: FUNCTION get_scale(type text, zoom integer, is_sensitive boolean); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.get_scale(type text, zoom integer, is_sensitive boolean) TO read_only_public;
GRANT ALL ON FUNCTION atlas_api.get_scale(type text, zoom integer, is_sensitive boolean) TO read_only_all;


--
-- Name: FUNCTION get_year_counts(taxakeys integer[], taxagroupkey integer); Type: ACL; Schema: atlas_api; Owner: postgres
--

GRANT ALL ON FUNCTION atlas_api.get_year_counts(taxakeys integer[], taxagroupkey integer) TO read_only_public;


--
-- Name: FUNCTION list_species(taxakeys integer[]); Type: ACL; Schema: atlas_api; Owner: postgres
--

GRANT ALL ON FUNCTION atlas_api.list_species(taxakeys integer[]) TO read_only_public;


--
-- Name: FUNCTION obs_dataset_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_dataset_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_dataset_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_map(region_type text, zoom integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_map(region_type text, zoom integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_map(region_type text, zoom integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_map(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: postgres
--

GRANT ALL ON FUNCTION atlas_api.obs_map(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_map(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_map_values(region_type text, scale integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_map_values(region_type text, scale integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_map_values(region_type text, scale integer, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_map_values_slippy(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_map_values_slippy(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_map_values_slippy(region_type text, zoom integer, x_min double precision, y_min double precision, x_max double precision, y_max double precision, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_region_counts_refresh(); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_region_counts_refresh() TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_region_counts_refresh() TO read_only_public;


--
-- Name: FUNCTION obs_regions_taxa_datasets_counts_refresh(); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_regions_taxa_datasets_counts_refresh() TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_regions_taxa_datasets_counts_refresh() TO read_only_public;


--
-- Name: FUNCTION obs_species_summary(taxa_key integer, region_fid integer, region_type text, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_species_summary(taxa_key integer, region_fid integer, region_type text, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_species_summary(taxa_key integer, region_fid integer, region_type text, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_summary(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION obs_taxa_list(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.obs_taxa_list(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.obs_taxa_list(region_fid integer, region_type text, taxa_keys integer[], taxa_group_key integer, min_year integer, max_year integer) TO read_only_public;


--
-- Name: FUNCTION regions_autocomplete(name text); Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT ALL ON FUNCTION atlas_api.regions_autocomplete(name text) TO read_only_all;
GRANT ALL ON FUNCTION atlas_api.regions_autocomplete(name text) TO read_only_public;


--
-- Name: FUNCTION autocomplete_taxa_name(name text); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.autocomplete_taxa_name(name text) TO read_only_public;
GRANT ALL ON FUNCTION public.autocomplete_taxa_name(name text) TO read_write_all;


--
-- Name: FUNCTION count_distinct_species(taxa_obs_keys integer[]); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.count_distinct_species(taxa_obs_keys integer[]) TO read_only_all;
GRANT ALL ON FUNCTION public.count_distinct_species(taxa_obs_keys integer[]) TO read_write_all;
GRANT ALL ON FUNCTION public.count_distinct_species(taxa_obs_keys integer[]) TO read_only_public;


--
-- Name: FUNCTION filter_qc_obs_from_taxa_match(name text); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.filter_qc_obs_from_taxa_match(name text) TO read_only_public;
GRANT ALL ON FUNCTION public.filter_qc_obs_from_taxa_match(name text) TO read_write_all;


--
-- Name: FUNCTION fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text) TO read_only_all;
GRANT ALL ON FUNCTION public.fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text) TO read_write_all;
GRANT ALL ON FUNCTION public.fix_taxa_obs_parent_scientific_name(scientific_name text, parent_scientific_name text) TO read_only_public;


--
-- Name: FUNCTION format_dwc_datetime(year integer, month integer, day integer, time_obs time without time zone); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.format_dwc_datetime(year integer, month integer, day integer, time_obs time without time zone) TO read_only_all;
GRANT ALL ON FUNCTION public.format_dwc_datetime(year integer, month integer, day integer, time_obs time without time zone) TO read_write_all;
GRANT ALL ON FUNCTION public.format_dwc_datetime(year integer, month integer, day integer, time_obs time without time zone) TO read_only_public;


--
-- Name: FUNCTION get_taxa_ref_gnames(name text, name_authorship text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_taxa_ref_gnames(name text, name_authorship text) TO read_only_all;
GRANT ALL ON FUNCTION public.get_taxa_ref_gnames(name text, name_authorship text) TO read_write_all;
GRANT ALL ON FUNCTION public.get_taxa_ref_gnames(name text, name_authorship text) TO read_only_public;


--
-- Name: FUNCTION insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text, taxa_obs_parent_scientific_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text, taxa_obs_parent_scientific_name text) TO read_only_all;
GRANT ALL ON FUNCTION public.insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text, taxa_obs_parent_scientific_name text) TO read_write_all;
GRANT ALL ON FUNCTION public.insert_taxa_ref_from_taxa_obs(taxa_obs_id integer, taxa_obs_scientific_name text, taxa_obs_authorship text, taxa_obs_parent_scientific_name text) TO read_only_public;


--
-- Name: FUNCTION insert_taxa_vernacular_using_all_ref(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.insert_taxa_vernacular_using_all_ref() TO read_only_all;
GRANT ALL ON FUNCTION public.insert_taxa_vernacular_using_all_ref() TO read_write_all;


--
-- Name: FUNCTION insert_taxa_vernacular_using_ref(id_taxa_ref integer); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.insert_taxa_vernacular_using_ref(id_taxa_ref integer) TO read_only_all;
GRANT ALL ON FUNCTION public.insert_taxa_vernacular_using_ref(id_taxa_ref integer) TO read_write_all;


--
-- Name: FUNCTION log_action_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_action_user() TO read_only_public;
GRANT ALL ON FUNCTION public.log_action_user() TO read_write_all;


--
-- Name: FUNCTION match_taxa_groups(id_taxa_obs integer[]); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.match_taxa_groups(id_taxa_obs integer[]) TO read_only_all;
GRANT ALL ON FUNCTION public.match_taxa_groups(id_taxa_obs integer[]) TO read_write_all;


--
-- Name: FUNCTION match_taxa_obs(taxa_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_taxa_obs(taxa_name text) TO read_only_all;
GRANT ALL ON FUNCTION public.match_taxa_obs(taxa_name text) TO read_write_all;
GRANT ALL ON FUNCTION public.match_taxa_obs(taxa_name text) TO read_only_public;


--
-- Name: FUNCTION match_taxa_ref_relatives(taxa_name text); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.match_taxa_ref_relatives(taxa_name text) TO read_only_public;
GRANT ALL ON FUNCTION public.match_taxa_ref_relatives(taxa_name text) TO read_write_all;


--
-- Name: FUNCTION match_taxa_sources(name text, name_authorship text, parent_scientific_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.match_taxa_sources(name text, name_authorship text, parent_scientific_name text) TO read_only_all;
GRANT ALL ON FUNCTION public.match_taxa_sources(name text, name_authorship text, parent_scientific_name text) TO read_write_all;
GRANT ALL ON FUNCTION public.match_taxa_sources(name text, name_authorship text, parent_scientific_name text) TO read_only_public;


--
-- Name: FUNCTION observations_set_within_quebec_trigger(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.observations_set_within_quebec_trigger() TO read_only_all;
GRANT ALL ON FUNCTION public.observations_set_within_quebec_trigger() TO read_write_all;
GRANT ALL ON FUNCTION public.observations_set_within_quebec_trigger() TO read_only_public;


--
-- Name: FUNCTION refresh_taxa_group_members_quebec(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.refresh_taxa_group_members_quebec() TO read_only_all;
GRANT ALL ON FUNCTION public.refresh_taxa_group_members_quebec() TO read_write_all;
GRANT ALL ON FUNCTION public.refresh_taxa_group_members_quebec() TO read_only_public;


--
-- Name: FUNCTION refresh_taxa_ref(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.refresh_taxa_ref() TO read_only_all;
GRANT ALL ON FUNCTION public.refresh_taxa_ref() TO read_write_all;
GRANT ALL ON FUNCTION public.refresh_taxa_ref() TO read_only_public;


--
-- Name: FUNCTION refresh_taxa_vernacular(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.refresh_taxa_vernacular() TO read_only_all;
GRANT ALL ON FUNCTION public.refresh_taxa_vernacular() TO read_write_all;


--
-- Name: FUNCTION refresh_taxa_vernacular_using_ref(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.refresh_taxa_vernacular_using_ref() TO read_only_all;
GRANT ALL ON FUNCTION public.refresh_taxa_vernacular_using_ref() TO read_write_all;
GRANT ALL ON FUNCTION public.refresh_taxa_vernacular_using_ref() TO read_only_public;


--
-- Name: FUNCTION set_dwc_event_date(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_dwc_event_date() TO read_only_all;
GRANT ALL ON FUNCTION public.set_dwc_event_date() TO read_write_all;
GRANT ALL ON FUNCTION public.set_dwc_event_date() TO read_only_public;


--
-- Name: FUNCTION taxa_vernacular_fix_caribou(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.taxa_vernacular_fix_caribou() TO read_only_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_fix_caribou() TO read_write_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_fix_caribou() TO read_only_public;


--
-- Name: FUNCTION taxa_vernacular_from_gbif(gbif_taxon_key text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.taxa_vernacular_from_gbif(gbif_taxon_key text) TO read_only_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_from_gbif(gbif_taxon_key text) TO read_write_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_from_gbif(gbif_taxon_key text) TO read_only_public;


--
-- Name: FUNCTION taxa_vernacular_from_match(observed_scientific_name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.taxa_vernacular_from_match(observed_scientific_name text) TO read_only_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_from_match(observed_scientific_name text) TO read_write_all;
GRANT ALL ON FUNCTION public.taxa_vernacular_from_match(observed_scientific_name text) TO read_only_public;


--
-- Name: FUNCTION trigger_set_timestamp(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trigger_set_timestamp() TO read_only_all;
GRANT ALL ON FUNCTION public.trigger_set_timestamp() TO read_only_public;
GRANT ALL ON FUNCTION public.trigger_set_timestamp() TO read_write_all;


--
-- Name: FUNCTION update_area(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.update_area() TO read_only_all;
GRANT ALL ON FUNCTION public.update_area() TO read_write_all;


--
-- Name: FUNCTION update_generated_tables_metadata(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.update_generated_tables_metadata() TO read_only_all;
GRANT ALL ON FUNCTION public.update_generated_tables_metadata() TO read_write_all;


--
-- Name: FUNCTION update_longitude_diff(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.update_longitude_diff() TO read_only_all;
GRANT ALL ON FUNCTION public.update_longitude_diff() TO read_write_all;


--
-- Name: FUNCTION update_width_km(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.update_width_km() TO read_only_all;
GRANT ALL ON FUNCTION public.update_width_km() TO read_write_all;


--
-- Name: FUNCTION update_within_quebec(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.update_within_quebec() TO read_only_all;
GRANT ALL ON FUNCTION public.update_within_quebec() TO read_write_all;


--
-- Name: FUNCTION width_km(); Type: ACL; Schema: public; Owner: vbeaure
--

GRANT ALL ON FUNCTION public.width_km() TO read_only_all;
GRANT ALL ON FUNCTION public.width_km() TO read_write_all;


--
-- Name: FUNCTION taxa_branch_tips(integer); Type: ACL; Schema: api; Owner: vbeaure
--

GRANT ALL ON FUNCTION api.taxa_branch_tips(integer) TO read_only_all;
GRANT ALL ON FUNCTION api.taxa_branch_tips(integer) TO read_write_all;
GRANT ALL ON FUNCTION api.taxa_branch_tips(integer) TO read_only_public;


--
-- Name: TABLE bird_cadre_eco_counts; Type: ACL; Schema: api; Owner: postgres
--

GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO PUBLIC;
GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.bird_cadre_eco_counts TO read_write_all;
GRANT SELECT ON TABLE api.bird_cadre_eco_counts TO read_only_public;


--
-- Name: TABLE datasets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.datasets TO admins;
GRANT ALL ON TABLE public.datasets TO coleo;
GRANT SELECT ON TABLE public.datasets TO read_only_all;
GRANT ALL ON TABLE public.datasets TO read_write_all;
GRANT SELECT ON TABLE public.datasets TO PUBLIC;


--
-- Name: TABLE bird_sampling_points; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.bird_sampling_points TO PUBLIC;
GRANT SELECT ON TABLE api.bird_sampling_points TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.bird_sampling_points TO read_write_all;
GRANT SELECT ON TABLE api.bird_sampling_points TO read_only_public;


--
-- Name: TABLE bird_sampling_observations_lookup; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.bird_sampling_observations_lookup TO PUBLIC;
GRANT SELECT ON TABLE api.bird_sampling_observations_lookup TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.bird_sampling_observations_lookup TO read_write_all;
GRANT SELECT ON TABLE api.bird_sampling_observations_lookup TO read_only_public;


--
-- Name: TABLE variables; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.variables TO coleo;
GRANT ALL ON TABLE public.variables TO admins;
GRANT SELECT ON TABLE public.variables TO read_only_all;
GRANT ALL ON TABLE public.variables TO read_write_all;
GRANT SELECT ON TABLE public.variables TO PUBLIC;


--
-- Name: TABLE observations; Type: ACL; Schema: api; Owner: postgres
--

GRANT SELECT ON TABLE api.observations TO PUBLIC;
GRANT SELECT ON TABLE api.observations TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.observations TO read_write_all;
GRANT SELECT ON TABLE api.observations TO read_only_public;


--
-- Name: TABLE regions; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.regions TO PUBLIC;
GRANT SELECT ON TABLE public.regions TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.regions TO read_write_all;


--
-- Name: TABLE observations_regions; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.observations_regions TO PUBLIC;
GRANT SELECT ON TABLE api.observations_regions TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.observations_regions TO read_write_all;
GRANT SELECT ON TABLE api.observations_regions TO read_only_public;


--
-- Name: TABLE taxa_groups; Type: ACL; Schema: api; Owner: vbeaure
--

GRANT SELECT ON TABLE api.taxa_groups TO PUBLIC;
GRANT SELECT ON TABLE api.taxa_groups TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.taxa_groups TO read_write_all;
GRANT SELECT ON TABLE api.taxa_groups TO read_only_public;


--
-- Name: TABLE time_series; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.time_series TO admins;
GRANT ALL ON TABLE public.time_series TO coleo;
GRANT SELECT ON TABLE public.time_series TO read_only_all;
GRANT ALL ON TABLE public.time_series TO read_write_all;
GRANT SELECT ON TABLE public.time_series TO PUBLIC;


--
-- Name: TABLE time_series; Type: ACL; Schema: api; Owner: postgres
--

GRANT SELECT ON TABLE api.time_series TO PUBLIC;
GRANT SELECT ON TABLE api.time_series TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE api.time_series TO read_write_all;
GRANT SELECT ON TABLE api.time_series TO read_only_public;


--
-- Name: TABLE obs_region_counts; Type: ACL; Schema: atlas_api; Owner: postgres
--

GRANT SELECT ON TABLE atlas_api.obs_region_counts TO read_only_all;
GRANT SELECT ON TABLE atlas_api.obs_region_counts TO read_only_public;


--
-- Name: TABLE obs_regions_taxa_datasets_counts; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.obs_regions_taxa_datasets_counts TO read_only_all;
GRANT SELECT ON TABLE atlas_api.obs_regions_taxa_datasets_counts TO read_only_public;


--
-- Name: TABLE regions_zoom_lookup; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.regions_zoom_lookup TO read_only_public;
GRANT SELECT ON TABLE atlas_api.regions_zoom_lookup TO read_only_all;


--
-- Name: TABLE region_types; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.region_types TO read_only_public;
GRANT SELECT ON TABLE atlas_api.region_types TO read_only_all;


--
-- Name: TABLE sensitive_taxa_max_scale; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.sensitive_taxa_max_scale TO read_only_public;
GRANT SELECT ON TABLE atlas_api.sensitive_taxa_max_scale TO read_only_all;


--
-- Name: TABLE temp_obs_region_counts; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.temp_obs_region_counts TO read_only_all;
GRANT SELECT ON TABLE atlas_api.temp_obs_region_counts TO read_only_public;


--
-- Name: TABLE temp_obs_regions_taxa_year_counts; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.temp_obs_regions_taxa_year_counts TO read_only_all;
GRANT SELECT ON TABLE atlas_api.temp_obs_regions_taxa_year_counts TO read_only_public;


--
-- Name: TABLE web_regions; Type: ACL; Schema: atlas_api; Owner: vbeaure
--

GRANT SELECT ON TABLE atlas_api.web_regions TO read_only_all;
GRANT SELECT ON TABLE atlas_api.web_regions TO read_only_public;


--
-- Name: TABLE api_keys; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.api_keys TO admins;
GRANT SELECT ON TABLE public.api_keys TO read_only_all;
GRANT ALL ON TABLE public.api_keys TO read_write_all;
GRANT SELECT ON TABLE public.api_keys TO PUBLIC;


--
-- Name: SEQUENCE api_keys_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.api_keys_id_seq TO read_write_all;


--
-- Name: TABLE cdpnq_ranges; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.cdpnq_ranges TO PUBLIC;
GRANT SELECT ON TABLE public.cdpnq_ranges TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.cdpnq_ranges TO read_write_all;


--
-- Name: SEQUENCE cdpnq_ranges_id_seq; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT USAGE ON SEQUENCE public.cdpnq_ranges_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.cdpnq_ranges_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.cdpnq_ranges_id_seq TO read_write_all;


--
-- Name: SEQUENCE datasets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.datasets_id_seq TO read_write_all;


--
-- Name: TABLE efforts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.efforts TO coleo;
GRANT ALL ON TABLE public.efforts TO admins;
GRANT SELECT ON TABLE public.efforts TO read_only_all;
GRANT ALL ON TABLE public.efforts TO read_write_all;
GRANT SELECT ON TABLE public.efforts TO PUBLIC;


--
-- Name: SEQUENCE efforts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.efforts_id_seq TO read_write_all;


--
-- Name: TABLE generated_tables_metadata; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.generated_tables_metadata TO PUBLIC;
GRANT SELECT ON TABLE public.generated_tables_metadata TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.generated_tables_metadata TO read_write_all;


--
-- Name: SEQUENCE generated_tables_metadata_id_seq; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT USAGE ON SEQUENCE public.generated_tables_metadata_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.generated_tables_metadata_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.generated_tables_metadata_id_seq TO read_write_all;


--
-- Name: TABLE mat_view_dependencies; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.mat_view_dependencies TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mat_view_dependencies TO read_write_all;


--
-- Name: TABLE mat_view_refresh_order; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.mat_view_refresh_order TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.mat_view_refresh_order TO read_write_all;


--
-- Name: TABLE montreal_terrestrial_limits; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.montreal_terrestrial_limits TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.montreal_terrestrial_limits TO read_write_all;
GRANT SELECT ON TABLE public.montreal_terrestrial_limits TO PUBLIC;


--
-- Name: SEQUENCE montreal_terrestrial_limits_ogc_fid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT USAGE ON SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq TO read_write_all;
GRANT USAGE ON SEQUENCE public.montreal_terrestrial_limits_ogc_fid_seq TO read_only_public;


--
-- Name: TABLE obs_efforts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.obs_efforts TO coleo;
GRANT ALL ON TABLE public.obs_efforts TO admins;
GRANT SELECT ON TABLE public.obs_efforts TO read_only_all;
GRANT ALL ON TABLE public.obs_efforts TO read_write_all;
GRANT SELECT ON TABLE public.obs_efforts TO PUBLIC;


--
-- Name: TABLE observations_qc; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.observations_qc TO PUBLIC;
GRANT SELECT ON TABLE public.observations_qc TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.observations_qc TO read_write_all;


--
-- Name: TABLE qc_limit; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.qc_limit TO PUBLIC;
GRANT SELECT ON TABLE public.qc_limit TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.qc_limit TO read_write_all;


--
-- Name: TABLE qc_region_limit; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.qc_region_limit TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.qc_region_limit TO read_write_all;
GRANT SELECT ON TABLE public.qc_region_limit TO PUBLIC;


--
-- Name: SEQUENCE qc_region_limit_ogc_fid_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT USAGE ON SEQUENCE public.qc_region_limit_ogc_fid_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.qc_region_limit_ogc_fid_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.qc_region_limit_ogc_fid_seq TO read_write_all;
GRANT USAGE ON SEQUENCE public.qc_region_limit_ogc_fid_seq TO read_only_public;


--
-- Name: SEQUENCE regions_fid_seq; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT USAGE ON SEQUENCE public.regions_fid_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.regions_fid_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.regions_fid_seq TO read_write_all;


--
-- Name: TABLE taxa; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.taxa TO admins;
GRANT ALL ON TABLE public.taxa TO coleo;
GRANT SELECT ON TABLE public.taxa TO read_only_all;
GRANT ALL ON TABLE public.taxa TO read_write_all;
GRANT SELECT ON TABLE public.taxa TO PUBLIC;


--
-- Name: SEQUENCE taxa_groups_id_seq; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT USAGE ON SEQUENCE public.taxa_groups_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.taxa_groups_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.taxa_groups_id_seq TO read_write_all;


--
-- Name: SEQUENCE taxa_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.taxa_id_seq TO read_write_all;


--
-- Name: SEQUENCE taxa_obs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT USAGE ON SEQUENCE public.taxa_obs_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.taxa_obs_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.taxa_obs_id_seq TO read_write_all;
GRANT USAGE ON SEQUENCE public.taxa_obs_id_seq TO read_only_public;


--
-- Name: TABLE taxa_obs_synonym_lookup; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.taxa_obs_synonym_lookup TO PUBLIC;
GRANT SELECT ON TABLE public.taxa_obs_synonym_lookup TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxa_obs_synonym_lookup TO read_write_all;


--
-- Name: SEQUENCE taxa_ref_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT USAGE ON SEQUENCE public.taxa_ref_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.taxa_ref_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.taxa_ref_id_seq TO read_write_all;
GRANT USAGE ON SEQUENCE public.taxa_ref_id_seq TO read_only_public;


--
-- Name: SEQUENCE taxa_vernacular_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT USAGE ON SEQUENCE public.taxa_vernacular_id_seq TO PUBLIC;
GRANT USAGE ON SEQUENCE public.taxa_vernacular_id_seq TO read_only_all;
GRANT ALL ON SEQUENCE public.taxa_vernacular_id_seq TO read_write_all;
GRANT USAGE ON SEQUENCE public.taxa_vernacular_id_seq TO read_only_public;


--
-- Name: TABLE time_series_from_obs; Type: ACL; Schema: public; Owner: vbeaure
--

GRANT SELECT ON TABLE public.time_series_from_obs TO PUBLIC;
GRANT SELECT ON TABLE public.time_series_from_obs TO read_only_all;
GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLE public.time_series_from_obs TO read_write_all;


--
-- Name: SEQUENCE time_series_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.time_series_id_seq TO read_write_all;


--
-- Name: TABLE tmpc; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.tmpc TO read_only_all;
GRANT ALL ON TABLE public.tmpc TO read_write_all;
GRANT SELECT ON TABLE public.tmpc TO PUBLIC;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO admins;
GRANT SELECT ON TABLE public.users TO read_only_all;
GRANT ALL ON TABLE public.users TO read_write_all;
GRANT SELECT ON TABLE public.users TO PUBLIC;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO read_write_all;


--
-- Name: SEQUENCE variables_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.variables_id_seq TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: api; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: api; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: api; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: api; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT USAGE ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: api; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: api; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: api; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: api; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: api; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: api; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: api; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: api; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA api GRANT SELECT ON TABLES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: atlas_api; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA atlas_api GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA atlas_api GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: atlas_api; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA atlas_api GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA atlas_api GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: atlas_api; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA atlas_api GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA atlas_api GRANT SELECT ON TABLES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: atlas_api; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA atlas_api GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA atlas_api GRANT SELECT ON TABLES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: observations_partitions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT USAGE ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: observations_partitions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: observations_partitions; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA observations_partitions GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: coleo
--

ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT USAGE ON SEQUENCES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT USAGE ON SEQUENCES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT ALL ON SEQUENCES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: coleo
--

ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_write_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_public;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT ALL ON FUNCTIONS  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT ALL ON FUNCTIONS  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: coleo
--

ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE coleo IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: will
--

ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE will IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: vbeaure
--

ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT SELECT ON TABLES  TO PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE vbeaure IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cabw2601
--

ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE cabw2601 IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO read_only_all;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,REFERENCES,TRIGGER,TRUNCATE,UPDATE ON TABLES  TO read_write_all;


--
-- PostgreSQL database dump complete
--

