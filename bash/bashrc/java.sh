#!/bin/bash

is-mac && {
  export JAVA_HOME="$HOMEBREW_PREFIX/Cellar/openjdk/18"
  pathshift "$JAVA_HOME/bin"
}
