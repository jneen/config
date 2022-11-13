#!/bin/bash
is-mac && {
  for gnubin in "$HOMEBREW_PREFIX"/opt/*/libexec/gnubin; do
    pathshift "$gnubin"
  done

  # sigh. gnu uname reports bad things on apple silicon
  BAD_UNAME="$HOMEBREW_PREFIX"/opt/coreutils/libexec/gnubin/uname
  [[ -w "$BAD_UNAME" ]] && rm -f "$BAD_UNAME"
}
