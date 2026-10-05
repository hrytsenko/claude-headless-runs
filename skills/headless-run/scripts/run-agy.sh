#!/usr/bin/env bash
# Usage: ./run-agy.sh <prompt-file> <input-file> [schema-file]
set -euo pipefail

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <prompt-file> <input-file> [schema-file]" >&2
  exit 1
fi

PROMPT_FILE="$1"
INPUT_FILE="$2"
SCHEMA_FILE="${3:-}"
: "${MODEL:?set MODEL to a model ID}"

for file in "$PROMPT_FILE" "$INPUT_FILE" ${SCHEMA_FILE:+"$SCHEMA_FILE"}; do
  if [ ! -r "$file" ]; then
    echo "Error: file not readable: $file" >&2
    exit 1
  fi
done

# --json-schema requires JSON output: the result is the envelope's structured_output.
FORMAT_ARGS=(--output-format text)
if [ -n "$SCHEMA_FILE" ]; then
  FORMAT_ARGS=(--json-schema "$(<"$SCHEMA_FILE")" --output-format json)
fi

# agy has no system-prompt channel, so instructions are prepended to the input.
# It cannot disable tools either, and in headless mode any tool call that needs
# permission is auto-denied and ends the run with no output, so ask for none.
NO_TOOLS="Answer directly from your own knowledge. Do not use any tools."

agy \
  --print "$(<"$PROMPT_FILE")"$'\n\n'"$(<"$INPUT_FILE")"$'\n\n'"$NO_TOOLS" \
  --model "$MODEL" \
  --sandbox \
  --disable-slash-commands \
  "${FORMAT_ARGS[@]}" \
  </dev/null
