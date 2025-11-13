#!/usr/bin/env bash
##
## @file teardown.sh
## @brief Test cleanup and resource management
## @description
##   Provides functions for cleaning up test resources:
##   - Remove temporary test directories
##   - Clean output files
##   - Generate test reports
##   - Final test summary
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/teardown.sh"
##   adt::lib::tests::teardown::cleanup_output_dir "/tmp/test-output"
##   adt::lib::tests::teardown::print_summary
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::teardown
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__teardown__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__teardown__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

##
## @description Removes output directory if it exists
## @param $1 Output directory path
## @return 0 on success (or if dir doesn't exist)
##
adt::lib::tests::teardown::cleanup_output_dir() {
  local output_dir="$1"

  if [[ -d "${output_dir}" ]]; then
    rm -rf "${output_dir}"
    echo "✓ Cleaned up output directory: ${output_dir}"
  fi

  return 0
}

##
## @description Removes temporary test files
## @param $1 Temp directory path
## @return 0 on success
##
adt::lib::tests::teardown::cleanup_temp_files() {
  local temp_dir="$1"

  if [[ -d "${temp_dir}" ]]; then
    rm -rf "${temp_dir}"
    echo "✓ Cleaned up temporary files: ${temp_dir}"
  fi

  return 0
}

##
## @description Prints test execution summary
## @noargs
## @stdout Summary report
## @return 0 always
##
adt::lib::tests::teardown::print_summary() {
  echo "${adt__lib__tests__colors__BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${adt__lib__tests__colors__RESET}"
  echo "${adt__lib__tests__colors__BOLD}Test Execution Complete${adt__lib__tests__colors__RESET}"
  echo "${adt__lib__tests__colors__BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${adt__lib__tests__colors__RESET}"
  echo ""

  return 0
}

##
## @description Removes all generated test artifacts
## @param $1 Artifacts directory path
## @return 0 on success
##
adt::lib::tests::teardown::cleanup_artifacts() {
  local artifacts_dir="$1"

  if [[ -d "${artifacts_dir}" ]]; then
    find "${artifacts_dir}" -type f -name "*.output" -o -name "*.tmp" | xargs rm -f || true
    echo "✓ Cleaned up test artifacts"
  fi

  return 0
}
