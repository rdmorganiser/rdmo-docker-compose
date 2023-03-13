#!/bin/bash

fil="${1}"

if [[ -z "${fil}" ]]; then
    echo -e "\nplease provide a psql dump file\n"
    exit 1
fi

export PGHOST="${POSTGRES_HOST}"
export PGPORT="${POSTGRES_PORT}"
export PGDATABASE="${POSTGRES_DB}"
export PGUSER="${POSTGRES_USER}"
export PGPASSWORD="${POSTGRES_PASSWORD}"

createdb rdmo || exit 1
psql <"${fil}"
