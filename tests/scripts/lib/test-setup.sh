#!/usr/bin/env bash
##
## @file test-setup.sh
## @brief Tests for setup.sh library
## @description
##   Unit tests for adt::lib::tests::setup module.
##   Verifies test initialization functions and environment validation.
##
## @usage
##   bash tests/scripts/lib/test-setup.sh
##   make scripts/test/single TEST=test-setup
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
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
test_setup_guard_works() {
    # First source - should set guard
    source "${REPO_ROOT}/scripts/lib/tests/setup.sh"

    # Check guard variable is set
    if [[ -z "${adt__lib__tests__setup__LOADED:-}" ]]; then
        echo "❌ Guard variable not set after first source"
        return 1
    fi

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__setup__LOADED}" \
        "Guard variable should be set to 1"

    return $?
}

##
## @description Test validate_repo_root function exists
##
test_setup_validate_repo_root_exists() {
    source "${REPO_ROOT}/scripts/lib/tests/setup.sh"

    adt::test::framework::assert_function_exists \
        "adt::lib::tests::setup::validate_repo_root" \
        "validate_repo_root function should exist"

    return $?
}

##
## @description Test validate_repo_root succeeds with valid REPO_ROOT
##
test_setup_validate_repo_root_success() {
    source "${REPO_ROOT}/scripts/lib/tests/setup.sh"

    # REPO_ROOT is already set and valid
    adt::test::framework::assert_success \
        "adt::lib::tests::setup::validate_repo_root" \
        "validate_repo_root should succeed with valid REPO_ROOT"

    return $?
}

##
## @description Test load_env function exists
##
test_setup_load_env_exists() {
    source "${REPO_ROOT}/scripts/lib/tests/setup.sh"

    adt::test::framework::assert_function_exists \
        "adt::lib::tests::setup::load_env" \
        "load_env function should exist"

    return $?
}

# Run all tests
echo "Testing: setup.sh"
echo ""

# Run tests (don't exit on failure, collect results)
test_setup_guard_works || true
test_setup_validate_repo_root_exists || true
test_setup_validate_repo_root_success || true
test_setup_load_env_exists || true

# Print summary and exit with appropriate code
echo ""
adt::test::framework::print_summary
exit $?
