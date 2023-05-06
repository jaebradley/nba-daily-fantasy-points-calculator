#!/bin/bash

. "$(dirname "${BASH_SOURCE}")/utilities/execute test file.sh";

run_tests() {
  if [[ "1" != "$#" ]]; then printf "Expected test directory path as a single argument instead of '$@'\\n" && exit 255; fi

  local -r test_directory_path="$1"
  if [[ ! -d "${test_directory_path}" ]]; then printf "${test_directory_path} is not a directory\n" && exit 255; fi

  find "${test_directory_path}/unit" -type f -name "*.sh" -print0 | \
    sort --zero-terminated | \
    while IFS= read -r -d '' file
    do 
      execute_test_file "${file}" || exit 255
    done
}
