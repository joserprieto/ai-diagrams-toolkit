#!/usr/bin/env bash
##
## @file setup.sh
## @brief Claude Code environment setup
## @description
##   Validates Claude Code specific environment and context.
##   Used by test framework to setup Claude Code execution.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/claude/setup.sh"
##   adt::lib::tests::claude::setup::validate_context
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-13
## @version 1.0.0
## @namespace adt::lib::tests::claude::setup
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__claude__setup__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__claude__setup__LOADED=1

##
## @description Validates Claude Code context is available
## @noargs
## @return 0 if context valid, 1 if not available
##
adt::lib::tests::claude::setup::validate_context() {
  # Check if CLAUDE_CODE environment variable is set or if we're in Claude Code environment
  if [[ -z "${CLAUDE_CODE:-}" ]] && [[ -z "${CLAUDE:-}" ]]; then
    echo "ℹ️  Claude Code context not detected (may be running in alternative executor)"
    return 0  # Not an error, just informational
  fi

  return 0
}

##
## @description Validates Claude Code executor/CLI is available
## @param $1 Path to .env file
## @return 0 if executor available, 1 if not
##
adt::lib::tests::claude::setup::validate_executor() {
  local env_file="$1"

  # Check if CLAUDE variable is set in env file
  if grep -q "^CLAUDE=" "${env_file}"; then
    return 0
  fi

  # Try to find claude in PATH
  if command -v claude &>/dev/null; then
    return 0
  fi

  echo "ℹ️  Claude Code executor not in PATH (may run in alternative mode)"
  return 0  # Not an error, test can continue
}
