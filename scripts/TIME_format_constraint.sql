-------------------------------------------------------------------
-- 1. Create format_dwc_datetime function
-------------------------------------------------------------------


DROP FUNCTION IF EXISTS format_dwc_datetime;
CREATE FUNCTION format_dwc_datetime(
	year integer DEFAULT NULL,
	month integer DEFAULT NULL,
	day integer DEFAULT NULL,
	time_obs time without time zone DEFAULT NULL)
RETURNS text AS $$
DECLARE out text := LPAD(year::text, 4, '0');
BEGIN
IF month is not null THEN
	out := out || '-' || LPAD(month::text, 2, '0');

END IF;
IF day is not null THEN
	out := out || '-' || LPAD(day::text, 2, '0');
END IF;
IF time_obs is not null THEN
	out := out || 'T' || time_obs;
END IF;
RETURN out;
END;
$$ LANGUAGE plpgsql;
-- select format_dwc_datetime(1982, 12, 31, '11:1:13');


-------------------------------------------------------------------------
-- 2. Alter table observations to prepare for new `dwc_event_date` column
-------------------------------------------------------------------------

ALTER TABLE public.observations
DROP CONSTRAINT observations_unique_rows;

ALTER TABLE public.observations
ADD COLUMN dwc_event_date text NOT NULL DEFAULT '';


-------------------------------------------------------------------------
-- 3. Update observations and set value of `dwc_event_date`
-------------------------------------------------------------------------

UPDATE public.observations
SET dwc_event_date = format_dwc_datetime(
	year_obs,
	month_obs,
	day_obs,
	time_obs);


-------------------------------------------------------------------------
-- 4. Find and remove doubles and implement constraint
-------------------------------------------------------------------------

DROP TABLE IF EXISTS del_obs cascade;
CREATE TEMPORARY TABLE del_obs AS
WITH kept_obs AS (
	SELECT
		max(id) id
	FROM observations
	GROUP BY (geom, dwc_event_date, id_taxa_obs, obs_value, id_variables))
select obs.id id_obs, obs_efforts.id_efforts
from observations obs
left join obs_efforts on obs.id = id_obs
WHERE obs.id not in ( select id from kept_obs );
DELETE FROM obs_efforts where id_obs in ( select id_obs from del_obs);
DELETE FROM observations where id in ( select id_obs from del_obs);
DELETE FROM efforts where id not in ( select id_efforts from obs_efforts);

ALTER TABLE public.observations
    ADD CONSTRAINT observations_unique_rows
    UNIQUE (geom, dwc_event_date, id_taxa_obs, id_variables, obs_value);


-------------------------------------------------------------------------
-- 5. Create trigger on observations injection to set dwc_event_date value
-------------------------------------------------------------------------

CREATE FUNCTION set_dwc_event_date ()
RETURNS TRIGGER AS $$
BEGIN
    NEW.dwc_event_date := format_dwc_datetime(
        NEW.year_obs,
        NEW.month_obs,
        NEW.day_obs,
        NEW.time_obs);
    RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER set_dwc_event_date_trggr
BEFORE INSERT ON public.observations
FOR EACH ROW
EXECUTE PROCEDURE set_dwc_event_date();
