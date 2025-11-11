# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

### Planned for v0.2.0

- AI slash commands (create, apply-colors, validate)
- Claude Code + Cursor integration
- Automated tests with `claude -p`

### Planned for v0.3.0

- Skills auto-activation (Claude Code exclusive)
- Subagent for complex diagrams (Claude Code exclusive)

### Planned for v1.0.0

- Design tokens JSON + CLI generator
- GitHub Actions CI/CD workflows
- Automated diagram linting

---

[0.1.0]: https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.1.0
