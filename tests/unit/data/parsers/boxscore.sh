#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../utilities/error.sh" || exit 255
. "$(dirname "${BASH_SOURCE[0]}")/../../../../data/parsers/boxscore.sh" || fail "Unable to import boxscore parser\n"

main() {
  local jq_executable_path
  if ! jq_executable_path="$(dirname "${BASH_SOURCE[0]}")/../../../../.dependencies/bin/jq"; then fail "Unable to calculate jq executable path\n"; fi
  if [[ ! -x "${jq_executable_path}" ]]; then fail "Could not execute jq program at ${jq_executable_path}\n"; fi

  local current_directory
  if ! current_directory="$(dirname "${BASH_SOURCE[0]}")"; then fail "Could not calculate current directory\n"; fi
  
  declare -a -r input_file_names=("0022201201" "0042200123")

  for input_file_name in "${input_file_names[@]}"
  do
    local input_file_path="${current_directory}/../boxscores/${input_file_name}.json"
    if [[ ! -f "${input_file_path}" ]]; then fail "Input file at ${input_file_path} is not a regular file\n"; fi
    if [[ ! -r "${input_file_path}" ]]; then fail "Input file at ${input_file_path} is not readable\n"; fi

    local expected_output_file_path="${current_directory}/expected/boxscore/${input_file_name}.csv"
    if [[ ! -f "${expected_output_file_path}" ]]; then fail "Expected output file at ${expected_output_file_path} is not a regular file\n"; fi
    if [[ ! -r "${expected_output_file_path}" ]]; then fail "Expected output file at ${expected_output_file_path} is not readable\n"; fi

    local temporary_file_name
    if ! temporary_file_name="/tmp/$(uuidgen)"; then fail "Could not generate temporary file name\n"; fi

    touch "${temporary_file_name}" || fail "Could not create temporary file ${temporary_file_name}\n"

    
    # TODO: @jaebradley handle pipefailure
    if ! parse_boxscore_data "${jq_executable_path}" < "${input_file_path}" &> "${temporary_file_name}"; then fail "Could not parse boxscore data to ${temporary_file_name}\n"; fi

    diff "${temporary_file_name}" "${expected_output_file_path}" || fail "Difference exists between ${temporary_file_name} and ${expected_output_file_path}\n"
  done
}

main
