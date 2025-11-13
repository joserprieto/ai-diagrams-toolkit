#!/bin/bash
##
## @file claude/extraction.sh
## @brief Functions for extracting data from Claude CLI responses
## @description
##   Provides functions to extract and process Claude CLI JSON responses:
##   - Extract Mermaid diagrams from markdown code blocks
##   - Extract validation reports
##   - Handle Claude CLI specific JSON format
##
## @example
##   source "${REPO_ROOT}/scripts/tests/lib/claude/extraction.sh"
##   tests::extraction::claude::mermaid_diagram \
##     "output/response.json" \
##     "output/diagram.mmd"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__extraction__claude__LOADED:-}" ]]; then
  return 0
fi
readonly tests__extraction__claude__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../colors.sh"

# Namespace for this library
readonly tests__extraction__claude__NAMESPACE="tests::extraction::claude"

##
## @description Extracts Mermaid diagram from Claude CLI JSON response
## @param $1 Path to response.json file (input)
## @param $2 Path to diagram.mmd file (output)
## @return 0 on success, 1 on failure
## @exitcode 1 if extraction fails
##
tests::extraction::claude::mermaid_diagram() {
  local response_file="$1"
  local output_file="$2"

  # Claude CLI returns: {"result": "```mermaid\n...\n```"}
  # Extract .result field, then extract content between ```mermaid markers
  if ! "${JQ}" -r '.result' "${response_file}" | \
       sed -n '/```mermaid/,/```/p' | \
       grep -v '```' \
       > "${output_file}"; then
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Failed to extract diagram from JSON"
    return 1
  fi

  return 0
}

##
## @description Extracts validation report from Claude CLI JSON response
## @param $1 Path to response.json file (input)
## @param $2 Path to validation-report.txt file (output)
## @return 0 on success, 1 on failure
## @exitcode 1 if extraction fails
##
tests::extraction::claude::validation_report() {
  local response_file="$1"
  local output_file="$2"

  # Extract .result field directly (contains validation report)
  if ! "${JQ}" -r '.result' "${response_file}" \
       > "${output_file}"; then
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Failed to extract validation report from JSON"
    return 1
  fi

  return 0
}

##
## @description Attempts to extract corrected diagram from validation report
## @param $1 Path to validation-report.txt file (input)
## @param $2 Path to corrected-diagram.mmd file (output)
## @return 0 if diagram found and extracted, 1 if not found
##
tests::extraction::claude::corrected_diagram() {
  local report_file="$1"
  local output_file="$2"

  # Try to extract corrected diagram from markdown code block
  if grep -q '```mermaid' "${report_file}"; then
    sed -n '/```mermaid/,/```/p' "${report_file}" | \
      grep -v '```' \
      > "${output_file}"
    return 0
  fi

  return 1
}
