#!/bin/bash

function sanitize(){
    r="$(echo "${1}/" \
        | tr -s "/" \
        | sed 's/.$//'
    )"
    if [[ -z "${r}" ]]; then
        echo "/"
    else
        echo "${r}"
    fi
}

export BASE_STATIC=$(sanitize "${BASE_URL}/static")
export BASE_URL=$(sanitize "${BASE_URL}")

# apache gets grumpy about pre-existing pid files
rm -f /usr/local/apache2/logs/httpd.pid
httpd -DFOREGROUND
