is-linux && . /usr/share/bash-completion/completions/git
alias g=git

__git_complete g __git_main

ghome() { cd "$(git root)" ;}
gsubmodule() { ghome && git submodule update && cd - ;}
