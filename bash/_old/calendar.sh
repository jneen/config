#!/bin/bash

ecal() {
  when e
  when
}

ec() { ecal "$@"; }

c() {
  local days="$1"; shift
  [[ -z "$days" ]] && days=7

  cal -3

  # nope
  # echo Upcoming:
  # when --future="$days"
}
