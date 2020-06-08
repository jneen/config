#!/bin/bash

is-linux && {
  SCREENLAYOUT_D=$HOME/.screenlayout
  mkdir -p "$SCREENLAYOUT_D/_defaults"

  layout() {
    local arg
    local set_default
    local config

    while [[ $# -gt 0 ]]; do
      arg="$1"; shift
      putd arg
      case "$arg" in
        -d|--default) set_default=1 ;;
        *) config="$arg"
      esac
    done

    putd config
    putd set_default

    [[ -z "$config" ]] && [[ -n "$set_default" ]] && config="$(layout-default)"
    [[ -z "$config" ]] && return 1

    local fname="$SCREENLAYOUT_D/$config.sh"
    if [[ -x "$fname" ]]; then
      echo "loading $fname:"
      cat "$fname"
      "$fname"

      # reset xmodmap automatically
      xm

      # re-launch feh
      launch-wallpaper
    else
      echo "no such layout $config (in $fname)"
      return 1
    fi

    [[ -n "$set_default" ]] && {
      echo "$config" > "$SCREENLAYOUT_D/_defaults/$(layout-config-hash)"
    }
  }

  layout-fingerprint() {
    xrandr -q --verbose | awk '
      /^[^ ]+ (dis)?connected / { DEV=$1; }
      $1 ~ /^[a-f0-9]+$/ { ID[DEV] = ID[DEV] $1 }
      END { for (X in ID) { print X " " ID[X]; } }'
  }


  layout-config-hash() {
    layout-fingerprint | md5sum - | cut -d' ' -f1
  }

  layout-default() {
      cat "$SCREENLAYOUT_D/_defaults/$(layout-config-hash)"
  }

  _layout() {
    __complete_files "$SCREENLAYOUT_D" .sh
  }

  complete -F _layout layout
}
