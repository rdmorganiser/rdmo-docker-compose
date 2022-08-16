#!/bin/bash

pip freeze | grep "gunicorn" || ${HOME}/sh/install-rdmo-app.sh

echo "Run gunicorn"
cd "${RDMO_APP}" && gunicorn \
    --bind 0.0.0.0:8080 \
    --log-level info \
    --access-logfile "/vol/log/gunicorn-access.log" \
    --error-logfile "/vol/log/gunicorn-error.log" \
    config.wsgi:application || sleep 60s
