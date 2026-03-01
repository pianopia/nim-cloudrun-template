#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

"${ROOT_DIR}/scripts/install_basolato.sh"
./scripts/tailwind.sh build

echo "Setup complete. Run: ./scripts/dev.sh"
