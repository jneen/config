#!/bin/bash

is-linux && {
  export AUDIO_DEFAULT_CAPTURE=hw:PCH
  export AUDIO_DEFAULT_PLAYBACK=hw:PCH

  execd() {
    echo "$@" >&2
    "$@"
  }

  # dbus-jack() {
  #   dbus-send --dest=org.jackaudio.service --print-reply "$@"
  # }
  # 
  # dbus-jack-controller() {
  #   local method="$1"; shift
  #   echo "--- $method" >&2
  #   dbus-jack /org/jackaudio/Controller org.jackaudio.JackControl."$method" "$@"
  # }

  # pulse-unload() {
  #   local mod
  #   for mod in "$@"; do
  #     pactl list-modules | fgrep -q "$mod" \
  #       && execd pactl unload-module "$mod"
  #   done
  # }

  audio-cleanup() {
    jack_control status || jack_control exit || return $?

    jack_control ds dummy

    # if jack isn't running, we try to just start it with jack_control.
    # sometimes this doesn't work because there's a zombie'd jackd
    # running somewhere. (yes, even though we have `exit` above).
    # we have to clean this up and unload the pulse modules so they
    # can get re-loaded later.
    jack_control status || jack_control start || {
      echo '---- zombied jack server'
      ps aux | grep jackd | grep -v grep
      pactl unload-module module-jack-sink
      pactl unload-module module-jack-source
      killall -9 jackd jackdbus
      jack_control start
    }

    jack_control sm

    pactl info || pulseaudio --start

    pulse-connect sink pulse-sink jack-sink
    pulse-connect source pulse-source jack-source
    # pulse-connect source pulse-monitor jack-monitor
    chrt -p 50 $(pgrep jackdbus)
  }

  pulse-connect() {
    jack_control status || return $?
    local dir="$1"; shift
    local jack_name="$1"; shift
    local pulse_name="$1"; shift

    jack_lsp | fgrep -q "$jack_name" && return

    pactl load-module module-jack-"$dir" \
      channels=2 client_name="$jack_name" \
      "$dir"_name="$pulse_name" \
      "$@"
  }

  audio-setup() {
    audio-cleanup || return $?

    jack_control ds alsa
    jack_control dps playback "$AUDIO_DEFAULT_PLAYBACK"
    jack_control dps capture "$AUDIO_DEFAULT_CAPTURE"

    local playback

    while [[ $# -gt 0 ]]; do
      local a="$1"; shift
      case "$a" in
        -o|--option)
          local opt_name="$1"; shift
          local opt_val="$1"; shift
          [[ -z "$opt_name" ]] && (echo invalid option >&2; return 1)
          [[ -z "$opt_val" ]] && (echo invalid option "$opt_name" >&2; return 1)
          jack_control dps "$opt_name" "$opt_val"
        ;;
        -*)
          echo "no such option $a" >&2
          return 1
        ;;
        *)
          if [[ -z "$playback" ]]; then
            playback=1
            jack_control dps playback "$a"
          else
            jack_control dps capture "$a"
          fi
        ;;
      esac
    done

    jack_control dp
    jack_control sm || return $?
    echo 'no exception'

    patch_pulse
  }

  jack_patch() {
    local a b
    paste <(jack_lsp | fgrep "$1" | sort) <(jack_lsp | fgrep "$2" | sort) \
      | while IFS="$TAB" read a b; do
        [[ -z "$a" ]] && break
        [[ -z "$b" ]] && break
        is-jack-connected "$a" "$b" || execd jack_connect "$a" "$b"
      done
  }

  is-jack-connected() {
    local source="$1"; shift
    local sink="$1"; shift

    jack_lsp -c "$source" | tail -n+2 | fgrep -q "$sink"
  }

  patch_pulse() {
    jack_patch system:capture pulse-source
    jack_patch system:playback pulse-sink
  }

  patch_renoise() {
    jack_patch system:playback renoise:output
    jack_patch system:capture renoise:input
  }

  patch_bitwig() {
    jack_patch system:playback 'Bitwig Studio:Speakers'
    jack_patch system:capture 'Bitwig Studio: Stereo In'
  }

  # patch_sc() {
  #   jack_lsp | fgrep SuperCollider:out | head -2 | patch_playback
  #   jack_lsp | fgrep SuperCollider:in | head -2 | patch_capture
  # }

  # headphones() {
  #   amixer -D hw:PCH sset Speaker off
  #   sudo headphone-hack
  # }
  # 
  # speaker() {
  #   amixer -D hw:PCH sset Speaker on
  # }

  # TODO: bluetooth, setup with pulse, hooked to jack applications through the "monitor" connection to pulse
  # btc() { bluetoothctl "$@" ;}
  # btheadphones() {
  #   # ALSA_OUT_OPTS='-p 1066 -n 9 -c 2 -t 0' audio-setup bluealsa "$@"
  # 
  #   # 2400 samples * 2 channels * 10 periods = 48000
  #   # ALSA_OUT_OPTS='-p 1024 -n 9 -c 2 -t 0' audio-setup bluealsa "$@"
  #   ALSA_OPTS='-c 2 -t 0 -v -n 9' audio-setup bluealsa "$@"
  #   # audio-setup bluealsa "$@"
  # }

  # bconnect() {
  #   echo power on | btc
  #   sys restart bluealsa
  #   (echo connect 70:26:05:3A:AE:DC; sleep 5) | btc && \
  #   btheadphones
  # }
}
