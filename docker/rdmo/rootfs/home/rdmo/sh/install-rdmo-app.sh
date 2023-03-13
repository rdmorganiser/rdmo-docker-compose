#!/bin/bash

echo "Install RDMO App"
git clone "${RDMO_APP_REPO}" "${RDMO_APP}"

targ="${RDMO_APP}/config/settings/local.py"
if [[ ! -f "${targ}" ]]; then
    cp -f /conf/template_local.py "${targ}"
fi

pip install -r "${RDMO_APP}/requirements/gunicorn.txt"

cd "${RDMO_APP}" || exit 1
python manage.py migrate
python manage.py download_vendor_files
python manage.py collectstatic --no-input
python manage.py setup_groups
