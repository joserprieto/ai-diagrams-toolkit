#!/bin/bash
##
## @file mermaid/validation.sh
## @brief Mermaid diagram validation functions
## @description
##   Provides validation functions for Mermaid diagrams:
##   - Graph/flowchart declaration
##   - ClassDef blocks
##   - Class assignments
##   - Node definitions
##   - Connections
##   - Sequence diagram elements
##
## @example
##   source "${REPO_ROOT}/scripts/tests/lib/mermaid/validation.sh"
##   tests::validation::mermaid::graph_declaration "diagram.mmd" || exit 1
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__validation__mermaid__LOADED:-}" ]]; then
  return 0
fi
readonly tests__validation__mermaid__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../colors.sh"

# Namespace for this library
readonly tests__validation__mermaid__NAMESPACE="tests::validation::mermaid"

##
## @description Validates graph/flowchart declaration exists
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::graph_declaration() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "^(graph|flowchart)\s+(TD|TB|LR)"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has graph declaration"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing graph declaration"
    return 1
  fi
}

##
## @description Validates classDef block exists
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::classdef_block() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -q "classDef"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Contains classDef block"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing classDef block"
    return 1
  fi
}

##
## @description Validates class assignments exist (inline or block syntax)
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::class_assignments() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  # Check for either ::: inline syntax or "class NodeName className" block
  if echo "${content}" | grep -qE "(:::|^[[:space:]]*class[[:space:]])"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has class assignments"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing class assignments"
    return 1
  fi
}

##
## @description Validates node definitions exist
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::node_definitions() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "\[.*\]"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has node definitions"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing node definitions"
    return 1
  fi
}

##
## @description Validates connections exist
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::connections() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -q -e "-->"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has connections (-->)"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing connections"
    return 1
  fi
}

##
## @description Validates sequenceDiagram declaration
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::sequence_declaration() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "^sequenceDiagram"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has sequenceDiagram declaration"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing sequenceDiagram declaration"
    return 1
  fi
}

##
## @description Validates sequenceDiagram does NOT use classDef (not supported)
## @param $1 Path to diagram.mmd file
## @return 0 if valid (no classDef), 1 if invalid (has classDef)
##
tests::validation::mermaid::sequence_no_classdef() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  # Check if it's a sequence diagram first
  if ! echo "${content}" | grep -qE "^sequenceDiagram"; then
    return 0  # Not a sequence diagram, skip this check
  fi

  # Check for classDef or class directives
  if echo "${content}" | grep -qE "(classDef|^[[:space:]]*class[[:space:]])"; then
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} ERROR: sequenceDiagram does NOT support classDef/class"
    echo -e "${tests__colors__YELLOW}${tests__colors__INFO}${tests__colors__RESET} See: guides/mermaid/common-pitfalls.md"
    return 1
  else
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} No invalid classDef in sequenceDiagram"
    return 0
  fi
}

##
## @description Validates diagram has theme configuration with semantic colors (ALL types)
## @param $1 Path to diagram.mmd file
## @return 0 always (info only, doesn't fail)
##
tests::validation::mermaid::has_theme() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  # Check for theme configuration (supports multiline format)
  if echo "${content}" | grep -qE "%%\{init" && echo "${content}" | grep -q "themeVariables"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has theme configuration with semantic colors"
    return 0
  else
    echo -e "${tests__colors__YELLOW}${tests__colors__INFO}${tests__colors__RESET} No theme configuration (recommended for ALL diagram types)"
    return 0
  fi
}

##
## @description Validates sequence diagram doesn't have deactivation in alt/else blocks
## @param $1 Path to diagram.mmd file
## @return 0 if valid (or not applicable), 1 if invalid
##
tests::validation::mermaid::sequence_activation_balance() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  # Check if it's a sequence diagram first
  if ! echo "${content}" | grep -qE "^sequenceDiagram"; then
    return 0  # Not a sequence diagram, skip this check
  fi

  # Check if diagram has alt/else blocks
  if ! echo "${content}" | grep -qE "^[[:space:]]*(alt|else)"; then
    return 0  # No alt/else blocks, activation balance is simpler
  fi

  # Extract content between alt and end
  local in_alt_block=false
  local has_deactivation_in_alt=false
  local line_num=0

  while IFS= read -r line; do
    line_num=$((line_num + 1))

    # Detect alt/else block start
    if echo "$line" | grep -qE "^[[:space:]]*(alt|else)"; then
      in_alt_block=true
      continue
    fi

    # Detect block end
    if echo "$line" | grep -qE "^[[:space:]]*end"; then
      in_alt_block=false
      continue
    fi

    # Check for deactivation inside alt/else block
    if [[ "$in_alt_block" == true ]]; then
      # Check for - suffix (inline deactivation)
      if echo "$line" | grep -qE ">>-"; then
        echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} ERROR: Deactivation (-) found inside alt/else block (line $line_num)"
        echo -e "${tests__colors__YELLOW}${tests__colors__INFO}${tests__colors__RESET} NEVER use '-' suffix inside alt/else/loop/opt blocks"
        echo -e "${tests__colors__YELLOW}${tests__colors__INFO}${tests__colors__RESET} See: guides/mermaid/common-pitfalls.md#sequence-diagram-activationdeactivation"
        has_deactivation_in_alt=true
      fi
    fi
  done <<< "$content"

  if [[ "$has_deactivation_in_alt" == true ]]; then
    return 1
  else
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} No deactivation inside alt/else blocks"
    return 0
  fi
}

##
## @description Validates sequenceDiagram has theme configuration (alias for compatibility)
## @param $1 Path to diagram.mmd file
## @return 0 always (info only, doesn't fail)
##
tests::validation::mermaid::sequence_has_theme() {
  tests::validation::mermaid::has_theme "$@"
}

##
## @description Validates participant definitions exist
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::participant_definitions() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "^\\s*participant\\s+"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has participant definitions"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing participant definitions"
    return 1
  fi
}

##
## @description Validates message arrows exist
## @param $1 Path to diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::message_arrows() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "(->|-->|->>|-->>)"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has message arrows"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing message arrows"
    return 1
  fi
}

##
## @description Checks for activation boxes (optional)
## @param $1 Path to diagram.mmd file
## @return 0 if found (info only, doesn't fail)
##
tests::validation::mermaid::activation_boxes() {
  local diagram_file="$1"
  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -qE "(activate|deactivate)"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Has activation boxes"
  else
    echo -e "${tests__colors__YELLOW}${tests__colors__INFO}${tests__colors__RESET} No activation boxes (optional but recommended)"
  fi

  return 0
}

##
## @description Validates issue analysis exists in validation report
## @param $1 Path to validation-report.txt file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::issue_analysis() {
  local report_file="$1"
  local content
  content="$(cat "${report_file}")"

  if echo "${content}" | grep -qi "issue"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Contains issue analysis"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing issue analysis"
    return 1
  fi
}

##
## @description Validates severity classification exists
## @param $1 Path to validation-report.txt file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::severity_classification() {
  local report_file="$1"
  local content
  content="$(cat "${report_file}")"

  if echo "${content}" | grep -qE "(ERROR|WARNING|INFO)"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Contains severity classification"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Missing severity indicators"
    return 1
  fi
}

##
## @description Validates corrected diagram has proper Mermaid syntax
## @param $1 Path to corrected-diagram.mmd file
## @return 0 if valid, 1 if invalid
##
tests::validation::mermaid::corrected_diagram_syntax() {
  local diagram_file="$1"

  if [[ ! -f "${diagram_file}" ]]; then
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} No corrected diagram found"
    return 1
  fi

  echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Contains corrected diagram"

  local content
  content="$(cat "${diagram_file}")"

  if echo "${content}" | grep -q "graph"; then
    echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Corrected diagram has proper syntax"
    return 0
  else
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} Corrected diagram syntax unclear"
    return 1
  fi
}
