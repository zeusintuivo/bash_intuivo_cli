#!/usr/bin/env bash

# Start loading Error sudo part
# Start loading Error sudo part
# Start loading Error sudo part
# Sample use Include this from the calling file:
# ----
# ---- loading Error sudo - start
#
# typeset -gr THISSCRIPTNAME="$(pwd)/$(basename "$0")"
# typeset -gr THISPWD="$(pwd)"
# . ./error_boot_load_sudo.bash
#
# ---- loading Error sudo - end
# ----


typeset -i _err=0

# -e (or -o errexit) option to the script, which will exit at the first error.
# -E (-o errtrace): Ensures that ERR traps (see below) get inherited by functions, command substitutions, and subshell environments.
# -u (-o nounset): Treats unset variables as errors.
# -o pipefail: normally Bash pipelines only return the exit code of the last command. This option will propagate intermediate errors.
# set -Eeuo pipefail
# . Detecting when a variable is used
# declare -t VARIABLE=value
# trap "echo VARIABLE is being used here." DEBUG

load_execute_boot_basic_with_sudo(){
    if ( typeset -p "SUDO_USER"  &>/dev/null ) ; then
    {
      export USER_HOME
      # typeset -rg USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)  # Get the caller's of sudo home dir Just Linux
      # shellcheck disable=SC2046
      # shellcheck disable=SC2031
      typeset -r USER_HOME="$(echo -n $(bash -c "cd ~${SUDO_USER} && pwd"))"  # Get the caller's of sudo home dir LINUX and MAC
    }
    else
    {
      local USER_HOME=$HOME
    }
    fi
    local -r provider="$USER_HOME/_/clis/execute_command_intuivo_cli/execute_boot_basic.sh"
    echo source "${provider}"
    # shellcheck disable=SC1090
    [   -e "${provider}"  ] && source "${provider}"
    [ ! -e "${provider}"  ] && eval """$(wget --quiet --no-check-certificate  https://raw.githubusercontent.com/zeusintuivo/execute_command_intuivo_cli/master/execute_boot_basic.sh -O -  2>/dev/null )"""   # suppress only wget download messages, but keep wget output for variable
    if ( command -v failed >/dev/null 2>&1; ) ; then
    {
      return 0
    }
    else
    {
      echo -e "\n \n  ERROR! Loading execute_boot_basic.sh \n \n "
      exit 1;
    }
    fi
    return 0
} # end load_execute_boot_basic_with_sudo

load_execute_boot_basic_with_sudo
_err=$?
if [ $_err -ne 0 ] ;  then
{
  >&2 echo -e "ERROR There was an error loading load_execute_boot_basic_with_sudo Err:$_err "
  exit $_err
}
fi

# End loading Error sudo part
# End loading Error sudo part
# End loading Error sudo part

    function toLower(){
        echo "${@,,}"
    }
    function toUpper(){
        echo "${@^^}"
    }
    function toCapitze(){
        echo "${@~}"
    }

    function Titlelize(){
        # echo "remote_available_packages" | sed -E 's/_(.)/\U\1/g' -> remoteAvailablePackages
        sed -E 's/_(.)/\U\1/g'  # REF: https://unix.stackexchange.com/questions/416656/underscore-to-camelcase
    }
    function ToCamel(){
        sed --expression 's/\([A-Z]\)/-\L\1/g' --expression 's/^-//' | sed 's/-a-d-r/-adr/'
    }


# function check_system_requirements(){
#   ( it_exists_with_spaces "logs" ) && rm -rf logs
#   directory_does_not_exist logs
#   mkdir -p logs
#   directory_exists logs
#   # it_does_not_exist_with_spaces .required_git && verify_is_installed git && touch .required_git
#   # it_does_not_exist_with_spaces .required_awk && verify_is_installed awk  && touch .required_awk
#   # it_does_not_exist_with_spaces .required_date && verify_is_installed date  && touch .required_date
#   return 0
# }
# check_system_requirements
