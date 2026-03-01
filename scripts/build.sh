#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

"${ROOT_DIR}/scripts/install_basolato.sh"
"${ROOT_DIR}/scripts/tailwind.sh" build

nim c -d:release -o:main main.nim
