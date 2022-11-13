#!/bin/bash

is-local || return 0

oc-production() {
  heroku run rails console -a opencounter-v2 -e DISABLE_DATADOG_AGENT=true
}

oc-staging() {
  heroku run rails console -a opencounter-v2-staging -e DISABLE_DATADOG_AGENT=true
}

oc-console() {
  local env="$1"; shift
  [[ -z "$env" ]] && env=opencounter-v2-staging
  heroku run rails console -a "$env" -e DISABLE_DATADOG_AGENT=true
}

OC_DUMP=/tmp/db.dump
oc-db-dump() {
  execd rm -rf "$OC_DUMP" 2> /dev/null
  echo "dumping db ($OC_DUMP)"
  mkdir -p "$OC_DUMP"
  local db_url="$(heroku config:get DATABASE_URL --app opencounter-v2)"
  execd pg_dump -v -d "$db_url" --format=directory --create --no-acl --jobs=6 --file "$OC_DUMP" "$@"
}

oc-db-blank-dump() {
  oc-db-dump --exclude-table=public.projects --exclude-table=public.changesets
}

oc-db-restore() {
  execd pg_restore --clean \
                   --verbose \
                   -Fd -j 8 -h localhost -d opencounter_dev "$OC_DUMP"
}

oc-db-refresh() {
  oc-db-blank-dump
  oc-db-restore
}
