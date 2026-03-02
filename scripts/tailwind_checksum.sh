#!/bin/sh
set -eu

version="${1:-}"
asset="${2:-}"

if [ -z "$version" ] || [ -z "$asset" ]; then
  echo "Usage: $0 <version> <asset>" >&2
  exit 1
fi

case "${version}:${asset}" in
  "v3.4.17:tailwindcss-linux-arm64")
    echo "69b1378b8133192d7d2feb12a116fa12d035594f58db3eff215879e4ad8cf39b"
    exit 0
    ;;
  "v3.4.17:tailwindcss-linux-armv7")
    echo "704e7d91afba6e1f630889afd0d7db36b4634e628512cc141d504a5beae28860"
    exit 0
    ;;
  "v3.4.17:tailwindcss-linux-x64")
    echo "7d24f7fa191d2193b78cd5f5a42a6093e14409521908529f42d80b11fde1f1d4"
    exit 0
    ;;
  "v3.4.17:tailwindcss-macos-arm64")
    echo "a1d0c7985759accca0bf12e51ac1dcbf0f6cf2fffb62e6e0f62d091c477a10a3"
    exit 0
    ;;
  "v3.4.17:tailwindcss-macos-x64")
    echo "6cbdad74be776c087ffa5e9a057512c54898f9fe8828d3362212dfe32fc933a3"
    exit 0
    ;;
  "v3.4.17:tailwindcss-windows-arm64.exe")
    echo "76f516476784c00f1562160b5758e3d8f0e6c48957efb26b5b50fbdfd76aa382"
    exit 0
    ;;
  "v3.4.17:tailwindcss-windows-x64.exe")
    echo "67f1c5e3f5a03406a7bf5badf5ada09b79f3ae78ec43450c15f7e983068da346"
    exit 0
    ;;
esac

checksums_url="https://github.com/tailwindlabs/tailwindcss/releases/download/${version}/sha256sums.txt"
checksum="$(curl -fsSL "${checksums_url}" | awk -v target="./${asset}" '$2 == target {print $1; exit}')"

if [ -z "$checksum" ]; then
  echo "Could not resolve Tailwind checksum for ${asset} (${version})" >&2
  exit 1
fi

echo "$checksum"
