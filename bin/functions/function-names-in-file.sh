# === Prints out the names of the functions in file:
# ===    __  function-name  "file"
# ===    echo something | __  function-name

function-names-in-file () {
  grep -Pzo '^function \K(.+?)(?=\()' "$@"
}
