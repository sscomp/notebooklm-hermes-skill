#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
run_notebooklm status --paths
run_notebooklm status || true
run_notebooklm auth check || true
