#!/bin/bash

is-linux || return 0
is-local || return 0

xm() {
  xmodmap ~/.config/x/xmodmap
}

xmr() {
  xmodmap ~/.config/x/xmodmap.reset
}
