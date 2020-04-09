#!/bin/bash

# automatically ssh-add if the identity isn't yet established
ssh() {
  ensure-ssh
  $(which ssh) "$@"
}

s() {
  export LC_TIME=
  ensure-ssh
  mosh "$@"
}

ensure-ssh() {
  ssh-add -l >/dev/null || ssh-add
}

sa() { ensure-ssh ;}
