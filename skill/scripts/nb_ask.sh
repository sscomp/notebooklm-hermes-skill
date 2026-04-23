#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/nb_env.sh"
question="$*"
require_arg "$question" "Usage: nb_ask.sh <question>"
run_notebooklm ask "$question"
