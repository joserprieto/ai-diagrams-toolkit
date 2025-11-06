# AI Diagrams Toolkit

> Semantic color system + AI-powered templates for Mermaid diagrams

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Mermaid](https://img.shields.io/badge/Mermaid-Supported-ff69b4.svg)](https://mermaid.js.org/)

## 🚀 Quick Start (2 minutes)

1. **Copy a template** from [`/templates/`](./templates/):
    - `flowchart.mmd` - Processes and workflows
    - `sequence.mmd` - API interactions
    - `class.mmd` - OOP structures
    - `state.mmd` - State machines

2. **Paste in your `.mmd` file** or markdown code block

3. **Replace example content** with your diagram

**Result**: Professional diagram with semantic colors in under 2 minutes.

## 🎨 Semantic Color System

Colors communicate **meaning**, not just aesthetics:

- 🟢 **Green** = Operational, success, working correctly
- 🟡 **Yellow** = Warning, decision point, attention needed
- 🔴 **Red** = Error, failure, critical issue
- 🔵 **Blue** = Info, neutral, entry point
- ⚫ **Gray** = Inactive, disabled, deprecated

### Architectural Layers

Light colors show system architecture:

- **Blue light** = Data layer (input, sensors)
- **Green light** = Processing layer (business logic)
- **Orange light** = Storage layer (databases)
- **Purple light** = Communication layer (APIs)
- **Cyan light** = Presentation layer (UI)

## 🤖 AI-Powered Features (v0.2.0+)

**NEW**: Slash commands for rapid diagram generation!

### Universal Commands (Claude Code + Cursor)

Load this repo in Claude Code or Cursor and use:

```bash
/create-flowchart user authentication with email and password
/create-sequence REST API with caching and database
/apply-colors existing-diagram.mmd
/validate-diagram my-diagram.mmd
```

### How It Works

1. **Commands read** from `.ai/commands/`
2. **AI generates diagram** with semantic colors automatically
3. **Follows conventions**: Semantic naming, no reserved keywords
4. **Production-ready**: Renders correctly, commented

### Automated Testing

```bash
make test/commands  # Runs automated tests with claude -p
```

**Requirements**: Claude Code CLI + jq

See `.ai/AGENTS.md` for complete AI instructions.

---

### Feature Compatibility

| Feature | Claude Code | Cursor |
|---------|-------------|--------|
| Templates | ✅ | ✅ |
| Guides | ✅ | ✅ |
| Slash Commands | ✅ | ✅ |
| Automated Tests | ✅ | ✅ |

## 📚 Documentation

- **[Templates](./templates/)** - Copy-paste ready templates
- **[Guides](./guides/mermaid/)** - Comprehensive Mermaid reference
- **[Examples](./examples/)** - Real-world use cases

## 🗺️ Roadmap

- ✅ **v0.1.0**: Templates, guides, examples
- ✅ **v0.2.0 (Current)**: AI slash commands (Claude Code + Cursor)
- 🔄 **v0.3.0 (Next)**: Skills + Subagent (Claude Code exclusive)
- 📅 **v1.0.0 (Future)**: Design tokens + CLI generator

See [ROADMAP.md](./ROADMAP.md) for details.

**PRs welcome!**

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📝 License

MIT License - see [LICENSE](./LICENSE) for details.

---

**Made with ❤️ for the diagrams-as-code community**
