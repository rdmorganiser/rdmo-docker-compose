#!/bin/bash

${HOME}/sh/install-rdmo-app.sh

launch_gunicorn() {
  echo "Run gunicorn"
  cd "${RDMO_APP}" && gunicorn \
    --bind 0.0.0.0:8080 \
    --log-level info \
    --access-logfile "/vol/log/gunicorn-access.log" \
    --error-logfile "/vol/log/gunicorn-error.log" \
    config.wsgi:application || {
    echo "gunicorn failed to start, retry in ${DELAY_AFTER_GUNICORN_FAILURE}"
    sleep ${DELAY_AFTER_GUNICORN_FAILURE}
    launch_gunicorn
  }
}

launch_gunicorn
