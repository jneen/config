#!/bin/bash

settitle() {
  echo -ne "\033]0;"
  echo -n "$@"
  echo -ne "\007"
}
