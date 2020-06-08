#!/bin/bash
is-linux && {
  open() {
    run xdg-open "$@"
  }
}
