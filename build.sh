#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/install dependencies.sh"
. "$(dirname "${BASH_SOURCE[0]}")/tests/run tests.sh"
. "$(dirname "${BASH_SOURCE[0]}")/utilities/error.sh"

build() {
  if [[ 3 -ne $# ]]; then fail "Expected three arguments: the path to the jq binary, the expected jq version, and the path to the test directory"; fi

  local -r jq_path="$1"
  local -r expected_version="$2"
  local -r test_directory_path="$3"

  install_dependencies "${jq_path}" "${expected_version}" || fail "Failed to install dependencies\n"
  run_tests "${test_directory_path}" || fail "Failed to install dependencies\n"
}

build "$(dirname "${BASH_SOURCE[0]}")/.dependencies/bin/jq" "jq-1.6" "$(dirname "${BASH_SOURCE[0]}")/tests"
