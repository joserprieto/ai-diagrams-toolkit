# ===============================================================================
# AI Diagrams Toolkit - Makefile
# ===============================================================================
# Professional Makefile with externalized configuration and semantic targets
#
# Configuration:
#   - Edit .env.example for project defaults (versioned)
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

# Try to load .env (user overrides), fallback to .env.example (defaults)
ifneq (,$(wildcard .env))
    include .env
    ENV_FILE_LOADED := .env
else ifneq (,$(wildcard .env.example))
    include .env.example
    ENV_FILE_LOADED := .env.example
else
    $(error Neither .env nor .env.example found. Copy .env.example to .env or restore .env.example)
endif

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Core Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Makefile metadata (version from .semver - single source of truth)
VERSION := $(shell cat .semver 2>/dev/null | head -n1 | tr -d '\n' || echo "0.0.0")
MAKEFILE_VERSION := $(VERSION)
MAKEFILE_DATE := 2025-11-12
MAKEFILE_AUTHOR := Jose R. Prieto
PROJECT_NAME := AI Diagrams Toolkit
PROJECT_SHORT := AI Diagrams

# Shell configuration
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
.DEFAULT_GOAL := help
MAKEFLAGS += --no-print-directory

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Tool Configuration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Core tools (standard names, user can override)
GIT ?= git
NPX ?= npx
JQ ?= jq
CLAUDE ?= claude

# Semantic executors (for abstraction/swapping)
AI_CLI_EXECUTOR ?= $(CLAUDE)
NODE_EXECUTOR ?= $(NPX)
RELEASE_TOOL ?= commit-and-tag-version

# Dependency checking behavior
# Set to false to skip checks (useful in CI after first validation)
CHECK_DEPS ?= true

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
# Versioning Configuration (from .env/.env.example)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# All configuration comes from .env/.env.example (NO hardcoded values)
NODE_RELEASE_PACKAGE ?= commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION ?= 12.4.4
NODE_RELEASE_CONFIG ?= .versionrc.js
NODE_RELEASE_PACKAGE_NPX_CMD := $(RELEASE_TOOL)@$(NODE_RELEASE_PACKAGE_VERSION)

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
		echo "$(CYAN)$(INFO)$(RESET) Using defaults from .env.example"; \
		echo "  $(DIM)Tip: Copy .env.example to .env for local customization$(RESET)"; \
	fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Dependency Checks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: check/deps
check/deps: ## Check all system dependencies
ifeq ($(CHECK_DEPS),true)
	$(call print_header,Checking Dependencies)
	@MISSING=0; \
	ALL_PRESENT=1; \
	\
	echo "$(BOLD)Required Dependencies:$(RESET)"; \
	echo ""; \
	if command -v $(GIT) >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) $(GIT) installed"; \
		GIT_VERSION=$$($(GIT) --version | awk '{print $$3}'); \
		echo "  $(DIM)Version: $$GIT_VERSION$(RESET)"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) $(GIT) NOT installed"; \
		echo "  $(YELLOW)→$(RESET) Install: https://git-scm.com"; \
		MISSING=$$((MISSING + 1)); \
		ALL_PRESENT=0; \
	fi; \
	\
	if command -v $(NPX) >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) $(NPX) installed (Node.js detected)"; \
		NPX_VERSION=$$($(NPX) --version); \
		NODE_VERSION=$$(node --version); \
		echo "  $(DIM)npx version: $$NPX_VERSION$(RESET)"; \
		echo "  $(DIM)Node.js version: $$NODE_VERSION$(RESET)"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) $(NPX) NOT installed"; \
		echo "  $(YELLOW)→$(RESET) Install Node.js: https://nodejs.org"; \
		MISSING=$$((MISSING + 1)); \
		ALL_PRESENT=0; \
	fi; \
	\
	echo ""; \
	echo "$(BOLD)Optional Dependencies (for testing):$(RESET)"; \
	echo ""; \
	if command -v $(AI_CLI_EXECUTOR) >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) $(AI_CLI_EXECUTOR) installed"; \
		CLAUDE_VERSION=$$($(AI_CLI_EXECUTOR) --version 2>/dev/null || echo "unknown"); \
		echo "  $(DIM)Version: $$CLAUDE_VERSION$(RESET)"; \
	else \
		echo "$(YELLOW)$(WARN)$(RESET) $(AI_CLI_EXECUTOR) NOT installed (optional)"; \
		echo "  $(DIM)Required for: make test/commands$(RESET)"; \
		echo "  $(YELLOW)→$(RESET) Install: https://docs.anthropic.com/claude/docs/claude-cli"; \
	fi; \
	\
	if command -v $(JQ) >/dev/null 2>&1; then \
		echo "$(GREEN)$(CHECK)$(RESET) $(JQ) installed"; \
		JQ_VERSION=$$($(JQ) --version); \
		echo "  $(DIM)Version: $$JQ_VERSION$(RESET)"; \
	else \
		echo "$(YELLOW)$(WARN)$(RESET) $(JQ) NOT installed (optional)"; \
		echo "  $(DIM)Required for: make test/commands$(RESET)"; \
		echo "  $(YELLOW)→$(RESET) Install: brew install jq (macOS) or apt-get install jq (Linux)"; \
	fi; \
	\
	echo ""; \
	if [ $$ALL_PRESENT -eq 1 ]; then \
		echo "$(GREEN)$(CHECK)$(RESET) All required dependencies installed!"; \
	else \
		echo "$(RED)$(CROSS)$(RESET) $$MISSING required dependencies missing"; \
		echo ""; \
		echo "$(BOLD)Install missing dependencies and run 'make check/deps' again$(RESET)"; \
		exit 1; \
	fi
else
	@echo "$(DIM)→ Skipping dependency check (CHECK_DEPS=false)$(RESET)"
endif

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Versioning Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: release
release: check/deps check/config ## Create new release based on conventional commits
	$(call print_header,Creating Release)
	$(call print_info,Using $(RELEASE_TOOL)@$(NODE_RELEASE_PACKAGE_VERSION))
	$(call print_info,Config: $(NODE_RELEASE_CONFIG))
	@$(NODE_EXECUTOR) $(NODE_RELEASE_PACKAGE_NPX_CMD)
	$(call print_success,Release created!)
	@echo ""
	$(call print_info,Run 'git push --follow-tags' to publish)

.PHONY: release/patch
release/patch: check/deps ## Create patch release (0.0.X)
	$(call print_info,Creating patch release...)
	@$(NODE_EXECUTOR) $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as patch

.PHONY: release/minor
release/minor: check/deps ## Create minor release (0.X.0)
	$(call print_info,Creating minor release...)
	@$(NODE_EXECUTOR) $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as minor

.PHONY: release/major
release/major: check/deps ## Create major release (X.0.0)
	$(call print_info,Creating major release...)
	@$(NODE_EXECUTOR) $(NODE_RELEASE_PACKAGE_NPX_CMD) --release-as major

.PHONY: release/dry-run
release/dry-run: check/deps ## Simulate release without making changes
	$(call print_header,Dry Run - Release Simulation)
	$(call print_info,Using $(RELEASE_TOOL)@$(NODE_RELEASE_PACKAGE_VERSION))
	@$(NODE_EXECUTOR) $(NODE_RELEASE_PACKAGE_NPX_CMD) --dry-run

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Delegation to Sub-Makefiles (Open/Closed Principle)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#
# Pattern: Root Makefile delegates domain-specific operations to sub-Makefiles
#
# Benefits:
#   - CLOSED: Root Makefile stable (doesn't change when adding domain targets)
#   - OPEN: Sub-Makefiles extend functionality independently
#   - Separation of Concerns: Each domain manages its own operations
#   - Locality of Behavior: Developers work with local tools
#
# Usage:
#   make scripts/test         # Delegates to scripts/Makefile → target 'test'
#   make scripts/tdd/colors   # Delegates to scripts/Makefile → target 'tdd/colors'
#
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Delegate all scripts/* targets to scripts/Makefile
.PHONY: scripts/%
scripts/%:
	@$(MAKE) -C scripts $*

# Delegate all tests/* targets to tests/Makefile (when it exists)
.PHONY: tests/%
tests/%:
	@$(MAKE) -C tests $*

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# AI Assistant Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: install
install: ## Setup AI assistant command symlinks
	@bash scripts/install-symlinks.sh

.PHONY: install-windows
install-windows: ## Setup AI assistant command symlinks (Windows PowerShell)
	@powershell -ExecutionPolicy Bypass -File scripts/install-symlinks.ps1

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
# Testing Commands
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

.PHONY: test/commands
test/commands: check/deps ## Test AI slash commands (automated)
	$(call print_header,Testing AI Commands)
	@bash tests/commands/run-all.sh

.PHONY: test/commands/single
test/commands/single: check/deps ## Test single command: make test/commands/single TEST=01-create-flowchart
	@if [ -z "$(TEST)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) TEST variable required"; \
		echo "  $(YELLOW)→$(RESET) Usage: make test/commands/single TEST=01-create-flowchart"; \
		exit 1; \
	fi
	@if [ ! -f "tests/commands/$(TEST)/test.sh" ]; then \
		echo "$(RED)$(CROSS)$(RESET) Test not found: $(TEST)"; \
		echo "  $(YELLOW)→$(RESET) Available tests:"; \
		ls -1 tests/commands/ | grep -E '^[0-9]' | sed 's/^/    /'; \
		exit 1; \
	fi
	@REPO_ROOT="$(shell pwd)" bash "tests/commands/$(TEST)/test.sh" "$(ENV_FILE_LOADED)"

.PHONY: test/makefile
test/makefile: ## Test Makefile targets (automated)
	@bash tests/makefile/test-targets.sh

.PHONY: scripts/test
scripts/test: ## Run all script tests (TDD test suite)
	$(call print_header,Testing Shell Scripts)
	@bash tests/scripts/run-all.sh

.PHONY: scripts/test/single
scripts/test/single: ## Test single script: make scripts/test/single TEST=test-colors
	@if [ -z "$(TEST)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) TEST variable required"; \
		echo "  $(YELLOW)→$(RESET) Usage: make scripts/test/single TEST=test-colors"; \
		exit 1; \
	fi
	@if [ ! -f "tests/scripts/lib/$(TEST).sh" ] && [ ! -f "tests/scripts/bin/$(TEST).sh" ]; then \
		echo "$(RED)$(CROSS)$(RESET) Test not found: $(TEST)"; \
		echo "  $(YELLOW)→$(RESET) Available tests:"; \
		ls -1 tests/scripts/lib/test-*.sh tests/scripts/bin/test-*.sh 2>/dev/null | xargs -n1 basename | sed 's/^/    /' || echo "    (no tests yet)"; \
		exit 1; \
	fi
	@if [ -f "tests/scripts/lib/$(TEST).sh" ]; then \
		bash "tests/scripts/lib/$(TEST).sh"; \
	else \
		bash "tests/scripts/bin/$(TEST).sh"; \
	fi

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
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' Makefile | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)Examples:$(RESET)"
	@echo "  $(DIM)make help$(RESET)           # Show this help"
	@echo "  $(DIM)make check/config$(RESET)   # Show current configuration"
	@echo "  $(DIM)make check/deps$(RESET)     # Check dependencies"
	@echo "  $(DIM)make release$(RESET)        # Create new release"
	@echo "  $(DIM)make release/dry-run$(RESET) # Simulate release"
	@echo ""
