# ===============================================================================
# Scripts - Development Makefile
# ===============================================================================
# Script development, testing, refactoring, and quality automation
#
# This Makefile provides local operations for script development, following
# the same paradigm as the root Makefile but focused on script-specific tasks.
#
# Architecture: Open/Closed Principle
#   - Root Makefile delegates to this Makefile (CLOSED for modification)
#   - This Makefile extends with script-specific targets (OPEN for extension)
#
# Usage:
#   cd scripts/
#   make <target>
#
# From root (delegation):
#   make scripts/<target>
#
# Examples:
#   make tdd/colors          # TDD cycle for colors.sh
#   make test                # Run all script tests
#   make lint                # Lint all scripts
#   make refactor/status     # Show refactoring progress
# ===============================================================================

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Core Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --no-print-directory

# Paths
SCRIPTS_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
REPO_ROOT := $(shell cd $(SCRIPTS_DIR)/.. && pwd)
TESTS_DIR := $(REPO_ROOT)/tests/scripts
LIB_DIR := $(SCRIPTS_DIR)/lib
BIN_DIR := $(SCRIPTS_DIR)/bin

# ── Color Codes ─────────────────────────────────────────────────────────────────
ifneq ($(TERM),)
    RED := $(shell tput setaf 1)
    GREEN := $(shell tput setaf 2)
    YELLOW := $(shell tput setaf 3)
    BLUE := $(shell tput setaf 4)
    MAGENTA := $(shell tput setaf 5)
    CYAN := $(shell tput setaf 6)
    BOLD := $(shell tput bold)
    DIM := $(shell tput dim)
    RESET := $(shell tput sgr0)
else
    RED :=
    GREEN :=
    YELLOW :=
    BLUE :=
    MAGENTA :=
    CYAN :=
    BOLD :=
    DIM :=
    RESET :=
endif

# ── Icons ───────────────────────────────────────────────────────────────────────
CHECK := ✓
CROSS := ✗
INFO := ℹ
WARN := ⚠

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helper Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

define print_header
	@echo ""
	@echo "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BOLD)$(BLUE)  $(1)$(RESET)"
	@echo "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo ""
endef

define print_success
	@echo "$(GREEN)$(CHECK)$(RESET) $(1)"
endef

define print_error
	@echo "$(RED)$(CROSS)$(RESET) $(1)"
endef

define print_warning
	@echo "$(YELLOW)$(WARN)$(RESET) $(1)"
endef

define print_info
	@echo "$(CYAN)$(INFO)$(RESET) $(1)"
endef

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Testing
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: test
test: ## Run all script tests
	$(call print_header,Testing All Scripts)
	@bash $(TESTS_DIR)/run-all.sh

.PHONY: test/single
test/single: ## Run single test: make test/single TEST=test-colors
	@if [ -z "$(TEST)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) TEST variable required"; \
		echo "  $(YELLOW)→$(RESET) Usage: make test/single TEST=test-colors"; \
		exit 1; \
	fi
	@if [ -f "$(TESTS_DIR)/lib/$(TEST).sh" ]; then \
		bash "$(TESTS_DIR)/lib/$(TEST).sh"; \
	elif [ -f "$(TESTS_DIR)/bin/$(TEST).sh" ]; then \
		bash "$(TESTS_DIR)/bin/$(TEST).sh"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) Test not found: $(TEST)"; \
		echo "  $(YELLOW)→$(RESET) Available tests:"; \
		ls -1 $(TESTS_DIR)/lib/test-*.sh $(TESTS_DIR)/bin/test-*.sh 2>/dev/null | xargs -n1 basename | sed 's/^/    /' || echo "    (no tests yet)"; \
		exit 1; \
	fi

.PHONY: test/lib
test/lib: ## Run only library tests
	$(call print_header,Testing Library Scripts)
	@for test in $(TESTS_DIR)/lib/test-*.sh; do \
		[ -f "$$test" ] || continue; \
		echo "$(BLUE)→$(RESET) Running $$(basename $$test)"; \
		bash "$$test" || exit 1; \
		echo ""; \
	done
	$(call print_success,All library tests passed)

.PHONY: test/bin
test/bin: ## Run only executable tests
	$(call print_header,Testing Executable Scripts)
	@for test in $(TESTS_DIR)/bin/test-*.sh; do \
		[ -f "$$test" ] || continue; \
		echo "$(BLUE)→$(RESET) Running $$(basename $$test)"; \
		bash "$$test" || exit 1; \
		echo ""; \
	done
	$(call print_success,All executable tests passed)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# TDD Workflow
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: tdd/colors
tdd/colors: ## TDD cycle for colors.sh
	$(call print_info,Testing colors.sh)
	@bash $(TESTS_DIR)/lib/test-colors.sh

.PHONY: tdd/setup
tdd/setup: ## TDD cycle for setup.sh
	$(call print_info,Testing setup.sh)
	@bash $(TESTS_DIR)/lib/test-setup.sh

.PHONY: tdd/validation
tdd/validation: ## TDD cycle for validation.sh
	$(call print_info,Testing validation.sh)
	@bash $(TESTS_DIR)/lib/test-validation.sh

.PHONY: tdd/extraction
tdd/extraction: ## TDD cycle for extraction.sh
	$(call print_info,Testing extraction.sh)
	@bash $(TESTS_DIR)/lib/test-extraction.sh

.PHONY: tdd/teardown
tdd/teardown: ## TDD cycle for teardown.sh
	$(call print_info,Testing teardown.sh)
	@bash $(TESTS_DIR)/lib/test-teardown.sh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Refactoring Helpers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: refactor/status
refactor/status: ## Show refactoring progress
	@echo "$(BOLD)Refactoring Progress$(RESET)"
	@echo ""
	@echo "$(BOLD)Scripts Refactored:$(RESET)"
	@REFACTORED=$$(find $(LIB_DIR)/tests -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') || REFACTORED=0; \
	echo "  $(GREEN)$$REFACTORED$(RESET) scripts in lib/tests/"
	@echo ""
	@echo "$(BOLD)Scripts Remaining:$(RESET)"
	@REMAINING=$$(find $(SCRIPTS_DIR)/tests/lib -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') || REMAINING=0; \
	echo "  $(YELLOW)$$REMAINING$(RESET) scripts in old location (scripts/tests/lib/)"
	@echo ""
	@echo "$(BOLD)Tests Created:$(RESET)"
	@TESTS=$$(find $(TESTS_DIR)/lib -name "test-*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') || TESTS=0; \
	echo "  $(CYAN)$$TESTS$(RESET) test files"
	@echo ""

.PHONY: refactor/next
refactor/next: ## Show next script to refactor
	@echo "$(BOLD)Next Scripts to Refactor:$(RESET)"
	@echo ""
	@if [ ! -f "$(LIB_DIR)/tests/validation.sh" ]; then \
		echo "  $(YELLOW)1.$(RESET) validation.sh  $(DIM)(run: make tdd/validation)$(RESET)"; \
	fi
	@if [ ! -f "$(LIB_DIR)/tests/extraction.sh" ]; then \
		echo "  $(YELLOW)2.$(RESET) extraction.sh  $(DIM)(run: make tdd/extraction)$(RESET)"; \
	fi
	@if [ ! -f "$(LIB_DIR)/tests/teardown.sh" ]; then \
		echo "  $(YELLOW)3.$(RESET) teardown.sh   $(DIM)(run: make tdd/teardown)$(RESET)"; \
	fi
	@echo ""
	@echo "$(DIM)Follow TDD: Create test (RED) → Refactor script (GREEN) → Clean (REFACTOR)$(RESET)"

.PHONY: refactor/list-old
refactor/list-old: ## List scripts still in old location
	@echo "$(BOLD)Scripts in Old Location:$(RESET)"
	@find ../tests/lib -name "*.sh" -type f 2>/dev/null | sed 's|.*/||' | sed 's/^/  /' || echo "  (none - all migrated!)"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Quality and Linting
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: lint
lint: ## Run shellcheck on all scripts
	$(call print_header,Linting All Scripts)
	@ERRORS=0; \
	for script in $$(find bin lib -name "*.sh" -o -type f -executable 2>/dev/null); do \
		echo "$(BLUE)→$(RESET) Checking $$script"; \
		if shellcheck "$$script" 2>/dev/null; then \
			echo "  $(GREEN)$(CHECK)$(RESET) No issues"; \
		else \
			echo "  $(RED)$(CROSS)$(RESET) Issues found"; \
			ERRORS=$$((ERRORS + 1)); \
		fi; \
		echo ""; \
	done; \
	if [ $$ERRORS -eq 0 ]; then \
		$(call print_success,All scripts passed linting); \
	else \
		$(call print_error,$$ERRORS scripts have linting issues); \
		exit 1; \
	fi

.PHONY: lint/single
lint/single: ## Lint single script: make lint/single SCRIPT=lib/tests/colors.sh
	@if [ -z "$(SCRIPT)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) SCRIPT variable required"; \
		echo "  $(YELLOW)→$(RESET) Usage: make lint/single SCRIPT=lib/tests/colors.sh"; \
		exit 1; \
	fi
	@if [ ! -f "$(SCRIPT)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) Script not found: $(SCRIPT)"; \
		exit 1; \
	fi
	@echo "$(BLUE)$(INFO)$(RESET) Linting $(SCRIPT)"
	@shellcheck "$(SCRIPT)"
	$(call print_success,No issues found)

.PHONY: check/shellcheck
check/shellcheck: ## Check if shellcheck is installed
	@if command -v shellcheck >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) shellcheck installed"; \
		shellcheck --version | head -2; \
	else \
		echo "$(YELLOW)$(WARN)$(RESET) shellcheck NOT installed (optional for linting)"; \
		echo "  $(YELLOW)→$(RESET) Install: brew install shellcheck (macOS) or apt-get install shellcheck (Linux)"; \
	fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Development Info
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: info
info: ## Show scripts directory information
	$(call print_header,Scripts Directory Info)
	@echo "$(BOLD)Paths:$(RESET)"
	@echo "  Scripts: $(CYAN)$(SCRIPTS_DIR)$(RESET)"
	@echo "  Repo:    $(CYAN)$(REPO_ROOT)$(RESET)"
	@echo "  Tests:   $(CYAN)$(TESTS_DIR)$(RESET)"
	@echo ""
	@echo "$(BOLD)Structure:$(RESET)"
	@echo "  bin/:    $$(find bin -type f 2>/dev/null | wc -l | tr -d ' ') executables"
	@echo "  lib/:    $$(find lib -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') libraries"
	@echo ""
	@echo "$(BOLD)Tests:$(RESET)"
	@echo "  Created: $$(find $(TESTS_DIR) -name "test-*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') test files"
	@echo ""

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Help Command
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: help
help: ## Show this help message
	@echo "$(BOLD)$(BLUE)╔══════════════════════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOLD)$(BLUE)║              Scripts - Development Makefile                 ║$(RESET)"
	@echo "$(BOLD)$(BLUE)╚══════════════════════════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(BOLD)About:$(RESET)"
	@echo "  Purpose: Script development and testing operations"
	@echo "  Pattern: Open/Closed Principle (extends without modifying root)"
	@echo ""
	@echo "$(BOLD)Available Commands:$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' Makefile | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-22s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)TDD Workflow:$(RESET)"
	@echo "  $(DIM)make tdd/colors$(RESET)       # Test colors.sh (RED/GREEN/REFACTOR)"
	@echo "  $(DIM)make tdd/setup$(RESET)        # Test setup.sh"
	@echo "  $(DIM)make tdd/validation$(RESET)   # Test validation.sh (next to refactor)"
	@echo ""
	@echo "$(BOLD)Testing:$(RESET)"
	@echo "  $(DIM)make test$(RESET)             # Run all tests"
	@echo "  $(DIM)make test/single TEST=test-colors$(RESET) # Run specific test"
	@echo ""
	@echo "$(BOLD)From Root:$(RESET)"
	@echo "  $(DIM)make scripts/test$(RESET)     # Delegates to this Makefile"
	@echo "  $(DIM)make scripts/tdd/colors$(RESET) # Delegates to this Makefile"
	@echo ""
