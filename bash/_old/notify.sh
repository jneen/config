notify-run() {
  local cmd="$@"

  "$@"

  if [[ $? == 0 ]]; then
    notify-send --urgency=low -i terminal "success" "$cmd"
  else
    notify-send --urgency=low -i error "error" "$cmd"
  fi
}

alias n:=notify-run
