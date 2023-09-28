#!/bin/bash

if [[ ! -d "${RDMO_APP}" ]]; then
  echo "Install RDMO App"
  git clone "${RDMO_APP_REPO}" "${RDMO_APP}"

  targ="${RDMO_APP}/config/settings/local.py"
  if [[ ! -f "${targ}" ]]; then
    cp -f /conf/template_local.py "${targ}"
  fi

fi

cd "${RDMO_APP}" && {
  python manage.py migrate
  python manage.py download_vendor_files
  python manage.py collectstatic --no-input
  python manage.py setup_groups
}
