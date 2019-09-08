#!/bin/bash

blanking() {
  local mode="$1"; shift
  case "$mode" in
    -|stop) xset -dpms; xset s off ;;
    +|start) xset +dpms; xset s on ;;
    sus|suspend)
      wake-loop &
      "$@"
      kill $!
    ;;
    *) return 1 ;;
  esac
}

wake() {
  if [[ $# -eq 0 ]]; then wake 20m; return $?; fi

  run blanking suspend sleep "$@"
}

wake-loop() {
  blanking stop
  while sleep 50; do blanking stop; done
}
