
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
} # === end function
