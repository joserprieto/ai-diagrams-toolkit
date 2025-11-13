#!/usr/bin/env bash
##
## @file validation.sh
## @brief Diagram validation and convention checking
## @description
##   Provides functions for validating Mermaid diagrams:
##   - Syntax validation (correct Mermaid structure)
##   - Convention checking (semantic names, English comments, etc.)
##   - Comprehensive error reporting
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/validation.sh"
##   adt::lib::tests::validation::validate_diagram "${DIAGRAM_FILE}"
##   adt::lib::tests::validation::validate_syntax "${DIAGRAM_CONTENT}"
##   adt::lib::tests::validation::validate_conventions "${DIAGRAM_CONTENT}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::validation
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__validation__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__validation__LOADED=1

# Import colors for output
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

##
## @description Validates Mermaid diagram syntax
## @param $1 Diagram content (as string)
## @return 0 if valid syntax, 1 if invalid
## @exitcode 1 if syntax errors detected
##
adt::lib::tests::validation::validate_syntax() {
  local diagram_content="$1"

  if [[ -z "${diagram_content}" ]]; then
    echo "❌ ERROR: Empty diagram content"
    return 1
  fi

  # Check for basic Mermaid structure
  if ! echo "${diagram_content}" | grep -q -E "^(flowchart|sequenceDiagram|classDiagram|stateDiagram|erDiagram)"; then
    echo "❌ ERROR: Missing Mermaid diagram type (flowchart, sequenceDiagram, etc.)"
    return 1
  fi

  return 0
}

##
## @description Validates diagram naming conventions
## @param $1 Diagram content (as string)
## @return 0 if conventions met, 1 if violations found
## @exitcode 1 if convention violations detected
##
adt::lib::tests::validation::validate_conventions() {
  local diagram_content="$1"
  local violations=0

  # Check for reserved keywords used as node IDs
  local reserved_keywords=("end" "class" "style" "subgraph" "graph" "default" "none")

  for keyword in "${reserved_keywords[@]}"; do
    if echo "${diagram_content}" | grep -q "\b${keyword}\b.*\["; then
      echo "⚠️  WARNING: Potential reserved keyword '${keyword}' used"
      ((violations++))
    fi
  done

  # Check for non-English comments (basic heuristic)
  if echo "${diagram_content}" | grep -q "%% .*[áéíóúñäöüç]"; then
    echo "⚠️  WARNING: Non-English characters in comments detected"
    ((violations++))
  fi

  if [[ $violations -gt 0 ]]; then
    return 1
  fi

  return 0
}

##
## @description Complete diagram validation (syntax + conventions)
## @param $1 Path to diagram file OR diagram content
## @return 0 if valid, 1 if any validation fails
## @exitcode 1 if validation fails
##
adt::lib::tests::validation::validate_diagram() {
  local diagram_input="$1"
  local diagram_content=""

  # Check if it's a file path or content
  if [[ -f "${diagram_input}" ]]; then
    diagram_content=$(cat "${diagram_input}")
  else
    diagram_content="${diagram_input}"
  fi

  # Run validations
  if ! adt::lib::tests::validation::validate_syntax "${diagram_content}"; then
    return 1
  fi

  if ! adt::lib::tests::validation::validate_conventions "${diagram_content}"; then
    return 1
  fi

  echo "${adt__lib__tests__colors__GREEN}✓ Diagram is valid${adt__lib__tests__colors__RESET}"
  return 0
}
