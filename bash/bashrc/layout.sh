#!/bin/bash

SCREENLAYOUT_D=$HOME/.screenlayout

layout() {
  xmodmap ~/.xmodmap

  local config="$1"; shift
  [[ -z "$config" ]] && config=default

  local fname="$HOME/.screenlayout/$config.sh"
  if [[ -x "$fname" ]]; then
    echo "loading $fname:"
    cat "$fname"
    "$fname"
  else
    echo "no such layout $config (in $fname)"
    return 1
  fi
}

_layout() {
  __complete_files "$SCREENLAYOUT_D" .sh
}

complete -F _layout layout
