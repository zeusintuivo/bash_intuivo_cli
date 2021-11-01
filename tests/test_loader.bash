#!/usr/bin/env bash

# set -xE -o functrace

# ----
# ---- loading Error sudo - start

# typeset -gr THISSCRIPTNAME="$(pwd)/$(basename "$0")"
# typeset -gr THISPWD="$(pwd)"
. ./error_boot.bash

# ---- loading Error sudo - end
# ----

function Describe(){
  echo -e "\033[38;5;93m "" \033[38;5;123m ${*}";
}
# function Test(){
#   echo -e "\033[38;5;93m === \033[38;5;241m ${1} \033[38;5;93m ${2} \033[38;5;123m echo ${*:3} \033[38;5;93m === \033[38;5;241m "
# }
function bash_loop_tsts(){
  alias it=function
  local -i err
  err=0
  # LOCAL_DEBUG=1
  local alltests alltests1 alltests2 alltests3 alltests4 alltests
  local thisname=$(basename "$0")
  (( LOCAL_DEBUG )) && echo -en "${CYAN}"
  (( LOCAL_DEBUG )) && echo -e "${YELLOW}......thisname:${GREEN}${thisname}"
  (( LOCAL_DEBUG )) && echo -e "${YELLOW}THISSCRIPTNAME:${GREEN}${THISSCRIPTNAME}"
  (( LOCAL_DEBUG )) && echo -e "${YELLOW}........caller:${GREEN}$(caller)"
  # source "${thisname}"
  # (( LOCAL_DEBUG )) && exit 0
  local one content

  # function load_tsts_from_caller_file(){
  #   content=$(<"${thisname}") # reload from another caller, loading this from same file, breaks
  #   enforce_variable_with_value content "$content"
  #   # echo "${content}"
  #   # (( LOCAL_DEBUG )) && exit 0
  #   # echo "${content}"| grep "function test_" | cüt "function test_"| cüt "(){" | cüt "}"
  #   # alltests=$(echo "${content}" | grep "function test_" | cüt "function test_" | cüt "(){" | cüt "}" | grep -v "^#")
  #   alltests=$(echo "${content}" | grep "function test_" | sed 's/function\ test_//' | sed "s/(){//" | sed 's/}//'| grep -v "^#")
  # }
  function load_tsts_from_declarations(){
    content=$(declare -F)
    enforce_variable_with_value content "$content"
    (( LOCAL_DEBUG )) && echo "${content}"
    echo "${content}" | grep "function test_"
    alltests=$(echo "${content}" | grep "declare -f test_" | sed 's/declare -f\ test_//' | grep -v 'positives' | uniq )
    enforce_variable_with_value alltests "$alltests"
  }
  load_tsts_from_declarations
  # TEST: echo -n '# function test_calendar_using_name_not_found_delete(){' | grep "function test_" | sed 's/function\ test_//' | sed "s/(){//" | sed 's/}//'| grep -v "^#"
  # alltests=$(echo "${content}" | grep "function test_"  | cüt "(){" | cüt "}" | grep -v "^#")
  (( LOCAL_DEBUG )) && echo "${alltests}"
  # alltests=$(echo "${alltests}\n${content}" | grep "function should_" | cüt "function should_" | cüt "(){" | cüt "}")
  # alltests=$(echo "${alltests}\n${content}" | grep "function must_" | cüt "function must_" | cüt "(){" | cüt "}")
  # alltests=$(echo "${alltests}\n${content}" | grep "it test_" | cüt "it test_" | cüt "(){" | cüt "}")
  # alltests=$(echo "${alltests}\n${content}" | grep "it should_" | cüt "it should_" | cüt "(){" | cüt "}")
  # alltests=$(echo "${alltests}\n${content}" | grep "it must_" | cüt "it must_" | cüt "(){" | cüt "}")
  (( LOCAL_DEBUG )) && echo "${alltests}"
  (( LOCAL_DEBUG )) && Testing ${alltests} ${alltests}
  (( LOCAL_DEBUG )) && Describe "${thisname}"
  # LOCAL_DEBUG=1
  # (( LOCAL_DEBUG )) && exit 0
  for one in ${alltests} ; do
  # while read -r one ; do
  {
    [[ -z "$one" ]] && continue # is not empty

    Testing "test_$one"
    test_${one}
    # "${one}"
  }
  done <<< "${alltests}"
  # (( LOCAL_DEBUG )) && exit 0
  # calendar_add
  # err=$?
  # [ ${err} -ne 0 ]  && echo "Error calendar_add ${seeking} value from ${configfile} " && exit 1
  echo 🍺
  return 0
} # end bash_loop_tsts
