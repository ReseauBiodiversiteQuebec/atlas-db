--
-- Taxa group resoucres creation
--


DROP TABLE IF EXISTS public.taxa_groups CASCADE;
CREATE TABLE public.taxa_groups (
    id serial primary key,
    vernacular_fr text,
    vernacular_en text,
    level integer
);

DROP TABLE IF EXISTS public.taxa_group_members CASCADE;
CREATE TABLE public.taxa_group_members (
    id_group serial,
    scientific_name text
);

--
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4 (Debian 13.4-4.pgdg100+1)
-- Dumped by pg_dump version 13.3

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
-- Data for Name: taxa_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxa_groups (id, vernacular_fr, vernacular_en, level) FROM stdin;
1	Amphibiens	Amphibians	1
2	Oiseaux	Birds	1
3	Mammifères	Mammals	1
4	Reptiles	Reptiles	1
5	Poissons	Fish	1
6	Tuniciers	Tunicates	1
7	Céphalocordés	Lancelets	1
8	Arthropodes	Arthropods	1
9	Autres invertébrés	Other invertebrates	1
10	Autres taxons	Other taxons	1
11	Mycètes	Fungi	1
12	Angiospermes	Angiosperms	1
13	Conifères	Conifers	1
14	Cryptogames vasculaires	Vascular cryptogam	1
15	Autres gymnospermes	Other gymnosperms	1
16	Algues	Algae	1
17	Bryophytes	Bryophytes	1
18	Autres plantes	Other plants	1
19	Toutes les espèces	All species	0
20  Québec  Quebec  2
\.


--
-- Name: taxa_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taxa_groups_id_seq', 1, false);


--
-- Data for Name: taxa_group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.taxa_group_members (id_group, scientific_name) FROM stdin;
1	Amphibia
2	Aves
3	Mammalia
4	Reptilia
5	Actinopterygii
5	Cephalaspidomorphi
5	Elasmobranchii
5	Holocephali
5	Myxini
5	Sarcopterygii
6	Appendicularia
6	Ascidiacea
6	Thaliacea
7	Leptocardii
8	Arthropoda
9	Acanthocephala
9	Annelida
9	Brachiopoda
9	Bryozoa
9	Cephalorhyncha
9	Chaetognatha
9	Cnidaria
9	Ctenophora
9	Cycliophora
9	Dicyemida
9	Echinodermata
9	Entoprocta
9	Gastrotricha
9	Gnathostomulida
9	Hemichordata
9	Micrognathozoa
9	Mollusca
9	Myxozoa
9	Nematoda
9	Nematomorpha
9	Nemertea
9	Onychophora
9	Orthonectida
9	Phoronida
9	Placozoa
9	Platyhelminthes
9	Porifera
9	Rotifera
9	Sipuncula
9	Tardigrada
9	Xenacoelomorpha
10	Archaea
10	Bacteria
10	Chromista
10	Protozoa
10	Viruses
11	Fungi
12	Liliopsida
12	Magnoliopsida
13	Pinopsida
14	Lycopodiopsida
14	Polypodiopsida
15	Cycadopsida
15	Ginkgoopsida
15	Gnetopsida
16	Charophyta
16	Chlorophyta
16	Rhodophyta
17	Bryophyta
18	Anthocerotophyta
18	Glaucophyta
18	Marchantiophyta
\.


--
-- Name: taxa_group_members_id_group_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.taxa_group_members_id_group_seq', 1, false);

CREATE INDEX IF NOT EXISTS id_taxa_obs_idx
  ON public.taxa_obs_ref_lookup (id_taxa_obs);

--
-- PostgreSQL database dump complete
--

--
-- CREATE TAXA LOOKUP
--

DROP VIEW IF EXISTS public.taxa_obs_group_lookup CASCADE;
CREATE VIEW public.taxa_obs_group_lookup AS (
    select distinct
    	obs_lookup.id_taxa_obs, group_m.id_group
    from public.taxa_group_members group_m
    left join public.taxa_ref
        on group_m.scientific_name = taxa_ref.scientific_name
    left join public.taxa_obs_ref_lookup obs_lookup
	    on taxa_ref.id = obs_lookup.id_taxa_ref
);

