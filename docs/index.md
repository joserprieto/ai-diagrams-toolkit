# AI Diagrams Toolkit - Documentation Index

_Last Updated: 2025-11-12 | Version: 1.0.0_

Welcome to the AI Diagrams Toolkit documentation hub. This page provides navigation to all project documentation organized by topic and role.

---

## 🚀 Quick Start

New here? Start with one of these paths based on your role:

### I'm a Developer

1. Read [Development Guide](./development/index.md) for setup and workflows
2. Follow [Conventions](./conventions/index.md) for coding standards
3. Check [Testing Guide](./development/testing-guide.md) before contributing

### I'm Adding AI Commands

1. Read [Multiagent Approach](./multiagent-approach/index.md) to understand the system
2. Run `make commands/install` to setup symlinks
3. Follow command templates in `.ai/commands/generic/`
4. Test with your AI assistant (Claude Code / Cursor)

### I'm Making Architectural Changes

1. Review [Architecture Decisions](./architecture/index.md) to understand current design
2. Read relevant ADRs before proposing changes
3. Create new ADR in `architecture/` following existing format
4. Update relevant conventions

### I'm Releasing

1. Follow [Release Workflow](./conventions/releases.md) step-by-step
2. Use `make release/dry-run` to preview
3. Execute `make release` to create release
4. Push with `git push --follow-tags origin main`

---

## 📂 Documentation Structure

### Core Documentation

#### [Architecture](./architecture/index.md)

Design decisions and system architecture documentation.

**Key documents**:
- [Versioning System](./architecture/versioning-system.md) - 3-layer automated release architecture
- [Orchestration Decision](./architecture/orchestration.md) - Why Makefile as main orchestrator
- [Testing Strategy](./architecture/testing-strategy.md) - Hybrid testing approach rationale
- [AI Tooling Centralization](./architecture/ai-tooling-centralization.md) - Symlink approach for multi-tool support
- [Makefile Design Decisions](./architecture/makefile-design-decisions.md) - Variable naming and fail-fast principles

**Audience**: Maintainers, architects, contributors making structural changes

---

#### [Conventions](./conventions/index.md)

Coding standards, guidelines, and project rules.

**Key documents**:
- [Commits](./conventions/commits.md) - Conventional Commits specification
- [CHANGELOG](./conventions/changelog.md) - CHANGELOG automation and formatting
- [Versioning](./conventions/versioning.md) - Semantic Versioning strategy
- [Releases](./conventions/releases.md) - Complete release workflow
- [Makefile](./conventions/makefile.md) - Makefile usage and configuration
- [Shell Scripting](./conventions/shell-scripting.md) - Shell script standards and namespace conventions
- [Documentation](./conventions/documentation.md) - Documentation file naming and structure

**Audience**: All contributors, developers, maintainers

---

#### [Development](./development/index.md)

Developer workflows, guides, and setup instructions.

**Key documents**:
- [Testing Guide](./development/testing-guide.md) - How to write and execute tests
- [Script Development](./development/script-development.md) - TDD approach for shell scripts
- [Setup Guide](./development/setup-guide.md) - Development environment setup _(Coming soon)_

**Audience**: Contributors, new developers, testers

---

### Extended Documentation

#### [Multiagent Approach](./multiagent-approach/index.md)

AI assistant integration with multi-tool command support.

**Key documents**:
- [Multiagent Approach](./multiagent-approach/index.md) - Cross-platform command system
- [Installation Critique](./multiagent-approach/installation-approach-critique.md) - Critical analysis of symlink approach

**Key features**:
- Cross-platform command system (Claude Code, Cursor, Codex CLI)
- Centralized `.ai/commands/` with symlinks
- Portable generic commands + system-specific variants
- Installation via `make commands/install`

**Audience**: AI assistant users, multi-tool teams, maintainers

---

#### [Proposals](./proposals/index.md)

Future features, RFCs, and architectural enhancements.

**Active proposals**:
- [001: Multi-CLI Support](./proposals/001-multi-cli-support.md) - AI CLI abstraction layer (v0.4.0+)

**Audience**: Product owners, maintainers, long-term contributors

---

## 🎯 Documentation by Role

### Developer Onboarding

**Day 1**:
1. Read [README.md](../README.md) - Project overview
2. Run `make check/deps` - Verify dependencies
3. Read [Conventions](./conventions/index.md) - Learn standards

**Day 2**:
4. Read [Testing Guide](./development/testing-guide.md) - Testing approach
5. Run `make test/commands` - Execute automated tests
6. Try creating a simple diagram using slash commands

**Week 1**:
7. Read [Architecture](./architecture/index.md) - Understand system design
8. Explore codebase following conventions
9. Make first contribution (docs or templates)

---

### AI Command Developer

**Setup**:
1. Read [Multiagent Approach](./multiagent-approach/index.md) completely
2. Understand command categories (generic / claude / codex)
3. Run `make commands/install` to create symlinks
4. Verify with `make commands/verify`

**Development**:
5. Choose command category (start with generic)
6. Follow frontmatter conventions (hybrid format)
7. Use positional arguments (`$1`, `$ARGUMENTS`) for portability
8. Test with your AI assistant

**Testing**:
9. Add test case in `tests/commands/`
10. Run `make commands/test` to verify
11. Document in command file

---

### Architect / Maintainer

**Understanding System**:
1. Read [Architecture Documentation](./architecture/index.md) completely
2. Study [Versioning System](./architecture/versioning-system.md) - Core automation
3. Review [Testing Strategy](./architecture/testing-strategy.md) - Quality approach

**Making Changes**:
4. Review relevant ADRs before changing architecture
5. Create new ADR for significant decisions
6. Update conventions documentation
7. Communicate changes to team

**Maintaining Quality**:
8. Review PRs against architecture decisions
9. Ensure tests pass before merging
10. Update documentation when merging features

---

### Release Manager

**Preparation**:
1. Read [Release Workflow](./conventions/releases.md) - Complete process
2. Understand [Versioning Strategy](./conventions/versioning.md) - SemVer rules
3. Review [CHANGELOG Conventions](./conventions/changelog.md) - Formatting

**Execution**:
4. Verify `git status` is clean
5. Run `make release/dry-run` - Preview release
6. Execute `make release` - Create release
7. Verify: `cat .semver`, `git log -1`, `git tag`
8. Push: `git push --follow-tags origin main`

**Troubleshooting**:
9. Check [Releases Guide](./conventions/releases.md#troubleshooting)
10. Verify [Makefile Config](./conventions/makefile.md#configuration)

---

## 📖 Key Documents Reference

| Document | Purpose | Priority | Audience |
|----------|---------|----------|----------|
| [Multiagent Approach](./multiagent-approach/index.md) | AI assistant integration | 🔴 High | AI users |
| [Testing Guide](./development/testing-guide.md) | How to write tests | 🔴 High | Contributors |
| [Releases Guide](./conventions/releases.md) | Release workflow | 🔴 High | Maintainers |
| [Makefile Guide](./conventions/makefile.md) | Orchestration usage | 🟡 Medium | All |
| [Versioning System](./architecture/versioning-system.md) | 3-layer architecture | 🟡 Medium | Architects |
| [Shell Scripting](./conventions/shell-scripting.md) | Script standards | 🟡 Medium | Script developers |
| [Testing Strategy](./architecture/testing-strategy.md) | Testing rationale | 🟢 Low | Architects |
| [Commits Guide](./conventions/commits.md) | Commit format | 🟢 Low | Contributors |

---

## 🗺️ Documentation Map

```
docs/
├── index.md (YOU ARE HERE)
│
├── conventions/           # Standards and guidelines
│   ├── index.md          # Hub
│   ├── commits.md        # Conventional Commits spec
│   ├── changelog.md      # CHANGELOG automation
│   ├── versioning.md     # SemVer strategy
│   ├── releases.md       # Release workflow
│   ├── makefile.md       # Makefile orchestration
│   ├── shell-scripting.md # Shell script standards
│   └── documentation.md  # Documentation conventions
│
├── architecture/          # Design decisions
│   ├── index.md          # Hub
│   ├── versioning-system.md # 3-layer architecture
│   ├── orchestration.md     # Makefile rationale
│   ├── testing-strategy.md  # Hybrid testing
│   ├── makefile-design-decisions.md # Design choices
│   ├── ai-tooling-centralization.md # Symlink approach
│   └── script-organization.md # bin/ vs lib/ rationale
│
├── development/           # Developer guides
│   ├── index.md          # Hub
│   ├── testing-guide.md  # Test writing
│   └── script-development.md # Script TDD guide
│
├── multiagent-approach/   # AI integration
│   ├── index.md          # Main guide
│   └── installation-approach-critique.md # Analysis
│
└── proposals/             # Future enhancements
    ├── index.md          # Hub
    └── 001-multi-cli-support.md # CLI abstraction
```

---

## 🔍 Finding Information

### By Topic

**Release Management**:
→ [Releases Guide](./conventions/releases.md)
→ [Versioning System](./architecture/versioning-system.md)
→ [CHANGELOG Guide](./conventions/changelog.md)

**Testing**:
→ [Testing Guide](./development/testing-guide.md)
→ [Testing Strategy](./architecture/testing-strategy.md)
→ [Script Testing](./conventions/shell-scripting.md#testing)

**AI Commands**:
→ [Multiagent Approach](./multiagent-approach/index.md)
→ [Command Installation](./multiagent-approach/index.md#installation)
→ [Compatibility Matrix](./multiagent-approach/index.md#compatibility-matrix)

**Scripts**:
→ [Shell Scripting Conventions](./conventions/shell-scripting.md)
→ [Script Organization](./architecture/script-organization.md)
→ [Script Development Guide](./development/script-development.md)

**Makefile**:
→ [Makefile Conventions](./conventions/makefile.md)
→ [Makefile Design](./architecture/makefile-design-decisions.md)
→ [Orchestration Decision](./architecture/orchestration.md)

---

## 🔗 External References

### Project Files

- [Project README](../README.md) - Main project overview
- [CHANGELOG](../CHANGELOG.md) - Version history
- [CONTRIBUTING](../CONTRIBUTING.md) - Contributing guidelines
- [ROADMAP](../ROADMAP.md) - Feature roadmap

### Specifications

- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message spec
- [Keep a Changelog](https://keepachangelog.com/) - CHANGELOG format
- [Semantic Versioning](https://semver.org/) - Versioning spec
- [Mermaid Documentation](https://mermaid.js.org/) - Diagram syntax

### Tools

- [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version) - Release automation
- [GNU Make Manual](https://www.gnu.org/software/make/manual/) - Makefile reference
- [Bash Manual](https://www.gnu.org/software/bash/manual/) - Shell scripting

---

## 📊 Documentation Coverage

| Topic | Status | Last Updated | Completeness |
|-------|--------|--------------|--------------|
| Conventions | ✅ Complete | 2025-11-12 | 100% |
| Architecture | ✅ Complete | 2025-11-12 | 95% |
| Development | ⚠️ Partial | 2025-11-12 | 60% |
| Multiagent | ✅ Complete | 2025-11-12 | 100% |
| Proposals | ✅ Active | 2025-11-12 | N/A |

**Legend**: ✅ Complete | ⚠️ Partial | ❌ Missing

---

## 🆘 Need Help?

### Common Questions

**Q: How do I create a release?**
A: Read [Releases Guide](./conventions/releases.md), then run `make release`

**Q: What commit format should I use?**
A: Read [Commits Guide](./conventions/commits.md) - Use Conventional Commits

**Q: How do I add AI commands?**
A: Read [Multiagent Approach](./multiagent-approach/index.md), run `make commands/install`

**Q: How do I write tests?**
A: Read [Testing Guide](./development/testing-guide.md) for command tests, [Script Development](./development/script-development.md) for script tests

**Q: What's the namespace convention for scripts?**
A: Read [Shell Scripting Conventions](./conventions/shell-scripting.md) - Use `adt::` namespace

### Can't Find What You Need?

1. Check section indexes ([Conventions](./conventions/index.md), [Architecture](./architecture/index.md), [Development](./development/index.md))
2. Search this repository for keywords
3. Check [Project README](../README.md) for general overview
4. Open an issue with label `documentation`

---

## 🎯 Documentation Principles

This documentation follows these principles:

1. **Hub-and-Spoke** - Each section has an index linking to detailed docs
2. **Role-Based** - Quick starts organized by user role
3. **Examples First** - Copy-paste ready examples in every guide
4. **Cross-Referenced** - Related docs linked in footers
5. **External Links** - Official specs referenced with URLs
6. **Versioned** - Last updated dates on all documents
7. **Semantic Naming** - `index.md` for navigation, descriptive names for content

---

## 📝 Contributing to Documentation

### Adding New Documents

1. Create document in appropriate section
2. Follow [Documentation Conventions](./conventions/documentation.md)
3. Add link to section's `index.md`
4. Cross-reference from related docs
5. Update this `docs/index.md` if it's a key document

### Updating Existing Documents

1. Update content following conventions
2. Update "Last Updated" date
3. Check all links still work
4. Verify examples are current
5. Commit with `docs:` prefix

---

_Navigate with confidence. All documentation is interconnected and cross-referenced._
