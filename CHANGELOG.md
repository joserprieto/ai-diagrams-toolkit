# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2025-11-06

### Added

- Initial public release
- 4 Mermaid diagram templates with semantic color system:
  - Flowchart template (processes, workflows, decision trees)
  - Sequence diagram template (API interactions, system communications)
  - Class diagram template (OOP structures, data models)
  - State diagram template (state machines, lifecycles)
- Comprehensive Mermaid guides (`/guides/mermaid/`):
  - Flowchart guide with shape reference and styling
  - Sequence diagram guide with interaction patterns
  - Class diagram guide with relationships and stereotypes
  - Common pitfalls guide (reserved keywords, special characters, fixes)
  - README index for guides
- Real-world examples (`/examples/`):
  - Critical system monitoring architecture
  - Business process (order fulfillment flow)
  - README explaining examples and adaptations
- Professional tooling:
  - Makefile with semantic targets (help, clean, release)
  - Conventional commits configuration (.commitlintrc.json)
  - EditorConfig for consistency
  - Comprehensive .gitignore
- Documentation:
  - Quick start README (2-minute onboarding)
  - ROADMAP (v0.1.0 → v1.0.0)
  - CONTRIBUTING guidelines
  - MIT License

### Documentation

- README with quick start guide and semantic color system explanation
- ROADMAP with planned features (AI commands, design tokens, CI/CD)
- CONTRIBUTING guide with conventional commits and SemVer
- Example diagrams with color explanations

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
