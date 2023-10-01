#!/bin/bash
scriptdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
basedir=$(echo "${scriptdir}" | grep -Po ".*(?=\/)")
export VOLDIR="${basedir}/vol"

dc_master="${basedir}/docker/dc_master.yaml"
dc_temp="${basedir}/docker/docker-compose.yaml"
envfile="${basedir}/docker/.env"

baseconf="${basedir}/docker/baseconf.toml"
conf="${basedir}/conf.toml"

export LOCAL_UID="$(id -u)"
export LOCAL_GID="$(id -g)"

get_from_conf() {
  if [[ -f "${conf}" ]]; then
    grep -Ei "^${1}( |=)" "${conf}" |
      grep -Po '(?<=\=)\s?.*' | grep -Po '[^=]+$' | xargs
  fi
}

append() {
  echo "${1}" >>"${envfile}"
}

getkey() {
  echo "${1}" | grep -Po '^[0-9A-Za-z_\-]+'
}

getval() {
  echo "${1}" | grep -Po '(?<=\=)\s?.*' | grep -Po '[^=]+$' | xargs
}

truncate -s 0 "${envfile}"

ext="$(echo "${baseconf}" | grep -Po "[^.]+$")"
if [[ ! -f "${baseconf}" || "${ext}" != "toml" ]]; then
  echo "target does not seem to be a toml file: ${baseconf}"
  exit 1
fi

mapfile -t arr < <(grep -E '^[0-9A-Za-z_\-]+\s*=\s*.*' "${baseconf}")
for el in "${arr[@]}"; do
  key="$(getkey "${el}")"
  upkey="$(echo "${key}" | sed -e 's/\(.*\)/\U\1/')"
  val="$(getval "${el}")"
  confval="$(get_from_conf "${key}")"

  # echo $val
  echo $confval

  if [[ -n "${confval}" ]]; then
    val="${confval}"
  fi

  append "${upkey}=${val}"
  if [[ "${upkey}" == "GLOBAL_PREFIX" ]]; then
    append "COMPOSE_PROJECT_NAME=${val}"
  fi
  export "$(echo "${upkey}")=${val}"
done

cat ${dc_master} | envsubst >${dc_temp}

mkdir -p ${VOLDIR}/log
mkdir -p ${VOLDIR}/postgres
mkdir -p ${VOLDIR}/rdmo-app

docker_compose_command="docker compose -p ${GLOBAL_PREFIX}"
if ! groups | grep docker >/dev/null 2>&1; then
  docker_compose_command="sudo docker compose -p ${GLOBAL_PREFIX}"
fi
echo "${docker_compose_command} -f \"${dc_temp}\""
