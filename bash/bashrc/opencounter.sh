#!/bin/bash

oc-production() {
  heroku run rails console -a opencounter-v2 -e DISABLE_DATADOG_AGENT=true
}

oc-staging() {
  heroku run rails console -a opencounter-v2-staging -e DISABLE_DATADOG_AGENT=true
}

oc-db-dump() {
  fname="$1"; shift
  [[ -z "$fname" ]] && fname=./tmp/local.dump
  curl -o "$fname" "$(heroku pg:backups public-url -a opencounter-v2)"
}
