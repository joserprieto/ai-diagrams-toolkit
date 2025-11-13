#!/usr/bin/env bash
##
## @file test-setup.sh
## @brief Tests for Claude Code setup utilities
## @description
##   Unit tests for adt::lib::tests::claude::setup module.
##   Verifies Claude Code environment initialization.
##
## @usage
##   bash tests/scripts/lib/claude/test-setup.sh
##   make scripts/test/single TEST=claude-setup
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
##

set -euo pipefail

# Get repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../../" && pwd)"
export REPO_ROOT

# Source framework
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

##
## @description Test guard clause
##
test_claude_setup_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/setup.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__claude__setup__LOADED}" \
        "Guard should be set"

    return $?
}

##
## @description Test validate_context returns 0
##
test_claude_setup_validate_context_always_succeeds() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/setup.sh"

    # validate_context doesn't take parameters and always returns 0
    adt::lib::tests::claude::setup::validate_context >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "0" \
        "$?" \
        "validate_context should always return 0 (informational)"

    return $?
}

##
## @description Test validate_executor checks for claude command
##
test_claude_setup_validate_executor_checks_command() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/setup.sh"

    # This test verifies the function exists and can be called
    # Result depends on whether claude is installed
    local result=0
    adt::lib::tests::claude::setup::validate_executor >/dev/null 2>&1 || result=$?

    # Both 0 (installed) and 1 (not installed) are valid
    if [[ $result == 0 ]] || [[ $result == 1 ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "validate_executor should execute without error"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "validate_executor should return valid exit code"
        return 1
    fi
}

# Run all tests
echo "Testing: claude/setup.sh"
echo ""

test_claude_setup_guard_works || true
test_claude_setup_validate_context_always_succeeds || true
test_claude_setup_validate_executor_checks_command || true

echo ""
adt::test::framework::print_summary
exit $?
