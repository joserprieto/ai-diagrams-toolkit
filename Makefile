# ===============================================================================
# AI Diagrams Toolkit - Makefile
# ===============================================================================
# Professional Makefile with externalized configuration and semantic targets
#
# Configuration:
#   - Edit .env.dist for project defaults (versionado)
#   - Copy to .env for local overrides (gitignored)
#   - All tool versions/names are externalized
#
# Usage:
#   make <target>
#
# Examples:
#   make help           # Show all available targets
#   make check/config   # Show current configuration
#   make check/deps     # Check system dependencies
#   make clean          # Clean temporary files
#   make release        # Create new release
# ===============================================================================

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Load Environment Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Try to load .env (user overrides), fallback to .env.dist (defaults)
ifneq (,$(wildcard .env))
    include .env
    ENV_FILE_LOADED := .env
else ifneq (,$(wildcard .env.dist))
    include .env.dist
    ENV_FILE_LOADED := .env.dist
else
    $(error Neither .env nor .env.dist found. Copy .env.dist to .env or restore .env.dist)
endif

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Core Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Makefile metadata (version from .semver - single source of truth)
VERSION := $(shell cat .semver 2>/dev/null | head -n1 | tr -d '\n' || echo "0.0.0")
MAKEFILE_VERSION := $(VERSION)
MAKEFILE_DATE := 2025-11-10
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
# Versioning Configuration (from .env/.env.dist)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# All configuration comes from .env/.env.dist (NO hardcoded values)
NODE_RELEASE_PACKAGE ?= commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION ?= 12.4.4
NODE_RELEASE_CONFIG ?= .versionrc.js
NODE_RELEASE_PACKAGE_NPX_CMD := $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION)

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
# Configuration Validation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: check/config
check/config: ## Show current configuration
	$(call print_header,Configuration)
	@echo "$(BOLD)Environment:$(RESET)"
	@echo "  Loaded from: $(GREEN)$(ENV_FILE_LOADED)$(RESET)"
	@echo ""
	@echo "$(BOLD)Project:$(RESET)"
	@echo "  Name: $(CYAN)$(PROJECT_NAME)$(RESET)"
	@echo "  Version: $(CYAN)$(VERSION)$(RESET)"
	@echo ""
	@echo "$(BOLD)Release Tooling:$(RESET)"
	@echo "  Package: $(CYAN)$(NODE_RELEASE_PACKAGE)$(RESET)"
	@echo "  Version: $(CYAN)$(NODE_RELEASE_PACKAGE_VERSION)$(RESET)"
	@echo "  Config: $(CYAN)$(NODE_RELEASE_CONFIG)$(RESET)"
	@echo "  NPX Command: $(DIM)npx $(NODE_RELEASE_PACKAGE_NPX_CMD)$(RESET)"
	@echo ""
	@if [ -f "$(NODE_RELEASE_CONFIG)" ]; then \
		echo "$(GREEN)$(CHECK)$(RESET) Config file found: $(NODE_RELEASE_CONFIG)"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) Config file NOT found: $(NODE_RELEASE_CONFIG)"; \
		exit 1; \
	fi
	@echo ""
	@if [ -f .env ]; then \
		echo "$(CYAN)$(INFO)$(RESET) Using local .env overrides"; \
	else \
		echo "$(CYAN)$(INFO)$(RESET) Using defaults from .env.dist"; \
		echo "  $(DIM)Tip: Copy .env.dist to .env for local customization$(RESET)"; \
	fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Dependency Checks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: check/deps
check/deps: ## Check all system dependencies
	$(call print_header,Checking Dependencies)
	@MISSING=0; \
	\
	if command -v git >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) Git installed"; \
		GIT_VERSION=$$(git --version | awk '{print $$3}'); \
		echo "  $(DIM)Version: $$GIT_VERSION$(RESET)"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) Git NOT installed"; \
		echo "  $(YELLOW)→$(RESET) Install: https://git-scm.com"; \
		MISSING=$$((MISSING + 1)); \
	fi; \
	\
	if command -v npx >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) npx installed (Node.js detected)"; \
		NPX_VERSION=$$(npx --version); \
		NODE_VERSION=$$(node --version); \
		echo "  $(DIM)npx version: $$NPX_VERSION$(RESET)"; \
		echo "  $(DIM)Node.js version: $$NODE_VERSION$(RESET)"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) npx NOT installed"; \
		echo "  $(YELLOW)→$(RESET) Install Node.js: https://nodejs.org"; \
		MISSING=$$((MISSING + 1)); \
	fi; \
	\
	echo ""; \
	if [ $$MISSING -eq 0 ]; then \
		echo "$(GREEN)$(CHECK)$(RESET) All required dependencies installed!"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) $$MISSING required dependencies missing"; \
		echo ""; \
		echo "$(BOLD)Install missing dependencies and run 'make check/deps' again$(RESET)"; \
		exit 1; \
	fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Versioning Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: release
release: check/config ## Create new release based on conventional commits
	@if ! command -v npx >/dev/null 2>&1; then \
		$(call print_error,npx not found); \
		$(call print_warning,Node.js required for automated releases); \
		echo "  $(YELLOW)→$(RESET) Install Node.js: https://nodejs.org"; \
		echo ""; \
		$(call print_info,Alternative: Manual tagging with git tag); \
		exit 1; \
	fi
	$(call print_header,Creating Release)
	$(call print_info,Using $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION))
	$(call print_info,Config: $(NODE_RELEASE_CONFIG))
	@npx $(NODE_RELEASE_PACKAGE_NPX_CMD)
	$(call print_success,Release created!)
	@echo ""
	$(call print_info,Run 'git push --follow-tags' to publish)

.PHONY: release/patch
release/patch: ## Create patch release (0.0.X)
	$(call print_info,Creating patch release...)
	@npx $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as patch

.PHONY: release/minor
release/minor: ## Create minor release (0.X.0)
	$(call print_info,Creating minor release...)
	@npx $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as minor

.PHONY: release/major
release/major: ## Create major release (X.0.0)
	$(call print_info,Creating major release...)
	@npx $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as major

.PHONY: release/dry-run
release/dry-run: ## Simulate release without making changes
	$(call print_header,Dry Run - Release Simulation)
	$(call print_info,Using $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION))
	@npx $(NODE_RELEASE_PACKAGE_NPX_CMD) --dry-run

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
	@echo "  Config: $(DIM)$(ENV_FILE_LOADED)$(RESET)"
	@echo ""
	@echo "$(BOLD)Available Commands:$(RESET)"
	@echo ""
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)Examples:$(RESET)"
	@echo "  $(DIM)make help$(RESET)           # Show this help"
	@echo "  $(DIM)make check/config$(RESET)   # Show current configuration"
	@echo "  $(DIM)make check/deps$(RESET)     # Check dependencies"
	@echo "  $(DIM)make release$(RESET)        # Create new release"
	@echo "  $(DIM)make release/dry-run$(RESET) # Simulate release"
	@echo ""
