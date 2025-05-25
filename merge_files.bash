#!/usr/bin/env bash

set -xuEe


# Validate input
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <source_dir> <target_dir> <topic> <extensions>"
  echo "$0 . chatgipity \"adding feature\" \"rs toml\" "
  echo "$0 . chatgipity \"adding feature\" \"php inc\" "
  echo "$0 . chatgipity \"adding feature\" \"js sass ccs scss svelte\" "
  echo "$0 . chatgipity \"adding feature\" \"tsx ts jsx js sass ccs scss\" "
  echo "$0 . chatgipity \"adding feature\" \"css js html hs sass tsx jsx svelte json\" "
  exit 1
fi

function _merge_files(){

  local SRC_DIR="${1}"
  local TARGET_DIR="${2}"
  local TOPIC="${3}"
  local _EXTENSIONS="${4}"

  local CWD=""
  CWD="$(pwd)"
  # Convert topic to snake_case filename
  local FILENAME=""
  FILENAME="$(echo "${TOPIC}" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g').txt"

  # File extensions to include
  local EXTENSIONS=""
  # shellcheck disable=SC2001
  if [[ -z "${_EXTENSIONS}" ]] ; then
  {
    EXTENSIONS="$(sed 's/ /\n/g' <<< "rs java php inc toml css ts js html hs sass tsx jsx svelte json")"
  }
  else
  {
    EXTENSIONS="$(sed 's/ /\n/g' <<< "${_EXTENSIONS}")"
  }
  fi
  # Create target directory if needed
  mkdir -p "${TARGET_DIR}"

  # Output file
  local OUTPUT_FILE="${TARGET_DIR}/${FILENAME}"
  echo "" > "${OUTPUT_FILE}" # empty the file

  cd "${SRC_DIR}"  || exit 1
  local ALLFILES=""

  cd "${CWD}"  || exit 1
  # ALLFILES=$(find "$SRC_DIR" -type f \( $(echo "$EXTENSIONS" | sed 's/\([^ ]\+\)/-iname "*.\1"/g' | sed 's/ / -o /g') \))
  # Find and process files
  local RELATIVE_PATH=""
  local _extension=""
  while read -r _extension ;  do
  {
    ALLFILES="$(oe "\\.${_extension}$")"
    [[ -z "${ALLFILES}" ]] && continue
    while read -r FILE; do
    {
      RELATIVE_PATH="${FILE}"

      # Add start marker
      # shellcheck disable=SC2129
      echo "# file: ${RELATIVE_PATH}   // --- start" >> "${OUTPUT_FILE}"

      # Remove comments and write cleaned content
      # sed -e 's/\/\/.*//' \
      #  -e 's/#.*//' \
      #  -e '/\/\*/,/\*\//d' \
      #  "${RELATIVE_PATH}" >> "${OUTPUT_FILE}"

      sed -E \
        -e '/\/\*/,/\*\//d' \
        -e 's/(^|[^:])\/\/.*$/\1/' \
        -e 's/#.*//' \
        "${RELATIVE_PATH}" >> "${OUTPUT_FILE}"

        # Add end marker
        echo "# file: ${RELATIVE_PATH}   // --- end" >> "${OUTPUT_FILE}"
        echo "" >> "${OUTPUT_FILE}"
    }
    done <<< "${ALLFILES}"
  }
  done <<< "${EXTENSIONS}"
  echo "✅ Combined file created at: ${OUTPUT_FILE}"

} # end _merge_files

_merge_files "${1}" "${2}" "${3}" "${4}"


#
