#!/bin/bash

is-linux && is-local && {
  # use the clipboard for xsel
  alias xsel='xsel -b'

  copy() {
    xsel
  }

  paste() {
    xsel -o
  }
}

is-mac && {
  alias copy=pbcopy
  alias paste=pbpaste
}
