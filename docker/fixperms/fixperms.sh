#!/bin/sh
set -eu

log() { echo "[fixperms] $*"; }

TARGET_UID="${LOCAL_UID:-1000}"
TARGET_GID="${LOCAL_GID:-1000}"
REQUESTED_VERSION="${POSTGRES_VERSION:-16}"
PGDIR="/vol/postgres"

mkdir -p /vol/log "${PGDIR}"

# Find any existing PG_VERSION marker: either flat directly under $PGDIR
# (the layout postgres <=17 images use), or nested under a major-version
# subdir (the layout postgres >=18 images use, e.g. $PGDIR/18/docker).
existing_version_file="$(find "${PGDIR}" -maxdepth 3 -name PG_VERSION 2>/dev/null | head -n1)"

if [ -n "${existing_version_file}" ]; then
  existing_major="$(cat "${existing_version_file}")"
  case "${REQUESTED_VERSION}" in
    latest | "")
      log "POSTGRES_VERSION is '${REQUESTED_VERSION}' - can't determine its major version ahead of time, skipping the version-mismatch check."
      ;;
    *)
      requested_major="${REQUESTED_VERSION%%.*}"
      if [ "${existing_major}" != "${requested_major}" ]; then
        backup="/vol/postgres-backup-${existing_major}-$(date +%Y%m%d%H%M%S).tar.gz"
        log "MISMATCH: existing data on disk is PostgreSQL major ${existing_major}, but POSTGRES_VERSION=${REQUESTED_VERSION} was requested."
        log "Backing up ${PGDIR} to ${backup} before refusing to start ..."
        tar -czf "${backup}" -C /vol postgres
        log "Backup done: ${backup}"
        log "Refusing to start: postgres major-version upgrades are not automatic here (they need pg_dump/pg_upgrade with"
        log "both binary versions available, not just a file copy). Either set POSTGRES_VERSION back to ${existing_major}.x,"
        log "or perform a deliberate upgrade (see readme.md) - the backup above is your safety net either way."
        exit 1
      fi
      log "Existing data is PostgreSQL major ${existing_major}, matches requested POSTGRES_VERSION=${REQUESTED_VERSION}."
      ;;
  esac
else
  log "No existing PostgreSQL data directory found under ${PGDIR} - nothing to check, starting fresh."
fi

chown -R "${TARGET_UID}:${TARGET_GID}" /vol
log "vol ownership set to ${TARGET_UID}:${TARGET_GID}."
