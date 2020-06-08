#!/bin/bash

shopt -s globstar

# bash escaping sucks
TAB="$(echo -ne '\t')"

case "$(uname -s)" in
  Darwin*) CONF_MODE=mac ;;
  Linux*) CONF_MODE=linux ;;
  *) echo UNKNOWN OS >&2 ;;
esac

is-mac() { [[ "$CONF_MODE" = mac ]] ;}
is-linux() { [[ "$CONF_MODE" = linux ]] ;}

__complete_files() {
  local dir="$1"; shift
  local ext="$1"; shift

  local files="$(
    for f in "$dir"/*"$ext"; do
      [[ -s "$f" ]] && basename -s "$ext" "$f"
    done
  )"

  COMPREPLY=( $( compgen -W "$files" "${COMP_WORDS[COMP_CWORD]}" ) )
}

export TERM=xterm

pathdel() {
  for p in "$@"; do
    export PATH="$(tr : "\n" <<<"$PATH" | fgrep -vx "$p" | tr "\n" :)"
  done

  # chomp off the last :
  export PATH="${PATH%:}"
}

pathshift() {
  for p in "$@"; do
    pathdel "$p"
    export PATH="$p:$PATH"
  done
}

pathpush() {
  for p in "$@"; do
    pathdel "$p"
    export PATH="$PATH:$p"
  done
}

exists() {
  silence type "$@"
}

pathshift /usr/local/bin
pathshift $HOME/.local/bin

# execute a command with no output
silence() {
  "$@" &>/dev/null
}

stderr() {
  echo "$@" >&2
}

putd() {
  stderr "$1=[${!1}]"
}

execd() {
  stderr "$@"
  "$@"
}

is-interactive() { test -n "$PS1" ;}
is-script() { ! is-interactive ;}

if is-linux; then
  . /usr/share/bash-completion/bash_completion
  for f in $HOME/.local/share/bash-completion/completions/*; do
    [[ -s "$f" ]] && . "$f"
  done
elif is-mac; then
  echo
  . /usr/local/etc/profile.d/bash_completion.sh
fi

for f in "$HOME"/.config/bash/bashrc/*.sh; do
  . "$f"
done

true
