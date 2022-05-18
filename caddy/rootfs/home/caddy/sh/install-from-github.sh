#!/bin/bash

url="${1}"
grep_scheme="${2}"
target_folder="${3}"
strip_comp="${4}"

if [[ ${strip_comp} =~ ^[0-9]+ ]]; then
    strip_comp="--strip-components=${strip_comp}"
else
    strip_comp=""
fi

if [[ -z "${target_folder}" ]]; then
    echo -e "\nthree args required, provide url, grepscheme and target folder"
    echo -e "\ni.e. install_from_github.sh \\
        \"triole/lunr-indexer/releases/latest\" \\
        \"(?<=href\=\").*_linux_x86_64.tar.gz\" \\
        \"${HOME}/bin\""
    echo ""
    exit 1
fi

function install() {
    mkdir -p "${target_folder}"
    url_prefix="https://github.com"
    tmpfil="/tmp/tmp_install.tar.gz"

    bin_url="https://github.com/$(
        curl -Ls "${url_prefix}/${url}" | grep -Po "${grep_scheme}"
    )"

    curl -L ${bin_url} -o "${tmpfil}" &&
        tar xvf "${tmpfil}" -C "${target_folder}" ${strip_comp}
}

install
