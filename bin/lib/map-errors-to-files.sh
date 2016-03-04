
# === node my-script 2>&1 | {{CMD}}
map-errors-to-files () {
  err_found=""
  while IFS= read LINE; do
    if [[ "$LINE" == *"   at "* ]]; then
      new_line="$(echo $LINE | tr -s ' ')"
      func_name="$(echo $new_line | cut -d' ' -f 2)"
      file="$(echo $new_line | cut -d' ' -f 3 | cut -d'(' -f2 | cut -d':' -f1)"
      num="$(echo $new_line | cut -d' ' -f 3 | cut -d'(' -f2 | cut -d':' -f2)"
      line="$([[ -f "$file" ]] && sed -n -e ${num}p "$file" || :)"
      if [[ -n "$line" ]]; then

        while IFS= read RESULT; do
          echo -e -n "  ${Green}$func_name${Color_Off} -> "
          echo -e "${BGreen}$(echo $RESULT | cut -d':' -f1)${Color_Off} ${BRed}@${Color_Off} ${Bold}$(echo $RESULT | cut -d':' -f2)${Color_Off}"
          echo -e -n "    ${BOrange}"
          echo -e $(echo $RESULT | cut -d':' --complement  -f1-3)${Color_Off}
          echo "-----------------------------------------------------------------"
        done < <(ag --vimgrep --literal "$line" lib)

      else
        echo $LINE
      fi
      err_found="yes"
    else
      echo "$LINE"
    fi
  done < <(node lib/node.spec.js test 2>&1) # || { stat=$?; echo -e "=== ${Red}Failed${Color_Off}" 1>&2; exit $stat; })

  [[ -z "$err_found" ]] && exit 0 || :
  exit 1
} # === end function
