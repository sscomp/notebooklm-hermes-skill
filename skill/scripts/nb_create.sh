#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"

title="$*"
require_arg "$title" "Usage: nb_create.sh <notebook-title>"

output="$(run_notebooklm create "$title" --json)"
printf '%s\n' "$output"

notebook_id="$(printf '%s' "$output" | "$PYTHON_BIN" -c 'import json,sys; data=json.load(sys.stdin); print(data.get("id") or data.get("notebook",{}).get("id",""))')"
if [ -n "$notebook_id" ]; then
  run_notebooklm use "$notebook_id"
  echo "Active notebook set to: $notebook_id"
fi
