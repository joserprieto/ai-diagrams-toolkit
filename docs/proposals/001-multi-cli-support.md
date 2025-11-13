# Future Enhancement: AI CLI Abstraction Layer

**Status**: Planned (v0.4.0+)

**Date**: 2025-11-12

**Author**: Jose R. Prieto

---

## 📋 Summary

Abstract the AI CLI executor to support multiple AI coding assistants, avoiding vendor lock-in to Claude Code.

---

## 🎯 Problem Statement

**Current state** (v0.2.0):

- Hardcoded dependency on `claude` CLI
- Makefile target `test/commands` assumes Claude Code
- Documentation references Claude Code exclusively
- Users of other AI assistants (Cursor, Junie, Codex) cannot use automated tests

**Limitation**:

```makefile
# Hardcoded in Makefile
test/commands:
    @claude -p "$(cat test.md)" --output-format json > output.json
```

**Impact**:

- Vendor lock-in to Anthropic Claude Code
- Excludes Cursor Agent, Junie, Codex CLI users
- Reduces toolkit adoption
- Goes against toolkit philosophy (tool-agnostic)

---

## 💡 Proposed Solution

### Environment Variable Configuration

**Introduce**: `AI_CLI_EXECUTOR` environment variable (v0.4.0+)

**Supported values**:

- `claude` (default) - Claude Code CLI
- `cursor-agent` - Cursor Agent CLI
- `junie` - JetBrains Junie CLI
- `codex` - OpenAI Codex CLI
- Custom path to any compatible CLI

**Configuration locations**:

1. `.env` file (gitignored, local overrides)
2. `.env.example` file (versioned, project defaults)
3. Shell environment variable (runtime override)

---

## 🏗️ Implementation Design

### Layer 1: CLI Adapter Interface

**Define standard interface** that all AI CLIs must implement:

```bash
# Required capabilities:
# 1. Accept prompt from stdin or file
# 2. Output JSON format with response field
# 3. Return exit code 0 on success

# Standard interface:
${AI_CLI_EXECUTOR} \
    --prompt "$(cat prompt.md)" \
    --output-format json \
    > response.json
```

### Layer 2: CLI-Specific Adapters

**Location**: `tools/ai-cli-adapters/`

**Structure**:

```
tools/ai-cli-adapters/
├── README.md              # Adapter interface spec
├── claude.sh              # Claude Code adapter
├── cursor-agent.sh        # Cursor Agent adapter
├── junie.sh               # Junie adapter
├── codex.sh               # Codex CLI adapter
└── custom-example.sh      # Template for custom adapters
```

**Adapter template**:

```bash
#!/bin/bash
# AI CLI Adapter: ${TOOL_NAME}
# Maps standard interface to tool-specific CLI

set -euo pipefail

PROMPT_FILE="$1"
OUTPUT_FILE="$2"

# Tool-specific CLI invocation
${TOOL_CLI} \
    ${TOOL_SPECIFIC_FLAGS} \
    "$(cat ${PROMPT_FILE})" \
    > "${OUTPUT_FILE}"

# Ensure JSON format with .response field
# (transform if needed)
```

**Example: Claude adapter** (`claude.sh`):

```bash
#!/bin/bash
set -euo pipefail

PROMPT_FILE="$1"
OUTPUT_FILE="$2"

claude -p "$(cat ${PROMPT_FILE})" \
    --output-format json \
    > "${OUTPUT_FILE}"
```

**Example: Cursor Agent adapter** (`cursor-agent.sh`):

```bash
#!/bin/bash
set -euo pipefail

PROMPT_FILE="$1"
OUTPUT_FILE="$2"

# Cursor Agent uses different flags
cursor-agent chat \
    --non-interactive \
    --output json \
    "$(cat ${PROMPT_FILE})" \
    > "${OUTPUT_FILE}"
```

**Example: Junie adapter** (`junie.sh`):

```bash
#!/bin/bash
set -euo pipefail

PROMPT_FILE="$1"
OUTPUT_FILE="$2"

# Junie requires auth token
if [ -z "${JUNIE_API_KEY:-}" ]; then
    echo "ERROR: JUNIE_API_KEY not set" >&2
    exit 1
fi

junie "$(cat ${PROMPT_FILE})" \
    --auth="${JUNIE_API_KEY}" \
    --format json \
    > "${OUTPUT_FILE}"
```

### Layer 3: Makefile Integration

**Updated configuration** (`.env.example`):

```bash
# AI CLI Executor (v0.4.0+)
# Options: claude, cursor-agent, junie, codex, or path to custom adapter
AI_CLI_EXECUTOR=claude

# CLI-specific configuration
CLAUDE_CLI=claude
CURSOR_AGENT_CLI=cursor-agent
JUNIE_CLI=junie
CODEX_CLI=codex
```

**Updated Makefile target**:

```makefile
# Load AI CLI executor (defaults to claude)
AI_CLI_EXECUTOR ?= claude
AI_CLI_ADAPTER := tools/ai-cli-adapters/$(AI_CLI_EXECUTOR).sh

.PHONY: test/commands
test/commands: ## Test AI slash commands (automated)
	$(call print_header,Testing AI Commands)
	@if [ ! -f "$(AI_CLI_ADAPTER)" ]; then \
		echo "$(RED)$(CROSS)$(RESET) Adapter not found: $(AI_CLI_ADAPTER)"; \
		echo "  $(YELLOW)→$(RESET) Supported: claude, cursor-agent, junie, codex"; \
		exit 1; \
	fi
	@mkdir -p tests/output
	@echo "$(CYAN)$(INFO)$(RESET) Using executor: $(AI_CLI_EXECUTOR)"
	@echo "$(CYAN)$(INFO)$(RESET) Running test: create-flowchart"
	@bash "$(AI_CLI_ADAPTER)" \
		tests/commands/test-create-flowchart.md \
		tests/output/01-flowchart.json
	@jq -r '.response' tests/output/01-flowchart.json \
		> tests/output/01-flowchart.mmd
	$(call print_success,Diagram generated: tests/output/01-flowchart.mmd)
```

### Layer 4: Dependency Checking

**Updated `check/deps`**:

```makefile
check/deps: ## Check all system dependencies
	# ... existing checks ...

	echo "$(BOLD)AI CLI Executor ($(AI_CLI_EXECUTOR)):$(RESET)"
	@if command -v $(AI_CLI_EXECUTOR) >/dev/null 2>&1; then
		echo "$(GREEN)$(CHECK)$(RESET) $(AI_CLI_EXECUTOR) installed"
		VERSION=$$($(AI_CLI_EXECUTOR) --version 2>/dev/null || echo "unknown")
		echo "  $(DIM)Version: $$VERSION$(RESET)"
	else
		echo "$(YELLOW)$(WARN)$(RESET) $(AI_CLI_EXECUTOR) NOT installed"
		echo "  $(DIM)Required for: make test/commands$(RESET)"
		# Show installation instructions per executor
	fi
```

---

## 📊 Supported AI CLIs (v0.4.0+)

| CLI Tool     | Command           | Install                               | Output Format | Status      |
|--------------|-------------------|---------------------------------------|---------------|-------------|
| Claude Code  | `claude`          | https://docs.anthropic.com/claude/cli | JSON native   | ✅ Default   |
| Cursor Agent | `cursor-agent`    | `curl https://cursor.com/install      | bash`         | JSON native | 🔄 Planned  |
| Junie        | `junie`           | `npm install -g @jetbrains/junie-cli` | JSON native   | 🔄 Planned  |
| Codex CLI    | `codex`           | https://github.com/openai/codex-cli   | JSON (custom) | 🔄 Planned  |
| Custom       | User-defined path | User provides adapter script          | JSON required | 🔄 Planned  |

**Key capabilities required**:

- Accept text prompt (from file or stdin)
- Execute prompt with AI model
- Return JSON response with `.response` field
- Exit code 0 on success

---

## 🎯 Benefits

### 1. **No Vendor Lock-in**

Users can choose their preferred AI assistant:

- Claude Code users: no change
- Cursor Agent users: set `AI_CLI_EXECUTOR=cursor-agent`
- Junie users: set `AI_CLI_EXECUTOR=junie`
- Custom tools: provide adapter script

### 2. **Toolkit Philosophy Consistency**

Aligns with existing principles:

- **Tool-agnostic foundation** (already in architecture)
- **Zero-dependency templates** (works with any AI)
- **Professional automation** (supports multiple tools)

### 3. **Broader Adoption**

Removes barrier for:

- JetBrains IDE users (Junie)
- Cursor users (Cursor Agent)
- OpenAI users (Codex CLI)
- Enterprise users (custom tools)

### 4. **Future-Proof**

New AI CLIs can be added via:

1. Create adapter script in `tools/ai-cli-adapters/`
2. Update `.env.example` with new option
3. Update documentation

No Makefile changes needed.

### 5. **Testing Flexibility**

Teams can:

- Use different AI tools for different test suites
- Compare outputs across multiple AIs
- Validate toolkit works with any AI
- Benchmark performance across tools

---

## 📝 Usage Examples

### Example 1: Using Cursor Agent

**Setup**:

```bash
# Install Cursor Agent
curl https://cursor.com/install -fsSL | bash

# Configure toolkit
echo "AI_CLI_EXECUTOR=cursor-agent" >> .env

# Run tests
make test/commands
```

**Output**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Testing AI Commands
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Using executor: cursor-agent
ℹ Running test: create-flowchart
✓ Diagram generated: tests/output/01-flowchart.mmd
```

### Example 2: Using Junie

**Setup**:

```bash
# Install Junie
npm install -g @jetbrains/junie-cli

# Set API key
export JUNIE_API_KEY="your-key-here"

# Configure toolkit
echo "AI_CLI_EXECUTOR=junie" >> .env
echo "JUNIE_API_KEY=${JUNIE_API_KEY}" >> .env

# Run tests
make test/commands
```

### Example 3: Custom Adapter

**Create custom adapter** (`tools/ai-cli-adapters/my-ai.sh`):

```bash
#!/bin/bash
set -euo pipefail

PROMPT_FILE="$1"
OUTPUT_FILE="$2"

# Your custom AI CLI
my-ai-tool execute \
    --input "${PROMPT_FILE}" \
    --format json \
    > "${OUTPUT_FILE}"

# Ensure .response field exists
jq '{response: .output}' "${OUTPUT_FILE}" > "${OUTPUT_FILE}.tmp"
mv "${OUTPUT_FILE}.tmp" "${OUTPUT_FILE}"
```

**Use**:

```bash
echo "AI_CLI_EXECUTOR=my-ai" >> .env
make test/commands
```

---

## 🚧 Implementation Phases

### Phase 1: Core Abstraction (v0.4.0)

**Deliverables**:

- [ ] Define adapter interface spec
- [ ] Create `tools/ai-cli-adapters/` directory
- [ ] Implement Claude adapter (baseline)
- [ ] Update Makefile to use adapter layer
- [ ] Update `.env.example` with `AI_CLI_EXECUTOR`
- [ ] Document adapter interface

**Compatibility**: 100% backward compatible (defaults to `claude`)

### Phase 2: Additional Adapters (v0.5.0)

**Deliverables**:

- [ ] Cursor Agent adapter
- [ ] Junie adapter
- [ ] Codex CLI adapter
- [ ] Custom adapter template
- [ ] Installation guides per tool

### Phase 3: Enhanced Features (v0.6.0)

**Deliverables**:

- [ ] Model selection per executor
- [ ] Timeout configuration
- [ ] Retry logic
- [ ] Performance benchmarking
- [ ] Side-by-side comparison tool

---

## 📖 Documentation Updates Required

### ADRs

**New**: `docs/architecture/ai-cli-abstraction.md`

- Decision to abstract AI CLI
- Adapter pattern rationale
- Supported executors

### Guides

**Update**: `docs/development/testing-guide.md`

- Add section on configuring AI executor
- Examples for each supported tool
- Troubleshooting per executor

**New**: `docs/development/ai-cli-adapters.md`

- How to write custom adapters
- Adapter interface specification
- Testing adapters

### Configuration

**Update**: `.env.example`

```bash
# AI CLI Executor Configuration (v0.4.0+)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Primary executor (claude, cursor-agent, junie, codex, or custom path)
AI_CLI_EXECUTOR=claude

# Executor-specific settings
CLAUDE_CLI=claude
CURSOR_AGENT_CLI=cursor-agent
JUNIE_CLI=junie
JUNIE_API_KEY=  # Required for Junie
CODEX_CLI=codex
```

---

## ⚠️ Breaking Changes

**None** - This is fully backward compatible.

**Default behavior** (no configuration):

```bash
# v0.2.0 (current)
make test/commands  # Uses claude

# v0.4.0 (with abstraction)
make test/commands  # Still uses claude (default)
```

**Opt-in** to alternative executors:

```bash
# Use Cursor Agent
AI_CLI_EXECUTOR=cursor-agent make test/commands

# Use Junie
AI_CLI_EXECUTOR=junie make test/commands
```

---

## 🔍 Open Questions

1. **Model selection**: Should `AI_CLI_EXECUTOR` also specify model? (e.g., `claude:sonnet-4`)
2. **Adapter versioning**: How to handle breaking changes in CLI tools?
3. **Fallback strategy**: If primary executor fails, try alternatives?
4. **Performance**: Benchmark different executors on same tests?
5. **CI/CD**: Which executor to use in GitHub Actions? (probably cheapest/fastest)

---

## 📚 References

### External Documentation

- [Claude Code CLI](https://docs.anthropic.com/claude/docs/claude-cli)
- [Cursor Agent CLI](https://docs.cursor.com/en/cli/overview)
- [Junie CLI](https://www.jetbrains.com/help/junie/junie-cli.html)
- [Codex CLI](https://github.com/openai/codex-cli) _(if publicly available)_

### Related ADRs

- [Testing Strategy](./testing-strategy.md) - Foundation for automated testing
- [Orchestration Decision](./orchestration.md) - Why Makefile for abstraction

---

**Last Updated**: 2025-11-12
**Version**: 1.0.0
**Status**: Planned for v0.4.0+
