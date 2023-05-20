#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/dependencies/install.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../tests/run tests.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../utilities/error.sh"
. "$(dirname "${BASH_SOURCE[0]}")/linting/shellcheck.sh"

build() {
  if [[ 6 -ne $# ]]; then fail "Expected the following arguments: the path to the jq binary, the expected jq version, the path to the shellcheck program, the expected shellcheck version, the path to the test directory, the path to the directory to lint"; fi

  local -r jq_path="$1"
  local -r expected_jq_version="$2"
  local -r shellcheck_path="$3"
  local -r expected_shellcheck_version="$4"
  local -r test_directory_path="$5"
  local -r linting_directory_path="$6"

  install_dependencies "${jq_path}" "${expected_jq_version}" "${shellcheck_path}" "${expected_shellcheck_version}" || fail "Failed to install dependencies\n"
  run_tests "${test_directory_path}" || fail "Failed to run tests in ${test_directory_path}\n"
  lint_sh_files "${shellcheck_path}" "${linting_directory_path}" || fail "Failed to lint files in ${linting_directory_path}"
}

build "$(dirname "${BASH_SOURCE[0]}")/../.dependencies/bin/jq" "jq-1.6" "$(dirname "${BASH_SOURCE[0]}")/../.dependencies/bin/shellcheck" "0.9.0" "$(dirname "${BASH_SOURCE[0]}")/../tests" "$(dirname "${BASH_SOURCE[0]}")/../"
