#!/usr/bin/env bash
##
## @file colors.sh
## @brief Color definitions for test output
## @description
##   Defines ANSI color codes and symbols for consistent test output
##   formatting across all test scripts and utilities.
##
##   Provides readonly color variables (RED, GREEN, YELLOW, BLUE, etc.)
##   and symbols (CHECK, CROSS, INFO, WARN) for visual feedback.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/colors.sh"
##   echo -e "${adt__lib__tests__colors__GREEN}Success${adt__lib__tests__colors__NC}"
##   echo -e "${adt__lib__tests__colors__CHECK} Operation complete"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
## @namespace adt::lib::tests::colors
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__colors__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__colors__LOADED=1

# ANSI Color Codes
readonly adt__lib__tests__colors__RED='\033[0;31m'
readonly adt__lib__tests__colors__GREEN='\033[0;32m'
readonly adt__lib__tests__colors__CYAN='\033[0;36m'
readonly adt__lib__tests__colors__YELLOW='\033[1;33m'
readonly adt__lib__tests__colors__BLUE='\033[0;34m'
readonly adt__lib__tests__colors__BOLD='\033[1m'
readonly adt__lib__tests__colors__DIM='\033[2m'
readonly adt__lib__tests__colors__RESET='\033[0m'
readonly adt__lib__tests__colors__NC='\033[0m'  # Alias for RESET

# Symbols
readonly adt__lib__tests__colors__CHECK='✓'
readonly adt__lib__tests__colors__CROSS='✗'
readonly adt__lib__tests__colors__INFO='ℹ'
readonly adt__lib__tests__colors__WARN='⚠'
