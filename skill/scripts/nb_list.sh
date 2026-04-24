#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"

if [ "${1:-}" = "--json" ]; then
  run_notebooklm list "$@"
  exit 0
fi

tmp_json="$(mktemp)"
trap 'rm -f "$tmp_json"' EXIT

run_notebooklm list --json "$@" >"$tmp_json"

"$PYTHON_BIN" - "$tmp_json" <<'PY'
import json
import sys
from pathlib import Path

data = json.loads(Path(sys.argv[1]).read_text(encoding="utf-8"))
notebooks = data.get("notebooks", [])

if not notebooks:
    print("No notebooks found.")
    raise SystemExit(0)

lines = ["Notebooks"]
for index, nb in enumerate(notebooks, 1):
    title = nb.get("title") or "(untitled)"
    owner = "Owner" if nb.get("is_owner") else "Shared"
    created_at = nb.get("created_at") or "-"
    created = created_at.split("T", 1)[0] if created_at != "-" else "-"
    lines.append(f"{index}. {title}")
    lines.append(f"ID: {nb.get('id', '-')}")
    lines.append(f"Owner: {owner} | Created: {created}")
    if index != len(notebooks):
        lines.append("")

print("\n".join(lines))
PY
