#!/bin/bash

raw-to-wav() {
  sox --no-dither -t raw -b 8 -r 16k -e unsigned "$@"
}

rgb-to-bmp() {
  local size="$1"; shift

  execd convert -size "$size" -depth 8 "$@"
}
