#!/usr/bin/env bash

#. ./update_boot.bash
# verify_is_installed awk
# Add this to the cron tab
# crontab -e   # for current user
# everyday every minute
# * * * * * "$HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash"
# * * * * * ( sleep 30 ; "$HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash" )
# at 10h:10m:30s on Mon to Fri  https://corntab.com/?c=10,30_10_*_*_1-5
# 10,30 10 * * 1-5 "$HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash"
# 10 10 * * 1-5 ( sleep 30 ; "$HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash" )
# 10,30 * * * 1-5  $($HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash) > /dev/null 2>&1 || true
# 10,30 * * * 1-5  $(sleep 30 ; $HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash) > /dev/null 2>&1 || true

# remember to restart the crontab everytime  this script chances to see changes take change in the crontab


function update_bash_intuivo_cli() {
  local -i _err=0
  local -i _cron_running=1
  local _msg
  local _home="${HOME}"
  local _log_file="${_home}/update_bash_intuivo_cli.log"
  local _lock_file="${_home}/update_bash_intuivo_cli.lock"
  local _lock_updated="${_home}/updated_bash_intuivo_cli.lock"
  echo "" > "${_log_file}"
  if [ -e "${_lock_file}" ] ; then
  {
    echo "${_lock_file} exists. I exit. I assume cron update_bash_intuivo_cli.bash is running."
    exit 0
  }
  fi
  touch "${_lock_file}"
  local _log_path="/dev/fd/3"
  local -i _no_wall_broadcast_no_banner=1
  function interrupt_update_bash_intuivo_cli() {
      echo "${0} ${FUNCNAME[0]} INTERRUPT"
      [ -e "${_lock_file}" ] && rm "${_lock_file}"
  }
  function error_update_bash_intuivo_cli() {
      echo "${0} ${FUNCNAME[0]} ERROR"
      [ -e "${_lock_file}" ] && rm "${_lock_file}"
  }
    function exit_update_bash_intuivo_cli() {
      echo "${0} ${FUNCNAME[0]} EXIT"
      [ -e "${_lock_file}" ] && rm "${_lock_file}"
      if [ ${_cron_running} -ne 0 ] ; then
      {
        exec 1>&3 2>&4 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
      }
      else
      {
        exec 1>&3  # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
      }
      fi
  }
  trap interrupt_update_bash_intuivo_cli INT
  trap error_update_bash_intuivo_cli ERR
  trap exit_update_bash_intuivo_cli EXIT
# Ok using technique that env un crontab and env with user
# different I observed different env
# also calling the script from command line causes type -f to respond
# different
# USER type -f ./update_bash_intuivo_cli.bash is
# CRON type -f  $HOME/_/clis/bash_intuivo_cli/update_bash_intuivo_cli.bash
# USER env LS_COLORS
# CRON env LS_COLORS
# type -f "${0}"
#echo "${LS_COLORS}"
#[[ -n "${LS_COLORS}" ]] && echo "true 1"
#[[ "$(type -f "${0}")" == "./update_bash_intuivo_cli.bash " ]] && echo "true 2"
#if [[ -n "${LS_COLORS}" ]] && [[ "$(type -f "${0}")" == "./update_bash_intuivo_cli.bash " ]]  ; then  # set not empty       -IF DEFINED AND HAS SOMETHING GO IN(or TRUE)

if [[ -n "${LS_COLORS}" ]] ; then  # set not empty       -IF DEFINED AND HAS SOMETHING GO IN(or TRUE)
{
#  echo hola
  exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
  _no_wall_broadcast_no_banner=1
  _cron_running=1
}
else
{
#  echo doble hola
  _no_wall_broadcast_no_banner=1
  _cron_running=0
  exec 3>&1 1>>"${_log_file}" 2>&1 # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
  exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
}
fi
# This script redirects both console and file to log
# but it produces TEE error when run from crontab
#exec 3>&1 1>>"${_log_file}" 2>&1 # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
# I discovered that it needs to change
# here we need to release the the trap of exec and release it
# before reassigning it, otherwise it will duplicate the
# the output
#exec 1>&3
# this other script redirect both console and file output to log
# and it does not produce error messages with TEE
#exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
# notice that exec can have two >> or one > after the redirections 3>&1
# these > >> are the same for appending to log or starting the log
# so xec 3>&1 4>&2 > will erase the log file just like echo "hola" > log
# and exec 3>&1 4>&2 >> will append to the log just like echo "hi" >> log


# before the exec wall works with crontab
# after the exec command then comes the errors
# wall: --nobanner is available only for root
# wall: cannot get tty name: Inappropriate ioctl for device
#  _msg=$(wall -n "test" 2>&1)
#  _err=$?
#  _err=0
#  if [ ${_err} -ne 0 ] ||
#      [[ "${_msg}" != *"nobanner"* ]] ||
#      [[ "${_msg}" != *"only"* ]]  ; then
#  {
#    echo _no_wall_broadcast_no_banner=1
    # This is behavior works ok with log and console but
    # it hides this annoying message from the logs
    # tee: /dev/fd/3: Permission denied
    #
#   # exec 3>&1 4>&2 >"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
#     exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
#    _no_wall_broadcast_no_banner=1
#  } else {
#    echo _no_wall_broadcast_no_banner=0
    #  echo "" > "${_log_file}"
    # This is behavior works ok with console but
    # produces these annoying message from the logs
    # tee: /dev/fd/3: Permission denied
    #
    #  exec 3>&1 1>"${_log_file}" 2>&1 # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
#       exec 3>&1 1>>"${_log_file}" 2>&1 # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
#  }
#  fi
# (log "INFO 1 ${BASH_SOURCE}:${BASH_LINENO[-0]} ${FUNCNAME[0]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 2  ${0}:${BASH_LINENO[-0]} ${FUNCNAME[-0]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 3  :${BASH_LINENO[-1]} ${FUNCNAME[-1]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 4  :${BASH_LINENO[-2]} ${FUNCNAME[-2]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 5  :${BASH_LINENO[-3]} ${FUNCNAME[-3]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 6  :${BASH_LINENO[-4]} ${FUNCNAME[-4]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 7  :${BASH_LINENO[-5]} ${FUNCNAME[-5]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 8  :${BASH_LINENO[-6]} ${FUNCNAME[-6]}" 2>&1) | tee -a "${_log_path}"
# (log "INFO 9  :$(which shell) $(whoami)" 2>&1) | tee -a "${_log_path}"

#  ( action 2>&1) | tee -a "${_log_path}"
    # test when form cron tab Writing to console is Permission denied
  # shellcheck disable=SC2116
  local _command_tee_or_not_tee="tee -a ${_log_path}"
#  if ! test -t 1 ; then
##    echo first part
##    ( echo third part  2>&1) | "${_command_tee_or_not_tee}"
##  else
##    echo second part goes to the log only
##    ( echo fourth part goes to both log and console 2>&1) | tee -a ${_log_path}
#    _msg=$( ( ( echo . 2>&1 ) | "${_command_tee_or_not_tee}" ) 2>&1 )
#    _err=$?
#    if [ ${_err} -ne 0 ] ||
#      [[ "${_msg}" != *"Permission denied"* ]] ||
#      [[ "${_msg}" != *"Erlaubnis verweigert"* ]] ||
#      [[ "${_msg}" != *"Erlaubnis abgelehnt"* ]] ||
#      [[ "${_msg}" != *"Erlaubnis verwehrt"* ]] ||
#      [[ "${_msg}" != *"Permiso denegado"* ]]; then
#      {
#        _command_tee_or_not_tee=">> ${_log_file}"
#      }
#    fi
#
#  fi
#
#  _msg=$(test -t 1 2>&1)
#  _err=$?
#  # shellcheck disable=SC1009
#  if [ ${_err} -ne 0 ] ||
#    [[ "${_msg}" != *"Permission denied"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis verweigert"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis abgelehnt"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis verwehrt"* ]] ||
#    [[ "${_msg}" != *"Permiso denegado"* ]]; then
#    {
#      exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
#      # exec 1>>"${_log_file}" 2>&1  # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
#    }
#  fi
#
#  # shellcheck disable=SC1009
#  # shellcheck disable=SC2116
#  _msg=$( ( (echo "." 2>&1) | tee -a "${_log_path}") 2>&1)
#  _err=$?
#  if [ ${_err} -ne 0 ] ||
#    [[ "${_msg}" != *"Permission denied"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis verweigert"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis abgelehnt"* ]] ||
#    [[ "${_msg}" != *"Erlaubnis verwehrt"* ]] ||
#    [[ "${_msg}" != *"Permiso denegado"* ]]; then
#    {
#      exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
#      # exec 1>>"${_log_file}" 2>&1  # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
#    }
#  fi

  local _target_folder="${_home}/_/clis/bash_intuivo_cli"
  # shellcheck disable=SC2164
  # shellcheck disable=SC2155
  local _msg=$(cd "${_target_folder}" 2>&1)
  _err=$?
  [ ${_err} -ne 0 ] && ( (log "ERROR while CD into \ntarget_folder: ${_target_folder}\nmsg:${_msg}" 2>&1) | tee -a "${_log_path}") && exit 1
  # shellcheck disable=SC2164
  cd "${_target_folder}"



  local -i _updated=0
  local -i _update_error=0
  # shellcheck disable=SC2155
  local _git_user=$(/usr/bin/git config --get user.name)
  _err=$?

  (log INFO _no_wall_ "${_no_wall_broadcast_no_banner}" 2>&1) | tee -a "${_log_path}"
  (log INFO _log_file "${_log_file}" 2>&1) | tee -a "${_log_path}"
  (log INFO _log_path "${_log_path}" 2>&1) | tee -a "${_log_path}"
  (log INFO _____home "${_home}" 2>&1) | tee -a "${_log_path}"
  (log INFO _git_user "${_git_user}" 2>&1) | tee -a "${_log_path}"
  (log INFO sudo_user "${SUDO_USER}" 2>&1) | tee -a "${_log_path}"
  (log INFO _____user "${USER}" 2>&1) | tee -a "${_log_path}"
  (log INFO ______pwd "$(pwd)" 2>&1) | tee -a "${_log_path}"

  local _message_date="$(date '+%Y-%m-%d %H:%M:%S')"
  local _message_did_nothing="update_bash_intuivo_cli nothing to do on/at ${_message_date}"
  local      _message_ran_on="update_bash_intuivo_cli ran           on/at ${_message_date}"
  local _output_message="${_message_did_nothing}"

  function private_do_pull() {
    # shellcheck disable=SC2155
    local _target_branch="${1}"
    _err=$?
    # shellcheck disable=SC2155
    local _git_remote_url=$(/usr/bin/git config --get remote.origin.url)
    _err=$?
    # shellcheck disable=SC2155
    local _current_branch=$(/usr/bin/git rev-parse --abbrev-ref HEAD 2>&1)
    _err=$?
    [ ${_err} -ne 0 ] && _current_branch="master"
    (log INFO cu_branch "${_current_branch}" 2>&1) | tee -a "${_log_path}"
    (log INFO ta_branch "${_target_branch}" 2>&1) | tee -a "${_log_path}"
    # shellcheck disable=SC2155
    local _git_commit_hash_local=$(/usr/bin/git rev-parse "${_target_branch}")
    _err=$?
    # shellcheck disable=SC2155
    local _git_commit_hash_remote=$(/usr/bin/git ls-remote "${_git_remote_url}" "${_target_branch}"  2>&1)
    _err=$?
    # echo "[$_err] ${_git_commit_hash_remote}"
    # if [ ${_err} -ne 0 ]; then
    # {
      if [[ ${_git_commit_hash_remote} == *"Could not read from remote"* ]] ; then
      {
        #       git@github.com: Permission denied (publickey).
        # fatal: Could not read from remote repository.

        # Please make sure you have the correct access rights
        # and the repository exists.
        ( log ERROR "Permission denied for ${_git_user} for ${_git_remote_url} " 2>&1 ) | tee -a "${_log_path}"
        _update_error=1
         return $_update_error
      }
      fi
    # }
    # fi
    _git_commit_hash_remote="$(echo -n "${_git_commit_hash_remote}" | awk '{ print $1}')"
    _err=$?
    # shellcheck disable=SC2155
    local _status_message="${_message_ran_on}"
    _err=$?
    local _update_message=""
    local _output_message="${_status_message}, ${_git_user} ${_target_branch} up to date, nothing to do"
    (log INFO ___local "${_git_commit_hash_local}" 2>&1) | tee -a "${_log_path}"
    (log INFO __remote "${_git_commit_hash_remote}" 2>&1) | tee -a "${_log_path}"
    if [[ "${_git_commit_hash_local}" != "${_git_commit_hash_remote}" ]]; then
    {
      (log DEBUG _commits "differ" 2>&1) | tee -a "${_log_path}"
      if [[ "${_current_branch}" != "${_target_branch}" ]]; then
      {
        (log DEBUG branches "differ" 2>&1) | tee -a "${_log_path}"
        # PULL TO ANOTHER ORIGIN TO ANOTHER BRANCH WHILE STAYING THIS BRANCH
        # _update_message=$(/usr/bin/git fetch -f origin master:master 2>&1) # master to master sample
        # _update_message=$(/usr/bin/git fetch -f origin main:main 2>&1) # master to master sample
        _update_message=$(/usr/bin/git fetch -f origin "${_target_branch}":"${_target_branch}" 2>&1)
        _err=$?
        echo "[$_err] ${_update_message}"
        if [ ${_err} -ne 0 ] || [[ "${_update_message}" == *"You have unstaged"* ]] ; then
        {
          # if ; then
          # {
            #  error: cannot pull with rebase: You have unstaged changes.
            # please commit or stash them.
            ( log ERROR "You have unstaged files for ${_target_branch} " 2>&1 ) | tee -a "${_log_path}"
          # }
          # fi
          _update_error=1
          return $_update_error
        }
        else
        {
          if [[ "${_update_message}" == *"Already up to date"* ]] ;  then
          {
            _updated=0
          }
          else
          {
            _output_message="${_update_message}, ${_status_message}, ${_target_branch} pulled"
           ( log INFO "${_output_message}" 2>&1 ) | tee -a "${_log_path}"
            _updated=1
          }
          fi
        }
        fi

      }
      else
      {
        (log DEBUG branches "same" 2>&1) | tee -a "${_log_path}"
        if is_dirty ; then
        {
          ( log ERROR "You have unstaged files for ${_target_branch} " 2>&1 ) | tee -a "${_log_path}"
          _update_error=1
          return $_update_error
        }
        fi
        _update_message=$(/usr/bin/git pull -f 2>&1)
        # echo "[$_err] ${_update_message}"
        _err=$?
        # (echo remote "${_update_message}" 2>&1) | tee -a "${_log_path}"
        if [ ${_err} -ne 0 ] || [[ "${_update_message}" == *"You have unstaged"* ]]  ; then
        {
          ( log ERROR "You have unstaged files for ${_target_branch} " 2>&1 ) | tee -a "${_log_path}"
          # _output_message="${_status_message}, ${_git_user} Error occurred: [$_err] ${_update_message}"
          _update_error=1
          return $_update_error
        }
        else
        {
          if [[ "${_update_message}" == *"Already up to date"* ]] ;  then
          {
            _updated=0
          }
          else
          {
            _output_message="${_update_message}, ${_status_message}, ${_target_branch} pulled"
           ( log INFO "${_output_message}" 2>&1 ) | tee -a "${_log_path}"
            _updated=1
          }
          fi
        }
        fi

      }
      fi

    }
    else # commit hashes the same
    {
      (log DEBUG _commits "same" 2>&1) | tee -a "${_log_path}"
      _output_message="${_status_message}, ${_target_branch} already up to date (nothing to do)"
     ( log INFO "${_output_message}" 2>&1 ) | tee -a "${_log_path}"
    }
    fi # end if git_commit_hash_
    # ( log INFO "${_output_message}" 2>&1 ) | tee -a "${_log_path}"


    if [ ${_update_error} -ne 0 ] ; then
    {
          (log ERROR "${_output_message}" 2>&1) | tee -a "${_log_path}"
    }
    fi

  } # end private_do_pull
  if is_in_local "master" ; then
  {
    private_do_pull "master"
    _update_error=$?
  }
  fi
  if is_in_local "main" ; then
  {
    private_do_pull "main"
    _update_error=$?
  }
  fi
  # shellcheck disable=SC2155
  local _current_branch=$(/usr/bin/git rev-parse --abbrev-ref HEAD 2>&1)
  _err=$?
  if [[ "${_current_branch}" != "master" ]] && [[ "${_current_branch}" != "main" ]] ; then
  {
    private_do_pull "${_current_branch}"
    _update_error=$?
  }
  fi




  [ -e "${_lock_file}" ] && rm "${_lock_file}"

  if [ ${_update_error} -eq 0 ] ; then   # true if it updated
  {
    # Run external cron file
    if [[ -e "${_target_folder}/update_cron_bash_intuivo_cli.bash" ]] ; then
    {
      (log INFO filecron "running ${_target_folder}/update_cron_bash_intuivo_cli.bash" 2>&1) | tee -a "${_log_path}"
      ( "${_target_folder}/update_cron_bash_intuivo_cli.bash" 2>&1 ) | tee -a "${_log_path}"
    }
    else
    {
      (log INFO filecron "not found ${_target_folder}/update_cron_bash_intuivo_cli.bash" 2>&1) | tee -a "${_log_path}"
    }
    fi

    touch "${_lock_updated}"


    if [[ "${_output_message}" != *"nothing to do"* ]] ; then
    {
      if [ ${_no_wall_broadcast_no_banner} -ne 0 ] ; then
      {
         wall <<<"${_output_message}"
      }
      else
      {
         wall <<< "${_output_message}" # wall: --nobanner is available only for root
      }
      fi
    }
    fi

  }
  fi


  # restore stdout and stderr
  if [ ${_no_wall_broadcast_no_banner} -ne 0 ] ; then
  {
    exec 1>&3 2>&4 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
  }
  else
  {
    exec 1>&3  # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
  }
  fi

  if [ ${_update_error} -ne 0 ] ; then
  {
        exit 1
  }
  fi

  exit 0

} # end update_bash_intuivo_cli

function is_dirty() {
    # REF: https://stackoverflow.com/questions/3878624/how-do-i-programmatically-determine-if-there-are-uncommitted-changes
    # Update the index
    # if is_dirty ; then
    # {
    #   exit 1
    # }
    # fi
    local res=$(git update-index -q --ignore-submodules --refresh  2>&1)
    local -i err=0

    # Disallow unstaged changes in the working tree
    if  ! git diff-files --quiet --ignore-submodules --  2>&1  ; then
        # echo >&2 "cannot $1: you have unstaged changes."
        res=$(git diff-files --name-status -r --ignore-submodules --  2>&1)
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --  2>&1
    then
        # echo >&2 "cannot $1: your index contains uncommitted changes."
        res=$(git diff-index --cached --name-status -r --ignore-submodules HEAD --  2>&1)
        err=1
    fi

    if [ $err -eq 1 ]
    then
        # echo >&2 "Please commit or stash them."
        return 0
    fi
    return 1
} # end is_dirty

function is_in_local() {
  # Local:
  # https://stackoverflow.com/questions/21151178/shell-script-to-check-if-specified-git-branch-exists
  # test if the branch is in the local repository.
  # if is_in_local "master" ; then
  # {
  #   echo "brach master exists locallly"
  # }
  # fi
  local branch="${1}"
  local existed_in_local=$(/usr/bin/git branch --list "${branch}")
  [[ -z ${existed_in_local} ]] && return 1
  return 0
} # end is_in_local

function is_in_remote() {
  # Remote:
  # Ref: https://stackoverflow.com/questions/8223906/how-to-check-if-remote-branch-exists-on-a-given-remote-repository
  # test if the branch is in the remote repository.
  # Usage:
  # if is_in_remote "master" ; then
  # {
  #   echo "brach master exists remotely"
  # }
  # fi
  local branch="${1}"
  local existed_in_remote=$(/usr/bin/git ls-remote --heads origin "${branch}")
  [[ -z ${existed_in_remote} ]] && return 1
  return 0
} # end is_in_remote

function doLog() {
  # Sample use: REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
  #
  # echo pass params and print them to a log file and terminal
  # with timestamp and $host_name and $0 PID
  # usage:
  # doLog "INFO some info message"
  # doLog "DEBUG some debug message"
  # doLog "WARN some warning message"
  # doLog "ERROR some really ERROR message"
  # doLog "FATAL some really fatal message"
  #
  # shellcheck disable=SC2155
  local type_of_msg=$(echo "${@}" | cut -d" " -f1)
  # shellcheck disable=SC2155
  local msg=$(echo "${@}" | cut -d" " -f2-)
  # shellcheck disable=SC2155
  local -i do_print_debug_msgs=0
  local run_unit
  local host_name
  local product_instance_dir
  [[ $type_of_msg == DEBUG ]] && [[ "${do_print_debug_msgs}" -ne 1 ]] && return
  [[ $type_of_msg == INFO ]] && type_of_msg="INFO " # one space for aligning
  [[ $type_of_msg == WARN ]] && type_of_msg="WARN " # as well

  # print to the terminal if we have one
  test -t 1 && echo " [${type_of_msg}] $(date "+%Y.%m.%d-%H:%M:%S %Z") [${run_unit}][@${host_name}] [$$] ${msg}"

  # define default log file none specified in cnf file
  test -z "${log_file}" &&
    mkdir -p "${product_instance_dir}/dat/log/bash" &&
    log_file="${product_instance_dir}/dat/log/bash/${run_unit}.$(date "+%Y%m").log"
  echo " [$type_of_msg] $(date "+%Y.%m.%d-%H:%M:%S %Z") [${run_unit}][@${host_name}] [$$] ${msg}" >>"${log_file}"
} # end func doLog

function log() {
  #  usage:
  # log "INFO some info message"
  # log "DEBUG some debug message"
  # log "WARN some warning message"
  # log "ERROR some really ERROR message"
  # log "FATAL some really fatal message"
  # shellcheck disable=SC2155
  local type_of_msg=$(echo "${@}" | cut -d" " -f1)
  # shellcheck disable=SC2155
  local msg=$(echo "${@}" | cut -d" " -f2-)
  echo " [$type_of_msg] $(date "+%Y.%m.%d-%H:%M:%S %Z")[$$] ${msg}"

} # end log

update_bash_intuivo_cli
