# Roadmap - AI Diagrams Toolkit

Vision and planned features for the toolkit evolution.

## 🎯 Vision

Create comprehensive, AI-powered diagrams-as-code toolkit with:

- **Semantic color system** that communicates meaning
- **AI integration** for rapid diagram creation
- **Multi-tool support** (Mermaid today, PlantUML/D2 future)
- **Design tokens** for brand consistency

---

## ✅ v0.1.0 - Templates + Guides

**Released**: 2025-11-11

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

## ✅ v0.2.0 - AI Slash Commands + Quality Foundation

**Released**: 2025-11-12

### Features

**AI Integration**:
- ✅ Universal AI slash commands (4 commands):
    - `/create-flowchart [description]` - Generate flowchart diagrams
    - `/create-sequence [description]` - Generate sequence diagrams
    - `/apply-colors [file]` - Apply semantic color system
    - `/validate-diagram [file]` - Validate syntax and conventions
- ✅ Multi-agent support:
    - Claude Code integration (`.claude/commands/` → `.ai/commands/generic/`)
    - Cursor IDE integration (`.cursor/commands/` → `.ai/commands/generic/`)
    - Codex CLI support (documented, manual copy)
- ✅ Centralized command structure (`.ai/commands/{generic,claude,codex}/`)
- ✅ Cross-platform setup (Unix + Windows with 3 documented options)

**Documentation**:
- ✅ AGENTS.md (universal AI instructions - 390+ lines, corrected state diagram rules)
- ✅ Comprehensive documentation hub (`docs/index.md` with role-based navigation)
- ✅ Shell scripting conventions (11,700 chars with TDD approach)
- ✅ Architecture ADRs (Makefile delegation - Open/Closed Principle)
- ✅ Windows setup guide (Git Bash, PowerShell, Install make)
- ✅ Common pitfalls updated (state diagram classDef section added)

**Testing & Quality**:
- ✅ Automated tests with `claude -p` (4 command tests)
- ✅ TDD infrastructure for shell scripts (framework + runner)
- ✅ Expected outputs (10 golden masters - 100% AGENTS.md compliance)
- ✅ Test directory structure (`tests/{commands,scripts,expected}/`)

**Architecture**:
- ✅ Makefiles delegados (scripts/Makefile with 17 targets)
- ✅ Open/Closed Principle applied (root delegates to sub-Makefiles)
- ✅ TDD workflow enabled (`make scripts/tdd/colors`, etc.)
- ✅ Directory structure (bin/, lib/tests/, lib/install/)
- ✅ Namespace pattern established (adt::)

**Value**: Instant diagram generation from natural language + professional development infrastructure.

---

## 🔄 v0.3.0 - Skills + Internal Quality Improvements (Next)

**Planned**: 2025-Q4 / 2026-Q1

### Features

**AI Capabilities**:
- [ ] Skills auto-activation (Claude Code exclusive):
    - `diagram-creator` - Auto-creates from description
    - `color-system-applier` - Auto-applies colors
    - `diagram-validator` - Auto-validates syntax
- [ ] Subagent `mermaid-assistant` (Claude Code exclusive):
    - Multi-turn conversations
    - Iterative diagram refinement
    - Guided creation
- [ ] Feature compatibility matrix (Claude vs Cursor vs Codex)

**Internal Quality** (Deferred from v0.2.0):
- [ ] Complete script refactorization (6/8 remaining scripts)
- [ ] New utility scripts (uninstall-symlinks, verify-installation, list-commands)
- [ ] Makefile target grouping (commands/*, scripts/*)
- [ ] Windows PowerShell launcher (run.ps1)
- [ ] Additional development guides

**Value**: Zero-friction diagram creation (just describe, AI creates) + enterprise-grade internal quality.

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
