#!/bin/bash

is-linux && {
  renoise() {
    run_ chrt 10 renoise "$@"
  }
}

oggify() {
  local input="$1"; shift

  echo ffmpeg -i "$input" "${input%.*}.ogg" "$@" >&2
  ffmpeg -i "$input" "${input%.*}.ogg" "$@"
}

twitterify() {
  local audio="$1"; shift
  local image="$1"; shift

  echo ffmpeg -i "$audio" -loop 1 -i "$image" -c:a aac -ab 112k -c:v libx264 -shortest -strict -2 "$@"
  ffmpeg -i "$audio" -loop 1 -i "$image" -c:a aac -ab 112k -c:v libx264 -shortest -strict -2 "$@"
}

mp3ify() {
  lame -q0 -V2 "$@"
}

samples() {
  ffprobe "$@" -show_streams 2>/dev/null | grep duration_ts | cut -d= -f2
}

halfsamples() {
  local samples="$(samples "$@")"
  echo "$(($samples / 2))"
}

halfaudio() {
  local infile="$1"; shift
  local ext="${infile##*.}"
  local base="${infile%.*}"
  local outfile="$base.half.$ext"
  execd sox "$infile" "$outfile" trim "$(halfsamples "$infile")"s
}
