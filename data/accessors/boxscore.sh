#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

fetch_boxscore_data() {
  if [[ "$#" != "1" ]]; then fail "Expected a single argument - an NBA.com game id\n"; fi
  local -r game_id="$1"

  if ! command -v "curl" &> /dev/null; then fail "curl program does not exist\n"; fi

  curl --silent "https://cdn.nba.com/static/json/liveData/boxscore/boxscore_${game_id}.json" 
}
