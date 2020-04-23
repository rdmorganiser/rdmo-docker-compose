#!/bin/bash

if [[ -n "${1}" ]]; then
    user="--user ${1}"
else
    user=""
fi

git clone ${RDMO_CATALOG_REPO} ${RDMO_CATALOG}

arr=($(
    find "${RDMO_CATALOG}/rdmorganiser/conditions" \
        -regex ".*catalog\/.*\.xml$" | sort
))
arr+=($(
    find "${RDMO_CATALOG}/rdmorganiser" \
        -regex ".*catalog\/.*\.xml$" \
        | grep -v "/conditions/" \
        | sort
))

IFS=$'\n'
sorted=($(sort <<<"${arr[*]}"))
unset IFS

cd ${RDMO_APP}
for i in "${sorted[@]}"; do
   echo -e "Starting to import ${i}..."
   python manage.py import "${i}" ${user}
done
