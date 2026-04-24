#!/usr/bin/env bash
set -euo pipefail

PROFILE_HOME="${1:-}"
SKIP_RUNTIME="${2:-}"
if [ -z "$PROFILE_HOME" ]; then
  echo "Usage: install-profile.sh <hermes-profile-home> [--skip-runtime]" >&2
  exit 2
fi
if [ ! -d "$PROFILE_HOME" ]; then
  echo "Profile path not found: $PROFILE_HOME" >&2
  exit 2
fi
if [ -n "$SKIP_RUNTIME" ] && [ "$SKIP_RUNTIME" != "--skip-runtime" ]; then
  echo "Unknown option: $SKIP_RUNTIME" >&2
  echo "Usage: install-profile.sh <hermes-profile-home> [--skip-runtime]" >&2
  exit 2
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_SRC="$REPO_DIR/skill"
SKILL_DST="$PROFILE_HOME/skills/research/notebooklm"
BIN_DST="$PROFILE_HOME/bin/nb"
HERMES_ROOT="$(cd "$PROFILE_HOME/../.." && pwd)"

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

if [ "$SKIP_RUNTIME" != "--skip-runtime" ]; then
  HERMES_ROOT="$HERMES_ROOT" "$REPO_DIR/scripts/bootstrap-notebooklm.sh"
fi

echo "Installed NotebookLM skill into: $PROFILE_HOME"
echo "  skill: $SKILL_DST"
echo "  wrapper: $BIN_DST"
if [ "$SKIP_RUNTIME" = "--skip-runtime" ]; then
  echo "  runtime: skipped (--skip-runtime)"
else
  echo "  runtime: $HERMES_ROOT/tools/notebooklm-py-venv/bin/notebooklm"
fi
echo "Recommended next step: enable Hermes CLI access so you can run: $PROFILE_HOME/bin/nb list"
echo "Optional legacy compatibility: merge templates/quick_commands.yaml into $PROFILE_HOME/config.yaml only if you still want slash aliases."
