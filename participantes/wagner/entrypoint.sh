#!/bin/bash
set -e

# Run the init scripts
docker-entrypoint.sh postgres &

# Wait for PostgreSQL to start
until pg_isready -U postgres; do
  sleep 1
done

# Start PostgreSQL with the custom configuration
exec postgres -c config_file=/var/lib/postgresql/data/postgresql.conf
