#!/bin/bash

main() {
  # TODO: @jbradley avoid running this if jq is already installed
  # TODO: @jbradley check jq version
  # TODO: @jbradley take base directory / installation directory as an argument
  local temporary_file_path
  temporary_file_path="/tmp/$(uuidgen)"
  if [[ $? -ne 0 ]]; then printf "Could not generate temporary file path\n" && exit 255; fi

  touch "${temporary_file_path}"
  if [[ $? -ne 0 ]]; then printf "Could not create temporary file at path: ${temporary_file_path}\n" && exit 255; fi

  command -v "curl"
  if [[ $? -ne 0 ]]; then printf "curl command does not exist\n" && exit 255; fi
  curl -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64" --output "${temporary_file_path}"
  if [[ $? -ne 0 ]]; then printf "Could not fetch jq binary: ${temporary_file_path}\n" && exit 255; fi

  mkdir -p ".dependencies/bin"
  if [[ $? -ne 0 ]]; then printf "Could not create directory at path: .dependencies/bin\n" && exit 255; fi

  mv "${temporary_file_path}" ".dependencies/bin/jq"
  if [[ $? -ne 0 ]]; then printf "Could not move jq binary\n" && exit 255; fi

  chmod 755 ".dependencies/bin/jq"
  if [[ $? -ne 0 ]]; then printf "Could not update jq binary permissions\n" && exit 255; fi
}

main
