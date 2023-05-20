#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../utilities/error.sh" || exit 255


install_shellcheck() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the URL for the jq binary to install and the installation location for the jq binary\n"; fi

  local -r binary_url="$1"
  local -r installation_location="$2"

  command -v "curl" &> /dev/null || fail "curl program does not exist\n"
  command -v "tar" &> /dev/null || fail "tar program does not exist\n"

  local temporary_file_path
  temporary_file_path="/tmp/$(uuidgen)"
  if [[ $? -ne 0 ]]; then fail "Could not generate temporary file path\n"; fi

  mkdir -p "${temporary_file_path}" || fail "Could not create temporary file at path: ${temporary_file_path}\n"
  curl --silent --location "${binary_url}" --output "${temporary_file_path}/_" || fail "Unable to download binary\n"

  tar --extract --verbose --gunzip --file "${temporary_file_path}/_" -C "$temporary_file_path" || fail "Unable to extract binary\n"

  local installation_directory
  installation_directory=$(dirname "${installation_location}")
  if [[ $? -ne 0 ]]; then fail "Could not identify installation directory for: ${installation_location}\n"; fi

  mkdir -p "${installation_directory}" || fail "Could not create directory at path: ${installation_directory}\n"

  mv "${temporary_file_path}/shellcheck-v0.9.0/shellcheck" "${installation_location}" || fail "Could not move shellcheck binary from ${temporary_file_path} to ${installation_location}\n"

  chmod 755 "${installation_location}" || fail "Could not update binary permissions at ${installation_location}\n"
}

