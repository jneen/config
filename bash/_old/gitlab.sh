#!/bin/bash

GITLAB_DIR="/home/jneen/src/gitlab"

gl() {
  TMUX_TEMPLATE=gitlab SRC_DIR="$GITLAB_DIR" src -c "cd gitlab" "$@"
}

__complete_gl() {
  SRC_DIR="$GITLAB_DIR" __complete_src
}

complete -F __complete_gl gl

tmux-template-gitlab() {
  tmux-template-default
  tmux new-window -t "$SESSION:2" -n 'gdk run db'
  tmux send-keys -t "$SESSION:2" 'gdk run db' C-m
}
