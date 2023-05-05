#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../data/accessors/daily games.sh"

main() {
  local current_directory
  current_directory="$(dirname "${BASH_SOURCE[0]}")"
  if [[ $? -ne 0 ]]; then printf "Could not calculate current directory\n" && exit 255; fi

  local -r jq_executable_path="${current_directory}/../../../../.dependencies/bin/jq"
  if [[ ! -x "${jq_executable_path}" ]]; then printf "Could not execute jq program at ${jq_executable_path}" && exit 255; fi

  local -r expected_scoreboard_data_file_path="${current_directory}/../scoreboard/finished games.json"
  if [[ ! -f "${expected_scoreboard_data_file_path}" ]]; then printf "Expected output file at ${expected_scoreboard_data_file_path} is not a regular file\n" && exit 255; fi
  if [[ ! -r "${expected_scoreboard_data_file_path}" ]]; then printf "Expected output file at ${{expected_scoreboard_data_file_path} is not readable\n" && exit 255; fi

  local temporary_file_name
  temporary_file_name="/tmp/$(uuidgen)"
  if [[ $? -ne 0 ]]; then printf "Could not generate temporary file name\n" && exit 255; fi

  touch "${temporary_file_name}"
  if [[ $? -ne 0 ]]; then printf "Could not create temporary file ${temporary_file_name}" && exit 255; fi

  fetch_games_for_day "2023" "03" "26" &> "${temporary_file_name}"
  if [[ $? -ne 0 ]]; then printf "Failed to fetch games for day\n" && exit 255; fi

  local fetched_data=$(cat "${temporary_file_name}" | "${jq_executable_path}" ".scoreboard")
  if [[ $? -ne 0 ]]; then printf "Failed to parse static portion of fetched data\n" && exit 255; fi

  local expected_data=$(cat "${expected_scoreboard_data_file_path}" | "${jq_executable_path}" ".scoreboard")

  if [[ "${fetched_data}" != "${expected_data}" ]]; then printf "Difference exists between ${temporary_file_name} and ${expected_scoreboard_data_file_path}\n" && exit 255; fi
}

main

