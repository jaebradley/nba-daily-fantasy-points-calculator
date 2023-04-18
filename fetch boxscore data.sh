#!/bin/bash

function fetch_boxscore_data() {
  if [[ "$#" != "1" ]]; then printf "Expected a single argument - an NBA.com game id\n" && exit 255; fi
  local -r game_id="$1"

  command -v "curl" &> /dev/null
  if [[ "$?" != "0" ]]; then printf "curl program does not exist\n" && exit 255; fi

  curl --silent "https://cdn.nba.com/static/json/liveData/boxscore/boxscore_${game_id}.json" 
}
