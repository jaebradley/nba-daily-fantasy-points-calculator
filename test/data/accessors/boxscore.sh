#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../data/accessors/boxscore.sh"

main() {
  local -r boxscore_data=$(fetch_boxscore_data "0022201201")
  if [[ "$?" != 0 ]]; then printf "Failed to fetch boxscore data\n" && exit 255; fi

  local -r expected_boxscore_data=$(cat "$(dirname "${BASH_SOURCE[0]}")/../boxscores/0022201201.json")
  if [[ "${boxscore_data}" != "${expected_boxscore_data}" ]]; then printf "Expected boxscore data is not equal to fetched boxscore data\n" && exit 255; fi
}

main