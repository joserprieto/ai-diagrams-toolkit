# ===============================================================================
# AI Diagrams Toolkit - Makefile
# ===============================================================================
# Professional Makefile with semantic targets and colored output
#
# Usage:
#   make <target>
#
# Examples:
#   make help     # Show all available targets
#   make clean    # Clean temporary files
#   make release  # Create new release
# ===============================================================================

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Core Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Makefile metadata (version from .semver - single source of truth)
VERSION := $(shell cat .semver 2>/dev/null | head -n1 | tr -d '\n' || echo "0.0.0")
MAKEFILE_VERSION := $(VERSION)
MAKEFILE_DATE := 2025-11-06
MAKEFILE_AUTHOR := Jose R. Prieto
PROJECT_NAME := AI Diagrams Toolkit
PROJECT_SHORT := AI Diagrams

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --no-print-directory

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
	@echo "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@echo "$(BOLD)$(BLUE)  $(1)$(RESET)"
	@echo "$(BOLD)$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
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
# Dependency Checks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: check/deps
check/deps: ## Check all system dependencies
	$(call print_header,Checking Dependencies)
	@MISSING=0; \
	\
	if command -v git >/dev/null 2>&1; then \
		$(call print_success,Git installed); \
	else \
		$(call print_error,Git NOT installed); \
		echo "  $(YELLOW)→$(RESET) Install: https://git-scm.com"; \
		MISSING=$$((MISSING + 1)); \
	fi; \
	\
	echo ""; \
	if [ $$MISSING -eq 0 ]; then \
		$(call print_success,All required dependencies installed!); \
	else \
		$(call print_error,$$MISSING required dependencies missing); \
		echo ""; \
		echo "$(BOLD)Install missing dependencies and run 'make check/deps' again$(RESET)"; \
		exit 1; \
	fi

.PHONY: check/node
check/node: ## Check Node.js availability (optional for versioning)
	@if command -v node >/dev/null 2>&1; then \
		$(call print_success,Node.js installed - versioning available); \
		NODE_VERSION=$$(node --version); \
		echo "  $(DIM)Version: $$NODE_VERSION$(RESET)"; \
	else \
		$(call print_warning,Node.js NOT installed - versioning unavailable); \
		echo "  $(YELLOW)→$(RESET) Optional: Install Node.js for 'make release'"; \
	fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Versioning Commands (Conditional)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Check for Node.js and versioning tool
CLI_NODE := $(shell command -v node 2>/dev/null)
CLI_NPX := $(shell command -v npx 2>/dev/null)
CLI_COMMIT_AND_TAG_VERSION := $(shell command -v commit-and-tag-version 2>/dev/null)

# Set versioning command based on available tools
ifdef CLI_COMMIT_AND_TAG_VERSION
    COMMIT_AND_TAG_VERSION_CMD := commit-and-tag-version
else ifdef CLI_NPX
    COMMIT_AND_TAG_VERSION_CMD := npx commit-and-tag-version
else
    COMMIT_AND_TAG_VERSION_CMD :=
endif

.PHONY: release
release: ## Create new release based on conventional commits
	@if [ -z "$(COMMIT_AND_TAG_VERSION_CMD)" ]; then \
		$(call print_error,commit-and-tag-version not found); \
		$(call print_warning,Node.js or npx required for automated releases); \
		echo "  $(YELLOW)→$(RESET) Install: npm install -g commit-and-tag-version"; \
		echo ""; \
		$(call print_info,Alternative: Manual tagging with git tag); \
		exit 1; \
	fi
	$(call print_header,Creating Release)
	@$(COMMIT_AND_TAG_VERSION_CMD)
	$(call print_success,Release created!)
	@echo ""
	$(call print_info,Run 'git push --follow-tags' to publish)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Cleanup Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: clean
clean: ## Clean temporary files
	$(call print_header,Cleaning Up)
	@find . -name ".DS_Store" -type f -delete 2>/dev/null || true
	@find . -name "*.tmp" -type f -delete 2>/dev/null || true
	@find . -name "*.temp" -type f -delete 2>/dev/null || true
	$(call print_success,Cleanup complete!)

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Testing Commands (v0.1.0+)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: test/makefile
test/makefile: ## Test Makefile targets (automated)
	@bash tests/makefile/test-targets.sh

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Help Command
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: help
help: ## Show this help message
	@echo "$(BOLD)$(BLUE)╔══════════════════════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOLD)$(BLUE)║     $(PROJECT_NAME) - Makefile v$(VERSION)                  ║$(RESET)"
	@echo "$(BOLD)$(BLUE)╚══════════════════════════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(BOLD)About:$(RESET)"
	@echo "  Version: $(GREEN)$(MAKEFILE_VERSION)$(RESET)"
	@echo "  Date: $(DIM)$(MAKEFILE_DATE)$(RESET)"
	@echo ""
	@echo "$(BOLD)Available Commands:$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)Examples:$(RESET)"
	@echo "  $(DIM)make help$(RESET)           # Show this help"
	@echo "  $(DIM)make clean$(RESET)          # Clean temporary files"
	@echo "  $(DIM)make check/deps$(RESET)     # Check dependencies"
	@echo "  $(DIM)make test/makefile$(RESET)  # Test Makefile targets"
	@echo ""
