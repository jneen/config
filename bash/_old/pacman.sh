#!/bin/bash

pm() { pacman "$@" ;}
spm() { sudo pacman "$@" ;}

y() { yaourt "$@" ;}
sy() { sudo yaourt "$@" ;}

_completion_loader pacman
complete -o default -o nospace -F _pacman pm
complete -o default -o nospace -F _pacman spm

_completion_loader yaourt
complete -o default -o nospace -F _yaourt y
complete -o default -o nospace -F _yaourt sy
