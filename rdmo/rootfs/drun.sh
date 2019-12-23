#!/bin/bash

source /opt/ve.sh

if [[ $(pip freeze | grep -Poc "^rdmo==") == "0" ]]; then
    /opt/install-rdmo.sh
else
    echo "Won't do anything because RDMO is already installed."
fi


echo "Run gunicorn"
cd "${RDMO_APP}"
gunicorn \
    --bind 0.0.0.0:8080 \
    --log-level info \
    --access-logfile "/vol/log/gunicorn-access.log" \
    --error-logfile "/vol/log/gunicorn-error.log" \
    config.wsgi:application
