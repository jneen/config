is-linux && {
  export LD_LIBRARY_PATH="$HOME/.local/lib:/usr/local/lib"
  export CPATH="$HOME/.local/include:/usr/local/include"
}

is-mac && {
  export LD_LIBRARY_PATH="$HOME/.local/lib:$HOMEBREW_PREFIX/lib:/usr/local/lib"
  export DYLD_LIBRARY_PATH="$HOME/.local/lib:$HOMEBREW_PREFIX/lib:/usr/local/lib"
  export CPATH="$HOME/.local/include:$HOMEBREW_PREFIX/include:/usr/local/include"
}
