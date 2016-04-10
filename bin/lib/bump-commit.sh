
# === {{CMD}}  major|minor|patch
bump-commit () {

  if [[ ! -f bower.json && ! -f package.json ]]; then
    mksh_setup RED "!!! Could not determine how to {{bump version}}. No bower.json, package.json found."
    exit 1
  fi

  mksh_setup BOLD "=== {{Upgrading}} packages/modules..."
  $0 upgrade
  $0 js_clean
  if ! git_repo_is_clean; then
    echo "=== Git repo is not clean" 1>&2
    git status
    exit 1
  fi

  local +x NEW_VERSION="$(git_setup bump $@)"
  local +x NEW_NUM=${NEW_VERSION/v/}

  if [[ -f package.json ]] ; then
    js_setup update-key "package.json" "version" "$NEW_NUM"
    git add package.json
    git commit -m "Bump: package.json -> $NEW_VERSION"
  fi

  git tag "$NEW_VERSION"
  git push origin "$NEW_VERSION"
  git push
} # === end function


specs () {
  init () {
    local +x TEMP="/tmp/js_setup/bump-commit/"
    rm -rf "$TEMP"
    mkdir -p "$TEMP"
    cd "$TEMP"

    git init --bare github.pseudo.git
    git clone github.pseudo.git repo
    cd repo
    echo '{"name":"testrepo","version":"0.0.0","dependencies":{}}' > package.json
    git init
    git add package.json
    git commit -m "Init"
    git push
  }
  init >/dev/null 2>&1

  should-match "0.0.0" "$(js_setup read-key package.json  version)"  "[init test]"

  js_setup bump-commit minor >/dev/null 2>&1
  should-match "0.1.0" "$(js_setup read-key package.json  version)"  "bump-commit minor"

  js_setup bump-commit major >/dev/null 2>&1
  should-match "1.0.0" "$(js_setup read-key package.json  version)"  "bump-commit major"


  js_setup bump-commit patch >/dev/null 2>&1
  should-match "1.0.1" "$(js_setup read-key package.json  version)"  "bump-commit patch"

  should-match "v1.0.1" "$(git tag -l | sort -r | head -n 1)"      "git tags"
} # === specs ()

