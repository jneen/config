#!/bin/bash

# use ripl if it exists
irb() {
  if exists ripl; then
    ripl "$@"
  else
    $(which irb) "$@"
  fi
}
