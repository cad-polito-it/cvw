#!/usr/bin/env bash
set -euo pipefail
cvw_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
exec make -C "$cvw_root/sbst" "$@"
