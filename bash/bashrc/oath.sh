#!/bin/bash

OATH_DIR="$CONF_DIR/.oath"

oath() {
  oathtool -b --totp "$(gpg -d "$OATH_DIR/secrets/$1.gpg")"
}

oath-gen() {
  local name="$1"; shift

  local secret
  printf "secret: "
  read -s secret

  [[ -z "$secret" ]] && return 1

  echo -n "$secret" | gpg -e "$@" > "$OATH_DIR/secrets/$name.gpg" && echo
}

__complete_oath() {
  __complete_files "$OATH_DIR/secrets" .gpg
}

complete -F __complete_oath oath
