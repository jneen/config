#!/bin/bash

# use the clipboard for xsel
alias xsel='xsel -b'

copy() {
  xsel
}

paste() {
  xsel -o
}
