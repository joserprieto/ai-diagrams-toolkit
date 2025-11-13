#!/usr/bin/env bash
##
## @file setup.sh
## @brief Test setup and initialization functions
## @description
##   Provides functions for test environment setup, including:
##   - REPO_ROOT validation
##   - CLAUDE.md existence check
##   - Environment file loading
##   - Required variable validation
##   - Output directory creation
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/setup.sh"
##   adt::lib::tests::setup::validate_repo_root
##   adt::lib::tests::setup::load_env "${ENV_FILE}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
## @namespace adt::lib::tests::setup
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__tests__setup__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__setup__LOADED=1

# Import colors
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

##
## @description Validates that REPO_ROOT environment variable is set
## @noargs
## @return 0 if valid, exits with 1 if invalid
## @exitcode 1 if REPO_ROOT is not set
##
adt::lib::tests::setup::validate_repo_root() {
  if [[ -z "${REPO_ROOT:-}" ]]; then
    echo "❌ ERROR: REPO_ROOT not set"
    echo ""
    echo "This test must be executed via run-all.sh with proper context."
    echo ""
    echo "Use: make test/commands"
    exit 1
  fi
}

##
## @description Loads environment variables from .env file
## @param $1 Path to .env file
## @return 0 on success, exits with 1 on failure
## @exitcode 1 if .env file not found or invalid
##
adt::lib::tests::setup::load_env() {
  local env_file="$1"

  if [[ -z "${env_file}" ]] || [[ ! -f "${env_file}" ]]; then
    echo "❌ ERROR: .env file not provided or not found"
    echo "Expected: ${env_file}"
    exit 1
  fi

  # Load environment variables in current scope
  set -a
  # shellcheck source=/dev/null
  source "${env_file}"
  set +a
}

##
## @description Validates that JQ environment variable is defined
## @param $1 Path to .env file (for error messages)
## @return 0 if valid, exits with 1 if variable missing
## @exitcode 1 if required variable not defined
##
adt::lib::tests::setup::validate_required_vars() {
  local env_file="$1"

  : "${JQ:?ERROR: JQ not defined in ${env_file}}"
}

##
## @description Creates output directory for test results
## @param $1 Output directory path
## @return 0 on success
##
adt::lib::tests::setup::create_output_dir() {
  local output_dir="$1"

  mkdir -p "${output_dir}"
}

##
## @description Validates AI CLI specific requirements (delegates to strategy)
## @param $1 Path to .env file
## @return 0 if valid, exits with 1 if invalid
##
adt::lib::tests::setup::validate_ai_cli() {
  local env_file="$1"

  # Delegate to strategy if it exists
  if declare -f adt::lib::tests::setup::${SETUP_STRATEGY}::validate_context >/dev/null 2>&1; then
    adt::lib::tests::setup::${SETUP_STRATEGY}::validate_context
  fi

  if declare -f adt::lib::tests::setup::${SETUP_STRATEGY}::validate_executor >/dev/null 2>&1; then
    adt::lib::tests::setup::${SETUP_STRATEGY}::validate_executor "${env_file}"
  fi
}

##
## @description Complete test setup (all validations + env loading, delegates to strategy)
## @param $1 Path to .env file
## @param $2 Output directory path
## @return 0 on success, exits with 1 on any validation failure
##
adt::lib::tests::setup::initialize() {
  local env_file="$1"
  local output_dir="$2"

  # Default strategy
  : "${SETUP_STRATEGY:=claude}"

  # Load strategy implementation if available
  if [[ -f "${SCRIPT_DIR}/${SETUP_STRATEGY}/setup.sh" ]]; then
    source "${SCRIPT_DIR}/${SETUP_STRATEGY}/setup.sh"
  fi

  adt::lib::tests::setup::validate_repo_root
  adt::lib::tests::setup::validate_ai_cli "${env_file}"
  adt::lib::tests::setup::load_env "${env_file}"
  adt::lib::tests::setup::validate_required_vars "${env_file}"
  adt::lib::tests::setup::create_output_dir "${output_dir}"
}
