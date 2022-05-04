CREATE OR REPLACE FUNCTION public_api.get_ecozones_species_list(
    ecozonesFid integer,
    ecozonesLevel integer,
    minYear integer DEFAULT 1950,
    maxYear integer DEFAULT 2200,
    taxaKeys integer[] DEFAULT NULL,
    taxaGroupKey integer DEFAULT NULL
)
RETURNS SETOF api.taxa AS
$$
BEGIN
    -- Validation of inputs
    IF (taxaGroupKey IS NULL AND taxaKeys IS NULL) THEN
        taxaGroupKey := (SELECT id from taxa_groups where level = 0);
    END IF;
    IF (taxaGroupKey IS NOT NULL AND taxaKeys IS NOT NULL) THEN
        RAISE 'ONLY one of parameters `taxa_group_keys` `taxaKeys` can be specified';
    END IF;

    IF taxaGroupKey IS NOT NULL THEN
        SELECT array_agg(id_taxa_obs)
        INTO taxaKeys
        FROM taxa_obs_group_lookup
        WHERE id_group = taxaGroupKey;
    END IF;

    RETURN QUERY
        SELECT
            distinct on (taxa.valid_scientific_name)
            taxa.*
        FROM
            -- params,
            public_api.ecozones_taxa_year_obs_count o,
            api.taxa
        WHERE o.fid = ecozonesFid
            AND o.niv = ecozonesLevel
            AND o.year_obs >= minYear
            AND o.year_obs <= maxYear
            AND o.id_taxa_obs = taxa.id_taxa_obs
            AND taxa.rank = 'species'
            AND taxa.id_taxa_obs = ANY(taxaKeys);
END;
$$ LANGUAGE plpgsql STABLE;

EXPLAIN ANALYZE select public_api.get_ecozones_species_list(3, 1, 1950, 2022, NULL, 2);