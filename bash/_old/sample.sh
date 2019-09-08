sample() {
  local hold
  local i=0

  while read line; do
    i=$(($i + 1))
    local sel=$(($RANDOM % $i))
    [[ 0 = $(($RANDOM % $i)) ]] && hold="$line"
  done

  echo "$hold"
}
