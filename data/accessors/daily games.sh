#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

fetch_games_for_day() {
  if [[ "$#" != "3" ]]; then fail "Expected three arguments - a year, a 0-padded month, a 0-padded day of month\n"; fi

  local -r year="$1"
  local -r month="$2"
  local -r day="$3"

  
  if ! command -v "curl" &> /dev/null; then fail "curl program does not exist\n"; fi
  if ! command -v "gunzip" &> /dev/null; then fail "gunzip program does not exist\n"; fi

  curl --silent "https://stats.nba.com/stats/scoreboardv3?GameDate=${year}-${month}-${day}&LeagueID=00" -H 'User-Agent: Mozilla/5.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=1' -H 'Accept-Encoding: gzip' -H 'Referer: https://www.nba.com/' -H 'Origin: https://www.nba.com' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' | gunzip
}
