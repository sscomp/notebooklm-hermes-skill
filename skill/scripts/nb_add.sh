#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
require_arg "${1:-}" "Usage: nb_add.sh <url|youtube|file|text> [notebooklm source add options]"
run_notebooklm source add "$@"
