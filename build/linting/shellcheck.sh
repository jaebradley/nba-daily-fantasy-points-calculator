#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

lint_sh_files() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the path to the shellcheck program, and the path to the directory to lint\n"; fi

  local -r shellcheck_path="$1"
  local -r directory_path="$2"

  find "${directory_path}" -type f -name "*.sh" -print0 | xargs -0 -I {} "${shellcheck_path}" {}

  if [[ "${PIPESTATUS[0]}" -ne "0" || "${PIPESTATUS[1]}" -ne "0" ]]
  then
    fail "Could not successfully lint all .sh files in ${directory_path}\n";
  fi
}
