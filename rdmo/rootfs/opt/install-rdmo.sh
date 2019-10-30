#!/bin/bash

source /opt/ve.sh


if [[ $(pip freeze | grep -Poc "^rdmo==") == "0" ]]; then

    pip install --upgrade pip
    pip install --upgrade wheel
    pip install --upgrade setuptools
    pip install psycopg2

    pip install rdmo

    git clone ${RDMO_APP_REPO} ${RDMO_APP}
    cp -f /tmp/template_local.py ${RDMO_APP}/config/settings/local.py
    cp -f /tmp/wsgi.py ${RDMO_APP}/config/wsgi.py

    cd ${RDMO_APP}
    python manage.py makemigrations
    python manage.py migrate
    python manage.py download_vendor_files
    python manage.py collectstatic --no-input
else
    echo "Won't do anything because RDMO is already installed."
fi
