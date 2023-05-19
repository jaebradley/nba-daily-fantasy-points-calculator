#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../utilities/error.sh" || exit 255;

strip_leading_and_trailing_double_quotes() {
  if [[ 1 -ne $# ]]; then fail "Expected a single argument: a string to remove leading and trailing double quotes\n"; fi
  sed -r 's/^"|"$//g' <<< "$1"
}

format_output_row() {
  if [[ 3 -ne $# ]]; then fail "Expected 3 arguments: the player name, the total fantasy points, player status\n"; fi

  local formatted_player_name
  formatted_player_name=$(strip_leading_and_trailing_double_quotes "$1")
  if [[ 0 -ne $? ]]; then fail "Failed to format player name\n"; fi

  local formatted_status
  formatted_status=$(strip_leading_and_trailing_double_quotes "$3")
  if [[ 0 -ne $? ]]; then fail "Failed to format player status\n"; fi

  printf "%b" "${formatted_player_name}|$2|${formatted_status}"
}

