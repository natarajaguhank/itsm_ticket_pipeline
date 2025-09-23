#!/bin/bash
set -e

host="postgres"
user="$POSTGRES_USER"
db="$POSTGRES_DB"

until pg_isready -h "$host" -U "$user" -d "$db"; do
  echo "Waiting for Postgres..."
  sleep 3
done

echo "Postgres is ready!"
