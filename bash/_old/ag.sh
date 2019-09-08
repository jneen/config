#!/bin/bash
_ag() {
  local cur="${COMP_WORDS[$COMP_CWORD]}"
  local word="${cur##*[.:/+]}"

  case "$cur" in
  -*|.*|/*)
    COMPREPLY=()
  ;;
  *)
    local end_index="$(expr ${#cur} - ${#word})"
    local prefix="${cur:0:$end_index}"

    [[ -z "$TAGS" ]] && [[ -s ./tags ]] && TAGS=./tags
    [[ -z "$TAGS" ]] && [[ -s ./.git/tags ]] && TAGS=./.git/tags

    local completions="$(
      # scan the help text for options
      ag --help | egrep -o -- '-[a-z-]+'

      [[ -s "$TAGS" ]] && cut -f1 "$TAGS" | grep -v '!_TAG'
    )"

    COMPREPLY=( $(compgen -P "$prefix" -W "$completions" -- "$word") )
  ;;
  esac
}

complete -o bashdefault -F _ag ag
