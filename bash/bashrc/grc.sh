#!/bin/bash
is-interactive || return 0
exists grc || return 0

grc-alias() {
  exists "$1" && alias "$1"="grc $@"
}

grc-alias netstat
grc-alias ping
grc-alias traceroute
