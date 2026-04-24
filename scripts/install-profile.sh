#!/usr/bin/env bash
set -euo pipefail

PROFILE_HOME="${1:-}"
if [ -z "$PROFILE_HOME" ]; then
  echo "Usage: install-profile.sh <hermes-profile-home> [--skip-runtime]" >&2
  exit 2
fi
if [ ! -d "$PROFILE_HOME" ]; then
  echo "Profile path not found: $PROFILE_HOME" >&2
  exit 2
fi

SKIP_RUNTIME=0

shift
while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-runtime)
      SKIP_RUNTIME=1
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: install-profile.sh <hermes-profile-home> [--skip-runtime]" >&2
      exit 2
      ;;
  esac
  shift
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$REPO_DIR/skill"
SKILL_DST="$PROFILE_HOME/skills/research/notebooklm"
BIN_DST="$PROFILE_HOME/bin/nb"
HERMES_ROOT="$(cd "$PROFILE_HOME/../.." && pwd)"
CONFIG_DST="$PROFILE_HOME/config.yaml"

mkdir -p "$PROFILE_HOME/skills/research" "$PROFILE_HOME/bin"
rm -rf "$SKILL_DST"
cp -R "$SKILL_SRC" "$SKILL_DST"

cat > "$BIN_DST" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export HERMES_HOME="\${HERMES_HOME:-$PROFILE_HOME}"
exec bash "\$HERMES_HOME/skills/research/notebooklm/scripts/nb.sh" "\$@"
EOF
chmod +x "$BIN_DST"

find "$SKILL_DST/scripts" -type f -name "*.sh" -exec chmod +x {} +

python3 - "$CONFIG_DST" "$PROFILE_HOME" <<'PY'
import sys
from pathlib import Path

config_path = Path(sys.argv[1])
profile_home = sys.argv[2]

rendered_block = f"""quick_commands:
  nb-create:
    type: exec
    command: {profile_home}/bin/nb create {{args}}
  nb_create:
    type: exec
    command: {profile_home}/bin/nb create {{args}}
  nb-use:
    type: exec
    command: {profile_home}/bin/nb use {{args}}
  nb_use:
    type: exec
    command: {profile_home}/bin/nb use {{args}}
  nb-add:
    type: exec
    command: {profile_home}/bin/nb add {{args}}
  nb_add:
    type: exec
    command: {profile_home}/bin/nb add {{args}}
  nb-research:
    type: exec
    command: {profile_home}/bin/nb research {{args}}
  nb_research:
    type: exec
    command: {profile_home}/bin/nb research {{args}}
  nb-ask:
    type: exec
    command: {profile_home}/bin/nb ask {{args}}
  nb_ask:
    type: exec
    command: {profile_home}/bin/nb ask {{args}}
  nb-brief:
    type: exec
    command: {profile_home}/bin/nb brief {{args}}
  nb_brief:
    type: exec
    command: {profile_home}/bin/nb brief {{args}}
  nb-slides:
    type: exec
    command: {profile_home}/bin/nb slides {{args}}
  nb_slides:
    type: exec
    command: {profile_home}/bin/nb slides {{args}}
  nb-podcast:
    type: exec
    command: {profile_home}/bin/nb podcast {{args}}
  nb_podcast:
    type: exec
    command: {profile_home}/bin/nb podcast {{args}}
  nb-quiz:
    type: exec
    command: {profile_home}/bin/nb quiz {{args}}
  nb_quiz:
    type: exec
    command: {profile_home}/bin/nb quiz {{args}}
  nb-mindmap:
    type: exec
    command: {profile_home}/bin/nb mindmap {{args}}
  nb_mindmap:
    type: exec
    command: {profile_home}/bin/nb mindmap {{args}}
  nb-download:
    type: exec
    command: {profile_home}/bin/nb download {{args}}
  nb_download:
    type: exec
    command: {profile_home}/bin/nb download {{args}}
  nb-reset:
    type: exec
    command: {profile_home}/bin/nb reset
  nb_reset:
    type: exec
    command: {profile_home}/bin/nb reset
  nb-list:
    type: exec
    command: {profile_home}/bin/nb list {{args}}
  nb_list:
    type: exec
    command: {profile_home}/bin/nb list {{args}}
  nb-status:
    type: exec
    command: {profile_home}/bin/nb status {{args}}
  nb_status:
    type: exec
    command: {profile_home}/bin/nb status {{args}}
  nb-login:
    type: exec
    command: {profile_home}/bin/nb login {{args}}
  nb_login:
    type: exec
    command: {profile_home}/bin/nb login {{args}}
"""


def is_top_level_key(line: str) -> bool:
    stripped = line.strip()
    if not stripped or line.startswith((" ", "\t")):
        return False
    return ":" in stripped and not stripped.startswith("#")


content = config_path.read_text(encoding="utf-8") if config_path.exists() else ""
lines = content.splitlines()
start = None
for i, line in enumerate(lines):
    if line.strip() == "quick_commands:" and not line.startswith((" ", "\t")):
        start = i
        break

if start is None:
    new_content = content.rstrip()
    if new_content:
        new_content += "\n"
    new_content += rendered_block
    config_path.write_text(new_content + "\n", encoding="utf-8")
    raise SystemExit(0)

end = len(lines)
for i in range(start + 1, len(lines)):
    if is_top_level_key(lines[i]):
        end = i
        break

updated_lines = lines[:start] + rendered_block.rstrip("\n").splitlines() + lines[end:]
config_path.write_text("\n".join(updated_lines).rstrip() + "\n", encoding="utf-8")
PY

if [ "$SKIP_RUNTIME" -eq 0 ]; then
  HERMES_ROOT="$HERMES_ROOT" "$REPO_DIR/scripts/bootstrap-notebooklm.sh"
fi

echo "Installed NotebookLM skill into: $PROFILE_HOME"
echo "  skill: $SKILL_DST"
echo "  wrapper: $BIN_DST"
if [ "$SKIP_RUNTIME" -eq 1 ]; then
  echo "  runtime: skipped (--skip-runtime)"
else
  echo "  runtime: $HERMES_ROOT/tools/notebooklm-py-venv/bin/notebooklm"
fi
echo "  quick_commands: installed into $CONFIG_DST"
echo "Recommended next step: restart the Hermes gateway, then test /nb-list in Telegram."
