#!/bin/bash

fail() {
  if [[ 1 -ne $# ]]; then printf "Expected a single argument - error message to output to standard output" && exit 255; fi
  printf "$1" && exit 255
}
