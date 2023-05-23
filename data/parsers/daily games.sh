#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255;

parse_daily_games() {
  if [[ 1 -ne $# ]]; then fail "Expected a single argument: the path to the jq executable\n"; fi

  local -r jq_program_path="$1"
  if [[ ! -f "${jq_program_path}" ]]; then fail "${jq_program_path} is not a regular file\n"; fi
  if [[ ! -e "${jq_program_path}" ]]; then fail "${jq_program_path} is not an executable program\n"; fi

  # TODO: @jbradley is there a way to convert input JSON into a whitespace-escaped string instead of reading from standard input
  "${jq_program_path}" '.scoreboard.games | map(select(.gameStatus > 1)) | map({ gameId: .gameId, gameStatus: .gameStatusText })' <<< "$(< /dev/stdin)"
}
