#!/bin/bash

coin() {
  if [[ $(( $RANDOM % 2 )) = 0 ]]; then
    echo yay
    return 0
  else
    echo oh no
    return 1
  fi
}
