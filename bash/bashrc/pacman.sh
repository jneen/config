#!/bin/bash
is-linux && {
  pm() { pacman "$@" ;}
  spm() { sudo pacman "$@" ;}

  _completion_loader pacman
  complete -o default -o nospace -F _pacman pm
  complete -o default -o nospace -F _pacman spm

  exists yay && {
    y() { yay "$@" ;}
    sy() { sudo yay "$@" ;}

    _completion_loader yay
    complete -o default -o nospace -F _yay y
    complete -o default -o nospace -F _yay sy
  }
}
