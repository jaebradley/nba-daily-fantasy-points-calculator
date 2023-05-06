#!/bin/bash

install_jq() {
  if [[ 2 -ne $# ]]; then printf "Expected two arguments: the URL for the jq binary to install and the installation location for the jq binary\n" && exit 255; fi

  local -r jq_binary_url="$1"
  local -r installation_location="$2"

  command -v "curl" &> /dev/null
  if [[ $? -ne 0 ]]; then printf "curl command does not exist\n" && exit 255; fi

  local temporary_file_path
  temporary_file_path="/tmp/$(uuidgen)"
  if [[ $? -ne 0 ]]; then printf "Could not generate temporary file path\n" && exit 255; fi

  touch "${temporary_file_path}"
  if [[ $? -ne 0 ]]; then printf "Could not create temporary file at path: ${temporary_file_path}\n" && exit 255; fi

  curl --silent --location "${jq_binary_url}"  --output "${temporary_file_path}"
  if [[ $? -ne 0 ]]; then printf "Could not fetch jq binary: ${temporary_file_path}\n" && exit 255; fi

  local installation_directory=$(dirname "${installation_location}")
  if [[ $? -ne 0 ]]; then printf "Could not identify installation directory for: ${installation_location}\n" && exit 255; fi

  mkdir -p "${installation_directory}" 
  if [[ $? -ne 0 ]]; then printf "Could not create directory at path: ${installation_directory}\n" && exit 255; fi

  mv "${temporary_file_path}" "${installation_location}" 
  if [[ $? -ne 0 ]]; then printf "Could not move jq binary from ${temporary_file_path} to ${installation_location}\n" && exit 255; fi

  chmod 755 "${installation_location}"
  if [[ $? -ne 0 ]]; then printf "Could not update jq binary permissions at ${installation_location}\n" && exit 255; fi
}

verify_jq_version() {
  if [[ 2 -ne $# ]]; then printf "Expected two arguments: the path to the jq binary and the expected jq version" && exit 255; fi

  local -r jq_path="$1"
  local -r expected_version="$2"

  local jq_version
  jq_version=$("${jq_path}" --version)
  if [[ $? -ne 0 ]]; then printf "Failed to identify jq version\n" && exit 255; fi
  if [[ "${expected_version}" != "${jq_version}" ]]; then printf "Expected jq version to be ${expected_version} but got ${jq_version}" && exit 255; fi
}

main() {
  if [[ 2 -ne $# ]]; then printf "Expected two arguments - the installation path for the jq binary and the expected jq version\n" && exit 255; fi

  local -r local_jq_path="$1"
  local -r jq_version="$2"

  if [[ -e "${local_jq_path}" ]];
  then
    if [[ -f "${local_jq_path}" ]];
    then
      if [[ -x "${local_jq_path}" ]];
      then
        verify_jq_version "${local_jq_path}" "${jq_version}"
        if [[ $? -ne 0 ]]; then printf "Failed to verify jq version for binary at path: ${local_jq_path} with expected version: ${jq_version}\n" && exit 255; fi
        exit 0
      fi
    fi
  fi

  rm -f "${local_jq_path}"
  if [[ $? -ne 0 ]]; then printf "Failed to delete jq binary at ${local_jq_path}\n" && exit 255; fi

  install_jq "https://github.com/stedolan/jq/releases/download/${jq_version}/jq-osx-amd64" "${local_jq_path}"
  if [[ $? -ne 0 ]]; then printf "Failed to install jq binary\n" && exit 255; fi
}

main "$(dirname "${BASH_SOURCE[0]}")/.dependencies/bin/jq" "jq-1.6"
