#!/bin/bash

export WINEARCH=win64
export WINEPREFIX=~/.wine

w() {
  local prefix="$1"; shift
  WINEPREFIX="$prefix" wine64 "$@"
}
