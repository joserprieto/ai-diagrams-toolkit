#!/bin/bash
##
## @file extraction.sh
## @brief Generic extraction functions (Strategy pattern)
## @description
##   Provides generic extraction interface that delegates to specific strategies.
##   Configure strategy via EXTRACTION_STRATEGY variable.
##
## @example
##   export EXTRACTION_STRATEGY="claude"
##   source "${REPO_ROOT}/scripts/tests/lib/extraction.sh"
##   tests::extraction::mermaid_diagram "response.json" "diagram.mmd"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__extraction__LOADED:-}" ]]; then
  return 0
fi
readonly tests__extraction__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

# Namespace for this library
readonly tests__extraction__NAMESPACE="tests::extraction"

# Default strategy
: "${EXTRACTION_STRATEGY:=claude}"

# Load strategy implementation
source "${SCRIPT_DIR}/${EXTRACTION_STRATEGY}/extraction.sh"

##
## @description Extracts Mermaid diagram from AI response (delegates to strategy)
## @param $1 Path to response.json file (input)
## @param $2 Path to diagram.mmd file (output)
## @return 0 on success, 1 on failure
##
tests::extraction::mermaid_diagram() {
  tests::extraction::${EXTRACTION_STRATEGY}::mermaid_diagram "$@"
}

##
## @description Extracts validation report from AI response (delegates to strategy)
## @param $1 Path to response.json file (input)
## @param $2 Path to validation-report.txt file (output)
## @return 0 on success, 1 on failure
##
tests::extraction::validation_report() {
  tests::extraction::${EXTRACTION_STRATEGY}::validation_report "$@"
}

##
## @description Extracts corrected diagram from validation report (delegates to strategy)
## @param $1 Path to validation-report.txt file (input)
## @param $2 Path to corrected-diagram.mmd file (output)
## @return 0 if diagram found and extracted, 1 if not found
##
tests::extraction::corrected_diagram() {
  tests::extraction::${EXTRACTION_STRATEGY}::corrected_diagram "$@"
}
