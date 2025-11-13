# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0](https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.2.0) - 2025-11-13

> **AI Commands Release** - Universal slash commands for Claude Code and Cursor with automated testing infrastructure and comprehensive documentation.

### Added

#### 🤖 Universal AI Slash Commands

- **4 slash commands** for both Claude Code and Cursor ([0280f58](https://github.com/joserprieto/ai-diagrams-toolkit/commit/0280f580643f07f475f4b9dc72ee60ffd900b218)):
    - `/create-flowchart [description]` - Generate flowchart from natural language
    - `/create-sequence [description]` - Generate sequence diagram from description
    - `/apply-colors [file]` - Apply semantic color system to existing diagram
    - `/validate-diagram [file]` - Validate Mermaid syntax and conventions
- **Universal AGENTS.md** - Comprehensive AI instructions (390+ lines) with:
    - Semantic color system rules
    - Diagram type selection guide
    - Naming conventions (strict)
    - Critical pitfalls to avoid
    - Quality enforcement checklist
- **Symlinked integration** - `.claude/commands/` and `.cursor/commands/` point to `.ai/commands/generic/`

#### 🧪 Automated Testing Infrastructure

- **Self-contained test structure** - Each test is an executable directory with validation logic
- **Test runner** (`run-all.sh`) - Discovers and runs all tests with colored output
- **Makefile targets**:
    - `make test/commands` - Run all command tests
    - `make test/commands/single TEST=01-create-flowchart` - Run specific test
- **4 test suites** - Comprehensive coverage of all slash commands
- **10 golden masters** - Expected outputs for validation ([ddf7842](https://github.com/joserprieto/ai-diagrams-toolkit/commit/ddf7842398e7a1612faca341558fc939f573c3f2))

#### 📚 Enhanced Documentation

- **Architecture docs** - Testing strategy, Makefile design decisions ([fd70a71](https://github.com/joserprieto/ai-diagrams-toolkit/commit/fd70a7181b5d81b50aa431f2123e3ecacba5ed2f))
- **Development guide** - Practical testing guide with examples
- **Documentation hub** (`docs/index.md`) - Role-based navigation ([96f085c](https://github.com/joserprieto/ai-diagrams-toolkit/commit/96f085c2a38383a1e19fae70559471febb535a4b))
- **Shell scripting conventions** - TDD approach for scripts
- **Proposals system** - Future multi-CLI abstraction design

#### 🛠️ Configuration Improvements

- **Enhanced .env system** - Replace `.env.dist` with `.env.example` ([a996218](https://github.com/joserprieto/ai-diagrams-toolkit/commit/a996218f4878a9624853dd1fbbb84f1be5f47f73))
- **Makefile variable loading** - Improved configuration management

### Fixed

- **AGENTS.md:** Update to ensure English as default language for generated diagrams ([ae4ed33](https://github.com/joserprieto/ai-diagrams-toolkit/commit/ae4ed33e13616358ac0865335f305721ff23e847))
- **AI commands:** Correct command structure, docs, and add golden masters for v0.2.0 validation ([ddf7842](https://github.com/joserprieto/ai-diagrams-toolkit/commit/ddf7842398e7a1612faca341558fc939f573c3f2))
- **Makefile:** Correct help target to show command names instead of filename ([d24e244](https://github.com/joserprieto/ai-diagrams-toolkit/commit/d24e2444966eba84e95149f012cbec1daa4d345d))
- **Sequence diagrams:** Prevent deactivation inside alt/else blocks - comprehensive pitfall section added
- **Common pitfalls:** Enhanced guide with state diagram classDef section

### Documentation

- **Comprehensive documentation hub** - Created centralized docs/ with role-based navigation ([fd70a71](https://github.com/joserprieto/ai-diagrams-toolkit/commit/fd70a7181b5d81b50aa431f2123e3ecacba5ed2f))
- **Semantic clarity** - Migrated README.md to index.md in docs structure ([96f085c](https://github.com/joserprieto/ai-diagrams-toolkit/commit/96f085c2a38383a1e19fae70559471febb535a4b))
- **Architecture ADRs** - Makefile delegation pattern (Open/Closed Principle)
- **Testing strategy** - Hybrid testing rationale (783 lines)
- **Windows setup guide** - Git Bash, PowerShell, and make installation options

### Changed

- **Command structure** - Reorganized to `.ai/commands/{generic,claude,codex}/` for multi-CLI support
- **Test organization** - Moved legacy tests to `_legacy/` directory
- **Documentation structure** - Proposals moved to `docs/proposals/`, removed temporary `docs/fixes/`

---

## [0.1.0](https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.1.0) - 2025-11-11

> **First public release** - Production-ready Mermaid diagram toolkit with templates, guides, examples, and professional automation.

### Added

#### 🎨 Diagram Templates

- 4 Mermaid diagram templates with semantic color system:
    - **Flowchart template** - Processes, workflows, decision trees
    - **Sequence diagram template** - API interactions, system communications
    - **Class diagram template** - OOP structures, data models
    - **State diagram template** - State machines, lifecycles

#### 📚 Comprehensive Guides (`/guides/mermaid/`)

- **Flowchart guide** - Shape reference and styling
- **Sequence diagram guide** - Interaction patterns
- **Class diagram guide** - Relationships and stereotypes
- **Common pitfalls guide** - Reserved keywords, special characters, fixes
- README index for guides

#### 💡 Real-World Examples (`/examples/`)

- Critical system monitoring architecture
- Business process (order fulfillment flow)
- README explaining examples and adaptations

#### 🛠️ Professional Tooling

- **Makefile** with semantic targets (help, clean, release, versioning) - Externalize config and enhance release/versioning targets ([80db866](https://github.com/joserprieto/ai-diagrams-toolkit/commit/80db8662087f5e1ae1ef62ca2941f488a0b6669d))
- **3-layer versioning system** - Templates, config, runtime vars with Keep a Changelog mapping ([5d0ec32](https://github.com/joserprieto/ai-diagrams-toolkit/commit/5d0ec32f77dbcae28539e4f45328b042bfd1e543))
- **Conventional commits** configuration (.commitlintrc.json)
- **EditorConfig** for consistency
- Comprehensive .gitignore

### Documentation

- **README** - Quick start guide (2-minute onboarding) with semantic color system explanation
- **ROADMAP** - v0.1.0 → v1.0.0 planned features (AI commands, design tokens, CI/CD)
- **CONTRIBUTING** - Guidelines with conventional commits and SemVer ([d35b88b](https://github.com/joserprieto/ai-diagrams-toolkit/commit/d35b88b608f117a732f086264c9f0acbf7e1dcab))
- **Architecture ADRs** - Orchestration and versioning system decisions ([a3e6146](https://github.com/joserprieto/ai-diagrams-toolkit/commit/a3e6146cd022a7cba6d34e06d32ae33a4ff7adfa))
- **Conventions** - Comprehensive project standards documentation ([d4e0d42](https://github.com/joserprieto/ai-diagrams-toolkit/commit/d4e0d4264278721215a899bf579c44f9564f7b03))
- **MIT License**

### Fixed

- **versioning:** Remove trailing newline from .semver preventing tag creation ([abaf046](https://github.com/joserprieto/ai-diagrams-toolkit/commit/abaf046e56fefdf46e1d9293b87f63c88dbcde2f))
- **versioning:** Enable GPG commit signing ([0e1e05c](https://github.com/joserprieto/ai-diagrams-toolkit/commit/0e1e05cc9ee8756be1390d0163f477568b216459))

---

## [Unreleased]

### Planned for v0.3.0

- Skills auto-activation (Claude Code exclusive)
- Subagent for complex diagrams (Claude Code exclusive)

### Planned for v1.0.0

- Design tokens JSON + CLI generator
- GitHub Actions CI/CD workflows
- Automated diagram linting

---

[0.2.0]: https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.2.0
[0.1.0]: https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.1.0
