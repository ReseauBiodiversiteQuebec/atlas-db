--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.24
-- Dumped by pg_dump version 9.5.24

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: enum_datasets_type_obs; Type: TYPE; Schema: public; Owner: coleo
--

CREATE TYPE public.enum_datasets_type_obs AS ENUM (
    'living specimen',
    'preserved specimen',
    'fossil specimen',
    'human observation',
    'machine observation',
    'literature'
);


ALTER TYPE public.enum_datasets_type_obs OWNER TO coleo;

--
-- Name: enum_taxa_family; Type: TYPE; Schema: public; Owner: coleo
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


ALTER TYPE public.enum_taxa_family OWNER TO coleo;

--
-- Name: enum_taxa_qc_status; Type: TYPE; Schema: public; Owner: coleo
--

CREATE TYPE public.enum_taxa_qc_status AS ENUM (
    'Menacée',
    'Susceptible',
    'Vulnérable',
    'Vulnérable à la récolte'
);


ALTER TYPE public.enum_taxa_qc_status OWNER TO coleo;

--
-- Name: enum_taxa_rank; Type: TYPE; Schema: public; Owner: coleo
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


ALTER TYPE public.enum_taxa_rank OWNER TO coleo;

--
-- Name: enum_taxa_sp_group; Type: TYPE; Schema: public; Owner: coleo
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


ALTER TYPE public.enum_taxa_sp_group OWNER TO coleo;

--
-- Name: enum_taxa_species_gr; Type: TYPE; Schema: public; Owner: coleo
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


ALTER TYPE public.enum_taxa_species_gr OWNER TO coleo;

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
-- Name: groups; Type: TYPE; Schema: public; Owner: belv1601
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


ALTER TYPE public.groups OWNER TO belv1601;

--
-- Name: groups_sp; Type: TYPE; Schema: public; Owner: belv1601
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


ALTER TYPE public.groups_sp OWNER TO belv1601;

--
-- Name: levels; Type: TYPE; Schema: public; Owner: belv1601
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


ALTER TYPE public.levels OWNER TO belv1601;

--
-- Name: qc; Type: TYPE; Schema: public; Owner: belv1601
--

CREATE TYPE public.qc AS ENUM (
    'Menacée',
    'Susceptible',
    'Vulnérable',
    'Vulnérable à la récolte'
);


ALTER TYPE public.qc OWNER TO belv1601;

--
-- Name: ranks; Type: TYPE; Schema: public; Owner: belv1601
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


ALTER TYPE public.ranks OWNER TO belv1601;

--
-- Name: sp_categories; Type: TYPE; Schema: public; Owner: belv1601
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


ALTER TYPE public.sp_categories OWNER TO belv1601;

--
-- Name: type_observation; Type: TYPE; Schema: public; Owner: belv1601
--

CREATE TYPE public.type_observation AS ENUM (
    'living specimen',
    'preserved specimen',
    'fossil specimen',
    'human observation',
    'machine observation',
    'literature',
    'material sample',
    'others'
);


ALTER TYPE public.type_observation OWNER TO belv1601;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: coleo
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.api_keys OWNER TO coleo;

--
-- Name: COLUMN api_keys.token; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.api_keys.token IS 'token used by a user';


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: coleo
--

CREATE SEQUENCE public.api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.api_keys_id_seq OWNER TO coleo;

--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coleo
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: belv1601
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
    centroid boolean DEFAULT false
);


ALTER TABLE public.datasets OWNER TO belv1601;

--
-- Name: datasets_id_seq; Type: SEQUENCE; Schema: public; Owner: belv1601
--

CREATE SEQUENCE public.datasets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.datasets_id_seq OWNER TO belv1601;

--
-- Name: datasets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: belv1601
--

ALTER SEQUENCE public.datasets_id_seq OWNED BY public.datasets.id;


--
-- Name: efforts; Type: TABLE; Schema: public; Owner: belv1601
--

CREATE TABLE public.efforts (
    id integer NOT NULL,
    id_variables integer NOT NULL,
    effort_value numeric NOT NULL
);


ALTER TABLE public.efforts OWNER TO belv1601;

--
-- Name: efforts_id_seq; Type: SEQUENCE; Schema: public; Owner: belv1601
--

CREATE SEQUENCE public.efforts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.efforts_id_seq OWNER TO belv1601;

--
-- Name: efforts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: belv1601
--

ALTER SEQUENCE public.efforts_id_seq OWNED BY public.efforts.id;


--
-- Name: hexquebec100km; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hexquebec100km (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hexquebec100km OWNER TO postgres;

--
-- Name: observations; Type: TABLE; Schema: public; Owner: belv1601
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
    id_taxa integer NOT NULL,
    id_variables integer NOT NULL,
    obs_value numeric NOT NULL,
    issue character varying
);


ALTER TABLE public.observations OWNER TO belv1601;

--
-- Name: observations_qc; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.observations_qc AS
 SELECT o.id,
    o.org_parent_event,
    o.org_event,
    o.org_id_obs,
    o.id_datasets,
    o.geom,
    o.year_obs,
    o.month_obs,
    o.day_obs,
    o.time_obs,
    o.id_taxa,
    o.id_variables,
    o.obs_value,
    o.issue
   FROM public.observations o,
    public.hexquebec100km h
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.observations_qc OWNER TO postgres;

--
-- Name: hex_100_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_100_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hexquebec100km h,
    public.observations_qc o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_100_obs_lookup OWNER TO postgres;

--
-- Name: taxa; Type: TABLE; Schema: public; Owner: belv1601
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


ALTER TABLE public.taxa OWNER TO belv1601;

--
-- Name: COLUMN taxa.rank; Type: COMMENT; Schema: public; Owner: belv1601
--

COMMENT ON COLUMN public.taxa.rank IS 'Site location';


--
-- Name: hex_100_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_100_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_100_summary_all OWNER TO postgres;

--
-- Name: hex_100_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_100_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_100_summary_group OWNER TO postgres;

--
-- Name: hexquebec10km; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hexquebec10km (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hexquebec10km OWNER TO postgres;

--
-- Name: hex_10_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_10_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hexquebec10km h,
    public.observations_qc o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_10_obs_lookup OWNER TO postgres;

--
-- Name: hex_10_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_10_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_10_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_10_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_10_summary_all OWNER TO postgres;

--
-- Name: hex_10_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_10_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_10_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_10_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_10_summary_group OWNER TO postgres;

--
-- Name: hexquebec20km; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hexquebec20km (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hexquebec20km OWNER TO postgres;

--
-- Name: hex_20_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_20_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hexquebec20km h,
    public.observations_qc o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_20_obs_lookup OWNER TO postgres;

--
-- Name: hex_20_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_20_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_20_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_20_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_20_summary_all OWNER TO postgres;

--
-- Name: hex_20_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_20_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_20_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_20_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_20_summary_group OWNER TO postgres;

--
-- Name: hex_250_na; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hex_250_na (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hex_250_na OWNER TO postgres;

--
-- Name: hex_250_na_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hex_250_na_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hex_250_na_ogc_fid_seq OWNER TO postgres;

--
-- Name: hex_250_na_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hex_250_na_ogc_fid_seq OWNED BY public.hex_250_na.ogc_fid;


--
-- Name: hex_250_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_250_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hex_250_na h,
    public.observations o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_250_obs_lookup OWNER TO postgres;

--
-- Name: hex_250_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_250_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations o,
            public.hex_250_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations o,
            public.hex_250_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_250_summary_all OWNER TO postgres;

--
-- Name: hex_250_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_250_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations o,
            public.hex_250_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations o,
            public.hex_250_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_250_summary_group OWNER TO postgres;

--
-- Name: hexquebec50km; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hexquebec50km (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hexquebec50km OWNER TO postgres;

--
-- Name: hex_50_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_50_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hexquebec50km h,
    public.observations_qc o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_50_obs_lookup OWNER TO postgres;

--
-- Name: hex_50_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_50_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_50_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_50_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_50_summary_all OWNER TO postgres;

--
-- Name: hex_50_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_50_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_50_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_50_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_50_summary_group OWNER TO postgres;

--
-- Name: hexquebec5km; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hexquebec5km (
    ogc_fid integer NOT NULL,
    fid numeric(11,0),
    geom public.geometry(Polygon,4326),
    centroid public.geometry(Point)
);


ALTER TABLE public.hexquebec5km OWNER TO postgres;

--
-- Name: hex_5_obs_lookup; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_5_obs_lookup AS
 SELECT h.fid,
    o.id
   FROM public.hexquebec5km h,
    public.observations_qc o
  WHERE public.st_within(o.geom, h.geom)
  WITH NO DATA;


ALTER TABLE public.hex_5_obs_lookup OWNER TO postgres;

--
-- Name: hex_5_summary_all; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_5_summary_all AS
 SELECT a.fid,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_5_obs_lookup h
          WHERE (o.id = h.id)
          GROUP BY h.fid) a
     LEFT JOIN ( SELECT h.fid,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_5_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid) b ON ((a.fid = b.fid)))
  WITH NO DATA;


ALTER TABLE public.hex_5_summary_all OWNER TO postgres;

--
-- Name: hex_5_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.hex_5_summary_group AS
 SELECT a.fid,
    a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_5_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY h.fid, t.species_gr) a
     LEFT JOIN ( SELECT h.fid,
            t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_5_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY h.fid, t.species_gr) b ON (((a.fid = b.fid) AND (a.species_gr = b.species_gr))))
  WITH NO DATA;


ALTER TABLE public.hex_5_summary_group OWNER TO postgres;

--
-- Name: hexquebec100km_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hexquebec100km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hexquebec100km_ogc_fid_seq OWNER TO postgres;

--
-- Name: hexquebec100km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hexquebec100km_ogc_fid_seq OWNED BY public.hexquebec100km.ogc_fid;


--
-- Name: hexquebec10km_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hexquebec10km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hexquebec10km_ogc_fid_seq OWNER TO postgres;

--
-- Name: hexquebec10km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hexquebec10km_ogc_fid_seq OWNED BY public.hexquebec10km.ogc_fid;


--
-- Name: hexquebec20km_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hexquebec20km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hexquebec20km_ogc_fid_seq OWNER TO postgres;

--
-- Name: hexquebec20km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hexquebec20km_ogc_fid_seq OWNED BY public.hexquebec20km.ogc_fid;


--
-- Name: hexquebec50km_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hexquebec50km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hexquebec50km_ogc_fid_seq OWNER TO postgres;

--
-- Name: hexquebec50km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hexquebec50km_ogc_fid_seq OWNED BY public.hexquebec50km.ogc_fid;


--
-- Name: hexquebec5km_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hexquebec5km_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hexquebec5km_ogc_fid_seq OWNER TO postgres;

--
-- Name: hexquebec5km_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hexquebec5km_ogc_fid_seq OWNED BY public.hexquebec5km.ogc_fid;


--
-- Name: obs_efforts; Type: TABLE; Schema: public; Owner: belv1601
--

CREATE TABLE public.obs_efforts (
    id_obs bigint NOT NULL,
    id_efforts integer NOT NULL
);


ALTER TABLE public.obs_efforts OWNER TO belv1601;

--
-- Name: observations_id_seq; Type: SEQUENCE; Schema: public; Owner: belv1601
--

CREATE SEQUENCE public.observations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.observations_id_seq OWNER TO belv1601;

--
-- Name: observations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: belv1601
--

ALTER SEQUENCE public.observations_id_seq OWNED BY public.observations.id;


--
-- Name: public.taxa; Type: TABLE; Schema: public; Owner: belv1601
--

CREATE TABLE public."public.taxa" (
    scientific_name text,
    level text,
    valid boolean,
    gbif integer,
    tsn integer,
    ncbi integer,
    col text,
    bold integer,
    eol integer,
    group_sp text,
    family text
);


ALTER TABLE public."public.taxa" OWNER TO belv1601;

--
-- Name: quebec_total_summary_group; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.quebec_total_summary_group AS
 SELECT a.species_gr,
    a.n_obs,
    b.n_species
   FROM (( SELECT t.species_gr,
            count(DISTINCT o.id) AS n_obs
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id))
          GROUP BY t.species_gr) a
     LEFT JOIN ( SELECT t.species_gr,
            count(DISTINCT o.id_taxa) AS n_species
           FROM public.observations_qc o,
            public.hex_100_obs_lookup h,
            public.taxa t
          WHERE ((o.id = h.id) AND (o.id_taxa = t.id) AND (t.rank = 'species'::public.ranks))
          GROUP BY t.species_gr) b ON ((a.species_gr = b.species_gr)))
  WITH NO DATA;


ALTER TABLE public.quebec_total_summary_group OWNER TO postgres;

--
-- Name: summary_datasets_observations; Type: MATERIALIZED VIEW; Schema: public; Owner: admins
--

CREATE MATERIALIZED VIEW public.summary_datasets_observations AS
 SELECT d.title AS dataset,
    sum(a.count_observations) AS count_observations,
    count(DISTINCT t.scientific_name) AS count_species,
    min(a.first_year) AS first_year,
    max(a.last_year) AS last_year,
    string_agg(DISTINCT ((t.species_gr)::character varying)::text, ','::text) AS taxa
   FROM ((( SELECT o.id_datasets,
            o.id_taxa,
            count(o.id) AS count_observations,
            min(o.year_obs) AS first_year,
            max(o.year_obs) AS last_year
           FROM public.observations o
          GROUP BY o.id_datasets, o.id_taxa) a
     LEFT JOIN public.datasets d ON ((a.id_datasets = d.id)))
     LEFT JOIN public.taxa t ON ((a.id_taxa = t.id)))
  GROUP BY d.title
  WITH NO DATA;


ALTER TABLE public.summary_datasets_observations OWNER TO admins;

--
-- Name: taxa_id_seq; Type: SEQUENCE; Schema: public; Owner: belv1601
--

CREATE SEQUENCE public.taxa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taxa_id_seq OWNER TO belv1601;

--
-- Name: taxa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: belv1601
--

ALTER SEQUENCE public.taxa_id_seq OWNED BY public.taxa.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: coleo
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


ALTER TABLE public.users OWNER TO coleo;

--
-- Name: COLUMN users.name; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.name IS 'Nom de l''utilisateur';


--
-- Name: COLUMN users.lastname; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.lastname IS 'Prénom de l''utilisateur';


--
-- Name: COLUMN users.email; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.email IS 'Adresse courriel de l''utilisateur';


--
-- Name: COLUMN users.role; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.role IS 'role de l''utilisateur';


--
-- Name: COLUMN users.organization; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.organization IS 'Organisme d''attache de l''utilisateur';


--
-- Name: COLUMN users.password; Type: COMMENT; Schema: public; Owner: coleo
--

COMMENT ON COLUMN public.users.password IS 'Mot de passe de l''utilisateur';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: coleo
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO coleo;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: coleo
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: variables; Type: TABLE; Schema: public; Owner: belv1601
--

CREATE TABLE public.variables (
    id integer NOT NULL,
    name character varying NOT NULL,
    unit character varying,
    description text
);


ALTER TABLE public.variables OWNER TO belv1601;

--
-- Name: COLUMN variables.unit; Type: COMMENT; Schema: public; Owner: belv1601
--

COMMENT ON COLUMN public.variables.unit IS 'Site location';


--
-- Name: variables_id_seq; Type: SEQUENCE; Schema: public; Owner: belv1601
--

CREATE SEQUENCE public.variables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.variables_id_seq OWNER TO belv1601;

--
-- Name: variables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: belv1601
--

ALTER SEQUENCE public.variables_id_seq OWNED BY public.variables.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.api_keys ALTER COLUMN id SET DEFAULT nextval('public.api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id SET DEFAULT nextval('public.datasets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.efforts ALTER COLUMN id SET DEFAULT nextval('public.efforts_id_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hex_250_na ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hex_250_na_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec100km ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hexquebec100km_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec10km ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hexquebec10km_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec20km ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hexquebec20km_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec50km ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hexquebec50km_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec5km ALTER COLUMN ogc_fid SET DEFAULT nextval('public.hexquebec5km_ogc_fid_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations ALTER COLUMN id SET DEFAULT nextval('public.observations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.taxa ALTER COLUMN id SET DEFAULT nextval('public.taxa_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.variables ALTER COLUMN id SET DEFAULT nextval('public.variables_id_seq'::regclass);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: api_keys_token_key; Type: CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_token_key UNIQUE (token);


--
-- Name: datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id);


--
-- Name: efforts_id_variables_effort_value_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_id_variables_effort_value_key UNIQUE (id_variables, effort_value);


--
-- Name: efforts_pkey; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_pkey PRIMARY KEY (id);


--
-- Name: hex_250_na_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hex_250_na
    ADD CONSTRAINT hex_250_na_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hexquebec100km_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec100km
    ADD CONSTRAINT hexquebec100km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hexquebec10km_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec10km
    ADD CONSTRAINT hexquebec10km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hexquebec20km_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec20km
    ADD CONSTRAINT hexquebec20km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hexquebec50km_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec50km
    ADD CONSTRAINT hexquebec50km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: hexquebec5km_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hexquebec5km
    ADD CONSTRAINT hexquebec5km_pkey PRIMARY KEY (ogc_fid);


--
-- Name: obs_efforts_id_obs_id_efforts_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.obs_efforts
    ADD CONSTRAINT obs_efforts_id_obs_id_efforts_key UNIQUE (id_obs, id_efforts);


--
-- Name: observations_pkey; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id);


--
-- Name: observations_unique_rows; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_unique_rows UNIQUE (id_datasets, org_parent_event, org_event, org_id_obs, geom, year_obs, month_obs, day_obs, time_obs, id_taxa, id_variables, obs_value);


--
-- Name: taxa_col_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_col_key UNIQUE (col);


--
-- Name: taxa_gbif_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_gbif_key UNIQUE (gbif);


--
-- Name: taxa_pkey; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_pkey PRIMARY KEY (id);


--
-- Name: taxa_scientific_name_authorship_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.taxa
    ADD CONSTRAINT taxa_scientific_name_authorship_key UNIQUE (scientific_name, authorship);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_name_lastname_key; Type: CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_name_lastname_key UNIQUE (name, lastname);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: variables_name_unit_key; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_name_unit_key UNIQUE (name, unit);


--
-- Name: variables_pkey; Type: CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (id);


--
-- Name: hex100_centroid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex100_centroid_idx ON public.hexquebec100km USING gist (centroid);


--
-- Name: hex100_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex100_geom_idx ON public.hexquebec100km USING gist (geom);


--
-- Name: hex10_centroid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex10_centroid_idx ON public.hexquebec10km USING gist (centroid);


--
-- Name: hex10_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex10_geom_idx ON public.hexquebec10km USING gist (geom);


--
-- Name: hex20_centroid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex20_centroid_idx ON public.hexquebec20km USING gist (centroid);


--
-- Name: hex250_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex250_geom_idx ON public.hex_250_na USING gist (geom);


--
-- Name: hex50_centroid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex50_centroid_idx ON public.hexquebec50km USING gist (centroid);


--
-- Name: hex50_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex50_geom_idx ON public.hexquebec50km USING gist (geom);


--
-- Name: hex5_centroid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex5_centroid_idx ON public.hexquebec5km USING gist (centroid);


--
-- Name: hex5_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex5_geom_idx ON public.hexquebec5km USING gist (geom);


--
-- Name: hex_100_summary_all_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_100_summary_all_id ON public.hex_100_summary_all USING btree (fid);


--
-- Name: hex_10_summary_all_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_10_summary_all_id ON public.hex_10_summary_all USING btree (fid);


--
-- Name: hex_20_summary_all_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_20_summary_all_id ON public.hex_20_summary_all USING btree (fid);


--
-- Name: hex_250_na_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_250_na_wkb_geometry_geom_idx ON public.hex_250_na USING gist (geom);


--
-- Name: hex_50_summary_all_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_50_summary_all_id ON public.hex_50_summary_all USING btree (fid);


--
-- Name: hex_5_summary_all_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hex_5_summary_all_id ON public.hex_5_summary_all USING btree (fid);


--
-- Name: hexquebec100km_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hexquebec100km_wkb_geometry_geom_idx ON public.hexquebec100km USING gist (geom);


--
-- Name: hexquebec10km_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hexquebec10km_wkb_geometry_geom_idx ON public.hexquebec10km USING gist (geom);


--
-- Name: hexquebec20km_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hexquebec20km_wkb_geometry_geom_idx ON public.hexquebec20km USING gist (geom);


--
-- Name: hexquebec50km_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hexquebec50km_wkb_geometry_geom_idx ON public.hexquebec50km USING gist (geom);


--
-- Name: hexquebec5km_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX hexquebec5km_wkb_geometry_geom_idx ON public.hexquebec5km USING gist (geom);


--
-- Name: observations_geom_idx; Type: INDEX; Schema: public; Owner: belv1601
--

CREATE INDEX observations_geom_idx ON public.observations USING gist (geom);


--
-- Name: observations_id_datasets_id_taxa_idx; Type: INDEX; Schema: public; Owner: belv1601
--

CREATE INDEX observations_id_datasets_id_taxa_idx ON public.observations USING btree (id_datasets, id_taxa);


--
-- Name: observations_id_datasets_idx; Type: INDEX; Schema: public; Owner: belv1601
--

CREATE INDEX observations_id_datasets_idx ON public.observations USING btree (id_datasets);


--
-- Name: observations_qc_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_qc_geom_idx ON public.observations_qc USING gist (geom);


--
-- Name: observations_qc_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX observations_qc_id ON public.observations_qc USING btree (id);


--
-- Name: observations_year_obs_idx; Type: INDEX; Schema: public; Owner: belv1601
--

CREATE INDEX observations_year_obs_idx ON public.observations USING btree (year_obs);


--
-- Name: api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: coleo
--

ALTER TABLE ONLY public.api_keys
    ADD CONSTRAINT api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: efforts_id_variables_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.efforts
    ADD CONSTRAINT efforts_id_variables_fkey FOREIGN KEY (id_variables) REFERENCES public.variables(id);


--
-- Name: obs_efforts_id_efforts_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.obs_efforts
    ADD CONSTRAINT obs_efforts_id_efforts_fkey FOREIGN KEY (id_efforts) REFERENCES public.efforts(id);


--
-- Name: obs_efforts_id_obs_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.obs_efforts
    ADD CONSTRAINT obs_efforts_id_obs_fkey FOREIGN KEY (id_obs) REFERENCES public.observations(id);


--
-- Name: observations_id_datasets_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_id_datasets_fkey FOREIGN KEY (id_datasets) REFERENCES public.datasets(id);


--
-- Name: observations_id_taxa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_id_taxa_fkey FOREIGN KEY (id_taxa) REFERENCES public.taxa(id);


--
-- Name: observations_id_variables_fkey; Type: FK CONSTRAINT; Schema: public; Owner: belv1601
--

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_id_variables_fkey FOREIGN KEY (id_variables) REFERENCES public.variables(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: sviss
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM sviss;
GRANT ALL ON SCHEMA public TO sviss;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: TABLE api_keys; Type: ACL; Schema: public; Owner: coleo
--

REVOKE ALL ON TABLE public.api_keys FROM PUBLIC;
REVOKE ALL ON TABLE public.api_keys FROM coleo;
GRANT ALL ON TABLE public.api_keys TO coleo;
GRANT SELECT ON TABLE public.api_keys TO atlas_reader;


--
-- Name: SEQUENCE api_keys_id_seq; Type: ACL; Schema: public; Owner: coleo
--

REVOKE ALL ON SEQUENCE public.api_keys_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.api_keys_id_seq FROM coleo;
GRANT ALL ON SEQUENCE public.api_keys_id_seq TO coleo;
GRANT SELECT ON SEQUENCE public.api_keys_id_seq TO atlas_reader;


--
-- Name: TABLE datasets; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.datasets FROM PUBLIC;
REVOKE ALL ON TABLE public.datasets FROM belv1601;
GRANT ALL ON TABLE public.datasets TO belv1601;
GRANT SELECT ON TABLE public.datasets TO atlas_reader;
GRANT ALL ON TABLE public.datasets TO admins;


--
-- Name: SEQUENCE datasets_id_seq; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON SEQUENCE public.datasets_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.datasets_id_seq FROM belv1601;
GRANT ALL ON SEQUENCE public.datasets_id_seq TO belv1601;
GRANT SELECT ON SEQUENCE public.datasets_id_seq TO atlas_reader;


--
-- Name: TABLE efforts; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.efforts FROM PUBLIC;
REVOKE ALL ON TABLE public.efforts FROM belv1601;
GRANT ALL ON TABLE public.efforts TO belv1601;
GRANT SELECT ON TABLE public.efforts TO atlas_reader;


--
-- Name: SEQUENCE efforts_id_seq; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON SEQUENCE public.efforts_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.efforts_id_seq FROM belv1601;
GRANT ALL ON SEQUENCE public.efforts_id_seq TO belv1601;
GRANT SELECT ON SEQUENCE public.efforts_id_seq TO atlas_reader;


--
-- Name: TABLE observations; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.observations FROM PUBLIC;
REVOKE ALL ON TABLE public.observations FROM belv1601;
GRANT ALL ON TABLE public.observations TO belv1601;
GRANT SELECT ON TABLE public.observations TO atlas_reader;
GRANT ALL ON TABLE public.observations TO admins;


--
-- Name: TABLE observations_qc; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE public.observations_qc FROM PUBLIC;
REVOKE ALL ON TABLE public.observations_qc FROM postgres;
GRANT ALL ON TABLE public.observations_qc TO postgres;
GRANT ALL ON TABLE public.observations_qc TO admins;


--
-- Name: TABLE taxa; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.taxa FROM PUBLIC;
REVOKE ALL ON TABLE public.taxa FROM belv1601;
GRANT ALL ON TABLE public.taxa TO belv1601;
GRANT SELECT ON TABLE public.taxa TO atlas_reader;
GRANT ALL ON TABLE public.taxa TO admins;


--
-- Name: TABLE obs_efforts; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.obs_efforts FROM PUBLIC;
REVOKE ALL ON TABLE public.obs_efforts FROM belv1601;
GRANT ALL ON TABLE public.obs_efforts TO belv1601;
GRANT SELECT ON TABLE public.obs_efforts TO atlas_reader;


--
-- Name: SEQUENCE observations_id_seq; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON SEQUENCE public.observations_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.observations_id_seq FROM belv1601;
GRANT ALL ON SEQUENCE public.observations_id_seq TO belv1601;
GRANT SELECT ON SEQUENCE public.observations_id_seq TO atlas_reader;


--
-- Name: TABLE "public.taxa"; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public."public.taxa" FROM PUBLIC;
REVOKE ALL ON TABLE public."public.taxa" FROM belv1601;
GRANT ALL ON TABLE public."public.taxa" TO belv1601;
GRANT ALL ON TABLE public."public.taxa" TO coleo;
GRANT SELECT ON TABLE public."public.taxa" TO atlas_reader;


--
-- Name: TABLE summary_datasets_observations; Type: ACL; Schema: public; Owner: admins
--

REVOKE ALL ON TABLE public.summary_datasets_observations FROM PUBLIC;
REVOKE ALL ON TABLE public.summary_datasets_observations FROM admins;
GRANT ALL ON TABLE public.summary_datasets_observations TO admins;
GRANT ALL ON TABLE public.summary_datasets_observations TO belv1601;


--
-- Name: SEQUENCE taxa_id_seq; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON SEQUENCE public.taxa_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.taxa_id_seq FROM belv1601;
GRANT ALL ON SEQUENCE public.taxa_id_seq TO belv1601;
GRANT SELECT ON SEQUENCE public.taxa_id_seq TO atlas_reader;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: coleo
--

REVOKE ALL ON TABLE public.users FROM PUBLIC;
REVOKE ALL ON TABLE public.users FROM coleo;
GRANT ALL ON TABLE public.users TO coleo;
GRANT SELECT ON TABLE public.users TO atlas_reader;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: coleo
--

REVOKE ALL ON SEQUENCE public.users_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.users_id_seq FROM coleo;
GRANT ALL ON SEQUENCE public.users_id_seq TO coleo;
GRANT SELECT ON SEQUENCE public.users_id_seq TO atlas_reader;


--
-- Name: TABLE variables; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON TABLE public.variables FROM PUBLIC;
REVOKE ALL ON TABLE public.variables FROM belv1601;
GRANT ALL ON TABLE public.variables TO belv1601;
GRANT SELECT ON TABLE public.variables TO atlas_reader;


--
-- Name: SEQUENCE variables_id_seq; Type: ACL; Schema: public; Owner: belv1601
--

REVOKE ALL ON SEQUENCE public.variables_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE public.variables_id_seq FROM belv1601;
GRANT ALL ON SEQUENCE public.variables_id_seq TO belv1601;
GRANT SELECT ON SEQUENCE public.variables_id_seq TO atlas_reader;


--
-- PostgreSQL database dump complete
--

