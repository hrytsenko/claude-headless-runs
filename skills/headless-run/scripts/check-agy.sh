#!/usr/bin/env bash
# Usage: ./check-agy.sh
set -euo pipefail

if ! command -v agy >/dev/null 2>&1; then
  echo "Error: agy is not installed (not on PATH)." >&2
  exit 1
fi

# agy has no login status command; auth problems surface when the run fails.
echo "agy is installed; login cannot be checked."
