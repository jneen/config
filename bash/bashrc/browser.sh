#!/bin/bash

is-local && {
  export BROWSER=firefox
  # export CHROMIUM_USER_FLAGS=--incognito
  browser() { $BROWSER "$@" ;}
  br() { browser "$@" ;}
  bri() { browser -P Private "$@" ;}
}
