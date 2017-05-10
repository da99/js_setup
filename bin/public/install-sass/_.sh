
# === {{CMD}}
# === Installs SassC
install-sass () {
  cd /progs
  my_git clone-or-pull https://github.com/sass/sassc
  my_git clone-or-pull https://github.com/sass/libsass
  export SASS_LIBSASS_PATH=/progs/libsass
  cd /progs/sassc
  make
} # === end function
