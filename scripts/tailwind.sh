#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "${ROOT_DIR}/scripts/load_env.sh"
load_env_file "${ROOT_DIR}/.env"

BIN_DIR="${ROOT_DIR}/tools/bin"
BIN_PATH="${BIN_DIR}/tailwindcss"
TAILWIND_VERSION="${TAILWIND_VERSION:-v3.4.17}"
TAILWIND_SHA256="${TAILWIND_SHA256:-}"

verify_sha256() {
  local file_path="$1"
  local expected="$2"
  local actual=""

  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "${file_path}" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "${file_path}" | awk '{print $1}')"
  else
    echo "sha256sum/shasum command is required for checksum verification." >&2
    exit 1
  fi

  if [[ "${actual}" != "${expected}" ]]; then
    echo "Tailwind checksum mismatch. expected=${expected} actual=${actual}" >&2
    exit 1
  fi
}

command="${1:-build}"
if [[ "$command" != "build" && "$command" != "watch" ]]; then
  echo "Usage: $0 [build|watch]" >&2
  exit 1
fi

os="$(uname -s)"
arch="$(uname -m)"

case "${os}-${arch}" in
  Darwin-arm64)
    asset="tailwindcss-macos-arm64"
    ;;
  Darwin-x86_64)
    asset="tailwindcss-macos-x64"
    ;;
  Linux-x86_64)
    asset="tailwindcss-linux-x64"
    ;;
  Linux-aarch64)
    asset="tailwindcss-linux-arm64"
    ;;
  *)
    echo "Unsupported platform: ${os}-${arch}" >&2
    exit 1
    ;;
esac

if [[ -z "${TAILWIND_SHA256}" ]]; then
  echo "TAILWIND_SHA256 is required. Fetch the official checksum and set it before running this script." >&2
  exit 1
fi

mkdir -p "${BIN_DIR}" "${ROOT_DIR}/public/css"

if [[ ! -x "${BIN_PATH}" ]]; then
  url="https://github.com/tailwindlabs/tailwindcss/releases/download/${TAILWIND_VERSION}/${asset}"
  echo "Downloading Tailwind CSS ${TAILWIND_VERSION} (${asset})..."
  curl -fsSL "${url}" -o "${BIN_PATH}"
fi

verify_sha256 "${BIN_PATH}" "${TAILWIND_SHA256}"
chmod +x "${BIN_PATH}"

args=(
  -c "${ROOT_DIR}/tailwind.config.js"
  -i "${ROOT_DIR}/src/styles/tailwind.css"
  -o "${ROOT_DIR}/public/css/tailwind.css"
)

if [[ "$command" == "build" ]]; then
  exec "${BIN_PATH}" "${args[@]}" --minify
fi

exec "${BIN_PATH}" "${args[@]}" --watch
