export EDITOR="$HOME/.config/nvim/editor.sh"

edit() { $EDITOR "$@"; }
e() { edit "$@"; }
:e() { e "$@"; }
vim() { e "$@"; }
:q() { exit 0; }
