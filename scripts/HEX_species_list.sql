CREATE OR REPLACE FUNCTION public_api.get_hex_species_list(
    hexFid integer,
    hexLevel integer,
    minYear integer,
    maxYear integer
-- ) AS (
--     VALUES (38, 50, 1950, 2022)
)
RETURNS SETOF api.taxa AS $$
SELECT
    distinct on (taxa.valid_scientific_name)
    taxa.*
FROM
    -- params,
    public_api.hex_taxa_year_obs_count o,
    api.taxa
WHERE o.fid = hexFid
    AND o.scale = hexLevel
    AND o.year_obs >= minYear
    AND o.year_obs <= maxYear
    AND o.id_taxa_obs = taxa.id_taxa_obs
    AND taxa.rank = 'species'
$$ LANGUAGE SQL STABLE;

EXPLAIN ANALYZE select public_api.get_hex_species_list(38, 50, 1950, 2022);