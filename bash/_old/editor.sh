#!/bin/bash
export EDITOR='vim8-auto'
# export EDITOR='gvim -v'
alias v="$EDITOR"
alias vi="$EDITOR"
#view using vim
alias view="$EDITOR -R"


alias ':e'='e'
alias ':q'='exit'
alias vim=edit

gv() {
  silence gvim &
}

edit() {
  $EDITOR "$@"
}

un() {
  find . -type f -name '*.un~' -delete
}

swp() {
  find . -type f -name '.*.sw[a-z]' -delete
}

e() {
  $EDITOR "$@"
}

# [jneen] TODO use this strategy to mark a term buffer as
# executing or not

# # Execute this to set up preexec and precmd execution.
# function preexec_install () {
# 
#     # *BOTH* of these options need to be set for the DEBUG trap to be invoked
#     # in ( ) subshells.  This smells like a bug in bash to me.  The null stackederr
#     # redirections are to quiet errors on bash2.05 (i.e. OSX's default shell)
#     # where the options can't be set, and it's impossible to inherit the trap
#     # into subshells.
# 
#     set -o functrace > /dev/null 2>&1
#     shopt -s extdebug > /dev/null 2>&1
# 
#     # Finally, install the actual traps.  Note: this must be the _last_ command
#     # in PROMPT_COMMAND for it to work, otherwise the debug trap will get
#     # confused and execute for random other commands.
#     PROMPT_COMMAND="${PROMPT_COMMAND}"$'\n'"preexec_invoke_cmd;";
#     trap 'preexec_invoke_exec' DEBUG;
# }
