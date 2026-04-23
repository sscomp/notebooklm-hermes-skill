#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
instructions="${*:-請做成適合簡報使用的 slide deck。}"
run_notebooklm generate slide-deck "$instructions" --format detailed --wait
