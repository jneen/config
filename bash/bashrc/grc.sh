#!/bin/bash
is-interactive && {
  grc-alias() {
    exists "$1" && alias "$1"="grc $@"
  }

  exists grc && {
    grc-alias netstat
    grc-alias ping
    grc-alias traceroute
  }
}
