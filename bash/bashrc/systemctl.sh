
is-linux || return 0

sys() { sudo systemctl "$@" ;}
_completion_loader systemctl
complete -F _systemctl sys
