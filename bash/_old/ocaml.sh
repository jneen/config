#!/bin/bash

exists opam && {
  # OPAM configuration
  . $HOME/.opam/opam-init/init.sh
  eval `opam config env`
}
