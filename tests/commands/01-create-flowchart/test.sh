#!/bin/bash
##
## @file test.sh
## @brief Test: Create Flowchart Diagram
## @description
##   Verifies AI can create a complete flowchart with semantic names
##   and colors.
##
##   Input: Text prompt describing API validation system
##   Expected: Mermaid flowchart with proper structure, semantic names,
##             and color classes
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# ── Configure strategies ─────────────────────────────────────────────────
export SETUP_STRATEGY="claude"
export EXTRACTION_STRATEGY="claude"
export VALIDATION_STRATEGY="mermaid"

# ── Load test libraries ──────────────────────────────────────────────────
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${REPO_ROOT}/scripts/tests/lib"

source "${LIB_DIR}/colors.sh"
source "${LIB_DIR}/setup.sh"
source "${LIB_DIR}/extraction.sh"
source "${LIB_DIR}/validation.sh"
source "${LIB_DIR}/teardown.sh"

# ── Configuration ────────────────────────────────────────────────────────
TEST_DIR_NAME="$(basename "${TEST_DIR}")"
OUTPUT_DIR="${REPO_ROOT}/tests/output/commands/${TEST_DIR_NAME}"
PROMPT_FILE="${TEST_DIR}/prompt.txt"

# ── Setup ────────────────────────────────────────────────────────────────
tests::setup::initialize "$1" "${OUTPUT_DIR}"

# Register cleanup
trap 'tests::teardown::cleanup' EXIT

# ── Execute test ─────────────────────────────────────────────────────────
echo -e "${tests__colors__CYAN}${tests__colors__INFO}${tests__colors__RESET} Running test: ${tests__colors__BOLD}${TEST_DIR_NAME}${tests__colors__RESET}"
echo -e "${tests__colors__CYAN}${tests__colors__INFO}${tests__colors__RESET} Using AI executor: ${AI_CLI_EXECUTOR}"

# Execute AI CLI
PROMPT="$(cat "${PROMPT_FILE}")"

"${AI_CLI_EXECUTOR}" -p "${PROMPT}" \
  --output-format json \
  > "${OUTPUT_DIR}/response.json" 2>&1 || {
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} AI execution failed"
    cat "${OUTPUT_DIR}/response.json"
    exit 1
  }

# Extract diagram
if tests::extraction::mermaid_diagram \
     "${OUTPUT_DIR}/response.json" \
     "${OUTPUT_DIR}/diagram.mmd"; then
  echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Diagram generated: ${OUTPUT_DIR}/diagram.mmd"
else
  exit 1
fi

# ── Automated validations ────────────────────────────────────────────────
FAILED=0

tests::validation::has_theme "${OUTPUT_DIR}/diagram.mmd"
tests::validation::graph_declaration "${OUTPUT_DIR}/diagram.mmd" || \
  FAILED=1
tests::validation::classdef_block "${OUTPUT_DIR}/diagram.mmd" || \
  FAILED=1
tests::validation::class_assignments "${OUTPUT_DIR}/diagram.mmd" || \
  FAILED=1
tests::validation::node_definitions "${OUTPUT_DIR}/diagram.mmd" || \
  FAILED=1
tests::validation::connections "${OUTPUT_DIR}/diagram.mmd" || \
  FAILED=1

# ── Manual verification prompt ───────────────────────────────────────────
echo ""
echo -e "${tests__colors__BOLD}Manual verification required:${tests__colors__RESET}"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Open: ${OUTPUT_DIR}/diagram.mmd"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Check: Renders in Mermaid preview"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Verify: Semantic names (not A, B, C)"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Verify: Colors match meanings"
echo ""

if [[ -f "${TEST_DIR}/expected-criteria.md" ]]; then
  echo -e "${tests__colors__DIM}Expected criteria: ${TEST_DIR}/expected-criteria.md${tests__colors__RESET}"
  echo ""
fi

# ── Result ───────────────────────────────────────────────────────────────
if [[ ${FAILED} -eq 0 ]]; then
  echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} ${tests__colors__BOLD}Test passed (automated checks)${tests__colors__RESET}"
  exit 0
else
  echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} ${tests__colors__BOLD}Test failed${tests__colors__RESET}"
  exit 1
fi
