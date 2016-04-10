
# === {{CMD}}
# === upgrade  # Global if package.json, bower.json not found.
upgrade () {
  if [[ -f package.json ]]; then
    npm prune
    npm update --save
    ncu -u
  fi

  if [[ -f bower.json ]]; then
    ncu -m bower
  fi

  if [[ ! -f package.json && ! -f bower.json ]]; then
    $0 install
    echo "=== Checking npm global packages"
    npm outdated -g
  fi
} # === end function
