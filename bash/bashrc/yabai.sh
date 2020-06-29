#!/bin/bash

is-mac || return 0

export YABAI="$HOME/src/yabai/bin/yabai"
pathshift "$HOME/src/yabai/bin"
# listshift MANPATH "$HOME/src/yabai/doc"
