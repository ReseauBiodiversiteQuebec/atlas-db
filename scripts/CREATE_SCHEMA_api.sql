-- Create schema for all api functions and materialized views

CREATE SCHEMA IF NOT exists api
    AUTHORIZATION admins;

REVOKE ALL ON SCHEMA api FROM admins;
GRANT USAGE ON SCHEMA api to public;
GRANT ALL ON SCHEMA api TO postgres;
GRANT ALL ON ALL TABLES IN SCHEMA api TO admins;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA api TO admins;

GRANT SELECT ON ALL TABLES IN SCHEMA api TO atlas_reader;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA api TO atlas_reader;