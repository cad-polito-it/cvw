#!/usr/bin/env bash
set -euo pipefail
cvw_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec python3 "$cvw_root/bin/run_cvw.py" sim gate "$@"
