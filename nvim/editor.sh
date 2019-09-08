#!/bin/bash

[[ -z "$NVIM_LISTEN_ADDRESS" ]] && exec nvim "$@"

first="$1"; shift

echo
echo -n "[[ editing $first"
for f in "$@"; do
  echo -n ", $f"
done
echo ' ]]'
echo

exec nvr --remote-wait-silent -cc 'split' -c 'set bufhidden=delete' "$first" "$@"
