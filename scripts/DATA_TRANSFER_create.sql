-- Schema: data_transfer
-- Schema to hold the tables and resources for the data transfer to the public
-- schema. Only this schema is allowed for temporary tables to be created by
-- the data transfer process using the `read_write_all` role.

CREATE SCHEMA IF NOT EXISTS data_transfer;

GRANT CREATE, USAGE ON SCHEMA data_transfer TO read_write_all;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA data_transfer TO read_write_all;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA data_transfer TO read_write_all;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA data_transfer TO read_write_all;

GRANT CREATE, USAGE ON SCHEMA data_transfer TO read_write_all_staging;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA data_transfer TO read_write_all_staging;
GRANT SELECT, USAGE ON ALL SEQUENCES IN SCHEMA data_transfer TO read_write_all_staging;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA data_transfer TO read_write_all_staging;
