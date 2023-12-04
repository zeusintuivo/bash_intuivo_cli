#!/bin/env bash


function _get_all_active_monitors(){
  local monitors=$(xrandr --current --verbose | grep " connected"  | cut -d" " -f1)
  echo "${monitors}"
} # end _get_all_active_monitors

function _get_primary_monitor(){
  local monitor=$(xrandr --current --verbose | grep " connected" | grep "primary" | cut -d" " -f1)
  echo "${monitor}"
} # end _get_primary_monitor


function _get_options_for_monitor(){
  local options="$(xrandr -q)"
  local monitor="${1}"
  local option line
  local line2
  local -i found=0
  (( DEBUG )) && echo "monitor:${monitor}"
  while read -r option; do
  {
    [[ -z ${option} ]] && continue
    (( DEBUG )) && echo "option:${option}"
    (( DEBUG )) && echo "found:${found}"
    if [ ${found} -eq 0 ] ; then
    {
      line=$(echo "${option}" | cut -d' ' -f1 )
      (( DEBUG )) && echo "line:${line}"
      [[ "${line}" == "${monitor}" ]] && found=1
      continue
    }
    fi

    line=$(echo "${option}" | cut -d' ' -f1 )
    line2=$(echo "${option}" | cut -d' ' -f6- | sed 's/ //g' )
    break
  }
  done <<< "${options}"
  echo "--mode ${line} --rate ${line2}"
} # end _get_options_for_monitor


function _set_primary(){
  local monitors="$(_get_all_active_monitors)"
  local primary="$(_get_primary_monitor)"
  local mode="$(_get_options_for_monitor "${primary}")"
  xrandr --output "${primary}"  --auto --primary ${mode}
  local monitor
  while read -r monitor; do
  {
    [[ -z ${monitor} ]] && continue
    [[ "${monitor}" == "${primary}" ]] && continue
    xrandr --output "${monitor}" --off
  }
  done <<< "${monitors}"

} # end _set_primary

function _to_direction(){
  # xrandr --output eDP-1 --primary --mode 1366x768 --rate 59.99++ --output DP-1 --mode 1720x1440 --rate 59.98*+ --left-of eDP-1
  local direction="${1}"
  local monitors="$(_get_all_active_monitors)"
  local primary="$(_get_primary_monitor)"
  local mode="$(_get_options_for_monitor "${primary}")"
  local primary_command=" --output ${primary}  --primary ${mode}"
  local secondary_commands=""
  local monitor
  while read -r monitor; do
  {
    [[ -z ${monitor} ]] && continue
    [[ "${monitor}" == "${primary}" ]] && continue
    mode="$(_get_options_for_monitor "${monitor}")"
    secondary_commands="${secondary_commands} --output ${monitor} ${mode} ${direction} ${primary}"
  }
  done <<< "${monitors}"
  echo "xrandr ${primary_command} ${secondary_commands}"
  xrandr ${primary_command} ${secondary_commands}
} # end _to_direction


#_set_primary
_to_direction "--above"
#_to_direction "--below"
#_to_direction "--left-of"
#_to_direction "--right-of"
