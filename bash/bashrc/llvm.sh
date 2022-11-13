#!/bin/bash

is-mac && {
  pathshift "$HOMEBREW_PREFIX"/opt/llvm/bin

  export LDFLAGS="-L/$HOMEBREW_PREFIX/opt/llvm/lib"
  export CPPFLAGS="-I/$HOMEBREW_PREFIX/opt/llvm/include"
}
