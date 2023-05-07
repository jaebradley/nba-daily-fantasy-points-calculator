#!/bin/bash

fail() {
  if [[ 1 -ne $# ]]; then printf "%s" "Expected a single argument - error message to output to standard output" && exit 255; fi
  printf "%s" "$1" && exit 255
}
