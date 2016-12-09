
# === {{CMD}} ...
install-node () {
  local PREFIX="/progs/node"


  # === install  # Installs: node_build, node

  # === install: node_build
  cd /progs
  echo -n "=== Installing/updating $(sh_color colorize YELLOW node-build): "
  git_setup clone-or-pull https://github.com/nodenv/node-build /progs/
  node_build="/progs/node-build/bin/node-build"

  # === install: node
  mkdir -p /progs/node/
  latest="$($THIS_SCRIPT latest)"

  if [[ ! -d /progs/node/$latest ]]; then
    echo "=== Installing node: $latest"
    $node_build "$latest" /progs/node/$latest
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
    echo -n "=== Installing $(sh_color colorize YELLOW $packages)... "
    MSG="Installed:"
  fi

  final="$(type node)"
  if [[ "$final" != */progs/node/current/* ]]; then
    echo "!!! Something went wrong: $final" 1>&2
    exit 1
  fi

  echo "=== $MSG: $(sh_color colorize YELLOW "$(node -v)") and $final"
  exit 0
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
