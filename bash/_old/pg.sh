#!/bin/bash

export PG_ROOT="$HOME/.local/lib/postgres"
export PG_LOG="$HOME/.local/log/postgres.log"

pg:start() {
  pg_ctl -D "$PG_ROOT" -l "$PG_LOG" start
}
