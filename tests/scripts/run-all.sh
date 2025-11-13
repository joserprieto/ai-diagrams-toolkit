#!/usr/bin/env bash
##
## @file run-all.sh
## @brief Execute all script tests
## @description
##   Discovers and runs all test files in tests/scripts/ directory.
##   Tests are executed in order: lib/ tests first, then bin/ tests.
##
##   Exit code reflects overall test success:
##   - 0: All tests passed
##   - 1: One or more tests failed
##
## @usage
##   bash tests/scripts/run-all.sh
##   make scripts/test
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Calculate repo root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
export REPO_ROOT

# Counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Print functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_test_file() {
    echo -e "${BLUE}→ Running:${NC} $(basename "$1")"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Run single test file
run_test_file() {
    local test_file="$1"
    local test_name
    test_name="$(basename "$test_file")"

    print_test_file "$test_file"

    ((TESTS_RUN++))

    if bash "$test_file"; then
        ((TESTS_PASSED++))
        print_success "$test_name passed"
        echo ""
        return 0
    else
        ((TESTS_FAILED++))
        print_error "$test_name failed"
        echo ""
        return 1
    fi
}

# Main execution
main() {
    print_header "Script Tests - AI Diagrams Toolkit"

    # Run lib/ tests first (foundational)
    if compgen -G "${SCRIPT_DIR}/lib/test-*.sh" > /dev/null; then
        echo -e "${BLUE}📚 Library Tests${NC}"
        echo ""
        for test_file in "${SCRIPT_DIR}/lib/test-"*.sh; do
            [[ -f "$test_file" ]] || continue
            run_test_file "$test_file"
        done
    else
        echo -e "${YELLOW}⚠${NC} No library tests found (tests/scripts/lib/test-*.sh)"
        echo ""
    fi

    # Run bin/ tests (executables)
    if compgen -G "${SCRIPT_DIR}/bin/test-*.sh" > /dev/null; then
        echo -e "${BLUE}🔧 Executable Tests${NC}"
        echo ""
        for test_file in "${SCRIPT_DIR}/bin/test-"*.sh; do
            [[ -f "$test_file" ]] || continue
            run_test_file "$test_file"
        done
    else
        echo -e "${YELLOW}⚠${NC} No executable tests found (tests/scripts/bin/test-*.sh)"
        echo ""
    fi

    # Print summary
    print_header "Overall Summary"

    echo "  Tests run:    $TESTS_RUN"
    echo -e "  Tests passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "  Tests failed: ${RED}$TESTS_FAILED${NC}"
    echo ""

    if [[ $TESTS_FAILED -eq 0 ]] && [[ $TESTS_RUN -gt 0 ]]; then
        echo -e "${GREEN}✓ All script tests passed!${NC}"
        echo ""
        return 0
    elif [[ $TESTS_RUN -eq 0 ]]; then
        echo -e "${YELLOW}⚠ No tests found${NC}"
        echo ""
        return 1
    else
        echo -e "${RED}✗ Some script tests failed${NC}"
        echo ""
        return 1
    fi
}

# Execute main
main "$@"
