#!/usr/bin/env bash
# exit 0
function restart_bash_intuivo_cli() {
  local -i _err=0
  local _msg
  local _home="/Users/username"  # If sudo crontab is running, we need to provide this
  local _log_file="${_home}/restarting_bash_intuivo_cli.log"
  local _lock_updated="${_home}/updated_bash_intuivo_cli.lock"
  local _lock_starting="${_home}/starting_bash_intuivo_cli.lock"
  local -i _start_error=0
  local -i _cron_running=1
  local interrupt_restart_bash_intuivo_cli
  function interrupt_restart_bash_intuivo_cli() {
      echo "${0} ${FUNCNAME[-1]} INTERRUPT"
      [ -e "${_lock_starting}" ] && rm "${_lock_starting}"
  }
  local error_restart_bash_intuivo_cli
  function error_restart_bash_intuivo_cli() {
      echo "${0} ${FUNCNAME[-1]} ERROR"
      [ -e "${_lock_starting}" ] && rm "${_lock_starting}"
      if [ ${_start_error} -ne 0 ] ; then
      {
            wall <<< "ERROR Restart Failed!!!"
            exit 1
      }
      fi
  }
  local exit_restart_bash_intuivo_cli
  function exit_restart_bash_intuivo_cli() {
    echo "${0} ${FUNCNAME[-1]} EXIT"
    [ -e "${_lock_starting}" ] && rm "${_lock_starting}"
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
  trap interrupt_restart_bash_intuivo_cli INT
  trap error_restart_bash_intuivo_cli ERR
  trap exit_restart_bash_intuivo_cli EXIT
  local _target_folder="${_home}/_/clis/bash_intuivo_cli"
  if [ ! -e "${_lock_updated}" ]; then
    {
      echo "${_lock_updated} does not exists. I exit. I assume no pull has been made."
      exit 0
    }
  fi
  [ -e "${_lock_updated}" ] && rm "${_lock_updated}"
  if [ -e "${_lock_starting}" ]; then
    {
      echo "${_lock_starting} exists. I exit. I assume rails is restarting_bash_intuivo_cli."
      exit 0
    }
  fi
  touch "${_lock_starting}"
  echo "" > "${_log_file}"
  local _log_path="/dev/fd/3"
  if [[ -n "${LS_COLORS}" ]]; then # set not empty       -IF DEFINED AND HAS SOMETHING GO IN(or TRUE)
    {
      exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
      _cron_running=1
    }
  else
    {
      _cron_running=0
      exec 3>&1 1>>"${_log_file}" 2>&1     # How to write output to both console and file REF: https://stackoverflow.com/questions/18460186/writing-outputs-to-log-file-and-console
      exec 3>&1 4>&2 >>"${_log_file}" 2>&1 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
    }
  fi

  (log INFO _log_file "${_log_file}" 2>&1) | tee -a "${_log_path}"

  #
  # - Procedures Start
  #

  #
  # - Procedures End
  #
  [ -e "${_lock_starting}" ] && rm "${_lock_starting}"
  #
  # restore stdout and stderr
  #
  if [ ${_cron_running} -ne 0 ] ; then
  {
    exec 1>&3 2>&4 # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
  }
  else
  {
    exec 1>&3  # How to redirect output  REF: https://stackoverflow.com/questions/314675/how-to-redirect-output-of-an-entire-shell-script-within-the-script-itself
  }
  fi


  wall<<< "update_restart_bash_intuivo_cli.bash lock removed - " #
  exit 0


} # end restart_bash_intuivo_cli

function log() {
  #  usage:
  # doLog "INFO some info message"
  # doLog "DEBUG some debug message"
  # doLog "WARN some warning message"
  # doLog "ERROR some really ERROR message"
  # doLog "FATAL some really fatal message"
  # shellcheck disable=SC2155
  local type_of_msg=$(echo "${@}" | cut -d" " -f1)
  # shellcheck disable=SC2155
  local msg=$(echo "${@}" | cut -d" " -f2-)
  echo " [$type_of_msg] $(date "+%Y.%m.%d-%H:%M:%S %Z")[$$] ${msg}"

} # end log
restart_bash_intuivo_cli
