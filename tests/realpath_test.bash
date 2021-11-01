#!/usr/bin/env bash
#
# @author Zeus Intuivo <zeus@intuivo.com>
#
#!/usr/bin/env bash
# ----
# ---- loading Error sudo - start

export THISSCRIPTCOMPLETEPATH
typeset -r THISSCRIPTCOMPLETEPATH="$(basename "$0")"   # § This goes in the FATHER-MOTHER script
export _err
typeset -i _err=0

typeset -r THISSCRIPTNAME="$(basename "$0")"
typeset -r THISPWD="$(pwd)"
# . ./error_boot_load_sudo.bash

# ---- loading Error sudo - end
# ----



# ----
# ---- test area - start


CONFIGFILE='realpath'
# ----
# ---- before do - start
#. ../realpath
# ---- before do - end
# ----
function realpath() { # Macos after BigSur is missing realpath  # updated realpath macos 20210924
    local _our_pwd="${PWD}"
    cd "$(dirname "${1}")"
    local _link=""
    _link=$(readlink $(basename ${1}))
    while [ "${_link}" ]; do
      cd $(dirname ${_link})
      _link=$(readlink $(basename ${1}))
    done
    local _resolved_path=""
    _resolved_path="${PWD}/$(basename "${1}")"
    cd "${_our_pwd}"
    echo "${_resolved_path}"
    return 0
}

echo 1:$(realpath "${HOME}")
echo 1:$(realpath "${HOME}/..")
 # "${HOME}"
exit 0

function test_end_home(){
  local  testing msg
  local -i err
  testing=$(realpath "${HOME}"  2>&1)
  # testing="${HOME}"
  err=$?
  # DEBUG=1
  (( DEBUG )) && echo "${testing}"
  msg=$(echo "${testing}" | tail -1)
  # DEBUG=0
  [ ${err} -ne 0 ]  && echo "Error testing  ${FUNCNAME[-0]} value from ${CONFIGFILE} " && exit 1
  # DEBUG=1
  expect "${testing}" to contain "${HOME}"
  # exit 0
  return 0
}

function test_end_dotdot(){
  local  testing msg
  local -i err
  testing=$(realpath "${HOME}/../"  2>&1)
  # testing="${HOME}"
  err=$?
  # DEBUG=1
  (( DEBUG )) && echo "${testing}"
  msg=$(echo "${testing}" | tail -1)
  # DEBUG=0
  [ ${err} -ne 0 ]  && echo "Error testing  ${FUNCNAME[-0]} value from ${CONFIGFILE} " && exit 1
  # DEBUG=1
  expect "${testing}" to contain "${HOME}"
  # exit 0
  return 0
}

function test_end_dotdot_clis(){
  local  testing msg
  local -i err
  testing=$(realpath "${HOME}/_/../_/clis/"  2>&1)
  err=$?
  # DEBUG=1
  (( DEBUG )) && echo "${testing}"
  # msg=$(echo "${testing}" | tail -1)
  # DEBUG=0
  [ ${err} -ne 0 ]  && echo "Error testing  ${FUNCNAME[-0]} value from ${CONFIGFILE} " && exit 1
  # DEBUG=1
  expect "${testing}" to equal "${HOME}/_/clis"
  # exit 0
  return 0
}



# ---- test area - end
# ----
# bash_loop_tsts
test_end_home
# test_end_dotdot
function load_tsts_from_declarations(){
    local content=$(declare -F)
    local LOCAL_DEBUG=1
    enforce_variable_with_value content "$content"
    # (( LOCAL_DEBUG )) && echo "${content}"
    echo "${content}" | grep "function test_"
    local alltests=$(echo "${content}" | grep "declare -f test_" | sed 's/declare -f\ test_//' | grep -v 'positives' | uniq )
    enforce_variable_with_value alltests "$alltests"
    (( LOCAL_DEBUG )) && echo "${alltests}"
    for one in ${alltests} ; do
    {
      [[ -z "$one" ]] && continue # is not empty

      Testing "test_$one"
      test_${one}
      # "${one}"
    }
    done <<< "${alltests}"
  }

. ./test_loader.bash
load_tsts_from_declarations
exit 0


