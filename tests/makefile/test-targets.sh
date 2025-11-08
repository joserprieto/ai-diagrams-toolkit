#!/bin/bash
# Automated Makefile targets test
# Tests: help, check/deps, clean

set -euo pipefail

# ── Test Configuration ──────────────────────────────────────────────────────────
EXPECTED_PROJECT="AI Diagrams"
EXPECTED_TARGETS=("check/deps" "clean" "release" "test/makefile")
REQUIRED_DEPS_V01=("git")  # v0.1.0 requires only git

# ── Colors ──────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

# Icons
CHECK='✓'
CROSS='✗'
WARN='⚠'

echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${BOLD}${BLUE}  Testing Makefile Targets${RESET}"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

FAILED=0

# Test 1: make help
echo -n "Test make help... "
HELP_OUT=$(make help 2>&1)
if echo "$HELP_OUT" | grep -q "Diagrams" && echo "$HELP_OUT" | grep -q "Makefile"; then
    echo -e "${GREEN}${CHECK}${RESET} Header found"
else
    echo -e "${RED}${CROSS}${RESET} Header not found"
    echo "Debug: Looking for 'Diagrams' and 'Makefile' in output"
    FAILED=$((FAILED + 1))
fi

# Verify targets listed
echo -n "  Checking targets... "
HELP_OUTPUT=$(make help 2>&1)
ALL_FOUND=true
for target in "${EXPECTED_TARGETS[@]}"; do
    if ! echo "$HELP_OUTPUT" | grep -q "$target"; then
        ALL_FOUND=false
        break
    fi
done

if $ALL_FOUND; then
    echo -e "${GREEN}${CHECK}${RESET} All targets listed"
else
    echo -e "${RED}${CROSS}${RESET} Missing targets"
    FAILED=$((FAILED + 1))
fi

# Test 2: make check/deps
echo -n "Test make check/deps... "
CHECK_OUTPUT=$(make check/deps 2>&1 || true)  # Don't exit on error
if echo "$CHECK_OUTPUT" | grep -q "Checking Dependencies"; then
    # Command ran (success or reported missing)
    if echo "$CHECK_OUTPUT" | grep -q "All required"; then
        echo -e "${GREEN}${CHECK}${RESET} All deps installed"
    elif echo "$CHECK_OUTPUT" | grep -q "missing"; then
        echo -e "${YELLOW}${WARN}${RESET} Reports missing (OK if deps not installed)"
    else
        echo -e "${GREEN}${CHECK}${RESET} Check ran successfully"
    fi
else
    echo -e "${RED}${CROSS}${RESET} Command failed"
    FAILED=$((FAILED + 1))
fi

# Test 3: make clean
echo -n "Test make clean... "
# Create temp files
touch .test-temp.tmp .test-temp.temp
if make clean >/dev/null 2>&1; then
    if [ ! -f .test-temp.tmp ] && [ ! -f .test-temp.temp ]; then
        echo -e "${GREEN}${CHECK}${RESET} Temp files removed"
    else
        echo -e "${RED}${CROSS}${RESET} Files not removed"
        rm -f .test-temp.tmp .test-temp.temp
        FAILED=$((FAILED + 1))
    fi
else
    echo -e "${RED}${CROSS}${RESET} Clean failed"
    rm -f .test-temp.tmp .test-temp.temp
    FAILED=$((FAILED + 1))
fi

# Summary
echo ""
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}${CHECK}${RESET} ${BOLD}All Makefile tests passed!${RESET}"
    exit 0
else
    echo -e "${RED}${CROSS}${RESET} ${BOLD}$FAILED test(s) failed${RESET}"
    exit 1
fi
