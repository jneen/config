#!/bin/bash
export BASHRC_D="$HOME/.bashrc.d"
shell() {
  exec $SHELL "$@"
}

vibashrc() {
  if [[ -n "$1" ]]; then
    local fname="${1%.sh}.sh"
  else
    local fname=
  fi

  cd "$BASHRC_D"
    $EDITOR $fname
  cd -
  shell
}
alias vb=vibashrc

__complete_vb() {
  __complete_files "$BASHRC_D" .sh
}

is-interactive && complete -F __complete_vb vb vibashrc
