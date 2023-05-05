#!/bin/bash

execute_test_file() {
    if [[ "1" != "$#" ]]; then printf "Expected a single path to file argument\n" && exit 255; fi

    local -r file_path="$1";

    if [[ ! -f "${file_path}" ]]; then printf "File ${file_path} is not a regular file\n" && exit 255; fi
    if [[ ! -x "${file_path}" ]]; then printf "File ${file_path} is not executable\n" && exit 255; fi

    local file_name
    file_name=$(basename "${file_path}")
    if [[ "0" != "$?" ]]; then printf "Unable to calculate file name for ${file_path}\n" && exit 255; fi

    printf "Starting ${file_name}\n"
    printf "File is at path: ${file_path}\n"
    time "${file_path}"
    local -r exit_code="$?"
    printf "Finished ${file_name} with exit code: ${exit_code}\n"
    if [[ "0" != "${exit_code}" ]]; then printf "Tests failed\n"; fi
}
