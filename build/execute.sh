#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../install dependencies.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../tests/run tests.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../utilities/error.sh"
. "$(dirname "${BASH_SOURCE[0]}")/linting/shellcheck.sh"

build() {
  if [[ 5 -ne $# ]]; then fail "Expected the following arguments: the path to the jq binary, the expected jq version, the path to the shellcheck program, the path to the test directory, the path to the directory to lint"; fi

  local -r jq_path="$1"
  local -r expected_version="$2"
  local -r shellcheck_path="$3"
  local -r test_directory_path="$4"
  local -r linting_directory_path="$5"

  install_dependencies "${jq_path}" "${expected_version}" "${shellcheck_path}" || fail "Failed to install dependencies\n"
  run_tests "${test_directory_path}" || fail "Failed to run tests in ${test_directory_path}\n"
  lint_sh_files "${shellcheck_path}" "${linting_directory_path}" || fail "Failed to lint files in ${linting_directory_path}"
}

build "$(dirname "${BASH_SOURCE[0]}")/../.dependencies/bin/jq" "jq-1.6" "$(dirname "${BASH_SOURCE[0]}")/../.dependencies/bin/shellcheck" "$(dirname "${BASH_SOURCE[0]}")/../tests" "$(dirname "${BASH_SOURCE[0]}")/../"
