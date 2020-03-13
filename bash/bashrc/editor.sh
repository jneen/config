export EDITOR="$HOME/.config/nvim/editor.sh"
export SUDO_EDITOR="/usr/bin/nvim"

edit() { $EDITOR "$@"; }
e() { edit "$@"; }
:e() { e "$@"; }
vim() { e "$@"; }
:q() { exit 0; }
