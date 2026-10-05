#!/usr/bin/env bash
# Usage: ./check-claude.sh
set -euo pipefail

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: claude is not installed (not on PATH)." >&2
  exit 1
fi

if ! status="$(claude auth status --text </dev/null 2>&1)"; then
  echo "Error: claude is not logged in." >&2
  printf '%s\n' "$status" >&2
  exit 1
fi

printf '%s\n' "$status"
