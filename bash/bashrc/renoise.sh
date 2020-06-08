renoise() {
  run_ chrt 10 renoise "$@"
}

oggify() {
  local input="$1"; shift

  echo ffmpeg -i "$input" "${input%.*}.ogg" "$@" >&2
  ffmpeg -i "$input" "${input%.*}.ogg" "$@"
}

twitterify() {
  ffmpeg -i "$1" -c:a aac -ab 112k -c:v libx264 -shortest -strict -2 "$2"
}
