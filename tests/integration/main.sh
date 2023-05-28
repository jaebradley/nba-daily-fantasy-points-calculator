#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

main() {
  local file_directory
  if ! file_directory=$(dirname "${BASH_SOURCE[0]}"); then fail "Unable to calculate current file directory\n"; fi

  local -r executable_script_path="${file_directory}/../../main.sh";

  "${executable_script_path}" 2023 05 06 &> /dev/null || fail "Could not calculate points for May 6th, 2023 using default jq program"

  local -r jq_executable_path="${file_directory}/../../.dependencies/bin/jq"
  "${executable_script_path}" 2023 05 06 "${jq_executable_path}"  &> /dev/null || fail "Could not calculate points for May 6th, 2023using specified jq program"
}

main
