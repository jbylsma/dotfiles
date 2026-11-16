#!/usr/bin/env bash
# Install the pinned chezmoi release to ~/.local/bin.
#
# chezmoi reruns a run_onchange_ script whenever its contents change, so
# bumping the pin below upgrades each host on its next `chezmoi update`.
# misc/bootstrap also runs this directly, before chezmoi exists.
#
# The download is checked against the SHA-256 pinned here before it's
# installed. Take new hashes from the release's checksums.txt. amd64 uses the
# static musl build, because the glibc build needs glibc 2.34 and RHEL 8 has
# 2.28. arm64 has only a pure Go build.
set -euo pipefail

readonly CHEZMOI_VERSION='2.74.1'
# chezmoi_<version>_linux-musl_amd64.tar.gz
readonly CHEZMOI_SHA256_AMD64='505d529beaff4ab1ba64bc99a407665148981996ae872549e8217afc58e6616c'
# chezmoi_<version>_linux_arm64.tar.gz
readonly CHEZMOI_SHA256_ARM64='8c62619c4303770342e7c7e75d168b6cc6efee4ad5e4b994980de7cf794d68e2'

readonly BIN_DIR="${HOME}/.local/bin"
readonly CHEZMOI="${BIN_DIR}/chezmoi"

tmp_dir=''

cleanup() {
  if [[ -n "${tmp_dir}" ]]; then
    rm -rf "${tmp_dir}"
  fi
}

main() {
  local arch asset sha256 url version

  if [[ -x "${CHEZMOI}" ]]; then
    version="$("${CHEZMOI}" --version)"
    if [[ "${version}" == "chezmoi version v${CHEZMOI_VERSION},"* ]]; then
      return 0
    fi
  fi

  arch="$(uname -m)"
  case "${arch}" in
    x86_64)
      asset="chezmoi_${CHEZMOI_VERSION}_linux-musl_amd64.tar.gz"
      sha256="${CHEZMOI_SHA256_AMD64}"
      ;;
    aarch64)
      asset="chezmoi_${CHEZMOI_VERSION}_linux_arm64.tar.gz"
      sha256="${CHEZMOI_SHA256_ARM64}"
      ;;
    *)
      echo "install-chezmoi: unsupported architecture ${arch}" >&2
      return 1
      ;;
  esac
  url="https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/${asset}"

  if ! command -v curl >/dev/null 2>&1; then
    echo 'install-chezmoi: curl is required' >&2
    return 1
  fi

  trap cleanup EXIT
  tmp_dir="$(mktemp -d)"

  echo "install-chezmoi: installing chezmoi ${CHEZMOI_VERSION}"
  curl --fail --silent --show-error --location --proto '=https' \
    --output "${tmp_dir}/${asset}" "${url}"
  if ! printf '%s  %s\n' "${sha256}" "${tmp_dir}/${asset}" \
    | sha256sum --check --status; then
    echo "install-chezmoi: SHA-256 mismatch for ${asset}; not installing" >&2
    return 1
  fi

  tar -xzf "${tmp_dir}/${asset}" -C "${tmp_dir}" chezmoi
  mkdir -p "${BIN_DIR}"
  # Install beside the target, then rename over it, so a running chezmoi is
  # never left with a half-written binary.
  install -m 0755 "${tmp_dir}/chezmoi" "${BIN_DIR}/.chezmoi.new"
  mv -f "${BIN_DIR}/.chezmoi.new" "${CHEZMOI}"
}

main "$@"
