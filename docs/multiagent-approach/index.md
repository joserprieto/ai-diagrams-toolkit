# Multiagent Command Approach

_Version: 1.0.0 | Last Updated: 2025-11-12_

## 🎯 Overview

This project uses a **unified command structure** that works across multiple AI coding assistants:
- **Claude Code** (Anthropic CLI)
- **Cursor IDE** (AI-powered VS Code fork)
- **Codex CLI** (OpenAI terminal assistant)

Commands are centralized in `.ai/commands/` and symlinked to each system's expected location, enabling:
- ✅ **Single source of truth** for commands
- ✅ **Version control** without symlink issues
- ✅ **Easy maintenance** across multiple AI systems
- ✅ **Selective feature usage** (generic vs system-specific)

## 📂 Directory Structure

```
ai-diagrams-toolkit/
├── .ai/
│   └── commands/
│       ├── generic/              # Portable commands (work everywhere)
│       │   ├── create-flowchart.md
│       │   ├── create-sequence.md
│       │   ├── apply-colors.md
│       │   └── validate-diagram.md
│       │
│       ├── claude/               # Claude Code specific features
│       │   └── (bash execution, file refs)
│       │
│       └── codex/                # Codex CLI specific features
│           └── (named arguments)
│
├── .claude/
│   └── commands/                 # Symlink (created by install script)
│       ├── [generic commands]    # → ../../.ai/commands/generic/*
│       └── claude/               # → ../../.ai/commands/claude/
│
├── .cursor/
│   └── commands/                 # Symlink (created by install script)
│       └── [generic commands]    # → ../../.ai/commands/generic/*
│
├── docs/
│   └── multiagent-approach/      # This documentation
│
└── scripts/
    └── install-symlinks.sh       # Setup script
```

## 🚀 Quick Start

### Installation

Run the installation script to create all necessary symlinks:

```bash
make commands/install
```

This creates symlinks from AI system directories to `.ai/commands/`.

---

## 🖥️ Platform-Specific Setup

Installation varies by operating system due to symlink support differences.

### Unix / macOS / Linux

**Simple** - Native symlink support:

```bash
make commands/install
```

All systems work identically.

---

### Windows

Windows users have **3 options** (in order of recommendation):

#### Option 1: Git Bash (Recommended)

**Why**: Already installed with Git for Windows, includes `make` support, works identically to Unix.

**Setup**:
1. Install Git for Windows: https://git-scm.com/download/win (if not already installed)
2. Open **Git Bash** (not PowerShell, not CMD)
3. Navigate to project directory
4. Run: `make commands/install`

**Advantages**:
- ✅ Identical commands to Unix/macOS
- ✅ Full Makefile support (all targets work)
- ✅ No additional installation needed (comes with Git)
- ✅ Symlinks work natively

**This is the recommended approach for Windows users.**

---

#### Option 2: PowerShell Native (Launcher Script)

**Why**: Native Windows PowerShell without installing `make`.

**Setup**:
1. Open **PowerShell** (can be regular user, Administrator recommended for symlinks)
2. Navigate to project directory
3. Run: `.\run.ps1 commands/install`

**Note**: Symlink creation in PowerShell requires either:
- Administrator privileges, OR
- Developer Mode enabled (Settings → Privacy & Security → For developers → Developer Mode)

**Advantages**:
- ✅ Pure PowerShell (no Git Bash needed)
- ✅ Works out of the box (no `make` installation)
- ✅ Familiar to Windows PowerShell users

**Limitations**:
- ⚠️ Different command syntax (`.\run.ps1` vs `make`)
- ⚠️ Limited functionality (subset of Makefile targets)
- ⚠️ Requires Administrator or Developer Mode for symlinks

**Available commands in run.ps1**:
```powershell
.\run.ps1 commands/install      # Setup symlinks
.\run.ps1 commands/uninstall    # Remove symlinks
.\run.ps1 commands/verify       # Verify installation
.\run.ps1 release               # Create release
```

---

#### Option 3: Install make (Advanced)

**Why**: Get full Makefile functionality in native PowerShell.

**Setup via Package Manager**:

**Chocolatey**:
```powershell
choco install make
```

**Scoop**:
```powershell
scoop install make
```

**MSYS2**:
1. Install MSYS2: https://www.msys2.org/
2. Run: `pacman -S make`

**After installation**:
```bash
make commands/install
```

**Advantages**:
- ✅ Full Makefile support
- ✅ Identical commands across all platforms

**Limitations**:
- ⚠️ Requires additional installation step
- ⚠️ Package manager needed (Chocolatey/Scoop)

---

### Why make Doesn't Work in PowerShell

**GNU Make** is a Unix tool not included in Windows by default. PowerShell has different build tools (`PSake`, `Invoke-Build`).

**Solutions**:
1. **Use Git Bash** (already installed with Git, includes `make`)
2. **Use `run.ps1`** (PowerShell native launcher, no `make` needed)
3. **Install `make`** via package manager (advanced users)

**Recommended**: Git Bash (Option 1) provides best compatibility.

---

### Usage

**Claude Code**:
```bash
claude
/create-flowchart user authentication flow
```

**Cursor IDE**:
```
# In Cursor chat
/create-flowchart user authentication flow
```

**Codex CLI** (manual copy needed):
```bash
# One-time setup per command
cp .ai/commands/generic/create-flowchart.md ~/.codex/prompts/

# Usage
codex
/prompts:create-flowchart user authentication flow
```

## 📋 Command Categories

### Generic Commands (Portable)

Located in `.ai/commands/generic/`

**Characteristics**:
- ✅ Work on Claude Code, Cursor, and Codex
- ✅ Use only positional arguments (`$1`, `$2`, `$ARGUMENTS`)
- ✅ Natural language instructions (no bash/file refs)
- ✅ Hybrid frontmatter (compatible with all systems)

**Current commands**:
- `create-flowchart.md` - Generate Mermaid flowchart diagrams
- `create-sequence.md` - Generate Mermaid sequence diagrams
- `apply-colors.md` - Apply semantic color schemes
- `validate-diagram.md` - Validate diagram syntax and structure

### Claude Code Specific Commands

Located in `.ai/commands/claude/`

**Features available**:
- ✅ Bash execution with `!command` prefix
- ✅ File references with `@filename`
- ✅ Tool permissions via `allowed-tools`
- ✅ Model selection via `model` field

**Use cases**:
- Git operations (commit, log, diff)
- File system operations
- Test runners
- Build commands

**Example** (not yet implemented):
```markdown
---
description: "Summarize recent git commits"
allowed-tools: ["Bash(git log:*)", "Bash(git diff:*)"]
---

!git log --oneline -10

Analyze commits above and suggest next steps.
```

### Codex CLI Specific Commands

Located in `.ai/commands/codex/`

**Features available**:
- ✅ Named arguments (`$FILES`, `$TICKET_ID`, etc.)
- ✅ Positional arguments (`$1-$9`)
- ✅ Required frontmatter (description, argument-hint)

**Use cases**:
- Complex workflows with multiple parameters
- Draft PR automation
- Multi-file operations

**Example** (not yet implemented):
```markdown
---
description: "Create branch, commit, and draft PR"
argument-hint: "[FILES=<paths>] [PR_TITLE=\"<title>\"]"
---

1. Create feature branch
2. Stage files: $FILES
3. Commit with clear message
4. Open draft PR: $PR_TITLE
```

## 🔧 Frontmatter Convention

### Standard Format (Generic Commands)

```yaml
---
# Required for all systems
description: "Brief one-line description (80 chars max)"

# Recommended
argument-hint: "<arg1> <arg2> [optional]"

# Claude Code specific (ignored by Cursor/Codex)
allowed-tools: ["Bash(git:*)", "Read(src/**)"]
model: "claude-sonnet-4"
---
```

### Extended Format (Codex Commands)

```yaml
---
description: "Create branch, commit, and PR"
argument-hint: "[FILES=<paths>] [PR_TITLE=\"<title>\"] [TICKET=\"<id>\"]"
---

# Use named arguments
Files: $FILES
PR Title: $PR_TITLE
Ticket: $TICKET
```

### Field Reference

| Field | Claude Code | Cursor | Codex | Purpose |
|-------|-------------|--------|-------|---------|
| `description` | ✅ Uses | ❌ Ignores | ✅ **Required** | Shown in command popup |
| `argument-hint` | ✅ Uses | ❌ Ignores | ✅ Uses | Parameter documentation |
| `allowed-tools` | ✅ **Required** for bash | ❌ Ignores | ❌ Ignores | Permission control |
| `model` | ✅ Uses | ❌ Ignores | ❌ Ignores | Model selection |

## 🔄 Compatibility Matrix

### Argument Syntax

| Feature | Claude Code | Cursor | Codex | Generic? |
|---------|-------------|--------|-------|----------|
| `$1`, `$2`, `$3` | ✅ | ⚠️ Natural | ✅ | ✅ YES |
| `$ARGUMENTS` | ✅ | ⚠️ Natural | ✅ | ✅ YES |
| `$NAMED_ARGS` | ❌ | ❌ | ✅ | ❌ NO (Codex only) |
| Natural language | ⚠️ Manual | ✅ Native | ⚠️ Manual | ✅ YES |

### Advanced Features

| Feature | Claude Code | Cursor | Codex | Generic? |
|---------|-------------|--------|-------|----------|
| Frontmatter | ✅ Optional | ❌ Ignored | ✅ Required | ⚠️ Hybrid |
| `!bash` execution | ✅ | ❌ | ❌ | ❌ NO (Claude only) |
| `@file` references | ✅ | ❌ | ❌ | ❌ NO (Claude only) |
| Subdirectories | ✅ Yes | ❌ No | ❌ No | ❌ NO |
| Team sync | ⚠️ Via git | ✅ Dashboard | ❌ No | N/A |

## 📝 Writing Commands

### Best Practices

**✅ DO**:
1. **Start generic** - Default to `.ai/commands/generic/` unless you need system-specific features
2. **Use positional args** - `$1`, `$2`, `$ARGUMENTS` for maximum compatibility
3. **Natural language fallback** - Describe actions that work in Cursor
4. **Document limitations** - Comment when features are system-specific
5. **Hybrid frontmatter** - Include all fields, systems ignore what they don't need
6. **Clear descriptions** - One-line, under 80 chars, actionable

**❌ DON'T**:
1. **Don't use named args in generic** - `$FILES`, `$TICKET` only work in Codex
2. **Don't assume bash** - `!command` only works in Claude Code
3. **Don't rely on file refs** - `@filename` only works in Claude Code
4. **Don't create system-specific unnecessarily** - Only when generic limits usefulness
5. **Don't forget frontmatter** - Codex requires it, Claude benefits from it
6. **Don't use subdirectories** - Only top-level files work (Cursor/Codex limitation)

### Template: Generic Command

```markdown
---
description: "Brief description of what this command does"
argument-hint: "<required-arg> [optional-arg]"
allowed-tools: []
---

# Command Title

## Overview
Brief explanation of purpose and when to use this command.

## Arguments
- `$1` - Description of first argument
- `$2` - Description of second argument (optional)

## Instructions

1. First step with $1
2. Second step with $2
3. Final step

## Output Format

Describe expected output structure.

## Examples

**Basic usage**:
```
/command-name basic-value
```

**Advanced usage**:
```
/command-name value1 value2
```

## Notes

- Important consideration 1
- Important consideration 2
```

### Template: Claude-Specific Command

```markdown
---
description: "Brief description"
argument-hint: "<arg>"
allowed-tools: ["Bash(git:*)", "Read(src/**)"]
model: "claude-sonnet-4"
---

# Command Title

## Prerequisites
List required permissions or setup.

## Bash Commands
!git log --oneline -10
!git status

## File References
@src/main.ts
@README.md

## Instructions
Use bash output and file contents to...

## Important
This command uses Claude Code specific features:
- Bash execution (!)
- File references (@)
```

### Template: Codex-Specific Command

```markdown
---
description: "Brief description"
argument-hint: "[FILES=<paths>] [OPTION=\"<value>\"]"
---

# Command Title

## Named Arguments
- `$FILES` - File paths to process
- `$OPTION` - Configuration option
- `$TICKET` - Issue/ticket reference (optional)

## Instructions

Process files: $FILES
Apply option: $OPTION
${TICKET:+Reference ticket: $TICKET}

## Important
This command uses Codex CLI specific features:
- Named arguments ($VAR)
- Conditional expansion (${VAR:+text})
```

## 🔧 Installation Details

### What `make install` Does

1. **Creates `.claude/commands/` symlink**
   ```bash
   ln -sf ../../.ai/commands/generic .claude/commands
   ```
   - Points to generic commands
   - Creates `claude/` subdirectory symlink for Claude-specific commands

2. **Creates `.cursor/commands/` symlink**
   ```bash
   ln -sf ../../.ai/commands/generic .cursor/commands
   ```
   - Points only to generic commands (Cursor doesn't support subdirectories)

3. **Prints Codex instructions**
   - Codex uses global scope (`~/.codex/prompts/`)
   - Manual copy required on per-command basis
   - Instructions printed by install script

### Manual Setup (Alternative)

If you prefer manual setup:

```bash
# Claude Code
ln -sf ../../.ai/commands/generic .claude/commands
mkdir -p .claude/commands/claude
ln -sf ../../../.ai/commands/claude/* .claude/commands/claude/

# Cursor
ln -sf ../../.ai/commands/generic .cursor/commands

# Codex (per-command basis)
cp .ai/commands/generic/create-flowchart.md ~/.codex/prompts/
cp .ai/commands/codex/draftpr.md ~/.codex/prompts/
```

### Verifying Installation

```bash
# Check symlinks
ls -la .claude/commands
ls -la .cursor/commands

# Expected output:
# .claude/commands -> ../../.ai/commands/generic
# .cursor/commands -> ../../.ai/commands/generic

# Test commands
claude
> /create-flowchart
```

## 🐛 Troubleshooting

### Commands not appearing

**Claude Code / Cursor**:
- Verify symlinks: `ls -la .claude/commands`
- Restart IDE/CLI
- Check file permissions: `ls -l .ai/commands/generic/`

**Codex CLI**:
- Verify files in `~/.codex/prompts/`
- Restart Codex
- Check frontmatter is present

### Argument substitution not working

**Claude Code / Cursor**:
- Use positional args: `$1`, `$2`, `$ARGUMENTS`
- Avoid named args: `$FILES` (Codex only)

**Codex CLI**:
- Check frontmatter has `argument-hint`
- Use correct invocation: `/prompts:command-name PARAM=value`

### Bash commands not executing (Claude Code)

- Check `allowed-tools` in frontmatter
- Verify command prefix: `!git log` not `git log`
- Check permissions in `.claude/settings.json`

### Symlinks broken after git pull

- Run `make install` again
- Or manually recreate: `ln -sf ../../.ai/commands/generic .claude/commands`

## 📚 Further Reading

- [Frontmatter Convention](./frontmatter-convention.md) - Detailed field documentation
- [Command Compatibility](./command-compatibility.md) - System-specific limitations
- [Symlink Setup](./symlink-setup.md) - Advanced installation scenarios
- [Writing Effective Commands](./writing-commands.md) - Best practices guide

## 🔗 Related Documentation

- [Claude Code Slash Commands](https://code.claude.com/docs/en/slash-commands.md)
- [Cursor Commands](https://cursor.com/docs/agent/chat/commands)
- [Codex CLI Slash Commands](https://developers.openai.com/codex/guides/slash-commands/)

---

_Multiagent approach v1.0.0 - AI Diagrams Toolkit (2025-11-12)_
