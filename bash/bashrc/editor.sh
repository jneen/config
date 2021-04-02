#!/bin/bash

export EDITOR="$HOME/.config/nvim/editor.sh"
export SUDO_EDITOR="/usr/bin/nvim"

edit() { $EDITOR "$@"; }
e() { edit "$@"; }
:e() { e "$@"; }
vim() { e "$@"; }
:q() { exit 0; }

o() {
  local path="$(readlink -f "$1")"; shift
  local origdir="$(pwd)"
  local f
  if [[ -d "$path" ]]; then
    cd "$path"
    f=.
  else
    cd "$(dirname "$path")"
    f="$(basename "$path")"
  fi

  settitle "[$(basename "$(pwd)")]"
  pwd
  execd edit "$f"
  settitle bash
  cd "$origdir"
}
