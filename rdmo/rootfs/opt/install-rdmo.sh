#!/bin/bash

source /opt/ve.sh


pip install --upgrade pip
pip install --upgrade wheel
pip install --upgrade setuptools
pip install psycopg2

pip install --upgrade git+https://github.com/rdmorganiser/rdmo@1.6-rc.1

git clone ${RDMO_APP_REPO} ${RDMO_APP}
cp -f /conf/template_local.py ${RDMO_APP}/config/settings/local.py

pip install -r ${RDMO_APP}/requirements/gunicorn.txt

cd ${RDMO_APP}
python manage.py migrate
python manage.py download_vendor_files
python manage.py collectstatic --no-input
python manage.py setup_groups
