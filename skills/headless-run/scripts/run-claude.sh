#!/usr/bin/env bash
# Usage: ./run-claude.sh <prompt-file> <input-file> [schema-file]
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

SCHEMA_ARGS=()
if [ -n "$SCHEMA_FILE" ]; then
  SCHEMA_ARGS=(--json-schema "$(<"$SCHEMA_FILE")")
fi

if ! output="$(claude --print \
  --model "$MODEL" \
  --system-prompt "$(<"$PROMPT_FILE")" \
  --safe-mode \
  --tools "" \
  --permission-mode dontAsk \
  --permission-prompts none \
  --no-session-persistence \
  "${SCHEMA_ARGS[@]}" \
  --output-format text \
  <"$INPUT_FILE")"; then
  echo "Error: claude failed." >&2
  printf '%s\n' "$output" >&2
  exit 1
fi

printf '%s\n' "$output"
