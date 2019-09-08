#!/bin/bash

CHROME_COMMAND=google-chrome-stable
chrome-app() {
  local profile=Default
  local app
  local argv

  while [[ $# -gt 0 ]]; do
    local h="$1"; shift

    case "$h" in
      -p) profile="$1"; shift ;;
      *) app="$h" ;;
      --) break
    esac
  done

  [[ -z "$app" ]] && return 1

  local app_id="$(chrome-app-id "$profile" "$app")"

  putd app_id
  echo google-chrome --app-id="$app_id" "$@"
  $CHROME_COMMAND --app="chrome-extension://$app_id/index.html" "$@"
}

chrome-app-id() {
  local profile="$1"; shift
  local app="$1"; shift

  local chrome_dir="${XDG_CONFIG_HOME:-$HOME/.config}/google-chrome"
  local ext_dir="$chrome_dir"/"$profile"/Extensions

  local app_id
  local app_version
  local manifest

  for manifest in "$ext_dir"/*/*/manifest.json; do
    local name="$(jq -r .name < "$manifest")"
    [[ "$name" = "$app" ]] || continue

    local version="$(jq -r .version <"$manifest")"
    local higher_version="$(highest-version "$version" "$app_version")"
    putd version
    putd app_version
    putd higher_version

    # check if we already have a higher version
    [[ -n "$app_id" ]] && [[ "$higher_version" = "$app_version" ]] && continue
    app_version="$version"

    app_id="$manifest"
    app_id="${app_id##*Extensions/}"
    app_id="${app_id%%/*}"
  done

  [[ -z "$app_id" ]] && return 1
  echo "$app_id"
}

highest-version() {
  semver "$@" | tail -1
}

lineapp() {
  chrome-app LINE
}

netflix() {
  $CHROME_COMMAND --app=https://netflix.com/
}

wanikani() {
  $CHROME_COMMAND --app=https://www.wanikani.com/
}
