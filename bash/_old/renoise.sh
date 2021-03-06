renoise() {
  renoise3 "$@" &
  { sleep 3 && patch_renoise; } &
}

oggify() {
  local input="$1"; shift

  echo ffmpeg -i "$input" "${input%.*}.ogg" "$@" >&2
  ffmpeg -i "$input" "${input%.*}.ogg" "$@"
}

twitterify() {
  ffmpeg -i "$1" -c:a aac -ab 112k -shortest -strict -2 "$2"
}
