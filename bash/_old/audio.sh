#!/bin/bash

export JACK_IN="$HOME/.local/run/jack/in"
export JACK_OUT="$HOME/.local/run/jack/out"

audio-cleanup() {
echo audio-cleanup >> /tmp/audio-cleanup
  local playback="$1"; shift
  [[ -z "$playback" ]] && playback="$(cat "$JACK_OUT")"

  local capture="$1"; shift
  [[ -z "$capture" ]] && capture="$(cat "$JACK_IN")"

  local in_pf="$HOME/.local/run/jack/in-$capture.pid"
  local out_pf="$HOME/.local/run/jack/out-$playback.pid"

  [[ -s "$in_pf" ]] && echo "killing in proc $(cat "$in_pf") from $in_pf" >&2 && kill "$(cat "$in_pf")" && rm -f "$in_pf"
  [[ -s "$out_pf" ]] && echo "killing out proc $(cat "$out_pf") from $out_pf" >&2 && kill "$(cat "$out_pf")" && rm -f "$out_pf"
}

audio-setup() {
  local playback="$1"; shift
  [[ -z "$playback" ]] && playback=hw:PCH

  local capture="$1"; shift
  [[ -z "$capture" ]] && capture="$playback"

  audio-cleanup

  jack_control start
  jack_control ds dummy
  jack_control sm || return $?

  pulseaudio --start

  pactl unload-module module-jack-source
  pactl unload-module module-jack-sink

  pactl load-module module-jack-source channels=2
  pactl load-module module-jack-sink channels=2

  local inslug="input-${capture/:/_}"
  local outslug="output-${playback/:/_}"

  local in_pf="$HOME/.local/run/jack/in-$capture.pid"
  local out_pf="$HOME/.local/run/jack/out-$playback.pid"

  [[ -z "$ALSA_OPTS" ]] && ALSA_OPTS="-p 6144 -q 0 -c 2"
  [[ -z "$ALSA_IN_OPTS" ]] && ALSA_IN_OPTS="$ALSA_OPTS"
  [[ -z "$ALSA_OUT_OPTS" ]] && ALSA_OUT_OPTS="$ALSA_OPTS"

  run alsa_in $ALSA_IN_OPTS -d "$capture" -j "$inslug" > "$in_pf"
  run alsa_out $ALSA_OUT_OPTS -d "$playback" -j "$outslug" >"$out_pf"

  echo "$capture" > "$JACK_IN"
  echo "$playback" > "$JACK_OUT"

  # allow time for alsa_in and alsa_out to come online
  sleep 1
  patch_pulse
}

patch_capture() {
  local i=0
  local cap
  local jacksource="$(cat "$JACK_IN")"
  jacksource="input-${jacksource/:/_}"

  while read cap; do
    i=$(($i + 1))
    echo jack_connect "$cap" "$jacksource:capture_$i" >&2
    jack_connect "$cap" "$jacksource:capture_$i"
  done
}

patch_playback() {
  local i=0
  local play
  local jacksink="$(cat "$JACK_OUT")"
  jacksink="output-${jacksink/:/_}"

  while read play; do
    i=$(($i + 1))
    echo jack_connect "$play" "$jacksink:playback_$i" >&2
    jack_connect "$play" "$jacksink:playback_$i"
  done
}


patch_pulse() {
  jack_lsp | grep PulseAudio | grep Source | patch_capture
  jack_lsp | grep PulseAudio | grep Sink | patch_playback
}

patch_renoise() {
  jack_lsp | fgrep renoise:output | patch_playback
  jack_lsp | fgrep renoise:input  | patch_capture
}

patch_bitwig() {
  jack_lsp | fgrep 'Bitwig Studio:Speakers' | patch_playback
  jack_lsp | fgrep 'Bitwig Studio:Stereo Input' | patch_capture
}

patch_sc() {
  jack_lsp | fgrep SuperCollider:out | head -2 | patch_playback
  jack_lsp | fgrep SuperCollider:in | head -2 | patch_capture
}

headphones() {
  amixer -D hw:PCH sset Speaker off
  sudo headphone-hack
}

speaker() {
  amixer -D hw:PCH sset Speaker on
}

btc() { bluetoothctl "$@" ;}
btheadphones() {
  # ALSA_OUT_OPTS='-p 1066 -n 9 -c 2 -t 0' audio-setup bluealsa "$@"

  # 2400 samples * 2 channels * 10 periods = 48000
  # ALSA_OUT_OPTS='-p 1024 -n 9 -c 2 -t 0' audio-setup bluealsa "$@"
  ALSA_OPTS='-c 2 -t 0 -v -n 9' audio-setup bluealsa "$@"
  # audio-setup bluealsa "$@"
}

bconnect() {
  echo power on | btc
  sys restart bluealsa
  (echo connect 70:26:05:3A:AE:DC; sleep 5) | btc && \
  btheadphones
}
