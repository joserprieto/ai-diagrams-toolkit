#!/usr/bin/env bash
##
## @file extraction.sh
## @brief Diagram element extraction utilities
## @description
##   Provides functions for extracting and analyzing diagram elements:
##   - Extract node definitions
##   - Extract connections/relationships
##   - Extract style definitions
##   - Parse diagram metadata
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"
##   adt::lib::tests::extraction::extract_nodes "${DIAGRAM_CONTENT}"
##   adt::lib::tests::extraction::extract_connections "${DIAGRAM_CONTENT}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::extraction
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__extraction__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__extraction__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

##
## @description Extracts node definitions from diagram
## @param $1 Diagram content
## @stdout Node definitions (one per line)
## @return 0 on success
##
adt::lib::tests::extraction::extract_nodes() {
  local diagram_content="$1"

  # Extract node definitions (basic pattern: NodeID["Label"])
  echo "${diagram_content}" | grep -E '^\s*[a-zA-Z0-9_]+\[' || true
}

##
## @description Extracts connections/arrows from diagram
## @param $1 Diagram content
## @stdout Connection definitions (one per line)
## @return 0 on success
##
adt::lib::tests::extraction::extract_connections() {
  local diagram_content="$1"

  # Extract arrows/connections (patterns: -->, ---, -.->, etc.)
  echo "${diagram_content}" | grep -E '(\-\-+>|\-\-\-|\-\.-+>|->)' || true
}

##
## @description Extracts style definitions from diagram
## @param $1 Diagram content
## @stdout Style definitions (classDef, style, linkStyle)
## @return 0 on success
##
adt::lib::tests::extraction::extract_styles() {
  local diagram_content="$1"

  # Extract style definitions (classDef, style commands, etc.)
  echo "${diagram_content}" | grep -E '(^classDef|^style|^linkStyle|^%%\{init)' || true
}

##
## @description Count diagram nodes
## @param $1 Diagram content
## @stdout Node count
## @return 0 on success
##
adt::lib::tests::extraction::count_nodes() {
  local diagram_content="$1"

  adt::lib::tests::extraction::extract_nodes "${diagram_content}" | wc -l
}

##
## @description Count diagram connections
## @param $1 Diagram content
## @stdout Connection count
## @return 0 on success
##
adt::lib::tests::extraction::count_connections() {
  local diagram_content="$1"

  adt::lib::tests::extraction::extract_connections "${diagram_content}" | wc -l
}
