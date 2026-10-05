#!/usr/bin/env bash
# Usage: ./check-codex.sh
set -euo pipefail

if ! command -v codex >/dev/null 2>&1; then
  echo "Error: codex is not installed (not on PATH)." >&2
  exit 1
fi

if ! status="$(codex login status </dev/null 2>&1)"; then
  echo "Error: codex is not logged in." >&2
  printf '%s\n' "$status" >&2
  exit 1
fi

printf '%s\n' "$status"
