
# === {{CMD}}  -args
sassc () {
  # export SASS_LIBSASS_PATH=/progs/libsass
  if [[ ! -d "/progs/sassc" ]]; then
    cd /progs
    js_setup install-sass
  fi
  /progs/sassc/bin/sassc "$@"
} # === end function
