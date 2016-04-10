
# === {{CMD}}  major|minor|patch
bump-commit () {

  if [[ ! -f bower.json && ! -f package.json ]]; then
    mksh_setup RED "!!! Could not determine how to {{bump version}}. No bower.json, package.json found."
    exit 1
  fi

  $0 upgrade
  $0 js_clean

  local +x NEW_VERSION="$(git_setup bump $@)"

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
    fi

    if [[ -f package.json ]] ; then
      js_setup update-key "package.json" "version" "$NEW_VERSION"
      git add package.json
      git commit -m "Bump: package.json -> $NEW_VERSION"
    fi

    git push
  fi # === package.json

  if ! git_repo_is_clean; then
    echo "=== Git repo is not clean" 1>&2
    git status
    exit 1
  fi

  git_setup bump-commit "$@"
} # === end function
