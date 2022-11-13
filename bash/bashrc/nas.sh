#!/bin/bash

is-local || return 0
is-linux && MOUNT_PREFIX=/mnt
is-mac && MOUNT_PREFIX=$HOME/mnt

fix-macfuse() {
  sudo kextunload -b io.macfuse.filesystems.macfuse
}

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
  mount-squash "$MOUNT_PREFIX/nas/backups/$fname.squashfs" "$fname"
}

mount-squash() {
  local fname="$1"; shift
  local name="$1"; shift

  [[ -z "$name" ]] && {
    name="${fname##*/}"
    name="${name%.*}"
  }

  execd squashfuse "$fname" "$MOUNT_PREFIX/$name" -o allow_other -o volname="$name" "$@"
}

mount-guanyin() {
  mount-sshfs guanyin guanyin:/var/public
}

umount-all() {
  echo pass
}

is-mac && {
  umount-all() {
    for f in "$MOUNT_PREFIX"/*; do
      diskutil unmount force "$f"
    done

    diskutil unmount force /Volumes/qvo
  }
}

um() { umount-all "$@"; }

cinnamon() {
  mount-squash ~/tmp/cinnamon.squashfs
}

