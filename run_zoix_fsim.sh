#!/usr/bin/env bash
set -euo pipefail
# LabInf: Z01X W-2024.09-SP2 needs its bundled Python 2.7 libraries (no effect elsewhere).
export LD_LIBRARY_PATH="/usr/local/synopsys/zoix/W-2024.09-SP2/lib/pylib27${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
cvw_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec python3 "$cvw_root/bin/run_cvw.py" fault "$@"
