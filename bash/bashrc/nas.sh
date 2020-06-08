#!/bin/bash

is-linux && MOUNT_PREFIX=/mnt
is-mac && MOUNT_PREFIX=$HOME/mnt

mount-nas() {
  mkdir -p $MOUNT_PREFIX/nas
  sshfs jneen@nas.wifesquad.little: $MOUNT_PREFIX/nas
}

mount-backup() {
  local fname="$1"; shift
  [[ -d $MOUNT_PREFIX/nas/backups ]] || mount-nas
  mkdir -p $MOUNT_PREFIX/"$fname"
  squashfuse $MOUNT_PREFIX/nas/backups/"$fname".squashfs $MOUNT_PREFIX/"$fname"
}
