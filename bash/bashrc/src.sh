#!/bin/bash
export SRC_DIR="$HOME/src"

src() {
  local multiplexer name

  while [[ $# -gt 0 ]]; do
    local opt="$1"; shift

    case "$opt" in
      -e) edit=e ;;
      *)  name="$opt" ;;
    esac
  done

  cd "$SRC_DIR"

  if [[ -n "$name" ]]; then
    dir="$(find $SRC_DIR/ \
      -maxdepth 1 \
      -mindepth 1 \
      -name "$name*" \
      -type d \
      | sortlines | head -1
    )"
    cd "$dir"
    if [[ -n "$dir" ]]; then
      [[ -n "$pre_command" ]] && eval "$pre_command"
      if [[ -n "$edit" ]]; then
        SESSION="$(basename "$dir")" o .
      else
        ls
      fi
    else
      ls
      false # no such project
    fi
  fi
}

# tab completion
__complete_src () {
  local cur src_dirs
  cur="${COMP_WORDS[COMP_CWORD]}"

  src_dirs="$(
    for f in $(/bin/ls -A $SRC_DIR | grep ^$cur); do
      if [ -d "$SRC_DIR/$f" ]; then
        echo $f
      fi
    done
  )"

  COMPREPLY=( $( compgen -W "$src_dirs" ) )
}

complete -F __complete_src src
