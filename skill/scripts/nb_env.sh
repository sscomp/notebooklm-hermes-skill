#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -z "${HERMES_HOME:-}" ]; then
  HERMES_HOME="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
fi

HERMES_ROOT="${HERMES_ROOT:-$HOME/.hermes}"
NOTEBOOKLM_BIN="${NOTEBOOKLM_BIN:-$HERMES_ROOT/tools/notebooklm-py-venv/bin/notebooklm}"
PYTHON_BIN="${PYTHON_BIN:-$HERMES_ROOT/tools/notebooklm-py-venv/bin/python}"

if [ ! -x "$NOTEBOOKLM_BIN" ]; then
  ALT_BIN="$(command -v notebooklm || true)"
  if [ -n "$ALT_BIN" ]; then
    NOTEBOOKLM_BIN="$ALT_BIN"
  fi
fi
if [ ! -x "$NOTEBOOKLM_BIN" ]; then
  echo "notebooklm binary not found. Set NOTEBOOKLM_BIN or run bootstrap-notebooklm.sh." >&2
  exit 2
fi

export NOTEBOOKLM_HOME="${NOTEBOOKLM_HOME:-$HERMES_HOME/notebooklm}"
export NOTEBOOKLM_OUTPUT_DIR="${NOTEBOOKLM_OUTPUT_DIR:-$NOTEBOOKLM_HOME/outputs}"
mkdir -p "$NOTEBOOKLM_HOME" "$NOTEBOOKLM_OUTPUT_DIR"

run_notebooklm() {
  "$NOTEBOOKLM_BIN" "$@"
}

require_arg() {
  local value="${1:-}"
  local message="$2"
  if [ -z "$value" ]; then
    echo "$message" >&2
    exit 2
  fi
}
