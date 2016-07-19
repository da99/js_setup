
specs () {
  local +x TEMP="/tmp/js_setup/update-key"
  rm -rf "$TEMP"
  mkdir -p "$TEMP"
  cd "$TEMP"

  echo '{"version":"v1.0.0"}' >file.json

  js_setup update-key "file.json"  "version"  "v2.0.0" >/dev/null
  should-match '{"version":"v2.0.0"}'  "$(cat file.json)"  "update-key file key val"

} # === specs

specs
