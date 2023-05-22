#!/bin/bash
# shellcheck disable=SC2091

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh" || exit 255

. "$(dirname "${BASH_SOURCE[0]}")/jq/install.sh" || fail "Unable to import jq installation function\n"
. "$(dirname "${BASH_SOURCE[0]}")/jq/verify version.sh" || fail "Unable to import jq version verification function\n"
. "$(dirname "${BASH_SOURCE[0]}")/shellcheck/install.sh" || fail "Unable to import shellcheck installation function\n"
. "$(dirname "${BASH_SOURCE[0]}")/shellcheck/verify version.sh" || fail "Unable to import shellcheck version verification function\n"

install_dependencies() {
  if [[ 4 -ne $# ]]; then fail "Expected five arguments - the installation path for the jq binary, the expected jq version, the URL to download the shellcheck binary from, the installation path for the shellcheck program, and the expected shellcheck version\n"; fi

  local -r jq_binary_path="$1"
  local -r expected_jq_version="$2"
  local -r shellcheck_binary_path="$3"
  local -r expected_shellcheck_version="$4"


  if ! $(verify_shellcheck_version "${shellcheck_binary_path}" "${expected_shellcheck_version}") &> /dev/null
  then
    rm -f "${shellcheck_binary_path}" || fail "Failed to delete shellcheck program at ${shellcheck_binary_path}"
    install_shellcheck "https://github.com/koalaman/shellcheck/releases/download/v${expected_shellcheck_version}/shellcheck-v${expected_shellcheck_version}.darwin.x86_64.tar.xz" "${shellcheck_binary_path}" || fail "Failed to install shellcheck program"
  fi

  if ! $(verify_jq_version "${jq_binary_path}" "${expected_jq_version}") &> /dev/null
  then
    rm -f "${jq_binary_path}" || fail "Failed to delete jq binary at ${jq_binary_path}\n"
    install_jq "https://github.com/stedolan/jq/releases/download/${expected_jq_version}/jq-osx-amd64" "${jq_binary_path}" || fail "Failed to install jq binary\n"
  fi
}
