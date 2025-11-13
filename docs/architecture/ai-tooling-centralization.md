# AI Tooling Centralization Architecture

**Status**: Accepted

**Date**: 2025-11-12

**Deciders**: Jose R. Prieto

**Context**: AI Diagrams Toolkit v0.2.0

**Acknowledgment**: Technical approach inspired by Codely's AI workshop

---

## Decision

Centralize ALL AI tooling in a single `.ai/` directory and use **symlinks** to integrate with different AI assistants, rather than duplicating files in each tool's expected location.

## Problem Statement

Different AI coding assistants expect configuration files in different locations:

- **Claude Code**: Looks for `.claude/commands/`, `.claude/skills/`, `.claude/subagents/`
- **Cursor**: Looks for `.cursor/commands/`
- **Other tools**: May have their own conventions (e.g., `.copilot/`, `.cody/`)

### Challenges

1. **File duplication**: Maintaining identical commands in `.claude/` AND `.cursor/` leads to:
   - Synchronization issues
   - Update errors (forgetting to update one copy)
   - Version drift between copies
2. **No single source of truth**: Which is the canonical version?
3. **Scalability**: Each new AI tool adds another directory to maintain
4. **Testing complexity**: Which version do tests validate?

## Solution: Centralization + Symlinks

### Directory Structure

```
ai-diagrams-toolkit/
├── .ai/                           # ← Single source of truth
│   ├── AGENTS.md                  # Universal AI instructions
│   ├── commands/                  # Slash commands (universal)
│   │   ├── create-flowchart.md
│   │   ├── create-sequence.md
│   │   ├── apply-colors.md
│   │   └── validate-diagram.md
│   ├── skills/                    # Claude Code only (future)
│   └── subagents/                 # Claude Code only (future)
│
├── AGENTS.md -> .ai/AGENTS.md     # Symlink for universal access
├── CLAUDE.md -> .ai/AGENTS.md     # Symlink for Claude Code
│
├── .claude/                       # Claude Code integration
│   └── commands/ -> ../.ai/commands/
│
└── .cursor/                       # Cursor integration
    └── commands/ -> ../.ai/commands/
```

### Key Principle

> **One canonical source** (`.ai/`) with **tool-specific symlinks** for compatibility.

## Rationale

### 1. Single Source of Truth

- **ALL** AI tooling lives in `.ai/`
- **ONE** place to update commands
- **ZERO** risk of version drift
- **CLEAR** which version is canonical

### 2. Tool Agnostic

- Adding support for new AI tool = create one symlink
- No file duplication
- No synchronization logic needed
- Compatible with any tool that follows conventions

### 3. Testing Clarity

- Tests reference `.ai/commands/` directly
- No ambiguity about which version is being tested
- Symlinks ensure production = test

### 4. Repository Cleanliness

```bash
# Without centralization (bad)
.claude/commands/create-flowchart.md     # 100 lines
.cursor/commands/create-flowchart.md     # 100 lines (duplicate!)
# Total: 200 lines, 2 files to maintain

# With centralization (good)
.ai/commands/create-flowchart.md         # 100 lines (source)
.claude/commands/ -> ../.ai/commands/    # symlink (4 bytes)
.cursor/commands/ -> ../.ai/commands/    # symlink (4 bytes)
# Total: 100 lines, 1 file to maintain
```

### 5. Git-Friendly

- Symlinks are tracked in git
- Cross-platform compatible (Unix/Linux/macOS/Windows with symlink support)
- Clear intent in `git log` (symlink creation = integration added)

## Implementation

### Creating Symlinks

```bash
# Root-level symlinks
ln -s .ai/AGENTS.md AGENTS.md        # Universal access
ln -s .ai/AGENTS.md CLAUDE.md        # Claude Code compatibility

# Tool-specific symlinks
mkdir -p .claude
ln -s ../.ai/commands .claude/commands

mkdir -p .cursor
ln -s ../.ai/commands .cursor/commands
```

### Verifying Symlinks

```bash
# Check symlink targets
ls -la CLAUDE.md
# lrwxr-xr-x  CLAUDE.md -> .ai/AGENTS.md

ls -la .claude/commands
# lrwxr-xr-x  .claude/commands -> ../.ai/commands
```

### Cross-Platform Compatibility

**Unix/Linux/macOS**: Native symlink support ✅

**Windows**:
- Modern Git for Windows: Supports symlinks ✅
- Requires `core.symlinks = true` in git config
- Alternative: Junction points (fallback)

## Benefits

### For Maintainers

- ✅ Update commands ONCE in `.ai/commands/`
- ✅ Changes immediately available to ALL tools
- ✅ Clear ownership: `.ai/` is the source
- ✅ Easy to add new AI tool support

### For Contributors

- ✅ Clear where to find AI tooling (`.ai/` directory)
- ✅ No confusion about which file to edit
- ✅ PRs modify one file, not multiple copies
- ✅ Reduced merge conflicts

### For Users

- ✅ Works with Claude Code AND Cursor out of the box
- ✅ Future AI tools: just add symlink
- ✅ No duplicate downloads (symlinks are tiny)

## Trade-offs

### Advantages

✅ Single source of truth
✅ Zero duplication
✅ Scalable to new tools
✅ Git-friendly
✅ Clear testing

### Disadvantages

❌ Requires symlink support (rare issue on old Windows)
❌ Slightly more complex initial setup
❌ Users unfamiliar with symlinks may be confused

**Verdict**: Advantages massively outweigh disadvantages. Symlink support is ubiquitous in modern development environments.

## Consequences

### Positive

- **Maintainability**: Updating AI commands becomes trivial
- **Scalability**: Adding support for new AI tools is one symlink
- **Clarity**: Repository structure clearly shows integration points
- **Quality**: Impossible to have version drift between tools

### Negative

- **Education**: Need to document symlink approach for contributors
- **Windows**: May need guidance for legacy Windows users (rare)

### Mitigation

- Document symlink creation in `CONTRIBUTING.md`
- Add verification step to `make check/deps`
- Provide fallback instructions for Windows legacy

## Alternatives Considered

### Alternative 1: Duplication

**Approach**: Maintain separate copies in `.claude/` and `.cursor/`

**Rejected because**:
- Synchronization burden
- Version drift risk
- Doesn't scale
- More files to review in PRs

### Alternative 2: Build Step

**Approach**: Generate tool-specific files from `.ai/` during build

**Rejected because**:
- Requires build tooling
- Generated files clutter git
- Harder to debug (source vs generated)
- Overkill for simple use case

### Alternative 3: npm Package

**Approach**: Publish `.ai/` as npm package, tools import it

**Rejected because**:
- This is not a Node.js project
- Adds unnecessary dependency
- Symlinks are simpler
- Over-engineering

## Examples

### Adding Support for New Tool

Hypothetical: Adding support for "Cody" (Sourcegraph)

```bash
# One command
mkdir -p .cody
ln -s ../.ai/commands .cody/commands

# Done! Cody now has access to all 4 commands
```

### Updating a Command

```bash
# Edit ONE file
vim .ai/commands/create-flowchart.md

# Automatically available in:
# - .claude/commands/create-flowchart.md
# - .cursor/commands/create-flowchart.md
# - .cody/commands/create-flowchart.md (if exists)
```

## Future Considerations

### Skills and Subagents (v0.3.0+)

Claude Code supports additional AI tooling:

- **Skills**: `.claude/skills/` (auto-activation)
- **Subagents**: `.claude/subagents/` (multi-turn conversations)

**Strategy**: Follow same centralization pattern

```
.ai/
├── commands/        # Universal
├── skills/          # Claude Code exclusive (not symlinked to Cursor)
└── subagents/       # Claude Code exclusive

.claude/
├── commands/ -> ../.ai/commands/
├── skills/ -> ../.ai/skills/
└── subagents/ -> ../.ai/subagents/

.cursor/
└── commands/ -> ../.ai/commands/  # Only universal commands
```

## References

### Inspiration

- **Codely AI Workshop**: Technical approach for AI tool centralization with symlinks
  - Workshop demonstrated benefits of single source of truth
  - Shared best practices for multi-tool AI integration
  - Credit: Codely team for pattern innovation

### External Documentation

- [Symbolic Links (Wikipedia)](https://en.wikipedia.org/wiki/Symbolic_link)
- [Git Symlinks Support](https://git-scm.com/docs/git-symbolic-ref)
- [Claude Code Documentation](https://docs.anthropic.com/claude/docs/claude-code)
- [Cursor Documentation](https://cursor.sh/docs)

### Internal Documentation

- [AI CLI Abstraction Proposal](../proposals/001-multi-cli-support.md) - Future multi-executor support
- [Testing Strategy](./testing-strategy.md) - How tests validate universal commands

---

**Decision Impact**: High - Affects all AI tooling integration, testing, and future extensibility.

**Reversibility**: Medium - Can revert to duplication, but would lose all benefits.

**Confidence**: High - Pattern proven in Codely workshop, scales well.
