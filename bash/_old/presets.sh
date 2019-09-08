PRESET_DIR="$HOME/.presets"

preset() {
  local name="$1"; shift
  [[ -z "$name" ]] && name=default
  local preset_file="$PRESET_DIR/$name.sh" 
  [[ -s "$preset_file" ]] && . "$preset_file"
}

alias p=preset

__complete_preset() {
  __complete_files "$PRESET_DIR" .sh
}

is-interactive && complete -F __complete_preset preset p
