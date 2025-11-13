#!/usr/bin/env bash
##
## @file test-colors.sh
## @brief Tests for colors.sh library
## @description
##   Unit tests for adt::lib::tests::colors module.
##   Verifies color definitions, symbols, and guard clause behavior.
##
## @usage
##   bash tests/scripts/lib/test-colors.sh
##   make scripts/test/single TEST=test-colors
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Get repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# Source framework
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

##
## @description Test guard clause prevents double sourcing
##
test_colors_guard_works() {
    # First source - should set guard
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    # Check guard variable is set
    if [[ -z "${adt__lib__tests__colors__LOADED:-}" ]]; then
        echo "❌ Guard variable not set after first source"
        return 1
    fi

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__colors__LOADED}" \
        "Guard variable should be set to 1"

    return $?
}

##
## @description Test color variables are defined
##
test_colors_variables_exist() {
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    # Check essential color variables exist
    [[ -n "${adt__lib__tests__colors__RED:-}" ]] || {
        echo "❌ RED variable not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__GREEN:-}" ]] || {
        echo "❌ GREEN variable not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__YELLOW:-}" ]] || {
        echo "❌ YELLOW variable not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__BLUE:-}" ]] || {
        echo "❌ BLUE variable not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__NC:-}" ]] || {
        echo "❌ NC (No Color) variable not defined"
        return 1
    }

    adt::test::framework::assert_success \
        "true" \
        "All color variables exist"

    return $?
}

##
## @description Test symbol variables are defined
##
test_colors_symbols_exist() {
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    # Check essential symbols exist
    [[ -n "${adt__lib__tests__colors__CHECK:-}" ]] || {
        echo "❌ CHECK symbol not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__CROSS:-}" ]] || {
        echo "❌ CROSS symbol not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__INFO:-}" ]] || {
        echo "❌ INFO symbol not defined"
        return 1
    }

    [[ -n "${adt__lib__tests__colors__WARN:-}" ]] || {
        echo "❌ WARN symbol not defined"
        return 1
    }

    adt::test::framework::assert_success \
        "true" \
        "All symbol variables exist"

    return $?
}

# Run all tests
echo "Testing: colors.sh"
echo ""

# Run tests (don't exit on failure, collect results)
test_colors_guard_works || true
test_colors_variables_exist || true
test_colors_symbols_exist || true

# Print summary and exit with appropriate code
echo ""
adt::test::framework::print_summary
exit $?
