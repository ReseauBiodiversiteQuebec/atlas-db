# Run this script as postgres user
cd /home/postgres/atlas-db/dump

# Drop database atlas_staging
psql -c "DROP DATABASE IF EXISTS atlas_staging;"

# Create database atlas_staging
psql -c "CREATE DATABASE atlas_staging;"

# Setup from dump files
psql -d "atlas_staging" -f ./dump_atlas_schema.sql
psql -d "atlas_staging" -f ./dump_atlas_public_data.sql
psql -d "atlas_staging" -f ./dump_regions.sql
psql -d "atlas_staging" -f ./dump_test_observations.sql