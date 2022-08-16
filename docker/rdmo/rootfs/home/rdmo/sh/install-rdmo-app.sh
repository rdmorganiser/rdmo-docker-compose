#!/bin/bash

echo "Install RDMO App"
git clone ${RDMO_APP_REPO} ${RDMO_APP}
cp -f /conf/template_local.py ${RDMO_APP}/config/settings/local.py

pip install -r ${RDMO_APP}/requirements/gunicorn.txt

cd ${RDMO_APP}
python manage.py migrate
python manage.py download_vendor_files
python manage.py collectstatic --no-input
python manage.py setup_groups
