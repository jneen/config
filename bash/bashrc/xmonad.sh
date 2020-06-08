is-linux && {
  vx() {
    cd ~/.xmonad
    edit xmonad.hs
    xmonad --recompile
    cd -
  }
}
