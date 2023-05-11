#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/install dependencies.sh"
. "$(dirname "${BASH_SOURCE[0]}")/tests/run tests.sh"
. "$(dirname "${BASH_SOURCE[0]}")/utilities/error.sh"

build() {
  if [[ 4 -ne $# ]]; then fail "Expected four arguments: the path to the jq binary, the expected jq version, the path to the shellcheck program, and the path to the test directory"; fi

  local -r jq_path="$1"
  local -r expected_version="$2"
  local -r shellcheck_path="$3"
  local -r test_directory_path="$4"

  install_dependencies "${jq_path}" "${expected_version}" "${shellcheck_path}" || fail "Failed to install dependencies\n"
  run_tests "${test_directory_path}" || fail "Failed to run tests in ${test_directory_path}\n"
}

build "$(dirname "${BASH_SOURCE[0]}")/.dependencies/bin/jq" "jq-1.6" "$(dirname "${BASH_SOURCE[0]}")/.dependencies/bin/shellcheck" "$(dirname "${BASH_SOURCE[0]}")/tests"
