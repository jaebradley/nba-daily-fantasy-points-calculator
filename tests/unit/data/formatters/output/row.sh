#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")/../../../../../utilities/error.sh" || exit 255
. "$(dirname "${BASH_SOURCE[0]}")/../../../../../data/formatters/output/row.sh" || fail "Could not import output row formatter"

compare() {
  local -r expected="$1"
  local -r player_name="$2"
  local -r points="$3"
  local -r player_status="$4"

  local formatted_output
  if ! formatted_output=$(format_output_row "${player_name}" "${points}" "${player_status}"); then fail "Could not format row\n"; fi

  if [[ "${expected}" != "${formatted_output}" ]]; then fail "Expected ${expected} but got ${formatted_output} instead"; fi
}

main() {
  compare "foo|bar|baz" "foo" "bar" "baz" || fail "Could not calculate input lacking quotes"
  compare "foo|bar|baz" "\"foo\"" "bar" "\"baz\"" || fail "Could not calculate input with quotes"
  compare "\"foo\"|bar|\"baz\"" "\"\"foo\"\"" "bar" "\"\"baz\"\"" || fail "Could not calculate input with two double quotes"
}

main
