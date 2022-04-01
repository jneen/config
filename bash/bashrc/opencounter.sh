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

oc-db-dump() {
  fname="$1"; shift
  [[ -z "$fname" ]] && fname=./tmp/local.dump
  curl -o "$fname" "$(heroku pg:backups public-url -a opencounter-v2)"
}

OC_DUMP=/tmp/db.dump
oc-db-blank-dump() {
  execd rm -r "$OC_DUMP" 2> /dev/null
  echo "dumping db ($OC_DUMP)"
  local db_url="$(heroku config:get DATABASE_URL --app opencounter-v2)"
  execd pg_dump -v -d "$db_url" --format=directory  -T public.projects  --create --no-acl --jobs 5 --file "$OC_DUMP"
}

oc-db-blank-restore() {
  execd pg_restore --clean \
                   --verbose \
                   -Fd -j 8 -h localhost -d opencounter_dev "$OC_DUMP"
}

oc-db-refresh() {
  oc-db-blank-dump
  oc-db-blank-restore
}
