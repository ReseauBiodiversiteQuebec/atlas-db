REVOKE ALL ON schema public FROM public;
REVOKE ALL ON schema public_api FROM public;
REVOKE ALL ON schema api FROM public;

REVOKE ALL ON schema public FROM read_only_all;
REVOKE ALL ON schema public_api FROM read_only_all;
REVOKE ALL ON schema api FROM read_only_all;

REVOKE ALL ON schema public FROM read_only_public;
REVOKE ALL ON schema public_api FROM read_only_public;
REVOKE ALL ON schema api FROM read_only_public;

REVOKE ALL ON schema public FROM read_write_all;
REVOKE ALL ON schema public_api FROM read_write_all;
REVOKE ALL ON schema api FROM read_write_all;

---revoke all on every role when a ressource is created------
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM read_only_public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public REVOKE ALL ON TABLES FROM read_write_all;

---public (role) access-----
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO public;

---read_only_all access ---- 
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE ON SEQUENCES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT SELECT ON TABLES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT USAGE ON SEQUENCES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT EXECUTE ON FUNCTIONS TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA api GRANT SELECT ON TABLES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA api GRANT USAGE ON SEQUENCES TO read_only_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA api GRANT EXECUTE ON FUNCTIONS TO read_only_all;



---read_only_public access ---- 
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT SELECT ON TABLES TO read_only_public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT USAGE ON SEQUENCES TO read_only_public;
ALTER DEFAULT PRIVILEGES IN SCHEMA public_api GRANT EXECUTE ON FUNCTIONS TO read_only_public;
GRANT USAGE ON SCHEMA public_api TO read_only_public;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public_api TO read_only_public;


---grant full access to read_write role except delete (only postgres user can remove)-----
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON TABLES TO read_write_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON FUNCTIONS TO read_write_all;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO read_write_all;

GRANT USAGE ON SCHEMA public TO read_write_all;
GRANT USAGE ON SCHEMA public_api TO read_write_all;
GRANT USAGE ON SCHEMA api TO read_write_all;
GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA public TO read_write_all;
GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA public_api TO read_write_all;
GRANT SELECT,INSERT, UPDATE, TRUNCATE, REFERENCES,TRIGGER ON ALL TABLES IN SCHEMA api TO read_write_all;

--- only once ---
---GRANT read_write_all TO belv1601 GRANTED BY postgres;
---GRANT read_write_all TO vbeaure GRANTED BY postgres;
---GRANT read_write_all TO cabw2601 GRANTED BY postgres;
