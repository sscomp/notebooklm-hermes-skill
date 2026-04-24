#!/usr/bin/env bash
set -euo pipefail

HERMES_ROOT="${HERMES_ROOT:-$HOME/.hermes}"
VENV_DIR="${NOTEBOOKLM_VENV_DIR:-$HERMES_ROOT/tools/notebooklm-py-venv}"
NOTEBOOKLM_PY_SPEC="${NOTEBOOKLM_PY_SPEC:-notebooklm-py[browser]==0.3.4}"

mkdir -p "$(dirname "$VENV_DIR")"

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install "$NOTEBOOKLM_PY_SPEC"
"$VENV_DIR/bin/playwright" install chromium

echo "NotebookLM runtime installed:"
echo "  $VENV_DIR/bin/notebooklm"
echo "  package: $NOTEBOOKLM_PY_SPEC"
