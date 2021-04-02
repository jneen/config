#!/bin/bash

is-local || return 0
is-linux && MOUNT_PREFIX=/mnt
is-mac && MOUNT_PREFIX=$HOME/mnt

mount-nas() {
  mkdir -p $MOUNT_PREFIX/nas
  sshfs jneen@nas.wifesquad.little: $MOUNT_PREFIX/nas -o volname=nas
}

mount-backup() {
  local fname="$1"; shift
  [[ -d $MOUNT_PREFIX/nas/backups ]] || mount-nas
  mkdir -p $MOUNT_PREFIX/"$fname"
  squashfuse $MOUNT_PREFIX/nas/backups/"$fname".squashfs $MOUNT_PREFIX/"$fname" -o allow_other -o volname="$fname"
}

is-mac && {
  umount-nas-all() {
    for f in "$MOUNT_PREFIX"/*; do
      diskutil unmount force "$f"
    done
  }
}
