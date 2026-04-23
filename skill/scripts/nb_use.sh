#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
require_arg "${1:-}" "Usage: nb_use.sh <notebook_id>"
run_notebooklm use "$1"
