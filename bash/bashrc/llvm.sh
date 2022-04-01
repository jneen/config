#!/bin/bash

is-mac && {
  pathshift /usr/local/opt/llvm/bin

  export LDFLAGS="-L/usr/local/opt/llvm/lib"
  export CPPFLAGS="-I/usr/local/opt/llvm/include"
}
