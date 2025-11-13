#!/usr/bin/env bash
##
## @file validation.sh
## @brief Mermaid-specific diagram validation
## @description
##   Validates diagrams against Mermaid-specific rules and best practices.
##   Checks syntax, colors, and conventions.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"
##   adt::lib::tests::mermaid::validation::validate_mermaid_syntax "${DIAGRAM}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::mermaid::validation
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__mermaid__validation__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__mermaid__validation__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../colors.sh"

##
## @description Validates Mermaid-specific syntax rules
## @param $1 Diagram content
## @return 0 if valid, 1 if invalid
##
adt::lib::tests::mermaid::validation::validate_mermaid_syntax() {
  local diagram_content="$1"

  # Check for valid Mermaid diagram types
  if ! echo "${diagram_content}" | grep -q -E "^(flowchart|sequenceDiagram|classDiagram|stateDiagram|erDiagram|graph)"; then
    echo "❌ Invalid Mermaid diagram type"
    return 1
  fi

  # Check for unmatched braces
  local open_braces=$(echo "${diagram_content}" | grep -o "{" | wc -l)
  local close_braces=$(echo "${diagram_content}" | grep -o "}" | wc -l)

  if [[ $open_braces -ne $close_braces ]]; then
    echo "❌ Unmatched braces in diagram"
    return 1
  fi

  return 0
}

##
## @description Validates semantic color system usage
## @param $1 Diagram content
## @return 0 if valid, 1 if violations
##
adt::lib::tests::mermaid::validation::validate_semantic_colors() {
  local diagram_content="$1"

  # Check for classDef definitions
  if ! echo "${diagram_content}" | grep -q "classDef"; then
    echo "⚠️  WARNING: No color definitions (classDef) found"
    return 1
  fi

  # Check for color assignments (:::className syntax)
  if ! echo "${diagram_content}" | grep -q ":::"; then
    echo "⚠️  WARNING: No color assignments (:::) found"
    return 1
  fi

  return 0
}

##
## @description Validates reserved keyword violations
## @param $1 Diagram content
## @return 0 if no violations, 1 if violations found
##
adt::lib::tests::mermaid::validation::check_reserved_keywords() {
  local diagram_content="$1"
  local violations=0

  local reserved=("end" "class" "style" "default")

  for keyword in "${reserved[@]}"; do
    if echo "${diagram_content}" | grep -q "\b${keyword}\b\s*\["; then
      echo "⚠️  Reserved keyword '${keyword}' used as node ID"
      ((violations++))
    fi
  done

  return $([[ $violations -eq 0 ]] && echo 0 || echo 1)
}
