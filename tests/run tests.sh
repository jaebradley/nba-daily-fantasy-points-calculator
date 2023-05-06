#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/execute test file.sh";
. "$(dirname "${BASH_SOURCE[0]}")/../utilities/error.sh"

run_tests() {
  if [[ "1" != "$#" ]]; then fail "Expected test directory path as a single argument instead of '$@'\\n"; fi

  local -r test_directory_path="$1"
  if [[ ! -d "${test_directory_path}" ]]; then fail "${test_directory_path} is not a directory\n"; fi

  find "${test_directory_path}/unit" -type f -name "*.sh" -print0 | \
    sort --zero-terminated | \
    while IFS= read -r -d '' file
    do 
      execute_test_file "${file}" || fail "Test failed for ${file}"
    done
}
