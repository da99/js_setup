
# TODO: Specs
# when js errors file names are http://localhost/file.js:100:23
# when js errors file names are http://localhost:1234/file.js:100:8
# when js errors file names are some/file.js:100:8

# === node my-script 2>&1 | {{CMD}}
map-errors-to-files () {
  err_found=""
  dirs="lib/"
  if [[ -n "$@" ]]; then
    dirs="$@"
  fi
  while IFS= read LINE; do
    if [[ "$LINE" == *"   at "* ]]; then

      new_line="$(echo $LINE | tr -s ' ')"
      func_name="$(echo $new_line | cut -d' ' -f 2)"
      file="$(echo $new_line | grep -Po '\(\K(.+?)(?=:[0-9]+:[0-9]+\))')"
      if [[ "$file" == *"://"* ]]; then
        file="$(echo "$file" | cut -d'/' --complement -f1-3)"
      fi
      num="$(echo $new_line | grep -Po '\(.+?:\K([0-9]+)(?=:[0-9]+\))')"
      line="$([[ -f "$file" ]] && sed -n -e ${num}p "$file" || :)"

      ag_results=""
      if [[ -n "$line" ]]; then
        ag_results="$(ag --follow --vimgrep --literal "$line" $dirs || :)"
      fi

      if [[ -z "$ag_results" ]]; then
        echo "$LINE"
      else
        while IFS= read RESULT; do
          echo -e -n "  ${Green}$func_name${Color_Off} -> "
          echo -e "${BGreen}$(echo $RESULT | cut -d':' -f1)${Color_Off} ${BRed}@${Color_Off} ${Bold}$(echo $RESULT | cut -d':' -f2)${Color_Off}"
          echo -e -n "    ${BOrange}"
          echo -e $(echo $RESULT | cut -d':' --complement  -f1-3)${Color_Off}
          echo "-----------------------------------------------------------------"
        done < <(echo "$ag_results")
      fi

      err_found="yes"
    else
      echo "$LINE"
    fi
  done
 # < <(node lib/node.spec.js test 2>&1) # || { stat=$?; echo -e "=== ${Red}Failed${Color_Off}" 1>&2; exit $stat; })

  [[ -z "$err_found" ]] && exit 0 || :
  exit 1
} # === end function
