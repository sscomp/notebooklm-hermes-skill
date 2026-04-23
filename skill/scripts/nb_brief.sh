#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
instructions="${*:-請產生一份結構清楚、可供決策使用的 briefing document。}"
run_notebooklm generate report "$instructions" --format briefing-doc --wait
