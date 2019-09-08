#!/bin/bash

watchd() {
  while sleep 1; do
    du -s "$@"
    du -sh "$@"
  done
}
