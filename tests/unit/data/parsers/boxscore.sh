#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../data/parsers/boxscore.sh"

function main() {
  local -r jq_executable_path="$(dirname "${BASH_SOURCE[0]}")/../../../../.dependencies/bin/jq"
  if [[ ! -x "${jq_executable_path}" ]]; then printf "Could not execute jq program at ${jq_executable_path}" && exit 255; fi

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
    local temporary_file_name
    temporary_file_name="/tmp/$(uuidgen)"
    if [[ $? -ne 0 ]]; then printf "Could not generate temporary file name\n" && exit 255; fi

    touch "${temporary_file_name}"
    if [[ $? -ne 0 ]]; then printf "Could not create temporary file ${temporary_file_name}" && exit 255; fi

    $(cat "${input_file_path}" | parse_boxscore_data "${jq_executable_path}" &> "${temporary_file_name}")
    if [[ $? -ne 0 ]]; then printf "Could not parse boxscore data to ${temporary_file_name}" && exit 255; fi

    diff "${temporary_file_name}" "${expected_output_file_path}"
    if [[ $? -ne 0 ]]; then printf "Difference exists between ${temporary_file_name} and ${expected_output_file_path}" && exit 255; fi
  done
}

main
