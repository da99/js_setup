
# === {{CMD}}  major|minor|patch
bump-commit () {
  git push
  $0 upgrade
  $0 js_clean

  if [[ -f package.json ]]; then
    echo "=== NPM shrinkwrapping modules..."

    # === "npm shrinkwrap" will fail if extraneous
    #     modules are found. "npm prune" takes care
    #     of this.
    npm prune

    if grep --extended-regexp ':\s+"latest' package.json ; then
      echo "=== Skipping shrinkwrap because \"latest\" string found in package.json" 1>&2
    else
      npm shrinkwrap
      git add npm-shrinkwrap.json
      git commit -m "Shrinkwrapped npm modules."
      git push
    fi
  fi # === package.json

  if ! git_repo_is_clean; then
    echo "=== Git repo is not clean" 1>&2
    git status
    exit 1
  fi

  if [[ ! -f bower.json && ! -f package.json ]]; then
    mksh_setup RED "!!! Could not determine how to {{bump version}}. No bower.json, package.json found."
    exit 1
  fi

  if [[ -f package.json ]] ; then
    npm version $@
    git push origin "v$(node -p "require('./package.json').version")"
    git push
  fi

} # === end function
