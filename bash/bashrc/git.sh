is-linux && . /usr/share/bash-completion/completions/git
alias g=git
complete -o default -o nospace -F _git g

ghome() { cd "$(git root)" ;}
gsubmodule() { ghome && git submodule update && cd - ;}
