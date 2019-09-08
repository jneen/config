#!/bin/bash

jneebooks() {
  local cmd="$1"; shift

  case "$cmd" in
    fetch) scp guanyin:src/jneebooks/tmp/tweets.out ~/tmp/tweets.out ;;
    *) echo "bad command $cmd" >&2 ; return 1
  esac
}
