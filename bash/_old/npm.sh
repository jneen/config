#!/bin/bash

pathshift "$HOME/.local/lib/npm/bin"

exists npm && {
  npm config set prefix "$HOME/.local/lib/npm"
}
