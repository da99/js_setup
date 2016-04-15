
# === {{CMD}}
# === Installs SassC
install-sass () {
  cd /progs
  git_setup clone-or-pull https://github.com/sass/sassc
  git_setup clone-or-pull https://github.com/sass/libsass
  export SASS_LIBSASS_PATH=/progs/libsass
  cd /progs/sassc
  make
} # === end function
