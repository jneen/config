#!/bin/bash

PROMPT_COMMAND="__ensure_hook;$PROMPT_COMMAND"
ENSURE=''

__ensure_hook() {
  [[ -n "$ENSURE" ]] && eval "$ENSURE"
  ENSURE=''
}

ensure() {
  ENSURE="$@; $ENSURE"
}
