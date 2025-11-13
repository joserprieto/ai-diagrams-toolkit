#!/usr/bin/env bash
##
## @file test-framework.sh
## @brief Minimal testing framework for shell scripts
## @description
##   Provides basic assertion functions for testing shell scripts.
##   Follows TDD approach with simple, readable assertions.
##
##   Features:
##   - Basic assertions (equals, success, fail)
##   - File and function existence checks
##   - Test counter tracking
##   - Summary reporting
##
## @example
##   source tests/scripts/lib/test-framework.sh
##
##   test_my_function() {
##       local result=$(my_function "input")
##       adt::test::framework::assert_equals "expected" "$result" "Test description"
##       return $?
##   }
##
##   test_my_function
##   adt::test::framework::print_summary
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
## @namespace adt::test::framework
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__test__framework__LOADED:-}" ]]; then
  return 0
fi
readonly adt__test__framework__LOADED=1

# Test counters (globals)
adt__test__framework__PASSED=0
adt__test__framework__FAILED=0
adt__test__framework__TOTAL=0

# Colors (inline definitions to avoid dependency)
readonly adt__test__framework__RED='\033[0;31m'
readonly adt__test__framework__GREEN='\033[0;32m'
readonly adt__test__framework__YELLOW='\033[1;33m'
readonly adt__test__framework__NC='\033[0m'

##
## @description Assert two values are equal (string comparison)
## @param $1 Expected value
## @param $2 Actual value
## @param $3 Test description (optional, default: "Assertion failed")
## @return 0 if equal, 1 if not equal
## @exitcode 0 Values are equal (test passed)
## @exitcode 1 Values are not equal (test failed)
## @example
##   adt::test::framework::assert_equals "expected" "$actual" "Values should match"
##
adt::test::framework::assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"

    ((adt__test__framework__TOTAL++))

    if [[ "$expected" != "$actual" ]]; then
        echo -e "${adt__test__framework__RED}❌ FAIL${adt__test__framework__NC}: $message"
        echo "   Expected: '$expected'"
        echo "   Got:      '$actual'"
        ((adt__test__framework__FAILED++))
        return 1
    fi

    echo -e "${adt__test__framework__GREEN}✓ PASS${adt__test__framework__NC}: $message"
    ((adt__test__framework__PASSED++))
    return 0
}

##
## @description Assert command succeeds (exit code 0)
## @param $1 Command to execute (as string)
## @param $2 Test description (optional, default: "Command should succeed")
## @return 0 if command succeeds, 1 if command fails
## @exitcode 0 Command succeeded (test passed)
## @exitcode 1 Command failed (test failed)
## @example
##   adt::test::framework::assert_success "ls /tmp" "ls should succeed"
##
adt::test::framework::assert_success() {
    local command="$1"
    local message="${2:-Command should succeed}"

    ((adt__test__framework__TOTAL++))

    if ! eval "$command" >/dev/null 2>&1; then
        echo -e "${adt__test__framework__RED}❌ FAIL${adt__test__framework__NC}: $message"
        echo "   Command: $command"
        ((adt__test__framework__FAILED++))
        return 1
    fi

    echo -e "${adt__test__framework__GREEN}✓ PASS${adt__test__framework__NC}: $message"
    ((adt__test__framework__PASSED++))
    return 0
}

##
## @description Assert command fails (exit code != 0)
## @param $1 Command to execute (as string)
## @param $2 Test description (optional, default: "Command should fail")
## @return 0 if command fails (test passed), 1 if command succeeds (test failed)
## @exitcode 0 Command failed as expected (test passed)
## @exitcode 1 Command succeeded unexpectedly (test failed)
## @example
##   adt::test::framework::assert_fail "ls /nonexistent" "ls should fail for bad path"
##
adt::test::framework::assert_fail() {
    local command="$1"
    local message="${2:-Command should fail}"

    ((adt__test__framework__TOTAL++))

    if eval "$command" >/dev/null 2>&1; then
        echo -e "${adt__test__framework__RED}❌ FAIL${adt__test__framework__NC}: $message"
        echo "   Command: $command (should have failed but succeeded)"
        ((adt__test__framework__FAILED++))
        return 1
    fi

    echo -e "${adt__test__framework__GREEN}✓ PASS${adt__test__framework__NC}: $message"
    ((adt__test__framework__PASSED++))
    return 0
}

##
## @description Assert file exists at given path
## @param $1 File path to check
## @param $2 Test description (optional, default: "File should exist")
## @return 0 if file exists, 1 if not
## @exitcode 0 File exists (test passed)
## @exitcode 1 File not found (test failed)
## @example
##   adt::test::framework::assert_file_exists "/path/to/file" "Config file should exist"
##
adt::test::framework::assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist}"

    ((adt__test__framework__TOTAL++))

    if [[ ! -f "$file" ]]; then
        echo -e "${adt__test__framework__RED}❌ FAIL${adt__test__framework__NC}: $message"
        echo "   File not found: $file"
        ((adt__test__framework__FAILED++))
        return 1
    fi

    echo -e "${adt__test__framework__GREEN}✓ PASS${adt__test__framework__NC}: $message"
    ((adt__test__framework__PASSED++))
    return 0
}

##
## @description Assert function exists (is defined)
## @param $1 Function name to check
## @param $2 Test description (optional, default: "Function should exist")
## @return 0 if function exists, 1 if not
## @exitcode 0 Function exists (test passed)
## @exitcode 1 Function not found (test failed)
## @example
##   adt::test::framework::assert_function_exists "my_function" "Function should be defined"
##
adt::test::framework::assert_function_exists() {
    local function_name="$1"
    local message="${2:-Function should exist}"

    ((adt__test__framework__TOTAL++))

    if ! type "$function_name" >/dev/null 2>&1; then
        echo -e "${adt__test__framework__RED}❌ FAIL${adt__test__framework__NC}: $message"
        echo "   Function not found: $function_name"
        ((adt__test__framework__FAILED++))
        return 1
    fi

    echo -e "${adt__test__framework__GREEN}✓ PASS${adt__test__framework__NC}: $message"
    ((adt__test__framework__PASSED++))
    return 0
}

##
## @description Print test summary with results
## @noargs
## @return 0 if all tests passed, 1 if any failed
## @exitcode 0 All tests passed
## @exitcode 1 One or more tests failed
## @example
##   # At end of test file
##   adt::test::framework::print_summary
##   exit $?
##
adt::test::framework::print_summary() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Test Summary"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  Total:  $adt__test__framework__TOTAL"
    echo -e "  Passed: ${adt__test__framework__GREEN}$adt__test__framework__PASSED${adt__test__framework__NC}"
    echo -e "  Failed: ${adt__test__framework__RED}$adt__test__framework__FAILED${adt__test__framework__NC}"
    echo ""

    if [[ $adt__test__framework__FAILED -eq 0 ]]; then
        echo -e "${adt__test__framework__GREEN}✓ All tests passed!${adt__test__framework__NC}"
        return 0
    else
        echo -e "${adt__test__framework__RED}✗ Some tests failed${adt__test__framework__NC}"
        return 1
    fi
}

##
## @description Reset test counters (useful for multiple test files)
## @noargs
## @return 0 always
##
adt::test::framework::reset_counters() {
    adt__test__framework__PASSED=0
    adt__test__framework__FAILED=0
    adt__test__framework__TOTAL=0
    return 0
}
