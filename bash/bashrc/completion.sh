#!/bin/bash

. /usr/share/bash-completion/bash_completion
for f in $HOME/.local/share/bash-completion/completions/*; do
  [[ -s "$f" ]] && . "$f"
done
