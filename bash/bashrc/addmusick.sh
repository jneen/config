#!/bin/bash
AMK_PREFIX=~/src/addmusick/workspace

amk() {
  local fname="$1"; shift
  execd mkdir -p "$AMK_PREFIX"/music/tmp
  execd cp "$fname" "$AMK_PREFIX"/music/tmp/

  pushd "$AMK_PREFIX"
  execd ./addmusick "$@" "$fname"
  popd
}
