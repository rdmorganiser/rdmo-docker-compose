#!/bin/bash

source "${HOME}/sh/ve.sh"

function waitforpg() {
    pg_isready -h ${POSTGRES_HOST} -U ${POSTGRES_USER} || (
        sleep 1
        waitforpg
    )
}

waitforpg

if [ $(pip freeze | grep -Poc "^rdmo==") -eq 0 ] && [ $(pip freeze | grep -Poc "^rdmo @") -eq 0 ]; then
    ${HOME}/sh/install-rdmo.sh
else
    echo "Won't do anything because RDMO is already installed."
fi

echo "Run gunicorn"
cd "${RDMO_APP}" && gunicorn \
    --bind 0.0.0.0:8080 \
    --log-level info \
    --access-logfile "/vol/log/gunicorn-access.log" \
    --error-logfile "/vol/log/gunicorn-error.log" \
    config.wsgi:application
