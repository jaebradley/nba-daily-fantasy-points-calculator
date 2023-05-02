#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../data/parsers/boxscore.sh"

function main() {
  if [[ "$#" != "1" ]]; then printf "Expected 1 argument - the path to the jq program" && exit 255; fi
  local -r jq_executable_path="$1"

  local current_directory
  current_directory="$(dirname "${BASH_SOURCE[0]}")"
  if [[ $? -ne 0 ]]; then printf "Could not calculate current directory\n" && exit 255; fi
  
  declare -a -r input_file_names=("0022201201" "0042200123")

  for input_file_name in "${input_file_names[@]}"
  do
    local input_file_path="${current_directory}/../boxscores/${input_file_name}.json"
    if [[ ! -f "${input_file_path}" ]]; then printf "Input file at ${input_file_path} is not a regular file\n" && exit 255; fi
    if [[ ! -r "${input_file_path}" ]]; then printf "Input file at ${input_file_path} is not readable\n" && exit 255; fi

    local expected_output_file_path="${current_directory}/expected/boxscore/${input_file_name}.csv"
    if [[ ! -f "${expected_output_file_path}" ]]; then printf "Expected output file at ${expected_output_file_path} is not a regular file\n" && exit 255; fi
    if [[ ! -r "${expected_output_file_path}" ]]; then printf "Expected output file at ${expected_output_file_path} is not readable\n" && exit 255; fi
    local expected_output
    expected_output=$(cat "${expected_output_file_path}")
    if [[ $? -ne 0 ]]; then printf "Could not read  boxscore data for expected output file: ${expected_output_file_path}}\n" && exit 255; fi
    cat "${input_file_path}" | parse_boxscore_data "${jq_executable_path}" &> /tmp/foo
    diff /tmp/foo "${expected_output_file_path}"

    local calculated_output
    calculated_output=$(cat "${input_file_path}" | parse_boxscore_data "${jq_executable_path}")
    if [[ $? -ne 0 ]]; then printf "Could not parse boxscore data for input file: ${input_file_name}\n" && exit 255; fi
    if [[ "${calculated_output}" !=  "${expected_output}" ]]; then printf "Calculated output does not match expected input for ${input_file_path}\n" && exit 255; fi

  done
}

main "$@"

