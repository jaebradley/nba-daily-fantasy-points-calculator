#!/bin/bash

declare current_directory
current_directory=$(dirname "${BASH_SOURCE[0]}")
if [[ 0 -ne $? ]]; then printf "%b" "Could not define current directory" && exit 255; fi

. "${current_directory}/../../utilities/error.sh" || exit 255


lint_sh_files() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the path to the shellcheck program, and the path to the directory to lint"; fi

  local -r shellcheck_path="$1"
  local -r directory_path="$2"

  $(find . -type f -name "*.sh" -print0 | xargs -0 -I {} "${shellcheck_path}" {})
  if [[ 0 -ne $? ]]; then fail "Could not successfully lint all .sh files"; fi
}
