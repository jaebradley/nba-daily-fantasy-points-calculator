#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../data/accessors/daily games.sh"

main() {
  local -r scoreboard_data=$(fetch_games_for_day "2023" "03" "26")
  if [[ "$?" != 0 ]]; then printf "Failed to fetch games for day\n" && exit 255; fi

  local -r expected_scoreboard_data=$(cat "$(dirname "${BASH_SOURCE[0]}")/../scoreboard/finished games.json")

  if [[ "${scoreboard_data}" != "${expected_scoreboard_data}" ]]; then printf "Expected scoreboard data is not equal to fetched scoreboard data\n" && exit 255; fi
}

main

