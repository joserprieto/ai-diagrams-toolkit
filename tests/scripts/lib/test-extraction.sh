#!/usr/bin/env bash
##
## @file test-extraction.sh
## @brief Tests for extraction.sh library
## @description
##   Unit tests for adt::lib::tests::extraction module.
##   Verifies diagram element extraction functions.
##
## @usage
##   bash tests/scripts/lib/test-extraction.sh
##   make scripts/test/single TEST=test-extraction
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
test_extraction_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__extraction__LOADED}" \
        "Guard variable should be set to 1"

    return $?
}

##
## @description Test extract_nodes extracts valid nodes
##
test_extraction_extract_nodes_finds_nodes() {
    source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"

    local diagram="flowchart TD
        A[Start]
        B[Process]
        C[End]"

    local node_count=$(adt::lib::tests::extraction::extract_nodes "$diagram" | grep -c . || echo 0)

    adt::test::framework::assert_equals \
        "3" \
        "$node_count" \
        "Should extract 3 nodes from diagram"

    return $?
}

##
## @description Test extract_connections finds arrows
##
test_extraction_extract_connections_finds_arrows() {
    source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"

    local diagram="flowchart TD
        A[Start]
        B[Process]
        C[End]
        A --> B
        B --> C"

    local connection_count=$(adt::lib::tests::extraction::extract_connections "$diagram" | grep -c . || echo 0)

    adt::test::framework::assert_equals \
        "2" \
        "$connection_count" \
        "Should extract 2 connections from diagram"

    return $?
}

##
## @description Test count_nodes returns correct count
##
test_extraction_count_nodes_accurate() {
    source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"

    local diagram="flowchart TD
        A[Start]
        B[Process]
        C[Decision]
        D[End]"

    local count=$(adt::lib::tests::extraction::count_nodes "$diagram" | tr -d ' ')

    adt::test::framework::assert_equals \
        "4" \
        "$count" \
        "Should count 4 nodes correctly"

    return $?
}

##
## @description Test count_connections returns correct count
##
test_extraction_count_connections_accurate() {
    source "${REPO_ROOT}/scripts/lib/tests/extraction.sh"

    local diagram="flowchart TD
        A[Start]
        B[Step1]
        C[Step2]
        D[End]
        A --> B
        B --> C
        C --> D"

    local count=$(adt::lib::tests::extraction::count_connections "$diagram" | tr -d ' ')

    adt::test::framework::assert_equals \
        "3" \
        "$count" \
        "Should count 3 connections correctly"

    return $?
}

# Run all tests
echo "Testing: extraction.sh"
echo ""

# Run tests (don't exit on failure, collect results)
test_extraction_guard_works || true
test_extraction_extract_nodes_finds_nodes || true
test_extraction_extract_connections_finds_arrows || true
test_extraction_count_nodes_accurate || true
test_extraction_count_connections_accurate || true

# Print summary and exit with appropriate code
echo ""
adt::test::framework::print_summary
exit $?
