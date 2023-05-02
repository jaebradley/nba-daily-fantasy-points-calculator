#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../../../calculators/daily/fantasy/sports/draftkings/classic.sh"

function main() {
  local all_zeroes_output
  all_zeroes_output=$(calculate_classic_points "0" "0" "0" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "0" != "${all_zeroes_output}" ]]; then printf "Expected 0 but instead got ${all_zeroes_output}" && exit 255; fi

  local only_turnovers_output
  only_turnovers_output=$(calculate_classic_points "0" "0" "0" "0" "0" "0" "1")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "-.5" != "${only_turnovers_output}" ]]; then printf "Expected -0.5 but instead got ${only_turnovers_output}" && exit 255; fi

  local one_of_everything
  one_of_everything=$(calculate_classic_points "1" "1" "1" "1" "1" "1" "1")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "7.75" != "${one_of_everything}" ]]; then printf "Expected 6.75 but instead got ${one_of_everything}" && exit 255; fi

  local double_double
  double_double=$(calculate_classic_points "10" "10" "0" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "36.5" != "${double_double}" ]]; then printf "Expected 27.5 but instead got ${double_double}" && exit 255; fi

  local triple_double
  triple_double=$(calculate_classic_points "10" "10" "10" "0" "0" "0" "0")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "49.5" != "${triple_double}" ]]; then printf "Expected 48 but instead got ${triple_double}" && exit 255; fi

  local quadruple_double
  quadruple_double=$(calculate_classic_points "10" "10" "10" "10" "0" "0" "0")
  if [[ $? -ne 0 ]]; then printf "Could not calculate points\n" && exit 255; fi
  if [[ "62.00" != "${quadruple_double}" ]]; then printf "Expected 62 but instead got ${quadruple_double}" && exit 255; fi
}

main
