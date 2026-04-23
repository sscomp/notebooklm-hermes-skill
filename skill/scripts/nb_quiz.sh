#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
instructions="${*:-請根據目前 notebook 來源產生測驗。}"
run_notebooklm generate quiz "$instructions" --difficulty medium --quantity standard --wait
