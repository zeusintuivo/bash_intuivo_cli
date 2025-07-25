#!/usr/bin/env bash
#
# Smarter tree-to-filesystem creator.
# Supports trees with mixed styles and root prefixes.

input="${1:-/dev/stdin}"
declare -a stack

while IFS= read -r raw_line; do
  # skip empty lines or comments
  [[ -z "$raw_line" || "$raw_line" =~ ^# ]] && continue

  line="$raw_line"
  depth=0

  # remove leading "./" or "." if present (root level)
  line="${line#./}"
  line="${line#.}"

  # Count depth by matching "│", spaces, or other indent markers
  indent_part="${line%%[├└]── *}"
  depth=$(( $(echo "$indent_part" | grep -oE "(│|    )" | wc -l) ))

  # Strip off tree connector characters
  line="${line##*── }"

  # Ignore lines like examples/ (can be both file or dir)
  is_dir=0
  if [[ "$line" == */ ]]; then
    is_dir=1
    line="${line%/}"
  fi

  # Update the stack
  stack[$depth]="$line"
  for ((i=depth+1; i<${#stack[@]}; i++)); do
    unset "stack[i]"
  done

  # Build full path
  path=""
  for ((i=0; i<=depth; i++)); do
    [[ -n "${stack[i]}" ]] && path+="${stack[i]}/"
  done
  path="${path%/}"  # remove trailing slash

  # Create
  if (( is_dir )); then
    mkdir -p "$path"
  else
    mkdir -p "$(dirname "$path")"
    touch "$path"
  fi
done < "$input"
