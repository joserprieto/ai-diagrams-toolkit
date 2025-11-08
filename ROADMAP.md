# Roadmap - AI Diagrams Toolkit

Vision and planned features for the toolkit evolution.

## 🎯 Vision

Create comprehensive, AI-powered diagrams-as-code toolkit with:

- **Semantic color system** that communicates meaning
- **AI integration** for rapid diagram creation
- **Multi-tool support** (Mermaid today, PlantUML/D2 future)
- **Design tokens** for brand consistency

---

## ✅ v0.1.0 - Templates + Guides (Current)

**Released**: 2025-11-06

### Features

- ✅ 4 Mermaid templates (flowchart, sequence, class, state)
- ✅ Semantic color system (operational, warning, error, layers, priority)
- ✅ Comprehensive guides per diagram type
- ✅ Common pitfalls documentation (reserved keywords, fixes)
- ✅ Real-world examples (critical systems, business processes)
- ✅ Professional tooling (Makefile, conventional commits, SemVer)
- ✅ MIT License

**Value**: Copy-paste templates with zero dependencies.

---

## 🔄 v0.2.0 - AI Slash Commands (Next)

**Planned**: 2025-11-07

### Features

- [ ] Universal AI slash commands:
    - `/create-flowchart [description]`
    - `/create-sequence [description]`
    - `/apply-colors [file]`
    - `/validate-diagram [file]`
- [ ] Claude Code integration (`.claude/commands/`)
- [ ] Cursor integration (`.cursor/commands/`)
- [ ] AGENTS.md (universal AI instructions)
- [ ] Automated tests with `claude -p`

**Value**: Instant diagram generation from natural language.

---

## 🔄 v0.3.0 - Skills + Subagent (Coming)

**Planned**: 2025-11-08

### Features

- [ ] Skills auto-activation (Claude Code exclusive):
    - `diagram-creator` - Auto-creates from description
    - `color-system-applier` - Auto-applies colors
    - `diagram-validator` - Auto-validates syntax
- [ ] Subagent `mermaid-assistant` (Claude Code exclusive):
    - Multi-turn conversations
    - Iterative diagram refinement
    - Guided creation
- [ ] Feature compatibility matrix (Claude vs Cursor)

**Value**: Zero-friction diagram creation (just describe, AI creates).

---

## 📅 v1.0.0 - Design Tokens + Production Ready (Future)

**Planned**: 2026-Q1

### Features

- [ ] Design tokens JSON schema
- [ ] CLI generator (tokens → branded templates)
- [ ] Custom branding support (corporate colors/fonts)
- [ ] GitHub Actions CI/CD:
    - Automated diagram linting
    - Syntax validation on PR
    - Diagram rendering to PNG/SVG
- [ ] PlantUML template support
- [ ] Advanced Makefile targets (lint, test automation)

**Value**: Enterprise-ready with brand consistency.

---

## 🌟 Future Explorations (v2.0.0+)

Ideas being considered:

- Multi-language support (docs in ES, FR, DE, etc.)
- D2 diagrams support
- Interactive diagram editor (web-based)
- VS Code extension
- Diagram diff tool for PRs
- Template marketplace (community)

---

## 🤝 Contributing

We welcome contributions at any stage!

### v0.1.0 Contributions Welcome

- ✅ Additional diagram examples (domain-specific)
- ✅ Bug fixes in templates
- ✅ Documentation improvements
- ✅ Translations of guides

### v0.2.0+ Contributions Welcome

- AI command enhancements
- Test suite improvements
- New diagram type support

### v1.0.0+ Contributions Welcome

- Design token schema feedback
- CLI generator contributions
- GitHub Actions workflows
- PlantUML templates

**PRs welcome for all versions!**

---

## 📬 Feedback

- Feature requests: [GitHub Issues](https://github.com/joserprieto/ai-diagrams-toolkit/issues)
- Discussions: [GitHub Discussions](https://github.com/joserprieto/ai-diagrams-toolkit/discussions)

---

**This roadmap evolves based on community feedback and real-world usage.**
