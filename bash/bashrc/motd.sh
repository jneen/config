motd() {
  case `hostname` in
    guanyin) cat <<-motd

welcome to guanyin

      \*/
      3^v
     (-*-)
    .(   ).
    (_/___)
motd
    ;;
    *)
  c 7

  cat <<-motd

   )\`(
  (   ) hello
    |/
motd
      ;;
  esac
}

is-interactive && motd
