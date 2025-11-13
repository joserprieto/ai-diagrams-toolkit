#!/usr/bin/env bash
##
## @file extraction.sh
## @brief Claude Code output extraction
## @description
##   Utilities for extracting diagrams and data from Claude Code output.
##   Handles JSON parsing and diagram content extraction.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/claude/extraction.sh"
##   adt::lib::tests::claude::extraction::extract_diagram "${JSON_OUTPUT}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::claude::extraction
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__claude__extraction__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__claude__extraction__LOADED=1

##
## @description Extracts diagram content from Claude Code output
## @param $1 Claude Code output (JSON)
## @stdout Diagram content
## @return 0 on success
##
adt::lib::tests::claude::extraction::extract_diagram() {
  local claude_output="$1"

  # Extract diagram content (basic extraction)
  # Assumes JSON format with "diagram" or "content" field
  echo "${claude_output}" | grep -o '"diagram":"[^"]*"' | cut -d'"' -f4 || \
  echo "${claude_output}" | grep -o '"content":"[^"]*"' | cut -d'"' -f4 || \
  echo "${claude_output}"
}

##
## @description Parses JSON output from Claude Code
## @param $1 JSON string
## @param $2 Field to extract (optional)
## @stdout Parsed value
## @return 0 on success
##
adt::lib::tests::claude::extraction::parse_json_output() {
  local json_output="$1"
  local field="${2:-content}"

  # Basic JSON parsing (assumes single-level structure)
  if command -v jq &>/dev/null; then
    echo "${json_output}" | jq -r ".${field}" 2>/dev/null || echo "${json_output}"
  else
    # Fallback: grep-based extraction
    echo "${json_output}" | grep -o "\"${field}\":\"[^\"]*\"" | cut -d'"' -f4 || echo "${json_output}"
  fi
}

##
## @description Validates Claude Code response format
## @param $1 Response string
## @return 0 if valid format, 1 if invalid
##
adt::lib::tests::claude::extraction::validate_response() {
  local response="$1"

  # Check for common Claude Code response patterns
  if echo "${response}" | grep -q -E "(diagram|flowchart|sequenceDiagram|classDiagram|stateDiagram)"; then
    return 0
  fi

  return 1
}
