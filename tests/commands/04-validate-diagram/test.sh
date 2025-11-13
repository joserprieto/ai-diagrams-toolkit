#!/bin/bash
##
## @file test.sh
## @brief Test: Validate Diagram
## @description
##   Verifies AI can identify issues in Mermaid diagrams.
##
##   Input: Diagram with reserved keywords and syntax issues (input.mmd)
##   Expected: Issue list with severity + corrected diagram
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
INPUT_FILE="${TEST_DIR}/input.mmd"

# ── Setup ────────────────────────────────────────────────────────────────
tests::setup::initialize "$1" "${OUTPUT_DIR}"

# Register cleanup
trap 'tests::teardown::cleanup' EXIT

# ── Execute test ─────────────────────────────────────────────────────────
echo -e "${tests__colors__CYAN}${tests__colors__INFO}${tests__colors__RESET} Running test: ${tests__colors__BOLD}${TEST_DIR_NAME}${tests__colors__RESET}"
echo -e "${tests__colors__CYAN}${tests__colors__INFO}${tests__colors__RESET} Using AI executor: ${AI_CLI_EXECUTOR}"

# Read input diagram and prompt
INPUT_DIAGRAM="$(cat "${INPUT_FILE}")"
PROMPT="$(cat "${PROMPT_FILE}")"

# Replace {INPUT} placeholder in prompt with actual diagram
FINAL_PROMPT="${PROMPT/\{INPUT\}/$INPUT_DIAGRAM}"

# Execute AI CLI
"${AI_CLI_EXECUTOR}" -p "${FINAL_PROMPT}" \
  --output-format json \
  > "${OUTPUT_DIR}/response.json" 2>&1 || {
    echo -e "${tests__colors__RED}${tests__colors__CROSS}${tests__colors__RESET} AI execution failed"
    cat "${OUTPUT_DIR}/response.json"
    exit 1
  }

# Extract validation report
if tests::extraction::validation_report \
     "${OUTPUT_DIR}/response.json" \
     "${OUTPUT_DIR}/validation-report.txt"; then
  echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Validation report generated: ${OUTPUT_DIR}/validation-report.txt"
else
  exit 1
fi

# Try to extract corrected diagram (if present in markdown code block)
if tests::extraction::corrected_diagram \
     "${OUTPUT_DIR}/validation-report.txt" \
     "${OUTPUT_DIR}/corrected-diagram.mmd"; then
  echo -e "${tests__colors__GREEN}${tests__colors__CHECK}${tests__colors__RESET} Corrected diagram extracted: ${OUTPUT_DIR}/corrected-diagram.mmd"
fi

# ── Automated validations ────────────────────────────────────────────────
FAILED=0

tests::validation::issue_analysis "${OUTPUT_DIR}/validation-report.txt" || \
  FAILED=1
tests::validation::severity_classification "${OUTPUT_DIR}/validation-report.txt" || \
  FAILED=1
tests::validation::corrected_diagram_syntax "${OUTPUT_DIR}/corrected-diagram.mmd" || \
  FAILED=1

# ── Manual verification prompt ───────────────────────────────────────────
echo ""
echo -e "${tests__colors__BOLD}Manual verification required:${tests__colors__RESET}"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Open: ${OUTPUT_DIR}/validation-report.txt"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Check: Identifies reserved keywords (end, class, type, subgraph)"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Check: Provides appropriate severity levels"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Check: Suggested fixes are practical"
echo -e "  ${tests__colors__CYAN}→${tests__colors__RESET} Verify: Corrected diagram renders in Mermaid preview"
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
