#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/fetch boxscore data.sh"
. "$(dirname "${BASH_SOURCE[0]}")/fetch games for day.sh"
. "$(dirname "${BASH_SOURCE[0]}")/parse daily games.sh"
. "$(dirname "${BASH_SOURCE[0]}")/parse boxscore data.sh"
. "$(dirname "${BASH_SOURCE[0]}")/calculators/daily/fantasy/sports/draftkings/classic.sh"

function main() {
  if [[ "$#" != "4" ]]; then printf "Expected four arguments - a year, a zero-padded month of year, a zero-padded day of month, and the path to the jq program\n" && exit 255; fi
  local -r year="$1"
  local -r month="$2"
  local -r day="$3"
  local -r jq_executable_path="$4"

  if [[ ! -f "${jq_executable_path}" ]]; then printf "jq program at the following path: ${jq_executable_path} is not a regular file\n" && exit 255; fi
  if [[ ! -x "${jq_executable_path}" ]]; then printf "jq program at the following path: ${jq_executable_path} is not executable\n" && exit 255; fi

  while IFS=$"\n", read -r -a game_id
  do
    while IFS=$",", read -r -a player_boxscore
    do
      local fantasy_points
      fantasy_points=$(calculate_classic_points "${player_boxscore[@]:2}")
      if [[ $? -ne 0 ]]; then printf "Could not calculate fantasy points for player with the following boxscore: ${player_boxscore}\n" && exit 255; fi

      printf "${player_boxscore[0]} | ${fantasy_points} | ${player_boxscore[1]}\n"
    done  < <(fetch_boxscore_data "${game_id}" | parse_boxscore_data "${jq_executable_path}")
  done < <(fetch_games_for_day "${year}" "${month}" "${day}" | parse_daily_games "${jq_executable_path}" | "${jq_executable_path}" 'map(.gameId) | .[]' | xargs -L1)
}

main "$@"
