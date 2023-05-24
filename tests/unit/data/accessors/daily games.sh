#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../utilities/error.sh" || exit 255
. "$(dirname "${BASH_SOURCE[0]}")/../../../../data/accessors/daily games.sh" || fail "Could not import daily game accessor\n"

main() {
  local current_directory
  if ! current_directory="$(dirname "${BASH_SOURCE[0]}")"; then fail "Could not calculate current directory\n"; fi

  # TODO: @jaebradley move this to a script argument
  local -r jq_executable_path="${current_directory}/../../../../.dependencies/bin/jq"
  if [[ ! -x "${jq_executable_path}" ]]; then fail "Could not execute jq program at ${jq_executable_path}"; fi

  local -r expected_scoreboard_data_file_path="${current_directory}/../scoreboard/finished games.json"
  if [[ ! -f "${expected_scoreboard_data_file_path}" ]]; then fail "Expected output file at ${expected_scoreboard_data_file_path} is not a regular file\n"; fi
  if [[ ! -r "${expected_scoreboard_data_file_path}" ]]; then fail "Expected output file at ${expected_scoreboard_data_file_path} is not readable\n"; fi

  local temporary_file_name
  if ! temporary_file_name="/tmp/$(uuidgen)"; then fail "Could not generate temporary file name\n"; fi

  touch "${temporary_file_name}" || fail "Could not create temporary file ${temporary_file_name}\n"

  
  if ! fetch_games_for_day "2023" "03" "26" &> "${temporary_file_name}"; then fail "Failed to fetch games for day\n"; fi

  local fetched_data
  if ! fetched_data=$(cat "${temporary_file_name}" | "${jq_executable_path}" ".scoreboard"); then fail "Failed to parse static portion of fetched data\n"; fi

  local expected_data
  if ! expected_data=$(cat "${expected_scoreboard_data_file_path}" | "${jq_executable_path}" ".scoreboard"); then fail "Failed to read file ${expected_scoreboard_data_file_path}\n"; fi
  if [[ "${fetched_data}" != "${expected_data}" ]]; then fail "Difference exists between ${temporary_file_name} and ${expected_scoreboard_data_file_path}\n"; fi
}

main

