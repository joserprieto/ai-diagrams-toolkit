#!/bin/bash
# Run all AI command tests
#
# This script discovers and runs all numbered test directories
# Tests are executed in order and results are summarized

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

CHECK='✓'
CROSS='✗'
INFO='ℹ'

# ── Configuration ───────────────────────────────────────────────────────────
TESTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${TESTS_DIR}/../.." && pwd)"

# ── Validate Execution Context ──────────────────────────────────────────────
# Tests must run from repo root to access CLAUDE.md (AI agent context)
if [ ! -f "${REPO_ROOT}/CLAUDE.md" ]; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}  AI Command Tests - Automated Suite${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${RED}❌ ERROR: CLAUDE.md not found in repository root${RESET}"
    echo ""
    echo -e "${DIM}Claude CLI requires CLAUDE.md to load AI agent context.${RESET}"
    echo -e "${DIM}Expected: ${REPO_ROOT}/CLAUDE.md${RESET}"
    echo ""
    echo -e "${BOLD}To fix:${RESET}"
    echo -e "  ${CYAN}→${RESET} cd ${REPO_ROOT}"
    echo -e "  ${CYAN}→${RESET} ln -s .ai/AGENTS.md CLAUDE.md"
    echo ""
    exit 1
fi

# ── Load Configuration ──────────────────────────────────────────────────────
ENV_FILE="${1:-}"

# Fallback: Search for .env in repo root
if [ -z "${ENV_FILE}" ] || [ ! -f "${ENV_FILE}" ]; then
    if [ -f "${REPO_ROOT}/.env" ]; then
        ENV_FILE="${REPO_ROOT}/.env"
    elif [ -f "${REPO_ROOT}/.env.example" ]; then
        ENV_FILE="${REPO_ROOT}/.env.example"
    else
        echo -e "${RED}❌ ERROR: No .env file found${RESET}"
        echo ""
        echo -e "${BOLD}Use:${RESET} ${CYAN}make test/commands${RESET}"
        echo ""
        exit 1
    fi
fi

# Load environment variables in local scope
set -a
source "${ENV_FILE}"
set +a

# Validate required variables
: "${AI_CLI_EXECUTOR:?ERROR: AI_CLI_EXECUTOR not defined in ${ENV_FILE}}"
: "${JQ:?ERROR: JQ not defined in ${ENV_FILE}}"

# ── Early Dependency Check ──────────────────────────────────────────────────
# Check if AI executor is available before running tests
# Try to execute with --version to detect if it works (handles aliases)
if ! "${AI_CLI_EXECUTOR}" --version >/dev/null 2>&1; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}  AI Command Tests - Automated Suite${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${YELLOW}⚠${RESET} ${BOLD}AI executor '${AI_CLI_EXECUTOR}' not found${RESET}"
    echo ""
    echo -e "${DIM}Tests require an AI CLI executor to run.${RESET}"
    echo ""
    echo -e "${BOLD}To install Claude CLI:${RESET}"
    echo -e "  ${CYAN}→${RESET} Visit: https://docs.anthropic.com/claude/docs/claude-cli"
    echo -e "  ${CYAN}→${RESET} Or run: ${BOLD}make check/deps${RESET} to see all dependencies"
    echo ""
    echo -e "${BOLD}Alternative executors:${RESET}"
    echo -e "  ${CYAN}→${RESET} Set AI_CLI_EXECUTOR=cursor-agent (if installed)"
    echo -e "  ${CYAN}→${RESET} Set AI_CLI_EXECUTOR=junie (if installed)"
    echo ""
    echo -e "${YELLOW}→${RESET} Tests skipped (missing required executor)"
    exit 1
fi

# Check if jq is available
# Using 'type' to detect aliases, functions, and binaries
if ! type "${JQ}" >/dev/null 2>&1; then
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${CYAN}  AI Command Tests - Automated Suite${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${YELLOW}⚠${RESET} ${BOLD}JSON parser '${JQ}' not found${RESET}"
    echo ""
    echo -e "${DIM}Tests require jq to parse JSON responses.${RESET}"
    echo ""
    echo -e "${BOLD}To install jq:${RESET}"
    echo -e "  ${CYAN}→${RESET} macOS: ${BOLD}brew install jq${RESET}"
    echo -e "  ${CYAN}→${RESET} Ubuntu/Debian: ${BOLD}apt-get install jq${RESET}"
    echo -e "  ${CYAN}→${RESET} Or run: ${BOLD}make check/deps${RESET} to see all dependencies"
    echo ""
    echo -e "${YELLOW}→${RESET} Tests skipped (missing required parser)"
    exit 1
fi

# ── Header ──────────────────────────────────────────────────────────────────
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}  AI Command Tests - Automated Suite${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${INFO} AI Executor: ${BOLD}${AI_CLI_EXECUTOR}${RESET}"
echo -e "${INFO} JSON Parser: ${BOLD}${JQ}${RESET}"
echo ""

# ── Test Discovery ──────────────────────────────────────────────────────────
FAILED=0
PASSED=0
TOTAL=0

# Find all test directories (numbered XX-*)
TEST_DIRS=()
while IFS= read -r -d '' test_dir; do
    TEST_DIRS+=("$test_dir")
done < <(find "${TESTS_DIR}" -maxdepth 1 -type d -name '[0-9][0-9]-*' -print0 | sort -z)

TOTAL=${#TEST_DIRS[@]}

if [ ${TOTAL} -eq 0 ]; then
    echo -e "${RED}${CROSS}${RESET} No tests found in ${TESTS_DIR}"
    exit 1
fi

echo -e "${INFO} Found ${BOLD}${TOTAL}${RESET} test(s)"
echo ""

# ── Run Tests ───────────────────────────────────────────────────────────────
# Tests must execute from repo root to access CLAUDE.md
cd "${REPO_ROOT}"

for test_dir in "${TEST_DIRS[@]}"; do
    test_name="$(basename "${test_dir}")"
    test_number=$((PASSED + FAILED + 1))

    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}Test ${test_number}/${TOTAL}: ${test_name}${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""

    if [ ! -f "${test_dir}/test.sh" ]; then
        echo -e "${RED}${CROSS}${RESET} Missing test.sh in ${test_name}"
        FAILED=$((FAILED + 1))
        echo ""
        continue
    fi

    # Run the test (passing REPO_ROOT and ENV_FILE)
    if REPO_ROOT="${REPO_ROOT}" bash "${test_dir}/test.sh" "${ENV_FILE}"; then
        PASSED=$((PASSED + 1))
    else
        FAILED=$((FAILED + 1))
    fi

    echo ""
done

# ── Summary ─────────────────────────────────────────────────────────────────
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}  Test Summary${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  Total:  ${BOLD}${TOTAL}${RESET}"
echo -e "  Passed: ${GREEN}${BOLD}${PASSED}${RESET}"
echo -e "  Failed: ${RED}${BOLD}${FAILED}${RESET}"
echo ""

if [ ${FAILED} -eq 0 ]; then
    echo -e "${GREEN}${CHECK}${RESET} ${BOLD}All tests passed!${RESET}"
    echo ""
    echo -e "${DIM}Note: Manual verification still required for some criteria.${RESET}"
    echo -e "${DIM}See individual test output and expected-criteria.md files.${RESET}"
    exit 0
else
    echo -e "${RED}${CROSS}${RESET} ${BOLD}${FAILED} test(s) failed${RESET}"
    echo ""
    echo -e "${DIM}Review individual test output above for details.${RESET}"
    exit 1
fi
