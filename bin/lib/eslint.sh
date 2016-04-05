
# === {{CMD}}  my args to eslint binary
eslint () {
  local +x STAT=0
  command eslint -c "$THIS_DIR/.eslintrc" "$@" || {
    STAT=$?
    if ! which --skip-functions eslint; then
      mksh_setup BOLD "=== Installing: {{eslint}}" >&2
      npm install -g eslint >&2
      $0 eslint "$@"
    fi
    exit $STAT
  }
} # === end function
