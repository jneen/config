#!/bin/bash
is-interactive && {
  __c() {
    echo "\\[\\e[$@m\]"
  }

  RED="$(__c '1;32')"
  ERR="$(__c '1;3$(($??1:7))')"
  DIR="$(__c '1;34')"

  if is-local
  then PROMPT="$(__c '1;32')"
  else PROMPT="$(__c '1;35')"
  fi

  CLEAR="$(__c '0;38')"

  unset __c

  ps1() {
    echo "\n$ERR{\$?:$PROMPT \u@\h $DIR\W $ERR}\$(ps1::git) \\$ $CLEAR\n; "
  }

  ps1::isgit() {
    exists git && {
      [[ -d .git ]] || silence git rev-parse --git-dir
    }
  }

  ps1::git() {
    ps1::isgit || return

    local branch="$(git symbolic-ref HEAD 2>/dev/null)"
    [[ -z "$branch" ]] && branch="$(git describe --exact-match --tags 2>/dev/null)"
    [[ -z "$branch" ]] && branch='(detached)'
    branch="${branch##refs/heads/}"

    local dirty=''
    git diff-index --quiet HEAD -- 2>/dev/null || dirty='*'

    echo " -> $dirty$branch"
  }

  export PS1="$(ps1)"
}
