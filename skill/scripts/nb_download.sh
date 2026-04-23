#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"

artifact_type="${1:-}"
require_arg "$artifact_type" "Usage: nb_download.sh <audio|video|slide-deck|report|mind-map|quiz|data-table|infographic|flashcards> [output-path]"
shift || true

output="${1:-}"
if [ -z "$output" ]; then
  case "$artifact_type" in
    audio) output="$NOTEBOOKLM_OUTPUT_DIR/audio.mp3" ;;
    video|cinematic-video) output="$NOTEBOOKLM_OUTPUT_DIR/video.mp4" ;;
    slide-deck) output="$NOTEBOOKLM_OUTPUT_DIR/slides.pdf" ;;
    report) output="$NOTEBOOKLM_OUTPUT_DIR/report.md" ;;
    mind-map) output="$NOTEBOOKLM_OUTPUT_DIR/mindmap.json" ;;
    quiz) output="$NOTEBOOKLM_OUTPUT_DIR/quiz.json" ;;
    data-table) output="$NOTEBOOKLM_OUTPUT_DIR/data.csv" ;;
    infographic) output="$NOTEBOOKLM_OUTPUT_DIR/infographic.png" ;;
    flashcards) output="$NOTEBOOKLM_OUTPUT_DIR/flashcards.json" ;;
    *) output="$NOTEBOOKLM_OUTPUT_DIR/$artifact_type.out" ;;
  esac
fi

run_notebooklm download "$artifact_type" "$output" "${@:2}"
echo "Downloaded to: $output"
