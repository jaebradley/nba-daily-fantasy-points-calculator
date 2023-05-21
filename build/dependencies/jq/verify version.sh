#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../utilities/error.sh" || exit 255

verify_jq_version() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the path to the jq binary and the expected jq version"; fi

  local -r jq_binary_path="$1"
  local -r expected_version="$2"

  if [[ ! -x "${jq_binary_path}" ]]; then fail "jq binary at path ${jq_binary_path} is not executable"; fi

  local jq_version
  jq_version=$("${jq_binary_path}" --version)
  if [[ $? -ne 0 ]]; then fail "Failed to identify jq version for binary at path ${jq_binary_path}\n"; fi

  if [[ "${expected_version}" != "${jq_version}" ]]; then fail "Expected jq version to be ${expected_version} but got ${jq_version}"; fi
}
