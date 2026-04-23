#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
instructions="${*:-請生成清楚、有脈絡的音訊導讀。}"
run_notebooklm generate audio "$instructions" --format brief --wait
