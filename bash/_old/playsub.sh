#!/bin/bash

playsub() {
  local sub="$1"; shift

  mplayer /dev/zero \
    -demuxer rawvideo \
    -rawvideo w=1024:h=128:format=bgra \
    -subfont-autoscale 2 -sub "$sub" \
    "$@"
}
