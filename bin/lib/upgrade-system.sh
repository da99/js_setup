
# === {{CMD}}
upgrade-system () {
  $0 install
  echo "=== Checking npm global packages"
  npm outdated -g
} # === end function
