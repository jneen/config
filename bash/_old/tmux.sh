#!/bin/bash

t() {
  putd SESSION

  local dir="$1"; shift

  [[ -z "$dir" ]] && dir="$(pwd)"

  local session_name="$SESSION"
  [[ -z "$session_name" ]] && session_name="$dir"
  session_name="${session_name//./_}"

  [[ -z "$TMUX_TEMPLATE" ]] && TMUX_TEMPLATE=default
  exists "tmux-template-$TMUX_TEMPLATE" || TMUX_TEMPLATE=default

  tmux new-session -d -c "$dir" -s "$session_name"
  tmux setenv -g -t "$session_name" TMUX_ROOT "$dir"

  SESSION="$session_name" "tmux-template-$TMUX_TEMPLATE"

  tmux attach -t "$session_name:0"
}

tmux-template-default() {
  tmux rename-window -t "$SESSION:0" edit
  tmux send-keys -t "$SESSION:0" edit C-m

  tmux new-window -t "$SESSION:1" -n shell
}
