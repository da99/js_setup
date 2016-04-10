
# === {{CMD}}
shrinkwrap () {
  echo "=== NPM shrinkwrapping modules..."

  # === "npm shrinkwrap" will fail if extraneous
  #     modules are found. "npm prune" takes care
  #     of this.
  npm prune

  if grep --extended-regexp ':\s+"latest' package.json ; then
    echo "=== Skipping shrinkwrap because \"latest\" string found in package.json" 1>&2
  else
    npm shrinkwrap
    # git add npm-shrinkwrap.json
    # git commit -m "Shrinkwrapped npm modules."
  fi
} # === end function
