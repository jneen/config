throttle() {
  local times="$1"; shift
  local seconds="$1"; shift

  local t="$(date +%s)"
  local count=0

  while IFS="\n" read line; do
    local new_t="$(date +%s)"
    # putd new_t
    # putd t
    # putd seconds
    interval=$(expr $new_t - $t)
    if [[ $interval -lt "$seconds" ]]; then
      count=$(expr $count + 1)
      [[ $count -gt $times ]] && return 1
    else
      count=0
      t="$new_t"
    fi

    echo "$line"
  done
}
