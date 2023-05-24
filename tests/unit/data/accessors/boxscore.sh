#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../utilities/error.sh" || exit 255
. "$(dirname "${BASH_SOURCE[0]}")/../../../../data/accessors/boxscore.sh" || fail "Unable to import boxscore accessor"

main() {
  local boxscore_data
  if ! boxscore_data=$(fetch_boxscore_data "0022201201"); then fail "Failed to fetch boxscore data\n"; fi

  local expected_boxscore_data
  if ! expected_boxscore_data=$(cat "$(dirname "${BASH_SOURCE[0]}")/../boxscores/0022201201.json"); then fail "Unable to read expected boxscore data\n"; fi

  if [[ "${boxscore_data}" != "${expected_boxscore_data}" ]]; then printf "Expected boxscore data is not equal to fetched boxscore data\n" && exit 255; fi
}

main
