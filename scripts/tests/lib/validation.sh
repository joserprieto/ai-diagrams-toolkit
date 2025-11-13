#!/bin/bash
##
## @file validation.sh
## @brief Generic validation functions (Strategy pattern)
## @description
##   Provides generic validation interface that delegates to specific strategies.
##   Configure strategy via VALIDATION_STRATEGY variable.
##
## @example
##   export VALIDATION_STRATEGY="mermaid"
##   source "${REPO_ROOT}/scripts/tests/lib/validation.sh"
##   tests::validation::graph_declaration "diagram.mmd"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__validation__LOADED:-}" ]]; then
  return 0
fi
readonly tests__validation__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

# Namespace for this library
readonly tests__validation__NAMESPACE="tests::validation"

# Default strategy
: "${VALIDATION_STRATEGY:=mermaid}"

# Load strategy implementation
source "${SCRIPT_DIR}/${VALIDATION_STRATEGY}/validation.sh"

##
## @description Validates graph/flowchart declaration (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::graph_declaration() {
  tests::validation::${VALIDATION_STRATEGY}::graph_declaration "$@"
}

##
## @description Validates classDef block (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::classdef_block() {
  tests::validation::${VALIDATION_STRATEGY}::classdef_block "$@"
}

##
## @description Validates class assignments (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::class_assignments() {
  tests::validation::${VALIDATION_STRATEGY}::class_assignments "$@"
}

##
## @description Validates node definitions (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::node_definitions() {
  tests::validation::${VALIDATION_STRATEGY}::node_definitions "$@"
}

##
## @description Validates connections (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::connections() {
  tests::validation::${VALIDATION_STRATEGY}::connections "$@"
}

##
## @description Validates sequence diagram declaration (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::sequence_declaration() {
  tests::validation::${VALIDATION_STRATEGY}::sequence_declaration "$@"
}

##
## @description Validates participant definitions (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::participant_definitions() {
  tests::validation::${VALIDATION_STRATEGY}::participant_definitions "$@"
}

##
## @description Validates message arrows (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::message_arrows() {
  tests::validation::${VALIDATION_STRATEGY}::message_arrows "$@"
}

##
## @description Checks for activation boxes (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 always (info only)
##
tests::validation::activation_boxes() {
  tests::validation::${VALIDATION_STRATEGY}::activation_boxes "$@"
}

##
## @description Validates issue analysis in report (delegates to strategy)
## @param $1 Path to validation-report.txt file
## @return 0 if valid, 1 if invalid
##
tests::validation::issue_analysis() {
  tests::validation::${VALIDATION_STRATEGY}::issue_analysis "$@"
}

##
## @description Validates severity classification (delegates to strategy)
## @param $1 Path to validation-report.txt file
## @return 0 if valid, 1 if invalid
##
tests::validation::severity_classification() {
  tests::validation::${VALIDATION_STRATEGY}::severity_classification "$@"
}

##
## @description Validates corrected diagram syntax (delegates to strategy)
## @param $1 Path to corrected-diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::corrected_diagram_syntax() {
  tests::validation::${VALIDATION_STRATEGY}::corrected_diagram_syntax "$@"
}

##
## @description Validates sequenceDiagram does NOT use classDef (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::sequence_no_classdef() {
  tests::validation::${VALIDATION_STRATEGY}::sequence_no_classdef "$@"
}

##
## @description Validates sequence diagram activation/deactivation balance (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 if valid, 1 if invalid
##
tests::validation::sequence_activation_balance() {
  tests::validation::${VALIDATION_STRATEGY}::sequence_activation_balance "$@"
}

##
## @description Validates diagram has theme configuration (delegates to strategy)
## @param $1 Path to diagram file
## @return 0 always (info only)
##
tests::validation::has_theme() {
  tests::validation::${VALIDATION_STRATEGY}::has_theme "$@"
}

##
## @description Validates sequenceDiagram has theme configuration (alias for compatibility)
## @param $1 Path to diagram file
## @return 0 always (info only)
##
tests::validation::sequence_has_theme() {
  tests::validation::has_theme "$@"
}
