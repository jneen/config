#!/bin/bash

export CONF_DIR="$HOME"/.config

config() {
  cd "$CONF_DIR" && edit "$@" && cd -
}

vibashrc() {
  if [[ -n "$1" ]]; then
    config bash/bashrc/"${1%.sh}.sh"
  else
    config bash/bashrc/
  fi

  shell
}

vb() { vibashrc "$@"; }
__complete_vb() { __complete_files $HOME/.config/bash/bashrc .sh; }
is-interactive && complete -F __complete_vb vb vibashrc

export SHELL=/usr/local/bin/bash

shell() { exec "$SHELL" "$@"; }

bootstrap() {
  execd ln -shf .config/git/gitconfig ~/.gitconfig

  execd ln -shf .config/nvim ~/.vim
  execd ln -shf .config/nvim/nvim.sh ~/.vimrc

  execd ln -shf .config/bash/init.sh ~/.bashrc
  execd echo '. "$HOME"/.bashrc' > ~/.bash_profile
}
