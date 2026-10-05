#!/usr/bin/env bash
# Usage: ./run-codex.sh <prompt-file> <input-file> [schema-file]
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
  SCHEMA_ARGS=(--output-schema "$SCHEMA_FILE")
fi

TRACE_FILE="$(mktemp)"
trap 'rm -f -- "$TRACE_FILE"' EXIT

if ! codex exec \
  --model "$MODEL" \
  --config "instructions='''$(<"$PROMPT_FILE")'''" \
  --config 'approval_policy="never"' \
  --strict-config \
  --sandbox read-only \
  --ephemeral \
  --skip-git-repo-check \
  --ignore-user-config \
  --ignore-rules \
  "${SCHEMA_ARGS[@]}" \
  <"$INPUT_FILE" 2>"$TRACE_FILE"; then
  echo "Error: codex failed." >&2
  cat "$TRACE_FILE" >&2
  exit 1
fi
