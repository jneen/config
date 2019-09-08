#!/bin/bash

is-interactive && {
  exists direnv && eval "$(direnv hook "$0")"

  direnv-edit() {
    envrc="$1"; shift
    [[ -z "$envrc" ]] && envrc=.envrc
    echo "edit $envrc"
    edit "$envrc"
    direnv allow
  }

  de() { direnv-edit "$@" ;}
}
