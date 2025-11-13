#!/bin/bash
##
## @file teardown.sh
## @brief Test cleanup and teardown functions
## @description
##   Provides functions for test cleanup:
##   - Temporary file removal
##   - Resource cleanup
##   - Exit code handling
##
## @example
##   source "${REPO_ROOT}/scripts/tests/lib/teardown.sh"
##   trap 'tests::teardown::cleanup' EXIT
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__teardown__LOADED:-}" ]]; then
  return 0
fi
readonly tests__teardown__LOADED=1

# Namespace for this library
readonly tests__teardown__NAMESPACE="tests::teardown"

# Global variable to track temporary files
tests__teardown__TEMP_FILES=()

##
## @description Registers a temporary file for cleanup
## @param $1 Path to temporary file
## @noargs
## @return 0 always
##
tests::teardown::register_temp_file() {
  local temp_file="$1"
  tests__teardown__TEMP_FILES+=("${temp_file}")
}

##
## @description Removes all registered temporary files
## @noargs
## @return 0 always
##
tests::teardown::cleanup_temp_files() {
  for temp_file in "${tests__teardown__TEMP_FILES[@]}"; do
    if [[ -f "${temp_file}" ]]; then
      rm -f "${temp_file}"
    fi
  done
}

##
## @description Complete test teardown (cleanup all resources)
## @noargs
## @return 0 always
##
tests::teardown::cleanup() {
  tests::teardown::cleanup_temp_files
}
