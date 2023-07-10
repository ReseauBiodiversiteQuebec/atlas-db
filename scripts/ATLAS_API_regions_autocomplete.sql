-- CREATE INDEX IF NOT EXISTS regions_name_idx ON regions (name);
-- CREATE INDEX IF NOT EXISTS regions_type_idx ON regions (type);
-- CREATE INDEX IF NOT EXISTS regions_scale_desc_idx ON regions (scale_desc);


--Possible values of `scale_desc` for regions of type `admin`:
-- "Province"
-- "Région administrative"
-- "Municipalité régionale de comté géographique"
-- "MRC (incluant les territoires autochtones)"
-- "Municipalité régionale de comté"
-- "Municipalité"
-- "Territoire autochtone"
-- "Territoire non organisé"

-- Autocomplete regions
-- DROP FUNCTION IF EXISTS atlas_api.regions_autocomplete (text);
CREATE OR REPLACE FUNCTION atlas_api.regions_autocomplete(
    name text)
RETURNS json AS $$
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
$$ LANGUAGE sql STABLE;

explain analyze SELECT atlas_api.regions_autocomplete('P');