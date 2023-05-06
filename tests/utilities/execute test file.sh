#!/bin/bash

execute_test_file() {
    if [[ "1" != "$#" ]]; then printf "Expected a single path to file argument\n" && exit 255; fi

    local -r file_path="$1";

    if [[ ! -f "${file_path}" ]]; then printf "File ${file_path} is not a regular file\n" && exit 255; fi
    if [[ ! -x "${file_path}" ]]; then printf "File ${file_path} is not executable\n" && exit 255; fi

    printf "Starting ${file_path}\n"
    time "${file_path}"
    local -r exit_code="$?"
    printf "Finished ${file_path} with exit code: ${exit_code}\n"
    if [[ "0" != "${exit_code}" ]]; then printf "Tests failed for ${file_path}\n"; fi
}
