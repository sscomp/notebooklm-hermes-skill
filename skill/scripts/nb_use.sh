#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
require_arg "${1:-}" "Usage: nb_use.sh <notebook_id>"

target="$*"

if [[ "$target" =~ ^[0-9a-fA-F-]{36}$ ]]; then
  run_notebooklm use "$target"
  exit 0
fi

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

run_notebooklm list --json >"$tmp_json"

resolved_id="$("$PYTHON_BIN" - "$tmp_json" "$target" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
target = sys.argv[2].strip()
target_lower = target.lower()
notebooks = data.get("notebooks", [])

if not target:
    raise SystemExit("Usage: nb_use.sh <notebook_id>")

def pick_unique(matches, label):
    if len(matches) == 1:
        print(matches[0]["id"])
        raise SystemExit(0)
    if len(matches) > 1:
        print(f"Ambiguous {label} '{target}' matches {len(matches)} notebooks:", file=sys.stderr)
        for nb in matches[:5]:
            print(f"- {nb.get('id')} | {nb.get('title') or '(untitled)'}", file=sys.stderr)
        raise SystemExit(1)

pick_unique([nb for nb in notebooks if (nb.get("id") or "").lower() == target_lower], "ID")
pick_unique([nb for nb in notebooks if (nb.get("id") or "").lower().startswith(target_lower)], "ID prefix")
pick_unique([nb for nb in notebooks if (nb.get("title") or "") == target], "title")
pick_unique([nb for nb in notebooks if (nb.get("title") or "").lower().startswith(target_lower)], "title prefix")
pick_unique([nb for nb in notebooks if target_lower in (nb.get("title") or "").lower()], "title")

print(
    f"No notebook found for '{target}'. Run /nb-list to copy the notebook ID.",
    file=sys.stderr,
)
raise SystemExit(1)
PY
)"

run_notebooklm use "$resolved_id"
