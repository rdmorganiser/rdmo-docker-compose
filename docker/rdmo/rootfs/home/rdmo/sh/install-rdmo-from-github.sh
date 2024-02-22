#!/bin/bash

branch="${1}"
url="${RDMO_REPO}"

for val in "$@"; do
  if [[ "${val}" =~ ^-+(h|help)$ ]]; then
    echo -e "\nhelp"
    echo -e "\n  synopsis"
    echo "    install rdmo directly from github"
    echo -e "    can take one positional arg to specify a certain branch"
    echo -e "\n  usage"
    echo "    install-rdmo.sh"
    echo -e "    install-rdmo.sh branch_name\n"
    exit
  fi
done

if [[ -z "${url}" ]]; then
  echo -e "\n[error] unable to retrieve rdmo repo url, env var RDMO_REPO not set\n"
  exit 1
fi

if [[ -n "${branch}" ]]; then
  url+="@${branch}"
fi

pip install --force-reinstall git+${url}
