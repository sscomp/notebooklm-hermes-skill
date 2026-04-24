#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_usage() {
  local stream="${1:-stderr}"
  if [ "$stream" = "stdout" ]; then
    cat <<'EOF'
Usage: nb <command> [args...]

Commands:
  create    Create a notebook and set it active
  use       Switch active notebook by ID or title
  add       Add a source to the active notebook
  research  Start research import
  ask       Ask a question against the active notebook
  brief     Generate a briefing artifact
  slides    Generate slide deck artifact
  podcast   Generate podcast/audio artifact
  quiz      Generate quiz artifact
  mindmap   Generate mind map artifact
  download  Download an artifact
  reset     Clear active notebook context
  status    Show notebook and auth status
  list      List notebooks
  login     Run NotebookLM login for this profile

Examples:
  nb list
  nb use "Project Notes"
  nb ask "Summarize the top 3 risks"
EOF
  else
    cat >&2 <<'EOF'
Usage: nb <command> [args...]

Commands:
  create    Create a notebook and set it active
  use       Switch active notebook by ID or title
  add       Add a source to the active notebook
  research  Start research import
  ask       Ask a question against the active notebook
  brief     Generate a briefing artifact
  slides    Generate slide deck artifact
  podcast   Generate podcast/audio artifact
  quiz      Generate quiz artifact
  mindmap   Generate mind map artifact
  download  Download an artifact
  reset     Clear active notebook context
  status    Show notebook and auth status
  list      List notebooks
  login     Run NotebookLM login for this profile

Examples:
  nb list
  nb use "Project Notes"
  nb ask "Summarize the top 3 risks"
EOF
  fi
}

cmd="${1:-}"
if [ -z "$cmd" ]; then
  print_usage stderr
  exit 2
fi
shift

case "$cmd" in
  help|-h|--help) print_usage stdout; exit 0 ;;
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
  *) echo "Unknown NotebookLM command: $cmd" >&2; print_usage stderr; exit 2 ;;
esac
