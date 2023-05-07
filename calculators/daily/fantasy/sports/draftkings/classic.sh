#!/bin/bash
# https://www.draftkings.com/help/rules/4

. "$(dirname "${BASH_SOURCE[0]}")/../../../../../utilities/error.sh"

calculate_classic_points() {
  if [[ "$#" != "7" ]]; then fail "Expected 7 arguments: assists, blocks, points, rebounds, steals, three pointers made, and turnovers"; fi

  local -r assists="$1"
  local -r blocks="$2"
  local -r points="$3"
  local -r rebounds="$4"
  local -r steals="$5"
  local -r three_pointers_made="$6"
  local -r turnovers="$7"

  local double_digit_categories_count=0
  if [[ assists -gt 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ points -gt 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ blocks -gt 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ rebounds -gt 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ steals -gt 9 ]]; then ((++double_digit_categories_count)); fi

  local double_digit_categories_bonus=0
  if [[ double_digit_categories_count -eq 2 ]]; then
    double_digit_categories_bonus=1
  elif [[ double_digit_categories_count -gt 2 ]]; then
    double_digit_categories_bonus=3
  fi
  
  local classic_points
  classic_points=$(printf "%s" "${points}+(${three_pointers_made}*0.5)+(${rebounds}*1.25)+(${assists}*1.5)+(${steals}*2)+(${blocks}*2)-(${turnovers}*0.5)+(${double_digit_categories_bonus}*1.5); scale=4" | bc)
  if [[ 0 -ne $? ]];
  then
    fail "Unable to calculate points"
  else
    printf "%s" "${classic_points}"
  fi
}

