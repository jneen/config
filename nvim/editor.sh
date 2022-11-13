#!/bin/bash

EXTRA=''
if [[ "$1" = --wait ]]; then
  EXTRA=--remote-wait
  shift
fi

[[ -z "$NVIM" ]] && exec nvim "$@"

exec nvr --remote-silent -cc 'split' -c 'set bufhidden=delete' $EXTRA "$@"

# shvim drop "$2"
# read
