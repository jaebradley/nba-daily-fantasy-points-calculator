#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../../../../calculators/daily/fantasy/sports/draftkings/classic.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../../../../../../../utilities/error.sh"

compare() {
  local output 
  output=$(calculate_classic_points "${@: 1:7}")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi

  local difference
  difference=$(bc <<< "${@: 8:8} - ${output}")
  if [[ $? -ne 0 ]]; then fail "Could not calculate difference between expected and outputted points\n"; fi
  if [[ "0" != "${difference}" ]]; then fail "Difference is ${difference} and not 0\n"; fi
}

function main() {
  compare "0" "0" "0" "0" "0" "0" "0" "0" || fail "Could not calculate all zeroes"
  compare "0" "0" "0" "0" "0" "0" "1" "-0.5" || fail "Could not calculate only turnovers"
  compare "1" "1" "1" "1" "1" "1" "1" "7.75" || fail "Could not calculate one of everything"
  compare "10" "10" "0" "0" "0" "0" "0" "36.5" || fail "Could not calculate double double"
  compare "10" "10" "10" "0" "0" "0" "0" "49.5" || fail "Could not calculate triple double"
  compare "10" "10" "10" "10" "0" "0" "0" "62" || fail "Could not calculate quadruple double"
}

main
