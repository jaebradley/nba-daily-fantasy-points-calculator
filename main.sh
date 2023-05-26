#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/utilities/error.sh" || exit 255;
. "$(dirname "${BASH_SOURCE[0]}")/data/accessors/boxscore.sh" || fail "Could not import boxscore accessor"
. "$(dirname "${BASH_SOURCE[0]}")/data/accessors/daily games.sh" || fail "Could not import daily games accessor"
. "$(dirname "${BASH_SOURCE[0]}")/data/parsers/daily games.sh" || fail "Could not import daily games parser"
. "$(dirname "${BASH_SOURCE[0]}")/data/parsers/boxscore.sh" || fail "Could not import boxscore parser"
. "$(dirname "${BASH_SOURCE[0]}")/calculators/daily/fantasy/sports/draftkings/classic.sh" || fail "Could not import DraftKings classic NBA contest calculator"
. "$(dirname "${BASH_SOURCE[0]}")/data/formatters/output/row.sh" || fail "Could not import row formatter"

calculate_nba_draftkings_points_for_day() {
  local file_directory
  if ! file_directory=$(dirname "${BASH_SOURCE[0]}"); then fail "Unable to calculate current file directory\n"; fi

  if [[ $# -eq 3 ]]; then
    jq_executable_path="${file_directory}/.dependencies/bin/jq"
  elif [[ $# -eq 4 ]]; then
    jq_executable_path="$4"
  else
    fail "Expected three or four arguments - a year, a zero-padded month of year, a zero-padded day of month, and an optional path to the jq program. Instead received $# arguments.\n"
  fi

  local -r year="$1"
  local -r month="$2"
  local -r day="$3"

  if [[ ! -f "${jq_executable_path}" ]]; then fail "jq program at the following path: ${jq_executable_path} is not a regular file\n"; fi
  if [[ ! -x "${jq_executable_path}" ]]; then fail "jq program at the following path: ${jq_executable_path} is not executable\n"; fi

  while IFS=$'\n', read -r game_id
  do
    while IFS=$",", read -r -a player_boxscore
    do
      local fantasy_points
      if fantasy_points=$(calculate_classic_points "${player_boxscore[@]:2}"); then fail "Could not calculate fantasy points for player with the following boxscore: ${player_boxscore[*]}\n"; fi

      local row
      if ! row=$(format_output_row "${player_boxscore[0]}" "${fantasy_points}" "${player_boxscore[1]}"); then fail "Could not format row for player with the following boxscore: ${player_boxscore[*]}\n"; fi

      printf "%b" "${row}\n"
    done  < <(fetch_boxscore_data "${game_id}" | parse_boxscore_data "${jq_executable_path}")
  done < <(fetch_games_for_day "${year}" "${month}" "${day}" | parse_daily_games "${jq_executable_path}" | "${jq_executable_path}" 'map(.gameId) | .[]' | xargs -L1)
}

calculate_nba_draftkings_points_for_day "$@"
