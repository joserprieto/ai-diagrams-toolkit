# Makefile Orchestration

Complete guide to using the Makefile as the **main entrypoint and orchestrator** for all project automation.

## 🎯 Overview

This project uses **GNU Make** as the **main entrypoint and orchestrator** for all project automation.

**Why this approach?** The Makefile provides:

- ✅ **Implementation abstraction** - Hide tool details (npx/bun/python) behind semantic commands
- ✅ **Single point of entry** - Same commands work locally and in CI/CD
- ✅ **Tool-agnostic interface** - Change tools without breaking workflows
- ✅ **Dependency validation** - Check requirements before execution
- ✅ **Configuration as code** - Version-controlled defaults, local overrides

For the complete architectural rationale and design decisions,
see [Orchestration Architecture Decision](../architecture/orchestration.md).

**Current capabilities** (v0.1.0):

- Release management (versioning, CHANGELOG, tagging)
- Configuration validation
- Dependency checks
- Cleanup tasks

**Planned capabilities** (future releases):

- Test orchestration (unit, integration, e2e)
- Build automation
- Deployment workflows
- Documentation generation
- Linting and formatting

## 📐 Architecture Position

The Makefile is **Layer 4 (Orchestration)** in
the [3-layer versioning architecture](../architecture/versioning-system.md):

```
Layer 1: Templates (.changelog-templates/)
    ↓
Layer 2: Behavior Config (.versionrc.js)
    ↓
Layer 3: Runtime Variables (.env.dist / .env)
    ↓
Layer 4: Orchestration (Makefile) ← YOU ARE HERE
```

**Role**: Loads configuration, executes tools with correct parameters, provides semantic targets.

## 🎮 Primary Targets

### Help and Information

```bash
# Show all available targets with descriptions
make help
```

**Output**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AI Diagrams Toolkit - Available Targets
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  help              Show this help message
  clean             Clean temporary files
  release           Create new release (auto-detect version)
  release/dry-run   Preview release without creating
  ...
```

### Release Management

```bash
# Preview what will happen (recommended first step)
make release/dry-run

# Create release (auto-detects version bump)
make release

# Force specific version bump
make release/patch   # 0.1.0 → 0.1.1
make release/minor   # 0.1.0 → 0.2.0
make release/major   # 0.1.0 → 1.0.0
```

**What happens**:

1. Loads configuration from `.env` (or `.env.dist` if no `.env`)
2. Analyzes commits since last tag
3. Calculates version bump (MAJOR/MINOR/PATCH)
4. Updates `.semver` file
5. Generates CHANGELOG section
6. Creates git commit and tag

### Configuration

```bash
# Show current configuration
make check/config
```

**Output**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Current Configuration
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Environment:
  Loaded from: .env.dist

Project:
  Name: AI Diagrams Toolkit
  Version: 0.1.0

Release Tooling:
  Package: commit-and-tag-version
  Version: 12.4.4
  Config: .versionrc.js

Tips:
  • Create .env to override .env.dist settings
  • Run 'make check/deps' to verify dependencies
```

### Dependency Management

```bash
# Check if required tools are installed
make check/deps
```

Verifies:

- Node.js installation
- `npx` availability
- `commit-and-tag-version` version

### Cleanup

```bash
# Remove temporary files
make clean
```

Removes:

- `node_modules/`
- `.DS_Store` files
- Other temporary artifacts

## 🔧 Configuration System

### Environment Files (Layer 3)

The Makefile loads configuration from **Layer 3: Runtime Variables**:

```
.env.dist    ← Committed defaults (version-controlled)
.env         ← Local overrides (gitignored, optional)
```

**Loading priority**:

1. Check for `.env` (local overrides)
2. If not found, use `.env.dist` (defaults)
3. Error if neither exists

**Example `.env.dist`**:

```makefile
# ── Release Tool Configuration ────────────────────────────────
NODE_RELEASE_PACKAGE := commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION := 12.4.4
NODE_RELEASE_CONFIG := .versionrc.js
```

**Local override example** (create `.env`):

```makefile
# Test with different tool version
NODE_RELEASE_PACKAGE_VERSION := 13.0.0
```

### Configuration Variables

Key variables loaded from environment files:

| Variable                       | Default                  | Description                    |
|--------------------------------|--------------------------|--------------------------------|
| `NODE_RELEASE_PACKAGE`         | `commit-and-tag-version` | npm package for releases       |
| `NODE_RELEASE_PACKAGE_VERSION` | `12.4.4`                 | Pinned version (reproducible)  |
| `NODE_RELEASE_CONFIG`          | `.versionrc.js`          | Behavior config file (Layer 2) |

### How It Works

When you run `make release`:

1. **Load environment** (`.env` or `.env.dist`)
2. **Construct command**: `npx commit-and-tag-version@12.4.4`
3. **Tool reads config**: `.versionrc.js` (Layer 2)
4. **Config loads templates**: `.changelog-templates/` (Layer 1)
5. **Execute release**: Update files, create commit, create tag

## 🎯 Common Workflows

### Creating a Release

```bash
# 1. Ensure clean working directory
git status

# 2. Review commits since last release
git log v0.1.0..HEAD --oneline

# 3. Preview release
make release/dry-run

# 4. Verify output looks correct
#    - Version bump is correct
#    - CHANGELOG section is accurate
#    - All commits are included

# 5. Create release
make release

# 6. Verify locally
cat .semver           # Check version
git log -1 --oneline  # Check commit
git tag               # Check tag

# 7. Push to GitHub
git push --follow-tags origin main
```

See [Releases Guide](./releases.md) for complete workflow.

### Testing Configuration Changes

```bash
# 1. Show current config
make check/config

# 2. Create local override
cat > .env << 'EOF'
NODE_RELEASE_PACKAGE_VERSION := 13.0.0
EOF

# 3. Verify override loaded
make check/config
# Should show: Version: 13.0.0

# 4. Test with dry-run
make release/dry-run

# 5. Remove override to restore defaults
rm .env
```

### Switching Release Tools

To switch from `commit-and-tag-version` to another tool:

```bash
# 1. Update .env.dist
vim .env.dist

# Change:
NODE_RELEASE_PACKAGE := standard-version
NODE_RELEASE_PACKAGE_VERSION := 9.5.0

# 2. Verify new config
make check/config

# 3. Test
make release/dry-run
```

**That's it!** No code changes needed, just configuration.

## 📊 Makefile Metadata

The Makefile tracks its own metadata:

```makefile
VERSION := $(shell cat .semver 2>/dev/null | head -n1 | tr -d '\n' || echo "0.0.0")
MAKEFILE_VERSION := $(VERSION)
MAKEFILE_DATE := 2025-11-10
MAKEFILE_AUTHOR := Jose R. Prieto
PROJECT_NAME := AI Diagrams Toolkit
```

- **VERSION**: Read from `.semver` (single source of truth)
- **MAKEFILE_DATE**: Last significant update to Makefile
- **PROJECT_NAME**: Used in colored output headers

## 🎨 Output Formatting

The Makefile provides professional colored output:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Creating Release
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Using commit-and-tag-version@12.4.4
ℹ Config: .versionrc.js
✔ bumping version in .semver from 0.1.0 to 0.2.0
✔ outputting changes to CHANGELOG.md
✔ committing .semver and CHANGELOG.md
✔ tagging release v0.2.0
✔ Release created!

ℹ Run 'git push --follow-tags' to publish
```

Features:

- Color-coded messages (info, success, warning, error)
- Unicode box-drawing characters
- Clear visual hierarchy
- Actionable next steps

## ⚙️ Advanced Usage

### Custom Targets

Add your own targets to the Makefile:

```makefile
# Add at the end of Makefile
.PHONY: my-target
my-target:  ## Description of my target
	@echo "Executing custom target"
	@# Your commands here
```

Target will appear in `make help` automatically.

### Debugging

```bash
# Show what Make is doing
make -n release       # Dry-run (show commands, don't execute)
make release --debug  # Verbose debug output

# Show variable values
make -p | grep NODE_RELEASE
```

### Environment Variables

Override at runtime:

```bash
# Use different config file
NODE_RELEASE_CONFIG=.versionrc.custom.js make release/dry-run

# Use different tool version
NODE_RELEASE_PACKAGE_VERSION=13.0.0 make release/dry-run
```

## 🐛 Troubleshooting

### "No .env or .env.dist found"

**Problem**: Neither environment file exists

**Solution**:

```bash
# Check files exist
ls -la .env .env.dist

# If .env.dist missing, restore from git
git checkout .env.dist
```

### "command not found: npx"

**Problem**: Node.js not installed

**Solution**:

```bash
# Install Node.js (macOS with Homebrew)
brew install node

# Verify
npx --version
```

### "Config file not found: .versionrc.js"

**Problem**: Behavior config missing

**Solution**:

```bash
# Check file exists
ls -la .versionrc.js

# Verify in check/config
make check/config
```

### Make targets not working

**Problem**: GNU Make version incompatibility

**Solution**:

```bash
# Check Make version
make --version

# Should be GNU Make 3.81+
# On macOS, system make is GNU Make
```

## 📖 Related Documentation

- [Releases Guide](./releases.md) - Complete release workflow
- [Versioning Guide](./versioning.md) - Semantic versioning strategy
- [Versioning System Architecture](../architecture/versioning-system.md) - Technical details of 3-layer architecture

## 🔗 External Resources

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Makefile Tutorial](https://makefiletutorial.com/)
- [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version)
