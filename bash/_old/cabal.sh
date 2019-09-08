pathshift "$HOME/.cabal/bin"

cabal-repl() {
  [[ -s .cabal-sandbox ]] || { echo "not a cabal sandbox" >&2; return 1; }

  package_db="$(echo .cabal-sandbox/*-packages.conf.d | cut -d' ' -f1)"

  ghci -no-user-package-db -package-db "$package_db"
}
