#!/bin/bash
export SRC_DIR="$HOME/src"

src() {
  local multiplexer name pre_command

  while [[ $# -gt 0 ]]; do
    local opt="$1"; shift

    case "$opt" in
      -t) multiplexer=t ;;
      -e) multiplexer=e ;;
      -m) multiplexer="$1"; shift ;;
      -c) pre_command="$1"; shift ;;
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
      echo -ne "\033]0;[$(basename "$dir")]\007"
      if [[ -n "$multiplexer" ]]; then
        SESSION="$(basename "$dir")" $multiplexer
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

work() {
  src && screen
}
