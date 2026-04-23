#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"

query="$*"
require_arg "$query" "Usage: nb_research.sh <query>"
mode="${NB_RESEARCH_MODE:-fast}"
source_from="${NB_RESEARCH_FROM:-web}"

run_notebooklm source add-research "$query" --mode "$mode" --from "$source_from" --import-all
