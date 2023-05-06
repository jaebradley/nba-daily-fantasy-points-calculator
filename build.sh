#!/bin/bash

if [[ ! -x "$(dirname "${BASH_SOURCE[0]}")/install dependencies.sh" ]]; then printf "Cannot execute installation dependencies script" && exit 255; fi
if [[ ! -x "$(dirname "${BASH_SOURCE[0]}")/tests/run tests.sh" ]]; then printf "Cannot execute test running script" && exit 255; fi

. "$(dirname "${BASH_SOURCE[0]}")/install dependencies.sh"
. "$(dirname "${BASH_SOURCE[0]}")/tests/run tests.sh"

build() {
  if [[ 3 -ne $# ]]; then printf "Expected three arguments: the path to the jq binary, the expected jq version, and the path to the test directory" && exit 255; fi

  local -r jq_path="$1"
  local -r expected_version="$2"
  local -r test_directory_path="$3"

  $(install_dependencies "${jq_path}" "${expected_version}")
  if [[ $? -ne 0 ]]; then printf "Failed to install dependencies\n" && exit 255; fi

  run_tests "${test_directory_path}" || exit 255
}

build "$(dirname "${BASH_SOURCE[0]}")/.dependencies/bin/jq" "jq-1.6" "$(dirname "${BASH_SOURCE[0]}")/tests"
