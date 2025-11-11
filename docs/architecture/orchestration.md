# Orchestration Architecture Decision

- **Status**: Accepted
- **Date**: 2025-11-10
- **Deciders**: Jose R. Prieto
- **Context**: AI Diagrams Toolkit v0.1.0

## Decision

Use **GNU Make** as the **main entrypoint and orchestrator** for ALL project automation (releases, tests, builds,
deployments, linting, documentation generation).

## Context

### Problem Statement

Modern development projects require orchestration of multiple tools and workflows:

- **Development**: Local testing, linting, building
- **CI/CD**: Automated testing, releases, deployments
- **Maintenance**: Dependency updates, cleanup, validation

**Challenges**:

1. **Tool heterogeneity**: Projects use different tools (npm, Python, shell scripts, Docker)
2. **Environment inconsistency**: Local vs CI/CD environments differ
3. **Implementation coupling**: Workflows tightly coupled to specific tools
4. **Documentation burden**: Each tool requires separate documentation
5. **Onboarding friction**: New contributors must learn multiple tool chains

### Current Project Stack

- **Node.js**: `commit-and-tag-version` for releases
- **Handlebars**: Template engine for CHANGELOG
- **Shell**: Utility scripts
- **Future**: Tests (potentially Bun, Jest, or Vitest), builds, deployments

**Risk**: Tool choices may change, but workflows should remain stable.

## Rationale

### 1. Implementation Abstraction

**Principle**: Hide implementation details behind semantic interfaces.

**Example**:

```bash
# User/CI executes
make release

# Internally, could be ANY of:
npx commit-and-tag-version@12.4.4      # Current (Node.js)
bun x commit-and-tag-version@12.4.4    # Future (Bun)
python -m semantic_release             # Alternative (Python)
./scripts/release.sh                   # Custom script
```

**Benefit**: Change tools without changing workflows.

**Real scenario**:

```bash
# Week 1: Using npx
make test  # → npx vitest

# Week 2: Switch to bun (faster)
# Update .env: TEST_RUNNER=bun
make test  # → bun test

# CI/CD workflows: UNCHANGED
# Documentation: UNCHANGED
# Developer muscle memory: UNCHANGED
```

### 2. Single Point of Entry

**Principle**: One command interface for all environments.

**Developer workflow**:

```bash
make help       # What can I do?
make release    # Create release
make test       # Run tests
make lint       # Check code quality
make build      # Build artifacts
```

**CI/CD workflow** (GitHub Actions):

```yaml
- name: Run tests
  run: make test

- name: Create release
  run: make release
```

**Same commands**, different environments, guaranteed consistency.

**Contrast with scattered approach**:

```bash
# Without orchestration (scattered)
npm run test           # Testing
./scripts/release.sh   # Releasing
python -m lint         # Linting
docker build .         # Building

# With orchestration (unified)
make test
make release
make lint
make build
```

### 3. Tool-Agnostic Interface

**Principle**: Workflows independent of tool implementations.

**Scenario**: Migrating from npm to Bun

**Without orchestration**:

```bash
# Update everywhere
package.json scripts
CI/CD workflows
Documentation
Developer guides
Onboarding docs
```

**With orchestration**:

```bash
# Update ONE place
vim .env
# Change: NODE_PACKAGE_MANAGER=bun

# Everything else: UNCHANGED
```

**File changes**:

- `.env`: 1 line
- `Makefile`: 0 lines (reads from `.env`)
- CI/CD: 0 lines (calls `make`)
- Docs: 0 lines (describes `make` commands)

### 4. Dependency Management and Validation

**Principle**: Validate environment before execution, fail fast with clear errors.

**Implementation**:

```makefile
check/deps:  ## Verify required dependencies
	@command -v node >/dev/null || { echo "ERROR: Node.js not found"; exit 1; }
	@command -v npx >/dev/null || { echo "ERROR: npx not found"; exit 1; }
	@npx --version >/dev/null || exit 1

release: check/deps  ## Create release (with validation)
	@npx commit-and-tag-version@$(VERSION)
```

**Benefits**:

- ✅ **Early failure**: Detect missing dependencies before execution
- ✅ **Clear errors**: Actionable error messages
- ✅ **Version pinning**: Ensure compatible tool versions
- ✅ **Reproducibility**: Same versions across environments

**Example error**:

```bash
$ make release
ERROR: Node.js not found
Install: brew install node
```

Better than:

```bash
$ ./scripts/release.sh
./scripts/release.sh: line 42: npx: command not found
```

### 5. Configuration as Code

**Principle**: Externalize configuration, version-control defaults, allow local overrides.

**Implementation**:

```
.env.dist    ← Defaults (version-controlled, committed)
.env         ← Local overrides (gitignored, optional)
```

**Workflow**:

```bash
# Developer 1: Uses defaults
make release
# → Uses commit-and-tag-version@12.4.4 (from .env.dist)

# Developer 2: Tests new version
echo "NODE_RELEASE_PACKAGE_VERSION=13.0.0" > .env
make release
# → Uses commit-and-tag-version@13.0.0 (from .env)

# CI/CD: Always uses defaults
make release
# → Uses commit-and-tag-version@12.4.4 (from .env.dist)
```

**Benefits**:

- ✅ **Version control**: Defaults committed
- ✅ **Local experimentation**: Override without polluting git
- ✅ **CI/CD stability**: Always uses committed defaults

## Benefits

### For Developers

1. **Muscle memory**: Learn `make <command>` once, works everywhere
2. **Discoverability**: `make help` shows all capabilities
3. **Fast onboarding**: Single interface to learn
4. **Local experimentation**: Override tools via `.env` safely

### For CI/CD

1. **Consistency**: Same commands locally and in CI
2. **Simplicity**: No complex CI-specific logic
3. **Portability**: Works on GitHub Actions, GitLab CI, Jenkins, local
4. **Debuggability**: Reproduce CI failures locally with same command

### For Maintainers

1. **Tool migration**: Change implementation without changing interface
2. **Version control**: Pin tool versions for reproducibility
3. **Clear contracts**: Semantic targets document capabilities
4. **Extensibility**: Add new targets as project grows

### For Documentation

1. **Single source**: Document `make` commands, not tool internals
2. **Stability**: Documentation doesn't change when tools change
3. **Simplicity**: One workflow for all tasks

## Trade-offs

### Costs

#### 1. Learning Curve

**Problem**: Makefile syntax is not intuitive

```makefile
.PHONY: release
release:  ## Create release
	@echo "Creating release..."
```

- `.PHONY`: Non-obvious concept
- `@`: Suppress echo (magic symbol)
- `##`: Comment convention for help (not standard)

**Mitigation**:

- Comprehensive documentation (`docs/conventions/makefile.md`)
- Auto-generated help (`make help`)
- Examples in documentation

**When it hurts**: New contributors unfamiliar with Make

#### 2. Platform Dependency

**Problem**: Windows doesn't have Make by default

**Options**:

- Install GNU Make (via Chocolatey, WSL, Git Bash)
- Use WSL (Windows Subsystem for Linux)
- Provide `make.bat` wrapper (calls WSL make)

**Mitigation**:

- Document installation in README
- Provide fallback scripts for critical targets

**When it hurts**: Windows-primary teams without WSL

#### 3. Abstraction Overhead

**Problem**: Adds indirection layer

```bash
# Direct (simple, but coupled)
npx commit-and-tag-version

# Abstracted (decoupled, but more complex)
make release
  ↓
Makefile loads .env.dist
  ↓
Makefile constructs command
  ↓
Executes npx commit-and-tag-version@12.4.4
```

**When to avoid**: Tiny projects with single tool, no CI/CD, no team

**When it pays off**: Multi-tool projects, CI/CD, teams >1 person

#### 4. Debugging Complexity

**Problem**: Errors happen inside abstraction

```bash
make release
# Error: ???
# Where did it fail? Make? npx? commit-and-tag-version?
```

**Mitigation**:

- Set `MAKEFLAGS += --warn-undefined-variables`
- Use `make -n` (dry-run) for debugging
- Add verbose output option (`make release VERBOSE=1`)

### Limitations

#### What Make is NOT good for

1. **Complex logic**: Use scripts, not Makefile
2. **Cross-platform compatibility**: Windows requires setup
3. **IDE integration**: Limited compared to npm scripts
4. **Parallel execution**: Possible but complex

#### When to avoid this approach

- **Single-tool projects**: If project only uses npm, `npm scripts` is simpler
- **Windows-only teams**: Without WSL, friction is high
- **IDE-centric workflows**: Some teams prefer IDE-integrated runners

## Alternatives Considered

### 1. npm scripts (package.json)

**Approach**:

```json
{
  "scripts": {
    "release": "commit-and-tag-version",
    "test": "vitest",
    "lint": "eslint"
  }
}
```

**Pros**:

- ✅ Native to Node.js ecosystem
- ✅ IDE integration (VSCode, WebStorm)
- ✅ No additional dependencies

**Cons**:

- ❌ Requires `package.json` (not suitable for non-Node projects)
- ❌ Limited to Node.js tools (can't easily call Python, Docker, shell)
- ❌ No environment loading (`.env` requires additional tools)
- ❌ Cross-platform issues (different shell on Windows/Unix)

**Verdict**: Good for pure Node.js projects, insufficient for polyglot projects

### 2. Task runners (Grunt, Gulp, Taskfile)

**Approach**:

```javascript
// Gruntfile.js
module.exports = function (grunt) {
    grunt.registerTask('release', ['commit-and-tag-version']);
};
```

**Pros**:

- ✅ JavaScript-based (familiar to JS devs)
- ✅ Rich plugin ecosystem

**Cons**:

- ❌ Requires Node.js
- ❌ Additional dependency
- ❌ Less universal than Make
- ❌ Adds complexity (config file + tool)

**Verdict**: Overkill for orchestration, better suited for asset pipelines

### 3. Just (command runner)

**Approach**:

```makefile
# justfile
release:
  npx commit-and-tag-version
```

**Pros**:

- ✅ Simpler syntax than Make
- ✅ Cross-platform
- ✅ Modern design

**Cons**:

- ❌ Additional installation required
- ❌ Less ubiquitous than Make
- ❌ Smaller ecosystem

**Verdict**: Promising alternative, but Make is more universally available

### 4. Custom scripts (bash/python)

**Approach**:

```bash
#!/bin/bash
# run.sh
case "$1" in
  release) npx commit-and-tag-version ;;
  test) npm test ;;
esac
```

**Pros**:

- ✅ No external dependencies
- ✅ Full flexibility

**Cons**:

- ❌ No standardization
- ❌ Custom help system
- ❌ Reinventing the wheel
- ❌ Harder for contributors to understand

**Verdict**: Reinventing Make, no benefit

### 5. CI-native workflows (GitHub Actions only)

**Approach**: Define everything in `.github/workflows/`

**Pros**:

- ✅ Native to CI platform

**Cons**:

- ❌ Can't reproduce locally
- ❌ Locked to GitHub
- ❌ Developer workflow diverges from CI

**Verdict**: Anti-pattern, violates "local = CI" principle

## Decision Matrix

| Criterion            | Make | npm scripts | Task runners | Just | Custom scripts |
|----------------------|------|-------------|--------------|------|----------------|
| Ubiquity             | ✅ ✅  | ✅           | ❌            | ❌    | ✅              |
| Polyglot support     | ✅ ✅  | ❌           | ❌            | ✅    | ✅              |
| Environment loading  | ✅    | ❌           | ✅            | ✅    | ✅              |
| Zero install (Unix)  | ✅ ✅  | ✅           | ❌            | ❌    | ✅              |
| Cross-platform       | ⚠️   | ✅ ✅         | ✅            | ✅ ✅  | ⚠️             |
| Learning curve       | ⚠️   | ✅ ✅         | ⚠️           | ✅    | ✅              |
| Community knowledge  | ✅ ✅  | ✅ ✅         | ⚠️           | ❌    | N/A            |
| CI/CD native support | ✅ ✅  | ✅           | ⚠️           | ⚠️   | ✅              |

**Legend**: ✅ ✅ = Excellent, ✅ = Good, ⚠️ = Acceptable with caveats, ❌ = Poor

## Implementation

### Layer Architecture

The orchestration system is implemented as **Layer 4** in the [3-layer versioning architecture](./versioning-system.md):

```
Layer 1: Templates          (.changelog-templates/)
Layer 2: Behavior Config    (.versionrc.js)
Layer 3: Runtime Variables  (.env.dist / .env)
Layer 4: Orchestration      (Makefile)  ← THIS LAYER
```

### Key Techniques

#### 1. Environment Loading

```makefile
# Load .env if exists, otherwise .env.dist
ifneq (,$(wildcard .env))
    include .env
    ENV_FILE_LOADED := .env
else ifneq (,$(wildcard .env.dist))
    include .env.dist
    ENV_FILE_LOADED := .env.dist
else
    $(error No .env or .env.dist found)
endif
```

#### 2. Command Construction

```makefile
# Construct versioned command
NODE_RELEASE_PACKAGE ?= commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION ?= 12.4.4

CMD := npx $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION)
```

#### 3. Dependency Validation

```makefile
check/deps:
	@command -v node >/dev/null || { echo "ERROR: Node.js not found"; exit 1; }
	@command -v npx >/dev/null || { echo "ERROR: npx not found"; exit 1; }

release: check/deps
	@$(CMD)
```

#### 4. Self-Documenting Targets

```makefile
help:  ## Show this help
	@grep -E '^[a-zA-Z_/-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	  awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

### File Structure

```
project/
├── Makefile              # Layer 4: Orchestration
├── .env.dist             # Layer 3: Default config (committed)
├── .env                  # Layer 3: Local overrides (gitignored)
├── .versionrc.js         # Layer 2: Behavior config
└── .changelog-templates/ # Layer 1: Templates
```

## Examples

### Example 1: Tool Migration (npx → bun)

**Scenario**: Migrate from npm/npx to Bun for faster execution

**Step 1: Update .env.dist**

```diff
- NODE_RELEASE_PACKAGE_MANAGER := npx
+ NODE_RELEASE_PACKAGE_MANAGER := bunx
```

**Step 2: Update Makefile**

```diff
- CMD := npx $(NODE_RELEASE_PACKAGE)@$(VERSION)
+ CMD := $(NODE_RELEASE_PACKAGE_MANAGER) $(NODE_RELEASE_PACKAGE)@$(VERSION)
```

**Files changed**: 2 (`.env.dist`, `Makefile`)
**Workflows changed**: 0
**CI/CD changed**: 0
**Documentation changed**: 0

**Developer workflow**:

```bash
make release  # Now uses bun instead of npx
# Output identical, implementation different
```

### Example 2: Local Experimentation

**Scenario**: Test pre-release version of commit-and-tag-version

**Developer action**:

```bash
# Create local override
cat > .env << 'EOF'
NODE_RELEASE_PACKAGE_VERSION := 13.0.0-beta.1
EOF

# Test with beta version
make release/dry-run
# Uses commit-and-tag-version@13.0.0-beta.1

# Satisfied? Commit to .env.dist
# Not satisfied? Delete .env, back to defaults
```

**Team impact**: Zero (`.env` is gitignored)

### Example 3: CI/CD Consistency

**Local workflow**:

```bash
make test
make lint
make release
```

**GitHub Actions workflow**:

```yaml
name: Release
on:
  push:
    branches: [ main ]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4

      - name: Run tests
        run: make test

      - name: Lint
        run: make lint

      - name: Create release
        run: make release
```

**Same commands**, same results, guaranteed consistency.

### Example 4: Multi-Tool Project

**Scenario**: Project uses Node.js (releases), Python (docs), Docker (deploy)

**Makefile**:

```makefile
release: check/deps/node
	@npx commit-and-tag-version@12.4.4

docs: check/deps/python
	@python -m mkdocs build

deploy: check/deps/docker
	@docker build -t app:$(VERSION) .
	@docker push app:$(VERSION)

check/deps/node:
	@command -v node >/dev/null || { echo "ERROR: Node.js required"; exit 1; }

check/deps/python:
	@command -v python >/dev/null || { echo "ERROR: Python required"; exit 1; }

check/deps/docker:
	@command -v docker >/dev/null || { echo "ERROR: Docker required"; exit 1; }
```

**Developer workflow**:

```bash
make help     # Discover all capabilities
make docs     # Uses Python (hidden from user)
make release  # Uses Node.js (hidden from user)
make deploy   # Uses Docker (hidden from user)
```

**Benefit**: Unified interface despite heterogeneous tools.

## Future Evolution

### Planned Capabilities

As documented in `docs/conventions/makefile.md`, the Makefile will expand to orchestrate:

**v0.2.0+**:

- Test orchestration (`make test`, `make test/unit`, `make test/integration`)
- Linting (`make lint`, `make format`)

**v0.3.0+**:

- Build automation (`make build`)
- Documentation generation (`make docs`)

**v1.0.0+**:

- Deployment workflows (`make deploy/staging`, `make deploy/prod`)
- Performance benchmarks (`make bench`)

### Extension Points

**Add new target**:

```makefile
.PHONY: custom-task
custom-task:  ## Description shown in help
	@echo "Executing custom task"
	@# Your commands here
```

**Add new dependency check**:

```makefile
check/deps/mytool:
	@command -v mytool >/dev/null || { echo "ERROR: mytool required"; exit 1; }

my-target: check/deps/mytool
	@mytool execute
```

## References

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Makefile Tutorial](https://makefiletutorial.com/)
- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [12-Factor App: Dev/prod parity](https://12factor.net/dev-prod-parity)

## Related Documentation

- [Makefile Usage Guide](../conventions/makefile.md) - How to use the Makefile
- [Versioning System Architecture](./versioning-system.md) - 3-layer architecture details
- [Release Workflow](../conventions/releases.md) - Complete release process
