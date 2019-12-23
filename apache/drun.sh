#!/bin/bash

function sanitize(){
    r="$(echo "/${1}/" \
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
rm -f /var/run/apache2/apache2.pid

apache2 -DFOREGROUND
