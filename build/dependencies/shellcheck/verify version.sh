#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../utilities/error.sh" || exit 255

verify_shellcheck_version() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the path to the shellcheck program and the expected shellcheck version\n"; fi

  local -r shellcheck_path="$1"
  local -r expected_version="$2"

  if [[ ! -e "${shellcheck_path}" ]]; then fail "shellcheck program at ${shellcheck_path} does not exist"; fi
  if [[ ! -f "${shellcheck_path}" ]]; then fail "shellcheck program at ${shellcheck_path} is not a regular file"; fi
  if [[ ! -x "${shellcheck_path}" ]]; then fail "shellcheck program at ${shellcheck_path} is not executable"; fi

  local shellcheck_version
  shellcheck_version=$("${shellcheck_path}" --version | sed -n "2,2p" | cut -d' ' -f2)
  if [[ 0 -ne $? ]]; then fail "Could not calculate version for shellcheck program at ${shellcheck_path}"; fi
  if [[ "${shellcheck_version}" != "${expected_version}" ]]; then fail "Shellcheck version: ${shellcheck_version} was not equal to the expected version: ${expected_version}"; fi
}

