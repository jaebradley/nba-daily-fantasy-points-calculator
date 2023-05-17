#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

main() {
  local file_directory
  file_directory=$(dirname "${BASH_SOURCE[0]}")
  if [[ 0 -ne $? ]]; then fail "Unable to calculate current file directory\n"; fi

  "${file_directory}/../../main.sh" "2023" "05" 06" || fail "Could not calculate points for May 6th, 2023"
  "${file_directory}/../../main.sh" "2023" "05" 06" "${file_directory}/../../.dependencies/bin/jq" || fail "Could not calculate points for May 6th, 2023"
}

main
