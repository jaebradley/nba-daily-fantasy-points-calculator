#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../../../../calculators/daily/fantasy/sports/draftkings/classic.sh"
. "$(dirname "${BASH_SOURCE[0]}")/../../../../../../../utilities/error.sh"

function main() {
  local all_zeroes_output
  all_zeroes_output=$(calculate_classic_points "0" "0" "0" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "0" != "${all_zeroes_output}" ]]; then fail "Expected 0 but instead got ${all_zeroes_output}"; fi

  local only_turnovers_output
  only_turnovers_output=$(calculate_classic_points "0" "0" "0" "0" "0" "0" "1")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "-.5" != "${only_turnovers_output}" ]]; then fail "Expected -0.5 but instead got ${only_turnovers_output}"; fi

  local one_of_everything
  one_of_everything=$(calculate_classic_points "1" "1" "1" "1" "1" "1" "1")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "7.75" != "${one_of_everything}" ]]; then fail "Expected 6.75 but instead got ${one_of_everything}"; fi

  local double_double
  double_double=$(calculate_classic_points "10" "10" "0" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "36.5" != "${double_double}" ]]; then fail "Expected 27.5 but instead got ${double_double}"; fi

  local triple_double
  triple_double=$(calculate_classic_points "10" "10" "10" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "49.5" != "${triple_double}" ]]; then fail "Expected 48 but instead got ${triple_double}"; fi

  local quadruple_double
  quadruple_double=$(calculate_classic_points "10" "10" "10" "10" "0" "0" "0")
  if [[ $? -ne 0 ]]; then fail "Could not calculate points\n"; fi
  if [[ "62.00" != "${quadruple_double}" ]]; then fail "Expected 62 but instead got ${quadruple_double}"; fi
}

main
