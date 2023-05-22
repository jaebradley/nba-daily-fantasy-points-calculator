#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../utilities/error.sh" || exit 255

install_jq() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the URL for the jq binary to install and the installation location for the jq binary\n"; fi

  local -r jq_binary_url="$1"
  local -r installation_location="$2"

  command -v "curl" &> /dev/null || fail "curl command does not exist\n"

  local temporary_file_path
  
  if ! temporary_file_path="/tmp/$(uuidgen)"; then fail "Could not generate temporary file path\n"; fi

  touch "${temporary_file_path}" || fail "Could not create temporary file at path: ${temporary_file_path}\n"

  curl --silent --location "${jq_binary_url}"  --output "${temporary_file_path}" || fail "Could not fetch jq binary: ${jq_binary_url}\n"

  local installation_directory
  if ! installation_directory=$(dirname "${installation_location}"); then fail "Could not identify installation directory for: ${installation_location}\n"; fi

  mkdir -p "${installation_directory}" || fail "Could not create directory at path: ${installation_directory}\n"

  mv "${temporary_file_path}" "${installation_location}" || fail "Could not move jq binary from ${temporary_file_path} to ${installation_location}\n"

  chmod 755 "${installation_location}" || fail "Could not update jq binary permissions at ${installation_location}\n"
}
