#!/bin/bash

function parse_boxscore_data() {
  local -r jq_executable_path="$1"

  # Has to be absolute path to binary
  if [[ ! -f "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not a file\n" && exit 255; fi
  if [[ ! -e "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not executable\n" && exit 255; fi
  "${jq_executable_path}" -r '.game.homeTeam.players 
  | map({
      name: .name,
      status: .status,
      statistics: .statistics
    })
  | map([ 
      .name,
      .status,
      .statistics.assists,
      .statistics.blocks,
      .statistics.points,
      .statistics.fieldGoalsMade,
      .statistics.reboundsTotal, 
      .statistics.steals,
      .statistics.threePointersMade,
      .statistics.turnovers
    ])
    | .[]
    | @csv' <<< "$(< /dev/stdin)"
}
