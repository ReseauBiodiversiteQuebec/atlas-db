#!/bin/sh
psql -U postgres -d atlas -f refresh_materialized_views_atlas.sql
