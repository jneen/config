#!/bin/bash

is-local || return 0
is-linux && MOUNT_PREFIX=/mnt
is-mac && MOUNT_PREFIX=$HOME/mnt

mount-sshfs() {
  local name="$1"; shift
  local ssh_path="$1"; shift

  mkdir -p "$MOUNT_PREFIX/$name"
  sshfs "$ssh_path" "$MOUNT_PREFIX/$name" -o volname="$name"
}

mount-nas() {
  mount-sshfs nas jneen@nas1.wifesquad.zone:
}

mount-backup() {
  local fname
  local force
  local arg

  while [[ $# -gt 0 ]]; do
    arg="$1"; shift
    case "$arg" in
      -f) force=1 ;;
      *) fname="$arg" ;;
    esac
  done

  [[ -n "$force" ]] && umount-nas-all

  [[ -d $MOUNT_PREFIX/nas/backups ]] || mount-nas
  mkdir -p $MOUNT_PREFIX/"$fname"
  squashfuse $MOUNT_PREFIX/nas/backups/"$fname".squashfs $MOUNT_PREFIX/"$fname" -o allow_other -o volname="$fname"
}

mount-guanyin() {
  mount-sshfs guanyin guanyin:/var/public
}

umount-nas-all() {
  echo pass
}

is-mac && {
  umount-nas-all() {
    for f in "$MOUNT_PREFIX"/*; do
      diskutil unmount force "$f"
    done
  }
}
