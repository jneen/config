#!/bin/bash

is-mac && {
  reboot() {
    launchctl reboot
  }

  poweroff() {
    launchctl shutdown
  }
}
