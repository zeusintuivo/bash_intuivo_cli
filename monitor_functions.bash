#!/usr/bin/env bash
#sset -xueo pipefail

# not a good idea touse these as globals
export SETSIZE
export POS1
export POS2
export SIZE1
function _get_current_size(){
  local gotsize=""
  local -i _err=0
  gotsize="$(xrandr --current | grep -B 0 -C 20  " connected primary" | grep "\*" | xargs | cut -d" " -f1 | head -1)"
  #  xrandr --current | grep " connected" | cut -d' ' -f4 | cut -d'+' -f1 | head -1)"
  _err=$?
  SETSIZE="${gotsize}"
  echo "${gotsize}"
  return ${_err}
} # end _get_current_size

function _get_all_active_monitors(){
  local monitors=""
  local -i _err=0
  monitors="$(xrandr --current --verbose | grep " connected"  | cut -d" " -f1)"
  _err=$?
  echo "${monitors}"
  return ${_err}
} # end _get_all_active_monitors

function _get_all_disconnected(){
  local monitors=""
  local -i _err=0
  monitors="$(xrandr --current --verbose | grep "disconnected"  | cut -d" " -f1)"
  _err=$?
  echo "${monitors}"
  return ${_err}
} # end _get_all_disconnected

function _get_highest_resolution_for_monitor(){
  local monitor="${1}"
  local resolution=""
  # xrandr --current | grep -B 0 -C 20  "DP-1-3"  | xargs  -I {} echo {} | sort -n | tail -1 | cut -d" " -f1
  resolution=$(xrandr --current | grep -B 0 -C 20  "${monitor}"  | xargs  -I {} echo {} | sort -n | tail -1 | cut -d" " -f1 )
  _err=$?
  echo "${resolution}"
  return ${_err}
} # end _get_highest_resolution_for_monitor

function _get_current_monitor(){
  local monitor=""
  monitor=$(xrandr --current --verbose | grep " connected" | grep " primary"  | cut -d" " -f1)
  _err=$?
  echo "${monitor}"
  return ${_err}
} # end _get_current_monitor

function _set_size(){
  local monitors=""
  monitors="$(_get_all_active_monitors)"

  local disconnected=""
  disconnected="$(_get_all_disconnected)"

  local disconnect=""
  local monitor=""
  # Build disconnect string from known list
  while read -r monitor; do
  {
    [[ -z ${monitor} ]] && continue
    disconnect="--output ${monitor} --off \\
${disconnect}"
  }
  done <<< "${disconnected}"

  local command_to_execute=""
  local current_monitor=""
  current_monitor=$(_get_current_monitor)

  local current_monitor_size=""
  current_monitor_size=$(_get_current_size)

  POS1="0x672" # "Middle" Use global maybe
  SIZE1="${current_monitor_size}"
  command_to_execute="xrandr \\
  --output ${current_monitor} --primary --mode ${SIZE1} --pos ${POS1} --rotate normal \\

"

  # --output ${current_monitor} --primary  --mode ${SIZE1} --pos ${POS1} --rotate normal \\
  # Get new monitors
  local extended_monitors=""
  # POS2="1366x0" # to the left of current
  POS2=$(cut -d"x" -f1 <<< "${SIZE1}")
  POS2="${POS2}x0"  # aligned to bottom
  local resolution=""
  resolution="${SIZE1}"

  while read -r monitor; do
  {
    [[ -z ${monitor} ]] && continue
    [[ "${current_monitor}" == "${monitor}" ]] && continue
    POS2=$(cut -d"x" -f1 <<< "${resolution}")
    POS2="${POS2}x0"  # aligned to bottom
    resolution=$(_get_highest_resolution_for_monitor "${monitor}")
    if [[ -n "${SETSIZE}" ]] ; then  # FORCE the use of SETSIZE for older scripts, not very good idea
    {
      resolution="${SETSIZE}"
    }
    fi
    extended_monitors="  --output ${monitor} --noprimary --mode ${resolution} --pos ${POS2} --rotate normal \\
${extended_monitors}

"
  }
  done <<< "${monitors}"

  #  xrandr --output "${monitor}" --primary --mode "${SETSIZE}" --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-0 --off  --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off
  #  xrandr --output "${monitor}" --primary --mode "${SETSIZE}" --pos 0x0 --rotate normal
  command_to_execute="${command_to_execute}
${extended_monitors}
${disconnect}

"
  local -i _err=0
  local fixed_command=""
  local commando
  while read -r commando ; do
  {
    [[ -z ${commando} ]] && continue
    fixed_command="${fixed_command}
${commando}"
  }
  done <<< "${command_to_execute}"

  fixed_command="${fixed_command}

"

  echo -e "RUNNING:
${fixed_command}"


  eval "${fixed_command}"
  _err=$?

  return ${_err}
} # end _set_size
