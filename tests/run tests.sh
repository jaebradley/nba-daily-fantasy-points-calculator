#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../utilities/error.sh" || exit 255
. "$(dirname "${BASH_SOURCE[0]}")/utilities/execute test file.sh" || fail "Could not import test execution script"

run_tests() {
  if [[ "1" != "$#" ]]; then fail "Expected test directory path as a single argument instead of '$*'\\n"; fi

  local -r test_directory_path="$1"
  if [[ ! -d "${test_directory_path}" ]]; then fail "${test_directory_path} is not a directory\n"; fi

  find "${test_directory_path}" -type f -name "*.sh" -print0 | \
    sort --zero-terminated | \
    while IFS= read -r -d '' file
    do 
      execute_test_file "${file}" || fail "Test failed for ${file}\n"
    done
}
