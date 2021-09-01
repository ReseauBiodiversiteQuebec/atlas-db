drop materialized view if exists api.quebec_observed_bird_taxa;

create materialized view if not exists api.quebec_observed_bird_taxa as
    select distinct obs.id_taxa
    from observations obs
    left join datasets as ds on obs.id_datasets = ds.id
    where 
        ds.title in (
            'Atlas des Oiseaux Nicheurs du Québec',
            'eBird Basic Dataset') and
        ST_X (ST_Transform (obs.geom, 4326)) >= -79.8 and
        ST_X (ST_Transform (obs.geom, 4326)) <= -57.1 and
        ST_Y (ST_Transform (obs.geom, 4326)) >= 45 and
        ST_Y (ST_Transform (obs.geom, 4326)) <= 62.56;