#!/bin/bash

function fetch_games_for_day() {
  if [[ "$#" != "3" ]]; then printf "Expected three arguments - a year, a 0-padded month, a 0-padded day of month\n" && exit 255; fi

  local -r year="$1"
  local -r month="$2"
  local -r day="$3"

  command -v "curl" &> /dev/null
  if [[ "$?" != "0" ]]; then printf "curl program does not exist\n" && exit 255; fi

  curl --silent "https://stats.nba.com/stats/scoreboardv3?GameDate=${year}-${month}-${day}&LeagueID=00" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:109.0) Gecko/20100101 Firefox/111.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' -H 'Accept-Encoding: gzip, deflate, br' -H 'Referer: https://www.nba.com/' -H 'Origin: https://www.nba.com' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' | gunzip
}