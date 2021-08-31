CREATE EXTENSION spi;

DROP TABLE IF EXISTS public.time_series CASCADE;

CREATE TABLE IF NOT EXISTS public.time_series (
  id SERIAL PRIMARY KEY,
  id_datasets integer NOT NULL,
  dataset_record_id integer,
  id_taxa integer NOT NULL,
  unit text,
  years integer[],
  values numeric [],
  geom geometry(Point,4326) NOT NULL,
  created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  modified_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
  CONSTRAINT fk_taxa
    FOREIGN KEY (id_taxa)
    REFERENCES public.taxa (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
  CONSTRAINT fk_datasets
    FOREIGN KEY (id_datasets)
        REFERENCES public.datasets (id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS
  time_series_update ON public.time_series;

CREATE TRIGGER time_series_update_at
  BEFORE UPDATE ON public.time_series FOR EACH ROW
  EXECUTE FUNCTION trigger_set_timestamp();

GRANT SELECT ON TABLE public.time_series TO atlas_reader;

GRANT ALL ON TABLE public.time_series TO admins;

CREATE INDEX IF NOT EXISTS id_taxa_idx
  ON public.time_series (id_taxa);
