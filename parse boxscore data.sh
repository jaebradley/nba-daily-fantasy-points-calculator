#!/bin/bash

function parse_boxscore_data() {
  if [[ "$#" != "1" ]]; then printf "Expected 1 argument - the path to the jq program" && exit 255; fi
  local -r jq_executable_path="$1"

  # Has to be absolute path to binary
  if [[ ! -f "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not a regular file\n" && exit 255; fi
  if [[ ! -x "${jq_executable_path}" ]]; then printf "${jq_executable_path} is not executable\n" && exit 255; fi

  "${jq_executable_path}" -r '.game.homeTeam.players + .game.awayTeam.players
  | map({
      name: .name,
      status: .status,
      statistics: .statistics
    })
  | sort_by(.name)
  | sort_by(.status)
  | map([ 
      .name,
      .status,
      .statistics.assists,
      .statistics.blocks,
      .statistics.points,
      .statistics.reboundsTotal,
      .statistics.steals,
      .statistics.threePointersMade,
      .statistics.turnovers
    ])
  | .[]
  | @csv' <<< "$(< /dev/stdin)"
}
