#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

NIMBLE_DIR="${NIMBLE_DIR:-${ROOT_DIR}/.nimble}"
BASOLATO_REPO="${BASOLATO_REPO:-https://github.com/itsumura-h/nim-basolato}"
DUCERE_LOCAL="${NIMBLE_DIR}/bin/ducere"

export NIMBLE_DIR

if [[ -x "${DUCERE_LOCAL}" ]]; then
  exit 0
fi

if command -v ducere >/dev/null 2>&1; then
  exit 0
fi

echo "Installing Basolato from ${BASOLATO_REPO} ..."
nimble install -y "${BASOLATO_REPO}"
