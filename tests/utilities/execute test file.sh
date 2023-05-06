#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../utilities/error.sh"

execute_test_file() {
    if [[ "1" != "$#" ]]; then fail "Expected a single path to file argument\n"; fi

    local -r file_path="$1";

    if [[ ! -f "${file_path}" ]]; then fail "File ${file_path} is not a regular file\n"; fi
    if [[ ! -x "${file_path}" ]]; then fail "File ${file_path} is not executable\n"; fi

    printf "Starting ${file_path}\n"
    time "${file_path}" || fail "Could not time script at ${file_path}"
    local -r exit_code="$?"
    printf "Finished ${file_path} with exit code: ${exit_code}\n"
    if [[ "0" != "${exit_code}" ]]; then fail"Tests failed for ${file_path}\n"; fi
}
