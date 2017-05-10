
source "$THIS_DIR"/bin/public/compile-node/_.sh

# === {{CMD}}
# === {{CMD}}  PREFIX
install-node () {
  if [[ -z "$@" ]]; then
    export PREFIX="/progs/node-current"
  else
    export PREFIX="$1"; shift
  fi

  local DESTDIR="$(mktemp -d || echo "/tmp/node-install-$(date '+%M-%D-%S-$H')")"

  local ARCH="$(lsb_release --codename | cut -f2)"

  # === Install computer packages:
  if [[ "$ARCH" == "void" ]]; then
    sudo xbps-install -S nodejs || {
      local +x STAT="$?"
      if [[ ! "$STAT" -eq 6 ]]; then
        exit $?
      fi
    }
    return
  fi # === if $ARCH

  # === install  # Installs: node_build, node

  # === install: node_build
  cd /progs
  echo -n "=== Installing/updating $(sh_color YELLOW node-build): "
  my_git clone-or-pull https://github.com/nodenv/node-build /progs/
  node_build="/progs/node-build/bin/node-build"

  # === install: node
  mkdir -p "$PREFIX"
  latest="$($THIS_SCRIPT latest)"

  if [[ ! -d "$PREFIX"/$latest ]]; then
    echo "=== Installing node: $latest"
    $node_build "$latest" "$PREFIX"/$latest
  fi

  MSG="Already installed:"
  current="/progs/node/current"
  if [[ "$(readlink -f "$current")" != "$(readlink -f "/progs/node/$latest")" ]]; then
    if [[ -L "$current" ]]; then
      rm "$current"
    fi
    ln -s /progs/node/$latest "$current"
    packages="jshint npm-check-updates bower eslint"
    npm install -g $packages
    echo -n "=== Installing $(sh_color YELLOW $packages)... "
    MSG="Installed:"
  fi

  if [[ "$(type node)" != *"$PREFIX/"* ]] || ! node -v ; then
    echo "!!! Something went wrong" 1>&2
    exit 1
  fi

  sh_color  YELLOW  "=== $MSG: {{$(node -v)}}"
  return 0

  # === $ ... install VERSION
  # === Uses NVM to install a node version.
  # $0 nvm install $@
  mkdir -p /progs/node
  cd $PREFIX
  dir="node-${latest}-linux-x64"
  archive="${dir}.tar.gz"
  if [[ ! -d "$dir" ]]; then
    rm -f "$archive"
    wget "https://nodejs.org/dist/$latest/$archive"
    tar xvzf "$archive"
  fi
  cd "$dir"
  ./configure
  make
  make install

  local LATEST="$( ls $PREFIX | grep -P '^\d+\.\d+\.\d+$' | sort -r | head -n 1 )"
  local OLD="$( ls $PREFIX | grep -P '^\d+\.\d+\.\d+$' | sort -r | tail -n 1 )"
  if [[ "$OLD" != "$LATEST" ]]; then
    sh_color BOLD "=== Trashing: {{$OLD}}"
    trash-put "$PREFIX/$OLD"
  fi

} # === end function
