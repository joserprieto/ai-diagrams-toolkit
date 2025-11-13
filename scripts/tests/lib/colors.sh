#!/bin/bash
##
## @file colors.sh
## @brief Color definitions for test output
## @description
##   Defines ANSI color codes and symbols for consistent test output
##   formatting across all test scripts.
##
## @example
##   source "${REPO_ROOT}/scripts/tests/lib/colors.sh"
##   echo -e "${tests__colors__GREEN}Success${tests__colors__RESET}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__colors__LOADED:-}" ]]; then
  return 0
fi
readonly tests__colors__LOADED=1

# Namespace for this library
readonly tests__colors__NAMESPACE="tests::colors"

# ANSI Color Codes
readonly tests__colors__RED='\033[0;31m'
readonly tests__colors__GREEN='\033[0;32m'
readonly tests__colors__CYAN='\033[0;36m'
readonly tests__colors__YELLOW='\033[1;33m'
readonly tests__colors__BOLD='\033[1m'
readonly tests__colors__DIM='\033[2m'
readonly tests__colors__RESET='\033[0m'

# Symbols
readonly tests__colors__CHECK='✓'
readonly tests__colors__CROSS='✗'
readonly tests__colors__INFO='ℹ'
