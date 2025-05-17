#!/bin/bash

# Validate input
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <source_dir> <target_dir> <topic>"
  exit 1
fi

SRC_DIR="$1"
TARGET_DIR="$2"
TOPIC="$3"

CWD=$(pwd)

# Convert topic to snake_case filename
FILENAME=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g').txt

# File extensions to include
EXTENSIONS="css ts js html hs sass tsx jsx svelte json"

# Create target directory if needed
mkdir -p "$TARGET_DIR"

# Output file
OUTPUT_FILE="$TARGET_DIR/$FILENAME"
> "$OUTPUT_FILE" # empty the file

cd "$SRC_DIR"  || exit 1
ALLFILES=$(oe ts)
cd "$CWD"  || exit 1
# ALLFILES=$(find "$SRC_DIR" -type f \( $(echo "$EXTENSIONS" | sed 's/\([^ ]\+\)/-iname "*.\1"/g' | sed 's/ / -o /g') \))
# Find and process files
 while read -r FILE; do
  RELATIVE_PATH="./$SRC_DIR/${FILE}"

  # Add start marker
  echo "# file: $RELATIVE_PATH   // --- start" >> "$OUTPUT_FILE"

  # Remove comments and write cleaned content
  sed -e 's/\/\/.*//' \
      -e 's/#.*//' \
      -e '/\/\*/,/\*\//d' \
      "$RELATIVE_PATH" >> "$OUTPUT_FILE"

  # Add end marker
  echo "# file: $RELATIVE_PATH   // --- end" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
done <<< "$ALLFILES"

echo "✅ Combined file created at: $OUTPUT_FILE"
