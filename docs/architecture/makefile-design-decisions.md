# Makefile Design Decisions

**Status**: Active (v0.2.0+)

**Date**: 2025-11-12

**Author**: Jose R. Prieto

---

## 📋 Summary

This document explains the architectural decisions behind the AI Diagrams Toolkit Makefile design, focusing on variable naming, dependency checking strategy, and fail-fast principles.

---

## 🎯 Design Principles

### 1. Semantic Abstraction with Practical Brevity

**Principle**: Balance semantic meaning with concise syntax for readability.

**Implementation**:

We use **standard tool names** for universal commands and **semantic abstraction** for swappable executors.

```makefile
# Core tools (standard names, user can override)
GIT ?= git
NPX ?= npx
JQ ?= jq
CLAUDE ?= claude

# Semantic executors (for abstraction/swapping)
AI_CLI_EXECUTOR ?= $(CLAUDE)
NODE_EXECUTOR ?= $(NPX)
RELEASE_TOOL ?= commit-and-tag-version
```

**Rationale**:

- **Short names** (`GIT`, `NPX`, `JQ`) improve readability in recipes
- **Semantic names** (`AI_CLI_EXECUTOR`, `NODE_EXECUTOR`) communicate intent and swappability
- **Override capability**: Users can customize with standard Make syntax: `make release GIT=hg`
- **Best of both worlds**: Concise syntax + clear abstraction where needed

**Examples**:

```makefile
# Standard tools (unlikely to swap, universal names)
$(GIT) tag v1.0.0           # Clear, concise
$(JQ) -r '.version'         # Familiar to Make users

# Swappable executors (abstraction needed for future features)
$(AI_CLI_EXECUTOR) -p "..."  # Could be: claude, cursor-agent, junie, codex
$(NODE_EXECUTOR) pkg@version # Could be: npx, bunx, pnpm
```

**Alternative considered**: Verbose semantic names (`SOURCE_CODE_VERSION_CLI`, `JSON_PARSER_CLI`)

**Why rejected**: Too verbose for Make recipes, reduces readability without significant benefit.

---

### 2. Fail-Fast via Explicit Prerequisites

**Principle**: All targets that require system dependencies **must** declare `check/deps` as a prerequisite.

**Implementation**:

```makefile
.PHONY: release
release: check/deps check/config ## Create new release
    @$(NODE_EXECUTOR) $(RELEASE_TOOL)@$(VERSION)

.PHONY: test/commands
test/commands: check/deps ## Test AI slash commands
    @$(AI_CLI_EXECUTOR) -p "..." | $(JQ) -r '.response'
```

**Rationale**:

1. **Fail-fast**: Catch missing dependencies before execution starts
2. **DRY (Don't Repeat Yourself)**: Single source of truth for validation logic
3. **Clarity**: Explicit dependency graph visible in Makefile
4. **Predictable**: Users know dependencies are always checked

**Benefits**:

- **Better error messages**: Centralized validation provides consistent, helpful errors
- **Easier maintenance**: Update dependency checks in one place
- **Explicit contracts**: Target prerequisites document runtime requirements
- **Prevents partial execution**: No risk of starting work with missing tools

---

### 3. Trade-off: Performance vs Safety

**Decision**: We **do not** use guard patterns (`.check-deps-done`) to cache dependency checks.

**Implementation**:

```makefile
# We run check/deps every time (no caching)
CHECK_DEPS ?= true

.PHONY: check/deps
check/deps:
ifeq ($(CHECK_DEPS),true)
    # Full validation every time
else
    @echo "→ Skipping dependency check (CHECK_DEPS=false)"
endif
```

**Rationale**:

1. **Development environment safety**: Dependencies can be uninstalled between Make invocations
2. **Clarity over optimization**: Explicit checks are more maintainable and predictable
3. **Acceptable cost**: 2-3s overhead is negligible for most workflows
4. **No hidden state**: Guard files (`.check-deps-done`) create hidden state that can become stale

**Trade-off analysis**:

| Approach | Pros | Cons |
|----------|------|------|
| **No guard (current)** | Always validates, no stale state, clear behavior | 2-3s overhead per invocation |
| **Guard pattern** | Faster (skip checks after first run) | Stale state risk, false positives, hidden files |
| **CI-only guards** | Fast CI, safe locally | Complex logic, environment-specific |

**Conclusion**: We prioritize **safety and clarity** over **performance optimization**.

**For CI optimization**:

Users can set `CHECK_DEPS=false` after first validation:

```bash
# In CI pipeline:
make check/deps              # First time: validates everything
CHECK_DEPS=false make release # Subsequent: skips validation
CHECK_DEPS=false make test/commands
```

**Local development optimization**:

For rapid iteration, users can skip checks:

```bash
# First run: check everything
make check/deps

# Rapid iteration: skip checks
CHECK_DEPS=false make test/commands
# Fix diagram
CHECK_DEPS=false make test/commands
# Fix diagram
CHECK_DEPS=false make test/commands
```

**Important**: This is **opt-in** behavior. Default is always safe (CHECK_DEPS=true).

---

### 4. Monolithic vs Granular Dependency Checks

**Decision**: Use a single `check/deps` target that validates **all dependencies**, even if individual targets only need a subset.

**Current implementation**:

```makefile
.PHONY: check/deps
check/deps: ## Check all system dependencies
    # Validates: GIT, NPX, AI_CLI_EXECUTOR, JQ (all at once)

# All targets use same check
release: check/deps check/config
test/commands: check/deps
```

**Rationale**:

1. **Simplicity**: Single target, easy to understand
2. **Fast enough**: Total check time ~2-3s (acceptable overhead)
3. **User expectation**: Answers "Does my system have what this project needs?"
4. **Easier maintenance**: One validation function to update

**Alternative considered**: Granular checks

```makefile
# Split into specific checks
check/deps/scm: ## Check source control tools
check/deps/node: ## Check Node.js tools
check/deps/ai: ## Check AI CLI tools
check/deps/json: ## Check JSON tools

# Composite
check/deps: check/deps/scm check/deps/node check/deps/ai check/deps/json

# Precise dependencies
release: check/deps/scm check/deps/node
test/commands: check/deps/ai check/deps/json
```

**Why rejected** (for now):

- Added complexity without measurable benefit
- Current check time (~2-3s) is acceptable
- Would require maintaining multiple validation functions
- May be reconsidered if check time exceeds 5s

**Future consideration**:

If total check time grows significantly (>5s), we may split into granular checks for performance.

---

## 📊 Implementation Details

### Variable Hierarchy

**Priority order** (highest to lowest):

1. **Command-line override**: `make release GIT=hg`
2. **Environment variable**: `export GIT=hg`
3. **Makefile default**: `GIT ?= git`

**Example**:

```bash
# Default behavior
make release
# Uses: GIT=git, NPX=npx, AI_CLI_EXECUTOR=claude

# Override for single invocation
make release NPX=bunx
# Uses: GIT=git, NPX=bunx, AI_CLI_EXECUTOR=claude

# Override via environment
export NODE_EXECUTOR=bunx
make release
# Uses: GIT=git, NPX=bunx (via NODE_EXECUTOR), AI_CLI_EXECUTOR=claude
```

### Configuration Externalization

**Principle**: No hardcoded values in Makefile.

**Implementation**:

```makefile
# Load from .env (user overrides) or .env.example (defaults)
ifneq (,$(wildcard .env))
    include .env
else ifneq (,$(wildcard .env.example))
    include .env.example
endif

# All configuration comes from environment
NODE_RELEASE_PACKAGE ?= commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION ?= 12.4.4
```

**Rationale**:

- **Version control**: `.env.example` is versioned (defaults)
- **Local customization**: `.env` is gitignored (user overrides)
- **Flexibility**: Different teams/developers can use different tools
- **Documentation**: `.env.example` documents all available options

---

## 🔄 Evolution Path

### v0.2.0 (Current)

- ✅ Variable abstraction (`GIT`, `NPX`, `JQ`, `AI_CLI_EXECUTOR`)
- ✅ Consolidated dependency checking
- ✅ Fail-fast prerequisites
- ✅ Optional CI optimization (`CHECK_DEPS=false`)

### v0.4.0+ (Planned)

See [AI CLI Abstraction](./future-ai-cli-abstraction.md) for:

- Multi-executor support (claude, cursor-agent, junie, codex)
- Adapter pattern for AI CLI executors
- Environment-based executor selection

**Changes required**:

```makefile
# v0.4.0+ additions
AI_CLI_EXECUTOR ?= claude    # Can be: cursor-agent, junie, codex
AI_CLI_ADAPTER := tools/ai-cli-adapters/$(AI_CLI_EXECUTOR).sh

test/commands: check/deps
    @bash $(AI_CLI_ADAPTER) tests/input.md tests/output.json
```

### Future Considerations

**If check time grows >5s**:

Split into granular checks:

```makefile
check/deps/required: check/deps/scm check/deps/node
check/deps/optional: check/deps/ai check/deps/json
```

**If multiple Node executors emerge**:

Add executor-specific config:

```makefile
NODE_EXECUTOR_ARGS ?=
NODE_EXECUTOR_FLAGS ?= --yes

test/commands:
    @$(NODE_EXECUTOR) $(NODE_EXECUTOR_ARGS) $(RELEASE_TOOL)
```

---

## 🎓 Lessons Learned

### 1. Variable Naming Trade-offs

**Initial approach**: Generic names (`GIT`, `JQ`)

**Problem**: Not semantic, doesn't communicate swappability

**Solution**: Hybrid approach (standard names + semantic abstraction)

**Learning**: Different variables serve different purposes:
- **Standard tools**: Use familiar names (`GIT`, `JQ`)
- **Swappable executors**: Use semantic names (`AI_CLI_EXECUTOR`, `NODE_EXECUTOR`)

### 2. Guard Pattern Complexity

**Initial consideration**: Use `.check-deps-done` sentinel files

**Problem**: Hidden state, stale checks, false positives

**Solution**: Always check, with opt-in skip via `CHECK_DEPS=false`

**Learning**: Clarity and safety > performance optimization in dev tools

### 3. Dependency Granularity

**Initial concern**: Checking all deps for all targets is wasteful

**Reality**: Total check time ~2-3s, not a bottleneck

**Learning**: Premature optimization is real - start simple, optimize when measured

---

## 📖 Related Documentation

### Architecture

- [Testing Strategy](./testing-strategy.md) - Why hybrid testing approach
- [AI CLI Abstraction](./future-ai-cli-abstraction.md) - Multi-executor support (v0.4.0+)
- [Orchestration Decision](./orchestration.md) - Why Makefile as orchestrator

### Conventions

- [Makefile Conventions](../conventions/makefile.md) - Code style and formatting *(Coming soon)*

### Development

- [Testing Guide](../development/testing-guide.md) - How to use automated tests
- [Contributing Guide](../../CONTRIBUTING.md) - Contribution workflow

---

## 🤔 Open Questions

1. **Model selection**: Should `AI_CLI_EXECUTOR` also specify model? (e.g., `claude:sonnet-4`)
2. **Retry logic**: Should dependency checks retry on transient failures?
3. **Version constraints**: Should we validate minimum versions? (e.g., `git >= 2.30`)
4. **Parallel checks**: Could we speed up `check/deps` by parallelizing validations?
5. **Cross-platform**: Do we need platform-specific variable values? (macOS vs Linux)

---

**Last Updated**: 2025-11-12

**Version**: 1.0.0

**Status**: Active
