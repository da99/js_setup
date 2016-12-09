
# === {{CMD}}           my args to eslint binary
# === {{CMD}}  browser  my args to eslint binary
# === {{CMD}}  node     my args to eslint binary
eslint () {
  local +x STAT=0
  local +x CONFIG="$THIS_DIR/browser.eslintrc"

  if [[ "$1" == "browser" ]]; then
    shift
  fi

  if [[ "$1" == "node" ]]; then
    CONFIG="$THIS_DIR/node.eslintrc"
    shift
  fi

  command eslint -c "$CONFIG" "$@" || {
    STAT=$?
    if ! which --skip-functions eslint; then
      sh_color BOLD "=== Installing: {{eslint}}" >&2
      npm install -g eslint >&2
      $0 eslint "$@"
    fi
    exit $STAT
  }
} # === end function
