#!/bin/bash

function parse_boxscore_data() {
  local -r jq_executable_path="$1"

  # Has to be absolute path to binary
  if [[ ! -f "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not a file\n" && exit 255; fi
  if [[ ! -e "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not executable\n" && exit 255; fi
  "${jq_executable_path}" '.game.homeTeam.players 
  | map({
      name: .name,
      status: .status,
      statistics: .statistics
    })
  | map({ 
      name: .name, 
      status: .status,
      assists: .statistics.assists,
      blocks: .statistics.blocks,
      points: .statistics.points,
      fieldGoalsMade: .statistics.fieldGoalsMade,
      rebounds: .statistics.reboundsTotal, 
      steals: .statistics.steals,
      threePointersMade: .statistics.threePointersMade,
      turnovers: .statistics.turnovers
    })' <<< "$(< /dev/stdin)"
}
