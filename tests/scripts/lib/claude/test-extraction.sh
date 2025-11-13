#!/usr/bin/env bash
##
## @file test-extraction.sh
## @brief Tests for Claude Code output extraction
## @description
##   Unit tests for adt::lib::tests::claude::extraction module.
##   Verifies Claude Code output parsing and diagram extraction.
##
## @usage
##   bash tests/scripts/lib/claude/test-extraction.sh
##   make scripts/test/single TEST=claude-extraction
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
test_claude_extraction_guard_works() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/extraction.sh"

    adt::test::framework::assert_equals \
        "1" \
        "${adt__lib__tests__claude__extraction__LOADED}" \
        "Guard should be set"

    return $?
}

##
## @description Test extract_diagram extracts valid diagram
##
test_claude_extraction_extract_diagram_valid() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/extraction.sh"

    local sample_output="Here's a flowchart diagram:

\`\`\`mermaid
flowchart TD
    A[Start]
    B[Process]
    A --> B
\`\`\`

This shows the flow."

    local result=$(adt::lib::tests::claude::extraction::extract_diagram "$sample_output" 2>/dev/null || true)

    if [[ "$result" == *"flowchart"* ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "extract_diagram should find Mermaid code block"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "extract_diagram should find Mermaid code block"
        return 1
    fi
}

##
## @description Test parse_json_output handles valid JSON
##
test_claude_extraction_parse_json_valid() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/extraction.sh"

    local sample_json='{"diagram": "flowchart TD\n  A[Start]\n  B[End]", "status": "success"}'

    local result=$(adt::lib::tests::claude::extraction::parse_json_output "$sample_json" "diagram" 2>/dev/null || true)

    if [[ "$result" == *"flowchart"* ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "parse_json_output should extract field from JSON"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "parse_json_output should extract field from JSON"
        return 1
    fi
}

##
## @description Test parse_json_output rejects invalid JSON
##
test_claude_extraction_parse_json_invalid() {
    source "${REPO_ROOT}/scripts/lib/tests/claude/extraction.sh"

    local invalid_json='{"diagram": "incomplete'

    adt::lib::tests::claude::extraction::parse_json_output "$invalid_json" "diagram" >/dev/null 2>&1

    # Should fail on invalid JSON
    local exit_code=$?

    if [[ $exit_code != 0 ]]; then
        adt::test::framework::assert_equals \
            "0" \
            "0" \
            "parse_json_output should reject invalid JSON"
        return 0
    else
        adt::test::framework::assert_equals \
            "1" \
            "0" \
            "parse_json_output should reject invalid JSON"
        return 1
    fi
}

# Run all tests
echo "Testing: claude/extraction.sh"
echo ""

test_claude_extraction_guard_works || true
test_claude_extraction_extract_diagram_valid || true
test_claude_extraction_parse_json_valid || true
test_claude_extraction_parse_json_invalid || true

echo ""
adt::test::framework::print_summary
exit $?
