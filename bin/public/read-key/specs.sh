
specs () {

  local +x TEMP="$(mktemp)"
  cd /tmp
  echo '{"key1":"123"}' >"$TEMP"

  should-match-stdout "123"  "js_setup read-key $TEMP  key1"

  rm -f "$TEMP"

} # === specs ()
specs
