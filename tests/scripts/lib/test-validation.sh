#!/usr/bin/env bash
##
## @file test-validation.sh
## @brief Tests for validation.sh library
## @description
##   Unit tests for adt::lib::tests::validation module.
##   Verifies diagram validation and convention checking functions.
##
## @usage
##   bash tests/scripts/lib/test-validation.sh
##   make scripts/test/single TEST=test-validation
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
##

set -euo pipefail

# Get repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
export REPO_ROOT

# Source framework
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

##
## @description Test guard clause prevents double sourcing
##
test_validation_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/validation.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__validation__LOADED}" \
        "Guard variable should be set to 1"

    return $?
}

##
## @description Test validate_syntax accepts valid Mermaid diagram
##
test_validation_syntax_accepts_valid_diagram() {
    source "${REPO_ROOT}/scripts/lib/tests/validation.sh"

    local valid_diagram="flowchart TD
        A[Start]
        B[Process]
        C[End]
        A --> B --> C"

    adt::lib::tests::validation::validate_syntax "$valid_diagram" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "0" \
        "$?" \
        "Should accept valid flowchart diagram"

    return $?
}

##
## @description Test validate_syntax rejects empty diagram
##
test_validation_syntax_rejects_empty() {
    source "${REPO_ROOT}/scripts/lib/tests/validation.sh"

    adt::lib::tests::validation::validate_syntax "" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "1" \
        "$?" \
        "Should reject empty diagram"

    return $?
}

##
## @description Test validate_syntax rejects missing diagram type
##
test_validation_syntax_rejects_missing_type() {
    source "${REPO_ROOT}/scripts/lib/tests/validation.sh"

    local invalid_diagram="A[Start]
        B[End]
        A --> B"

    adt::lib::tests::validation::validate_syntax "$invalid_diagram" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "1" \
        "$?" \
        "Should reject diagram without type declaration"

    return $?
}

##
## @description Test validate_conventions accepts English diagram
##
test_validation_conventions_accepts_english() {
    source "${REPO_ROOT}/scripts/lib/tests/validation.sh"

    local english_diagram="flowchart TD
        %% This is an English comment
        A[Start]
        B[Process]
        A --> B"

    adt::lib::tests::validation::validate_conventions "$english_diagram" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "0" \
        "$?" \
        "Should accept English comments"

    return $?
}

# Run all tests
echo "Testing: validation.sh"
echo ""

# Run tests (don't exit on failure, collect results)
test_validation_guard_works || true
test_validation_syntax_accepts_valid_diagram || true
test_validation_syntax_rejects_empty || true
test_validation_syntax_rejects_missing_type || true
test_validation_conventions_accepts_english || true

# Print summary and exit with appropriate code
echo ""
adt::test::framework::print_summary
exit $?
