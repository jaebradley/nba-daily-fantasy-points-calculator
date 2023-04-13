#!/bin/bash

function fetch_boxscore_data() {
  local -r game_id="$1"
  local -r jq_executable_path="$2"

  # Has to be absolute path to binary
  if [[ ! -f "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not a file\n" && exit 255; fi
  if [[ ! -e "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not executable\n" && exit 255; fi
  curl --silent "https://cdn.nba.com/static/json/liveData/boxscore/boxscore_${game_id}.json" 
}
