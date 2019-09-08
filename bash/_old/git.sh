#!/bin/bash

alias g=git
complete -o default -o nospace -F _git g
_completion_loader git

ghome() { cd "$(git root)" ;}
gsubmodule() { ghome && git submodule update && cd - ;}

is_git() {
  exists git || return 1
  [[ -d .git ]] && return 0
  silence git rev-parse --git-dir
}

git_headsup() {
  is_git || return

  local branch="$(git symbolic-ref HEAD 2>/dev/null)"
  [[ -z "$branch" ]] && branch="$(git describe --exact-match --tags 2>/dev/null)"
  [[ -z "$branch" ]] && branch='(detached)'
  branch="${branch##refs/heads/}"

  local dirty=''
  git diff --quiet 2>/dev/null || dirty='*'

  echo " -> $dirty$branch"
}
