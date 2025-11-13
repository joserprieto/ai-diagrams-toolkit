#!/bin/bash
##
## @file claude/setup.sh
## @brief Claude CLI specific setup functions
## @description
##   Provides Claude CLI specific setup functions:
##   - CLAUDE.md existence validation
##   - AI_CLI_EXECUTOR validation
##
## @example
##   source "${REPO_ROOT}/scripts/tests/lib/claude/setup.sh"
##   tests::setup::claude::validate_context
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${tests__setup__claude__LOADED:-}" ]]; then
  return 0
fi
readonly tests__setup__claude__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../colors.sh"

# Namespace for this library
readonly tests__setup__claude__NAMESPACE="tests::setup::claude"

##
## @description Validates that CLAUDE.md exists in repository root
## @noargs
## @return 0 if exists, exits with 1 if not found
## @exitcode 1 if CLAUDE.md not found
##
tests::setup::claude::validate_context() {
  if [[ ! -f "${REPO_ROOT}/CLAUDE.md" ]]; then
    echo "❌ ERROR: CLAUDE.md not found in ${REPO_ROOT}"
    echo ""
    echo "Claude CLI requires CLAUDE.md to load AI agent context."
    echo ""
    echo "To fix:"
    echo "  cd ${REPO_ROOT}"
    echo "  ln -s .ai/AGENTS.md CLAUDE.md"
    exit 1
  fi
}

##
## @description Validates AI_CLI_EXECUTOR variable and executable
## @param $1 Path to .env file (for error messages)
## @noargs
## @return 0 if valid, exits with 1 if invalid
## @exitcode 1 if AI_CLI_EXECUTOR not defined or not executable
##
tests::setup::claude::validate_executor() {
  local env_file="$1"

  if [[ -z "${AI_CLI_EXECUTOR:-}" ]]; then
    echo "❌ ERROR: AI_CLI_EXECUTOR not defined in ${env_file}"
    exit 1
  fi

  if [[ ! -x "${AI_CLI_EXECUTOR}" ]]; then
    echo "❌ ERROR: AI_CLI_EXECUTOR is not executable: ${AI_CLI_EXECUTOR}"
    exit 1
  fi
}
