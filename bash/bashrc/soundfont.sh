#!/bin/bash

is-mac && POLYPHONE=/Applications/polyphone-2.2.app/Contents/MacOS/polyphone

[[ -n "$POLYPHONE" ]] && {
  polyphone() {
    execd "$POLYPHONE" "$@"
  }

  sf2convert() {
    local input
    local outdir

    local number_prefix=0
    local bank_directory=0
    local midi_classify=0

    while [[ $# -gt 0 ]]; do
      local a="$1"; shift

      case "$a" in
        -p|--number-prefix) number_prefix=1 ;;
        -b|--bank-directory) bank_directory=1 ;;
        -m|--midi-classify) midi_classify=1 ;;
        *)
          if [[ -z "$input" ]]
          then input="$a"
          else outdir="$a"
          fi
        ;;
      esac
    done

    [[ -z "$outdir" ]] && outdir=$HOME/renoise/instruments
    polyphone -3 -i "$input" -d "$outdir" -c $number_prefix$bank_directory$midi_classify
  }
}
