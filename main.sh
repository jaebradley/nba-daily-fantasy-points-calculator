#!/bin/bash

source ./fetch\ boxscore\ data.sh
source ./fetch\ games\ for\ day.sh
source ./parse\ daily\ games.sh
source ./parse\ boxscore\ data.sh
source ./calculators/daily/fantasy/sports/draftkings/classic.sh

function main() {
  local -r year="$1"
  local -r month="$2"
  local -r day="$3"
  local -r jq_executable_path="$4"

  while IFS=$"\n", read -r -a game_id
  do
    while IFS=$",", read -r -a player_boxscore
    do
      local fantasy_points
      fantasy_points=$(calculate_classic_points "${player_boxscore[@]:2}")
      if [[ $? -ne 0 ]]; then printf "Could not calculate fantasy points\n" && exit 255; fi

      printf "${player_boxscore[0]} | ${fantasy_points} | ${player_boxscore[1]}\n"
    done  < <(fetch_boxscore_data "${game_id}" | parse_boxscore_data "${jq_executable_path}")
  done < <(fetch_games_for_day "${year}" "${month}" "${day}" | parse_daily_games "${jq_executable_path}" | "${jq_executable_path}" 'map(.gameId) | .[]' | xargs -L1)
}

main "$@"
