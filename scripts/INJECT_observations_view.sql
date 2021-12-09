-- ALTER TABLE public.observations DROP CONSTRAINT observations_id_taxa_fkey;
-- alter table public.observations alter column id_taxa drop not null;

UPDATE public.variables
SET unit = '' WHERE unit is NULL;

DROP VIEW IF EXISTS inject_observations CASCADE;
CREATE VIEW inject_observations AS (
    SELECT
        obs.org_parent_event,
        obs.org_event,
        obs.org_id_obs,
        obs.id_datasets,
        obs.geom,
        obs.year_obs,
        obs.month_obs,
        obs.day_obs,
        obs.time_obs,
        obs.obs_value,
        obs.issue,
        taxa_obs.scientific_name,
        taxa_obs.authorship,
        taxa_obs.rank,
        ds.original_source,
        ds.org_dataset_id,
        ds.creator,
        ds.title,
        ds.publisher,
        ds.modified,
        ds.keywords,
        ds.abstract,
        ds.type_sampling,
        ds.type_obs::text,
        ds.intellectual_rights,
        ds.license,
        ds.owner,
        ds.methods,
        ds.open_data,
        ds.exhaustive,
        ds.direct_obs,
        ds.centroid,
        var.name,
        var.unit,
        var.description
    FROM observations obs
    left join taxa_obs
        on obs.id_taxa_obs = taxa_obs.id
    left join datasets ds
        on obs.id_datasets = ds.id
    left join variables var
        on obs.id_variables = var.id
);

DROP FUNCTION IF EXISTS view_observations_insert();
CREATE FUNCTION view_observations_insert() RETURNS trigger AS $$
BEGIN
    INSERT INTO public.taxa_obs (scientific_name, rank, authorship)
    SELECT
        NEW.scientific_name,
        NEW.rank,
        NEW.authorship
    ON CONFLICT DO NOTHING;

    INSERT INTO public.datasets (
        original_source,
        org_dataset_id,
        creator,
        title,
        publisher,
        modified,
        keywords,
        abstract,
        type_sampling,
        type_obs,
        intellectual_rights,
        license,
        owner,
        methods,
        open_data,
        exhaustive,
        direct_obs,
        centroid)
    SELECT
        NEW.original_source,
        NEW.org_dataset_id,
        NEW.creator,
        NEW.title,
        NEW.publisher,
        NEW.modified,
        NEW.keywords,
        NEW.abstract,
        NEW.type_sampling,
        NEW.type_obs::type_observation,
        NEW.intellectual_rights,
        NEW.license,
        NEW.owner,
        NEW.methods,
        NEW.open_data,
        NEW.exhaustive,
        NEW.direct_obs,
        NEW.centroid::boolean
    ON CONFLICT DO NOTHING;

    INSERT INTO public.variables (name, unit, description)
    SELECT
        NEW.name,
        NEW.unit,
        NEW.description
    ON CONFLICT DO NOTHING;

    INSERT INTO public.observations (
        org_event,
        org_id_obs,
        org_parent_event,
        geom,
        year_obs,
        month_obs,
        day_obs,
        time_obs,
        obs_value,
        issue,
        id_taxa_obs,
        id_variables,
        id_datasets
    )
    SELECT
        NEW.org_event,
        NEW.org_id_obs,
        NEW.org_parent_event,
        NEW.geom,
        NEW.year_obs,
        NEW.month_obs,
        NEW.day_obs,
        NEW.time_obs,
        NEW.obs_value,
        NEW.issue,
        (SELECT id FROM public.taxa_obs
            WHERE NEW.scientific_name = taxa_obs.scientific_name
            and NEW.authorship = taxa_obs.authorship
            ) as id_taxa_obs,
        (SELECT id FROM public.variables as var
            where NEW.name = var.name
            and NEW.unit = var.unit
            ) as id_variables,
       (SELECT id from public.datasets ds
            where NEW.original_source = ds.original_source
            and NEW.title = ds.title limit 1
            ) as id_datasets;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER view_observations_insert_trigger ON inject_observations;
CREATE TRIGGER view_observations_insert_trigger
    INSTEAD OF INSERT ON inject_observations
    FOR EACH ROW
    EXECUTE FUNCTION view_observations_insert();

-- INSERT INTO	inject_observations
-- SELECT * FROM test_inject_observations LIMIT 1;