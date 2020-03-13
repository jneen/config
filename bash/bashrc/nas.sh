#!/bin/bash

mount-nas() {
  sshfs jneen@nas.wifesquad.little: /mnt/nas
}

mount-backup() {
  local fname="$1"; shift
  [[ -d /mnt/nas/backups ]] || mount-nas
  mkdir -p /mnt/"$fname"
  squashfuse /mnt/nas/backups/"$fname".squashfs /mnt/"$fname"
}
