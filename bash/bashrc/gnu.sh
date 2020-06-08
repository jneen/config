#!/bin/bash
is-mac && {
  for gnubin in /usr/local/opt/*/libexec/gnubin; do
    pathshift "$gnubin"
  done
}
