is-mac && {
  POSTGRES_PREFIX=/usr/local/var/postgres
}

exists pg_ctl && [[ -n "$POSTGRES_PREFIX" ]] && {
  pg() {
    pg_ctl -D "$POSTGRES_PREFIX" "$@"
  }

  pg-console() {
    psql -D "$POSTGRES_PREFIX" "$@"
  }

  pg-restore() {
    local db_name="$1"; shift
    local fname="$1"; shift
    pg_restore --verbose --clean -drop --no-acl --no-owner -h localhost -j 6 -d "$db_name" "$fname" "$@"
  }
}
