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

export SHELL=/usr/bin/bash

shell() { exec "$SHELL" "$@"; }

bootstrap() {
  if is-linux; then bootstrap-linux "$@"
  elif is-mac; then bootstrap-mac "$@"
  else error "oh no" && return 1
  fi
}

bootstrap-global() {
  execd $ln .config/git/gitconfig ~/.gitconfig

  execd $ln .config/nvim ~/.vim
  execd $ln .config/nvim/nvim.sh ~/.vimrc

  execd $ln .config/bash/init.sh ~/.bashrc
  execd echo '. "$HOME"/.bashrc' > ~/.bash_profile


}

bootstrap-linux() {
  local ln="ln -snf"
  bootstrap-global
  execd $ln ~/.config/xmonad/xmonad.hs ~/.xmonad/xmonad.hs
  execd $ln ~/.config/uim ~/.uim.d
  execd bash ~/.config/gnome-terminal/thankful-eyes.sh
}

bootstrap-mac() {
  local ln="ln -shf"
  bootstrap-global
}
