#!/bin/bash

is-linux && {
  current-desktop() {
    desktop="$(xdotool get_desktop 2>/dev/null)"
    [[ $? != 0 ]] && desktop=0 # first boot
    # get_desktop can fail if we've never switched desktops
    echo $((1 + $desktop))
  }

  register-sticky() {
    mkdir -p /tmp/sticky
    echo "$XMONAD_STICKY" > /tmp/sticky/$1
  }

  cleanup-sticky() {
    [[ -z "$1" ]] && rm -f /tmp/sticky/$1
  }

  run_() {
    [[ -z "$ON_BEGIN" ]] && ON_BEGIN=echo
    [[ -z "$ON_END" ]] && ON_END=echo
    (
      _p=$(
        (
        ("$@" 2>&1 & echo $! >&3; echo $! >&4; eval "$ON_BEGIN $!") \
        | logger -t "run-$1"
        ) 3>&1
      )
      eval "$ON_END $_p"
    ) 4>&1 &
  }

  run() {
    run-on "$(current-desktop)" "$@"
  }

  run-on() {
    export XMONAD_STICKY="$1"; shift

    ON_BEGIN=register-sticky ON_END=cleanup-sticky run_ "$@"
  }

  x() {
    run "$@" && exit 0
  }

  is-interactive && {
    complete -c run
    complete -c x
  }

  startapps() {
    run-on 1 br
    run-on 8 slack
    run-on 7 discord
    exit
  }
}

is-mac && {
  run() {
    "$@" | logger -t "$1" &
  }

  x() {
    run "$@"
    exit 0
  }
}
