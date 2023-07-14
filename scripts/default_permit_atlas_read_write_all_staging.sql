---CREATE ROLE read_write_all_staging;
---this script is only apply in staging BDs, please do not apply in production DBs
REVOKE ALL ON schema public FROM read_write_all_staging;
REVOKE ALL ON schema public_api FROM read_write_all_staging;
REVOKE ALL ON schema api FROM read_write_all_staging;


ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA public REVOKE ALL ON TABLES FROM read_write_all_staging;


---grant full access to read_write role except delete (only postgres user can remove)-----
GRANT USAGE ON SCHEMA public TO read_write_all_staging;
GRANT USAGE ON SCHEMA public_api TO read_write_all_staging;
GRANT USAGE ON SCHEMA api TO read_write_all_staging;

ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA public GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON TABLES TO read_write_all_staging;
ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO read_write_all_staging;
ALTER DEFAULT PRIVILEGES FOR USER postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO read_write_all_staging;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO read_write_all_staging;

GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA public TO read_write_all_staging;
GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA public_api TO read_write_all_staging;
GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA api TO read_write_all_staging;


