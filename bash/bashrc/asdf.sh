#!/bin/bash

is-mac && {
  ASDF_INIT="$HOME/.asdf/asdf.sh" 

  [[ -s "$ASDF_INIT" ]] && . "$ASDF_INIT"
}
