#!/bin/bash
is-local || return 0

is-linux && {
  open() {
    run xdg-open "$@"
  }
}
