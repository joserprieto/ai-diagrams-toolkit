#!/usr/bin/env bash
##
## @file test-teardown.sh
## @brief Tests for teardown.sh library
## @description
##   Unit tests for adt::lib::tests::teardown module.
##   Verifies test cleanup and resource management functions.
##
## @usage
##   bash tests/scripts/lib/test-teardown.sh
##   make scripts/test/single TEST=test-teardown
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
test_teardown_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/teardown.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__teardown__LOADED}" \
        "Guard variable should be set to 1"

    return $?
}

##
## @description Test cleanup_output_dir removes directory
##
test_teardown_cleanup_output_dir_removes() {
    source "${REPO_ROOT}/scripts/lib/tests/teardown.sh"

    # Create temp output dir
    local test_dir=$(mktemp -d)
    mkdir -p "${test_dir}/output" 2>/dev/null || true

    adt::lib::tests::teardown::cleanup_output_dir "${test_dir}/output" 2>/dev/null || true

    if [ ! -d "${test_dir}/output" ]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "cleanup_output_dir should remove directory"
        rm -rf "${test_dir}" 2>/dev/null || true
        return 0
    else
        rm -rf "${test_dir}" 2>/dev/null || true
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "cleanup_output_dir should remove directory"
        return 1
    fi
}

##
## @description Test cleanup_temp_files removes temp files
##
test_teardown_cleanup_temp_files_removes() {
    source "${REPO_ROOT}/scripts/lib/tests/teardown.sh"

    # Create temp dir with files
    local test_base=$(mktemp -d)
    local test_dir="${test_base}/temp_test"
    mkdir -p "${test_dir}" 2>/dev/null || true
    touch "${test_dir}/test.tmp" "${test_dir}/test.temp" 2>/dev/null || true

    # Should remove the directory
    adt::lib::tests::teardown::cleanup_temp_files "${test_dir}" 2>/dev/null || true

    # Check if directory was removed
    if [ ! -d "${test_dir}" ]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "cleanup_temp_files should remove directory and temp files"
        rm -rf "${test_base}" 2>/dev/null || true
        return 0
    else
        rm -rf "${test_base}" 2>/dev/null || true
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "cleanup_temp_files should remove directory and temp files"
        return 1
    fi
}

##
## @description Test print_summary outputs text
##
test_teardown_print_summary_outputs() {
    source "${REPO_ROOT}/scripts/lib/tests/teardown.sh"

    local output=$(adt::lib::tests::teardown::print_summary 2>&1 || true)

    if [[ -n "$output" ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "print_summary should produce output"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "print_summary should produce output"
        return 1
    fi
}

# Run all tests
echo "Testing: teardown.sh"
echo ""

# Run tests (don't exit on failure, collect results)
test_teardown_guard_works || true
test_teardown_cleanup_output_dir_removes || true
test_teardown_cleanup_temp_files_removes || true
test_teardown_print_summary_outputs || true

# Print summary and exit with appropriate code
echo ""
adt::test::framework::print_summary
exit $?
