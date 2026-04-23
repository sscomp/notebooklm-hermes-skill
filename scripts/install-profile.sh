#!/usr/bin/env bash
set -euo pipefail

PROFILE_HOME="${1:-}"
if [ -z "$PROFILE_HOME" ]; then
  echo "Usage: install-profile.sh <hermes-profile-home>" >&2
  exit 2
fi
if [ ! -d "$PROFILE_HOME" ]; then
  echo "Profile path not found: $PROFILE_HOME" >&2
  exit 2
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$REPO_DIR/skill"
SKILL_DST="$PROFILE_HOME/skills/research/notebooklm"
BIN_DST="$PROFILE_HOME/bin/nb"

mkdir -p "$PROFILE_HOME/skills/research" "$PROFILE_HOME/bin"
rm -rf "$SKILL_DST"
cp -R "$SKILL_SRC" "$SKILL_DST"

cat > "$BIN_DST" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export HERMES_HOME="\${HERMES_HOME:-$PROFILE_HOME}"
exec "\$HERMES_HOME/skills/research/notebooklm/scripts/nb.sh" "\$@"
EOF
chmod +x "$BIN_DST"

find "$SKILL_DST/scripts" -type f -name "*.sh" -exec chmod +x {} +

echo "Installed NotebookLM skill into: $PROFILE_HOME"
echo "  skill: $SKILL_DST"
echo "  wrapper: $BIN_DST"
echo "Next: merge quick_commands from templates/quick_commands.yaml into $PROFILE_HOME/config.yaml"
