# Architecture Documentation

This directory contains technical architecture documentation for the AI Diagrams Toolkit.

## 📚 Contents

- [**Versioning System**](./versioning-system.md) - Complete architecture of the automated release system
- [**Orchestration Decision**](./orchestration.md) - Architecture decision record for Makefile as main orchestrator
- [**AI Tooling**](./ai-tooling.md) - How AI commands, skills, and subagents work _(Coming soon)_

## 🎯 Overview

The AI Diagrams Toolkit is built with several key architectural principles:

### 1. Language-Agnostic Core

The toolkit is **not** a Node.js application. It's a collection of:

- Mermaid diagram templates (`.mmd` files)
- Markdown guides (`.md` files)
- AI integration files (commands, skills, subagents)

Node.js tooling is used only for **development automation** (versioning, releases).

### 2. Zero-Dependency Templates

Templates are **pure Mermaid**:

- No build step required
- No dependencies to install
- Copy-paste ready
- Work in any Mermaid-compatible environment

### 3. AI-First Design

Integration with AI coding assistants is a **first-class feature**:

- Slash commands for explicit diagram generation
- Skills for automatic activation based on context
- Subagents for complex multi-turn diagram creation

See [AI Tooling Architecture](./ai-tooling.md) for details (coming soon)

### 4. Professional Automation

Release management is **fully automated**:

- Conventional Commits → CHANGELOG generation
- Semantic Versioning automation
- Zero-friction releases with `make release`

See [Versioning System Architecture](./versioning-system.md) for details.

## 🔧 Technology Stack

### Core Content

- **Mermaid.js** - Diagram syntax (templates)
- **Markdown** - Documentation format (guides)

### Development Tooling

- **GNU Make** - Build automation and orchestration
- **commit-and-tag-version** - Release automation
- **Handlebars** - Template engine for CHANGELOG
- **Git** - Version control and tagging

### AI Integration

- **Claude Code** - Primary AI assistant (commands + skills + subagents)
- **Cursor** - Alternative AI assistant (commands only)

## 📖 Related Documentation

- [Conventions Documentation](../conventions/README.md) - Project conventions and standards
- [Development Documentation](../development/README.md) - Setup and development guides _(Coming soon)_

## 🏗️ Project Structure

```
ai-diagrams-toolkit/
├── templates/              # Pure Mermaid templates
├── guides/                 # Mermaid usage guides
├── examples/               # Real-world examples
├── tests/                  # Test suite (samples + expected outputs)
├── .ai/                    # AI tooling (commands, skills, subagents)
├── .changelog-templates/   # Handlebars templates for CHANGELOG
├── .versionrc.js           # Release automation configuration
├── Makefile                # Build and release automation
└── docs/                   # This documentation
```

## 🎯 Design Principles

### Simplicity

- Minimal dependencies
- Clear file organization
- Self-documenting code

### Automation

- One command releases: `make release`
- Automated CHANGELOG generation
- Consistent formatting via templates

### Extensibility

- Easy to add new diagram types
- Pluggable AI tooling
- Configurable color systems

### Documentation

- Comprehensive guides for all features
- Architecture docs for maintainers
- Convention docs for contributors

## 🔗 External Resources

- [Mermaid.js Documentation](https://mermaid.js.org/)
- [Handlebars Documentation](https://handlebarsjs.com/)
- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Conventional Commits](https://www.conventionalcommits.org/)
