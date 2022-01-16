ALTER TABLE public.observations
ADD COLUMN IF NOT EXISTS within_quebec BOOLEAN DEFAULT FALSE;

CREATE INDEX observations_id_taxa_obs_qc
on public.observations (id_taxa_obs)
where within_quebec is true;

with quebec as (
	select ST_UNION(wkb_geometry) as geom from qc_region_limit
	)
UPDATE public.observations obs
SET within_quebec = TRUE
FROM quebec
WHERE ST_WITHIN(obs.geom, quebec.geom);

DROP FUNCTION IF EXISTS observations_set_within_quebec_trigger() CASCADE;
CREATE FUNCTION observations_set_within_quebec_trigger()
RETURNS TRIGGER AS
$$
BEGIN
	IF ST_WITHIN(NEW.geom, (SELECT ST_UNION(wkb_geometry) FROM qc_region_limit)) THEN
		NEW.within_quebec := TRUE; 
    END IF;
	RETURN NEW;
END;
$$ language plpgsql;

CREATE TRIGGER observations_set_within_quebec 
BEFORE INSERT on public.observations
	FOR EACH ROW EXECUTE FUNCTION observations_set_within_quebec_trigger();