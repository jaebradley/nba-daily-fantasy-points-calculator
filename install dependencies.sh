#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/utilities/error.sh"

install_jq() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the URL for the jq binary to install and the installation location for the jq binary\n"; fi

  local -r jq_binary_url="$1"
  local -r installation_location="$2"

  command -v "curl" &> /dev/null || fail "curl command does not exist\n"

  local temporary_file_path
  temporary_file_path="/tmp/$(uuidgen)"
  if [[ $? -ne 0 ]]; then printf "Could not generate temporary file path\n" && exit 255; fi

  touch "${temporary_file_path}" || fail "Could not create temporary file at path: ${temporary_file_path}\n"

  curl --silent --location "${jq_binary_url}"  --output "${temporary_file_path}" || fail "Could not fetch jq binary: ${temporary_file_path}\n"

  local installation_directory
  installation_directory=$(dirname "${installation_location}")
  if [[ $? -ne 0 ]]; then printf "Could not identify installation directory for: ${installation_location}\n" && exit 255; fi

  mkdir -p "${installation_directory}" || fail "Could not create directory at path: ${installation_directory}\n"

  mv "${temporary_file_path}" "${installation_location}" || fail "Could not move jq binary from ${temporary_file_path} to ${installation_location}\n"

  chmod 755 "${installation_location}" || fail "Could not update jq binary permissions at ${installation_location}\n"
}

verify_jq_version() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments: the path to the jq binary and the expected jq version"; fi

  local -r jq_path="$1"
  local -r expected_version="$2"

  local jq_version
  jq_version=$("${jq_path}" --version)
  if [[ $? -ne 0 ]]; then fail "Failed to identify jq version\n"; fi
  if [[ "${expected_version}" != "${jq_version}" ]]; then fail "Expected jq version to be ${expected_version} but got ${jq_version}"; fi
}

install_dependencies() {
  if [[ 2 -ne $# ]]; then fail "Expected two arguments - the installation path for the jq binary and the expected jq version\n"; fi

  local -r local_jq_path="$1"
  local -r jq_version="$2"

  if [[ -e "${local_jq_path}" ]];
  then
    if [[ -f "${local_jq_path}" ]];
    then
      if [[ -x "${local_jq_path}" ]];
      then
        verify_jq_version "${local_jq_path}" "${jq_version}" || fail "Failed to verify jq version for binary at path: ${local_jq_path} with expected version: ${jq_version}\n"
        return 0
      fi
    fi
  fi

  rm -f "${local_jq_path}" || fail "Failed to delete jq binary at ${local_jq_path}\n"
  install_jq "https://github.com/stedolan/jq/releases/download/${jq_version}/jq-osx-amd64" "${local_jq_path}" || fail "Failed to install jq binary\n"
}
