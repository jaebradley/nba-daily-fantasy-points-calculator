#!/bin/bash
# https://www.draftkings.com/help/rules/4

function calculate_classic_points() {
  local -r assists="$1"
  local -r blocks="$2"
  local -r points="$3"
  local -r rebounds="$4"
  local -r steals="$5"
  local -r three_pointers_made="$6"
  local -r turnovers="$7"

  local double_digit_categories_count=0
  if [[ "${assists}" > 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ "${points}" > 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ "${blocks}" > 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ "${rebounds}" > 9 ]]; then ((++double_digit_categories_count)); fi
  if [[ "${steals}" > 9 ]]; then ((++double_digit_categories_count)); fi

  local double_digit_categories_bonus=0
  if [[ "${double_digit_categories_count}" == "2" ]]; then
    double_digit_categories_bonus=1
  elif [[ "${double_digit_categories_count}" > 2 ]]; then
    double_digit_categories_bonus=3
  fi
  
  printf "${points}+(${three_pointers_made}*0.5)+(${rebounds}*1.25)+(${assists}*1.5)+(${steals}*2)+(${blocks}*2)+(${turnovers}*0.5)+${double_digit_categories_bonus}; scale=2" | bc
}

