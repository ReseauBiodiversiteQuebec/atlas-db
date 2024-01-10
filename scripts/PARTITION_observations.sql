----------------------------------------------------------------
-- PARTITIONNING OBSERVATIONS TABLE BY `WITHIN_QUEBEC` COLUMN --
----------------------------------------------------------------


-- NOTE. "It is not possible to turn a regular table into a partitioned table or
--  vice versa. However, it is possible to add an existing regular or
--  partitioned table as a partition of a partitioned table"
--  SOURCE https://www.postgresql.org/docs/13/ddl-partitioning.html


SET session_replication_role = 'replica';


-- 0. ----------------------------------------------------------
--  CREATING SCHEMA TO HOLD PARTITION TABLES

CREATE SCHEMA IF NOT EXISTS observations_partitions
    AUTHORIZATION postgres;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT SELECT ON TABLES TO read_only_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT INSERT, TRUNCATE, SELECT, REFERENCES, TRIGGER, UPDATE ON TABLES TO read_write_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT SELECT ON TABLES TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT USAGE ON SEQUENCES TO read_only_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT USAGE ON SEQUENCES TO read_only_public;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT ALL ON SEQUENCES TO read_write_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT USAGE ON SEQUENCES TO PUBLIC;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT EXECUTE ON FUNCTIONS TO read_only_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT EXECUTE ON FUNCTIONS TO read_only_public;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT EXECUTE ON FUNCTIONS TO read_write_all;

ALTER DEFAULT PRIVILEGES IN SCHEMA observations_partitions
GRANT EXECUTE ON FUNCTIONS TO PUBLIC;


-- 2. ----------------------------------------------------------
--  ALTER CONSTRAINTS FOR PARTITIONING PREPARATION

ALTER TABLE public.observations DROP CONSTRAINT observations_pkey CASCADE;
ALTER TABLE public.observations DROP CONSTRAINT observations_unique_rows;
ALTER TABLE public.observations
    ADD CONSTRAINT observations_unique_rows
	UNIQUE (id_datasets, geom,
			year_obs, month_obs, day_obs, time_obs,
			id_taxa_obs, id_variables, obs_value, within_quebec);
ALTER TABLE public.observations
    ALTER COLUMN within_quebec SET NOT NULL;


-- 1. ----------------------------------------------------------
--  CREATING PARTITION TABLES

ALTER TABLE observations RENAME TO outside_quebec;
ALTER TABLE outside_quebec SET SCHEMA observations_partitions;

CREATE TABLE observations_partitions.within_quebec (
    LIKE observations_partitions.outside_quebec
    INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING STORAGE
);

CREATE TABLE public.observations (
    LIKE observations_partitions.outside_quebec
    INCLUDING ALL
) PARTITION BY LIST (within_quebec);

ALTER TABLE ONLY public.observations
    ADD CONSTRAINT observations_pkey PRIMARY KEY (id, within_quebec);


-- 3. ----------------------------------------------------------
--  MOVE RECORDS

INSERT INTO observations_partitions.within_quebec
SELECT *
FROM observations_partitions.outside_quebec
WHERE within_quebec is TRUE;

DELETE FROM observations_partitions.outside_quebec
WHERE within_quebec is TRUE;


-- 4. ----------------------------------------------------------
--  SET TABLES AS PARTITIONS

ALTER TABLE public.observations
    ATTACH PARTITION observations_partitions.within_quebec
    FOR VALUES IN (TRUE);

ALTER TABLE public.observations
    ATTACH PARTITION observations_partitions.outside_quebec
    FOR VALUES IN (FALSE);


-- 5. ----------------------------------------------------------
--  ADD CONSTRAINTS

ALTER TABLE observations_partitions.within_quebec
ADD CONSTRAINT within_quebec_unique_id UNIQUE (id);

ALTER TABLE observations_partitions.outside_quebec
ADD CONSTRAINT outside_quebec_unique_id UNIQUE (id);

-- 6. ----------------------------------------------------------
--  ADD TRIGGER FOR INSERTIONS

ALTER TABLE observations ALTER COLUMN within_quebec SET DEFAULT FALSE;

CREATE OR REPLACE FUNCTION update_within_quebec()
RETURNS TRIGGER AS $$
DECLARE
BEGIN
    NEW.within_quebec := ST_Within(NEW.geom, (SELECT geom FROM regions WHERE type = 'admin' AND scale = 1));
    IF (NEW.within_quebec IS NULL) THEN
        RAISE EXCEPTION 'within_quebec is NULL';
    ELSIF (NEW.within_quebec IS TRUE) THEN
        INSERT INTO observations_partitions.within_quebec VALUES (NEW.*);
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_within_quebec_trigger
BEFORE INSERT ON observations_partitions.outside_quebec
FOR EACH ROW
EXECUTE FUNCTION update_within_quebec();
