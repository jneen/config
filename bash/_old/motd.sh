motd() {
  cal -3

  cat <<-motd
   )\`(
  (   ) hello
    |/
motd

}

is-interactive && motd
