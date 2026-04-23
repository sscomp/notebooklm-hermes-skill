#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cmd="${1:-}"
if [ -z "$cmd" ]; then
  echo "Usage: nb.sh <create|use|add|research|ask|brief|slides|podcast|quiz|mindmap|download|reset|status|list|login> [args...]" >&2
  exit 2
fi
shift

case "$cmd" in
  create) exec "$SCRIPT_DIR/nb_create.sh" "$@" ;;
  use) exec "$SCRIPT_DIR/nb_use.sh" "$@" ;;
  add) exec "$SCRIPT_DIR/nb_add.sh" "$@" ;;
  research) exec "$SCRIPT_DIR/nb_research.sh" "$@" ;;
  ask) exec "$SCRIPT_DIR/nb_ask.sh" "$@" ;;
  brief) exec "$SCRIPT_DIR/nb_brief.sh" "$@" ;;
  slides) exec "$SCRIPT_DIR/nb_slides.sh" "$@" ;;
  podcast) exec "$SCRIPT_DIR/nb_podcast.sh" "$@" ;;
  quiz) exec "$SCRIPT_DIR/nb_quiz.sh" "$@" ;;
  mindmap) exec "$SCRIPT_DIR/nb_mindmap.sh" "$@" ;;
  download) exec "$SCRIPT_DIR/nb_download.sh" "$@" ;;
  reset) exec "$SCRIPT_DIR/nb_reset.sh" "$@" ;;
  status) exec "$SCRIPT_DIR/nb_status.sh" "$@" ;;
  list) exec "$SCRIPT_DIR/nb_list.sh" "$@" ;;
  login) exec "$SCRIPT_DIR/nb_login.sh" "$@" ;;
  *) echo "Unknown NotebookLM command: $cmd" >&2; exit 2 ;;
esac
