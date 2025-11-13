#!/usr/bin/env bash
##
## @file test-validation.sh
## @brief Tests for Mermaid diagram validation
## @description
##   Unit tests for adt::lib::tests::mermaid::validation module.
##   Verifies Mermaid-specific diagram validation.
##
## @usage
##   bash tests/scripts/lib/mermaid/test-validation.sh
##   make scripts/test/single TEST=mermaid-validation
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
test_mermaid_validation_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__mermaid__validation__LOADED}" \
        "Guard should be set"

    return $?
}

##
## @description Test validate_mermaid_syntax accepts valid diagram
##
test_mermaid_validation_syntax_accepts_valid() {
    source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"

    local valid_diagram="flowchart TD
        A[Start]
        B{Decision}
        C[End]
        A --> B
        B --> C"

    adt::lib::tests::mermaid::validation::validate_mermaid_syntax "$valid_diagram" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "0" \
        "$?" \
        "validate_mermaid_syntax should accept valid Mermaid"

    return $?
}

##
## @description Test validate_mermaid_syntax rejects invalid type
##
test_mermaid_validation_syntax_rejects_invalid() {
    source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"

    local invalid_diagram="A[Start]
        B[End]
        A --> B"

    adt::lib::tests::mermaid::validation::validate_mermaid_syntax "$invalid_diagram" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "1" \
        "$?" \
        "validate_mermaid_syntax should reject missing type"

    return $?
}

##
## @description Test validate_semantic_colors checks classDef
##
test_mermaid_validation_colors_checks_classdef() {
    source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"

    local diagram_with_colors="flowchart TD
        classDef operational fill:#4CAF50
        classDef warning fill:#FFC107
        A[Start]:::operational
        B[Warning]:::warning"

    adt::lib::tests::mermaid::validation::validate_semantic_colors "$diagram_with_colors" >/dev/null 2>&1

    adt::test::framework::assert_equals \
        "0" \
        "$?" \
        "validate_semantic_colors should accept classDef"

    return $?
}

##
## @description Test check_reserved_keywords detects violations
##
test_mermaid_validation_keywords_detects_reserved() {
    source "${REPO_ROOT}/scripts/lib/tests/mermaid/validation.sh"

    local diagram_with_reserved="flowchart TD
        end[Node]
        class[Other]"

    adt::lib::tests::mermaid::validation::check_reserved_keywords "$diagram_with_reserved" >/dev/null 2>&1

    # Should return 1 for violations found
    if [[ $? == 1 ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "check_reserved_keywords should detect violations"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "check_reserved_keywords should detect violations"
        return 1
    fi
}

# Run all tests
echo "Testing: mermaid/validation.sh"
echo ""

test_mermaid_validation_guard_works || true
test_mermaid_validation_syntax_accepts_valid || true
test_mermaid_validation_syntax_rejects_invalid || true
test_mermaid_validation_colors_checks_classdef || true
test_mermaid_validation_keywords_detects_reserved || true

echo ""
adt::test::framework::print_summary
exit $?
