
# === {{CMD}}
# === {{CMD}}  PREFIX
compile-node () {
  if [[ -z "$@" ]]; then
    export PREFIX="/progs/node"
  else
    export PREFIX="$1"; shift
  fi

  local ARCH="$(lsb_release --codename | cut -f2)"

  # === Install computer packages:
  if [[ "$ARCH" == "void" ]]; then
    echo '=== Installing packages:'
    sudo xbps-install -S \
      zlib-devel        python-devel icu-devel \
      libressl-devel    libuv-devel \
      http-parser-devel python || {
        STAT=$?
        if [[ "$STAT" != 6 ]]; then
          exit $STAT
        fi
      }
  fi # === if $ARCH

  mkdir -p "$PREFIX"
  cd "/progs"
  if [[ -d node-src ]]; then
    cd node-src
    git checkout master
    git pull
  else
    git clone https://github.com/nodejs/node node-src
    cd node-src
  fi

  local +x LATEST=$(git tag | grep -P '^v\d+\.\d+\.\d+$' | sort -V -r | head -n 1)

  git checkout "$LATEST"
  PREFIX="$PREFIX/$LATEST"

  if [[ -s "$PREFIX/bin/node" ]]; then
    echo "=== Already installed: $("$PREFIX"/bin/node -v)"
    return 0
  fi

  ./configure \
    --prefix="$PREFIX"   \
    --with-intl=system-icu \
    --shared-zlib        \
		--shared-http-parser \
		--shared-libuv

  local +x CPU_COUNT=$(grep -c ^processor /proc/cpuinfo)
  make -j $CPU_COUNT LDFLAGS+=-ldl
  make -j $CPU_COUNT LDFLAGS+=-ldl install

  "$PREFIX"/bin/node -v
} # === end function

