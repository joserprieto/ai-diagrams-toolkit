# Mermaid Guides

Comprehensive guides for creating Mermaid diagrams with semantic color system.

## 📚 Available Guides

| Guide | Diagram Type | Best For |
|-------|--------------|----------|
| [Flowchart](./flowchart.md) | Flowchart/Graph | Processes, workflows, decision trees |
| [Sequence](./sequence.md) | Sequence | API interactions, system communications |
| [Class](./class.md) | Class | OOP structures, data models, architecture |
| [Common Pitfalls](./common-pitfalls.md) | All types | Reserved keywords, syntax errors, fixes |

## 🚀 Quick Start

1. **Choose diagram type** based on your use case
2. **Copy template** from `/templates/[type].mmd`
3. **Read guide** for that diagram type (this directory)
4. **Check pitfalls** in common-pitfalls.md before publishing

## 🎨 Semantic Color System

All guides use the same semantic color system:

**States**:
- 🟢 Green (#4CAF50): Operational/success
- 🟡 Yellow (#FFC107): Warning/attention
- 🔴 Red (#F44336): Error/critical
- 🔵 Blue (#2196F3): Info/neutral
- ⚪ Gray (#9E9E9E): Inactive/disabled

**Architectural Layers**:
- 🔵 Blue: Data layer (input/sensors)
- 🟣 Purple: Processing layer (logic)
- 🟠 Orange: Storage layer (persistence)
- 🟣 Purple: Communication layer (APIs)
- 🔷 Cyan: Presentation layer (UI)

---

*Guides follow Mermaid official syntax. For official docs: https://mermaid.js.org/*
