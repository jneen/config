#!/bin/bash

is-linux || return 0

export NETCTL_DEBUG=yes
PING=8.8.8.8

net() { sudo netctl "$@" ;}
_completion_loader netctl
complete -F _netctl net
n() { wifi connect "$@" && echo 'connected. ping:'; ping "$PING" ;}
nb() { wifi connect "$@" && x br ;}

# wifi() { sudo wifi-menu "$@" && p8 ;}
wpa() { sudo wpa_cli "$@" ;}
wifi() { sudo /usr/local/bin/wifi "$@" ;}

sys() { sudo systemctl "$@" ;}
_completion_loader systemctl
complete -F _systemctl sys

jc() { sudo journalctl "$@" ;}

_complete_n() {
  COMPREPLY=( $( compgen -W "$(_netctl_profiles)" "${COMP_WORDS[COMP_CWORD]}" ) )
}

complete -F _complete_n n
complete -F _complete_n nb
