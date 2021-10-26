-- INSTALL python PL EXTENSION TO SUPPORT API CALL
CREATE EXTENSION IF NOT EXISTS plpython3u;

-- CREATE FUNCTION TO ACCESS REFERENCE TAXA FROM GLOBAL NAMES
DROP FUNCTION IF EXISTS public.get_taxa_ref_gnames(text, text);
CREATE FUNCTION public.get_taxa_ref_gnames(
    name text,
    authorship text DEFAULT NULL)
RETURNS TABLE (
    source_name text,
    source_id numeric,
    source_record_id text,
    scientific_name text,
    authorship text,
    rank text,
    rank_order integer,
    valid boolean,
    valid_srid text
)
LANGUAGE plpython3u
AS $function$
    from urllib.request import Request, urlopen, URLError, HTTPError
    from urllib.parse import urlencode, quote_plus
    import json
    import re

    def find_authorship(name):
        try:
            return re.search(
                "(?<=\().*(?=\))", name
            ).group()
        except AttributeError:
            return " ".join(name.split(" ")[1:])

    def to_taxa_ref(gn_result):
        is_valid = gn_result["currentRecordId"] == gn_result["recordId"]
        out = []
        if not is_valid:
            out.append({
                "source_id": gn_result["dataSourceId"],
                "source_record_id": gn_result["recordId"],
                "source_name": gn_result["dataSourceTitleShort"],
                "scientific_name": gn_result["matchedCanonicalFull"],
                "authorship": find_authorship(gn_result["matchedName"]),
                "rank": gn_result["classificationRanks"].split("|")[-1],
                "rank_order": gn_result["classificationRanks"].count("|") + 1,
                "valid": is_valid,
                "valid_srid": gn_result["currentRecordId"]
            })
        for rank_order, taxa_attributes in enumerate(zip(
            gn_result["classificationPath"].split("|"),
            gn_result["classificationRanks"].split("|"),
            gn_result["classificationIds"].split("|"))
        ):
            taxa, rank, srid = taxa_attributes
            # if rank not in ["family", "species", "subspecies"]:
            #     continue
            if rank == gn_result["classificationRanks"].split("|")[-1]:
                valid_authorship = find_authorship(gn_result["matchedName"])
            else:
                valid_authorship = ""
            out.append(
                {
                    "source_id": gn_result["dataSourceId"],
                    "source_record_id": srid,
                    "source_name": gn_result["dataSourceTitleShort"],
                    "scientific_name": taxa,
                    "authorship": valid_authorship,
                    "rank": rank,
                    "rank_order": rank_order,
                    "valid": True,
                    "valid_srid": srid
                }
            )
        return out

    host = "https://verifier.globalnames.org"
    path_prefix = "api/v1/verifications"
    path_name = quote_plus(name)
    params = urlencode(
        {'pref_sources': "|".join(['%.0f' % v for v in [1, 11, 147]])}
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
        out = json.loads(data.read().decode('utf-8'))
        out = [taxa_ref for species in out
            for rec in species['preferredResults']
            for taxa_ref in to_taxa_ref(rec)]
        return out

$function$;

SELECT * FROM public.get_taxa_ref_gnames('Cyanocitta cristata');

-- TODO verify what function was created and reuse it
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.modified_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS public.taxa_ref (
    id SERIAL PRIMARY KEY,
    source_name text NOT NULL,
    source_id numeric,
    source_record_id text NOT NULL,
    scientific_name text NOT NULL,
    authorship text,
    rank text NOT NULL,
    valid text NOT NULL,
    valid_srid text NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by text NOT NULL DEFAULT CURRENT_USER,
    UNIQUE (source_name, source_record_id)
);
CREATE INDEX IF NOT EXISTS source_id_srid_idx
  ON public.taxa_ref (source_id, valid_srid);

CREATE TRIGGER taxa_ref_modified_at
  BEFORE UPDATE ON public.taxa_ref FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TABLE IF NOT EXISTS public.taxa_obs (
    id SERIAL PRIMARY KEY,
    scientific_name text NOT NULL,
    authorship text,
    rank text,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by text DEFAULT CURRENT_USER NOT NULL,
    UNIQUE (scientific_name, authorship)
);

CREATE TRIGGER taxa_obs_modified_at
  BEFORE UPDATE ON public.taxa_obs FOR EACH ROW
  EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TABLE IF NOT EXISTS public.taxa_obs_ref_lookup (
    id_taxa_obs integer NOT NULL,
    id_taxa_ref integer NOT NULL,
    match_type text,
    UNIQUE (id_taxa_obs, id_taxa_ref)
);

CREATE INDEX IF NOT EXISTS id_taxa_obs_idx
  ON public.taxa_obs_ref_lookup (id_taxa_obs);

CREATE INDEX IF NOT EXISTS id_taxa_ref_idx
  ON public.taxa_obs_ref_lookup (id_taxa_ref);
--

--FUZZY MATCHING OF SCIENTIFIC NAME
DROP FUNCTION IF EXISTS get_taxa_obs_from_name(text, text);
CREATE FUNCTION get_taxa_obs_from_name(
    scientific_name text,
    authorship text DEFAULT NULL)
RETURNS SETOF public.taxa_obs AS $$
    WITH source_ref AS (
        SELECT *
        FROM get_taxa_ref_gnames(scientific_name)
        WHERE valid
        ORDER BY rank_order DESC
    )
    SELECT DISTINCT(taxa_obs.*)
    FROM source_ref
    LEFT JOIN public.taxa_ref taxa_ref
        ON source_ref.source_id = taxa_ref.source_id
        AND source_ref.valid_srid = taxa_ref.valid_srid
    LEFT JOIN public.taxa_obs_ref_lookup lookup on
        taxa_ref.id = lookup.id_taxa_ref
    LEFT JOIN public.taxa_obs taxa_obs on
        lookup.id_taxa_obs = taxa_obs.id
    WHERE source_ref.rank = (SELECT rank from source_ref limit 1);
$$ LANGUAGE sql;

-- INSERT taxa_ref from obs record field

DROP FUNCTION IF EXISTS insert_taxa_ref_from_obs(integer, text, text) CASCADE;
CREATE OR REPLACE FUNCTION insert_taxa_ref_from_obs(
    new_id integer,
    new_scientific_name text,
    new_authorship text DEFAULT NULL
)
RETURNS void AS
$BODY$
BEGIN
    DROP TABLE IF EXISTS temp_src_taxa_ref;
    CREATE TEMPORARY TABLE temp_src_taxa_ref AS (
        SELECT source_ref.*, taxa_ref.id id_taxa_ref
        FROM get_taxa_ref_gnames(new_scientific_name, new_authorship) source_ref
        LEFT JOIN public.taxa_ref taxa_ref
            ON source_ref.source_id = taxa_ref.source_id
            AND source_ref.source_record_id = taxa_ref.source_record_id
    );

    WITH ins_ref AS (
        INSERT INTO public.taxa_ref (
            source_name,
            source_id,
            source_record_id,
            scientific_name,
            authorship,
            rank,
            valid,
            valid_srid
        )
        SELECT
            source_name,
            source_id,
            source_record_id,
            scientific_name,
            authorship,
            rank,
            valid,
            valid_srid
        FROM temp_src_taxa_ref
        ON CONFLICT DO NOTHING
        RETURNING id AS id_taxa_ref, source_record_id, source_id)
    UPDATE temp_src_taxa_ref
    SET id_taxa_ref = ins_ref.id_taxa_ref
    FROM ins_ref
    WHERE
        temp_src_taxa_ref.source_id = ins_ref.source_id
        AND temp_src_taxa_ref.source_record_id = ins_ref.source_record_id;

    INSERT INTO public.taxa_obs_ref_lookup (id_taxa_obs, id_taxa_ref)
        SELECT new_id, src_ref.id_taxa_ref
        FROM temp_src_taxa_ref src_ref
        ON CONFLICT DO NOTHING;
END;
$BODY$
LANGUAGE 'plpgsql';


-- CREATE the trigger for insertion:

CREATE OR REPLACE FUNCTION trigger_insert_taxa_ref_from_obs()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM insert_taxa_ref_from_obs(
        NEW.id, NEW.scientific_name, NEW.authorship
        );
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS taxa_insert_ref ON public.taxa_obs;
CREATE TRIGGER taxa_insert_ref AFTER INSERT
ON public.taxa_obs
FOR EACH ROW
EXECUTE PROCEDURE trigger_insert_taxa_ref_from_obs();

-- TEST queries

DELETE FROM public.taxa_ref;
DELETE FROM public.taxa_obs;
DELETE FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Cyanocitta cristata');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Antigone canadensis');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Antigone cacadensis');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Grus canadensis');
-- SELECT COUNT(id) FROM public.taxa_obs;
-- SELECT COUNT(id) FROM public.taxa_ref;
-- SELECT COUNT(*) FROM public.taxa_obs_ref_lookup;
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer sp.');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer saccharum.');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer nigrum');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer');
-- INSERT INTO public.taxa_obs (scientific_name) VALUES ('Acer rubrum');



-- TODO: Elegantly crashes when no `get_taxa_ref_gnames` finds nothing
-- TODO: See how to make it work with funky caps
-- TODO: Fuzzy match without gnames API (?)
-- TODO: BUG Request 