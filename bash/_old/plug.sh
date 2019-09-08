#!/bin/bash

PLUG_DIR="$HOME/Music/plug"

plug::get-youtube() {
  local url="$1"; shift
  local outfile="$1"; shift

  youtube-dl -x "$url" -o "$outfile"
}

plug::get-soundcloud() {
  local url="$1"; shift
  local outfile="$1"; shift

  scdl -l "$url" --path "$outfile"
}

plug::create-playlist() {
  local name="$1"; shift
  mkdir -p "$PLUG_DIR"/"$name"
}
