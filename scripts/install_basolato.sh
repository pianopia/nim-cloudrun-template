#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"
. "${ROOT_DIR}/scripts/load_env.sh"
load_env_file "${ROOT_DIR}/.env"

NIMBLE_DIR="${NIMBLE_DIR:-${ROOT_DIR}/.nimble}"
BASOLATO_REPO="${BASOLATO_REPO:-https://github.com/itsumura-h/nim-basolato}"
BASOLATO_REF="${BASOLATO_REF:-6ef054fa959d4a10421723c5ccbd3ea9b751c240}"
DUCERE_LOCAL="${NIMBLE_DIR}/bin/ducere"

export NIMBLE_DIR

if [[ -x "${DUCERE_LOCAL}" ]]; then
  exit 0
fi

if command -v ducere >/dev/null 2>&1; then
  exit 0
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/basolato-src.XXXXXX")"
cleanup() {
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT INT TERM

echo "Installing Basolato ${BASOLATO_REF} from ${BASOLATO_REPO} ..."
git clone --filter=blob:none "${BASOLATO_REPO}" "${tmp_dir}/repo"
(
  cd "${tmp_dir}/repo"
  git checkout --detach "${BASOLATO_REF}"
  nimble install -y .
)
