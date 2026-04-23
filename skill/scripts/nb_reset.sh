#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
run_notebooklm clear
echo "NotebookLM active context cleared for NOTEBOOKLM_HOME=$NOTEBOOKLM_HOME"
