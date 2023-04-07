function parse_daily_games() {
  local -r jq_program_path="$1"
  if [[ ! -e "${jq_program_path}" ]]; then printf "${jq_program_path} is not an executable program\n" && exit 255; fi

  # TODO: @jbradley is there a way to convert input JSON into a whitespace-escaped string instead of reading from standard input
  "${jq_program_path}" '.scoreboard.games | map(select(.gameStatusText == "Final")) | map({ gameId: .gameId, gameStatus: .gameStatusText })' <<< "$(< /dev/stdin)"
}
