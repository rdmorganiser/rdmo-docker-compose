#!/bin/bash

source /opt/ve.sh

cp -f /tmp/wsgi.py /vol/rdmo-app/config/wsgi.py

pip install --upgrade pip
pip install --upgrade wheel
pip install --upgrade setuptools
pip install psycopg2

pip install rdmo

git clone ${RDMO_APP_REPO} ${RDMO_APP}
cp -f /tmp/template_local.py ${RDMO_APP}/config/settings/local.py

cd ${RDMO_APP}
python manage.py makemigrations
python manage.py migrate
python manage.py download_vendor_files
python manage.py collectstatic --no-input
