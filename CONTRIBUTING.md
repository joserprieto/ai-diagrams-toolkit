# Contributing to AI Diagrams Toolkit

Thank you for considering contributing! This document provides guidelines for contributing to the project.

## 🎯 Ways to Contribute

- 🐛 Report bugs or issues
- 💡 Suggest new features or improvements
- 📝 Improve documentation
- ✨ Add new diagram templates or examples
- 🔧 Enhance AI tooling (commands, skills)
- 🌐 Translate guides to other languages

## 📋 Contribution Process

### 1. Check Existing Issues

Before creating new issue or PR:

- Search [existing issues](https://github.com/joserprieto/ai-diagrams-toolkit/issues)
- Check [roadmap](./ROADMAP.md) to see if already planned
- Join [discussions](https://github.com/joserprieto/ai-diagrams-toolkit/discussions) if unsure

### 2. Fork and Branch

```bash
# Fork repository on GitHub
git clone https://github.com/YOUR-USERNAME/ai-diagrams-toolkit.git
cd ai-diagrams-toolkit

# Create feature branch
git checkout -b feature/your-feature-name

# Or bug fix branch
git checkout -b fix/issue-description
```

### 3. Make Changes

- Follow coding conventions (see below)
- Update documentation if needed
- Add examples if adding features
- Test your changes

### 4. Commit with Conventional Commits

We strictly follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

**Format**: `type(scope): description`

**Examples**:

```bash
git commit -m "feat(templates): add ER diagram template"
git commit -m "fix(flowchart): correct reserved keyword in example"
git commit -m "docs(readme): improve quick start guide"
git commit -m "chore(makefile): add lint target"
```

**📖 Complete Documentation**: See [Commit Conventions](./docs/conventions/commits.md) for:

- Full list of commit types and their meanings
- How commits map to CHANGELOG sections
- Examples of good vs bad commit messages
- Breaking change format
- Issue references

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create Pull Request on GitHub with:

- Clear title (same format as commit)
- Description of changes
- Reference related issues (#123)
- Screenshots if UI/visual changes

## 📐 Code Conventions

### Mermaid Diagrams

- **Node IDs**: Semantic English names (SessionStart, not A)
- **Comments**: English
- **User-visible text**: Spanish default (or specify language)
- **Colors**: Use semantic color system (not random colors)
- **Reserved keywords**: Avoid (see `guides/mermaid/common-pitfalls.md`)

### Markdown

- Blank line before/after code blocks, lists, headings
- No consecutive blank lines
- Headers: ATX style (#), sentence case
- Max line length: 120 characters (soft limit)

### File Names

- Lowercase with hyphens: `common-pitfalls.md`
- Descriptive: `flowchart-template.mmd` (not `template1.mmd`)

## 🔢 Versioning

We follow [Semantic Versioning 2.0.0](https://semver.org/) **strictly**:

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes
- **MINOR** (v0.2.0 → v0.3.0): New features, backwards-compatible
- **PATCH** (v0.2.0 → v0.2.1): Bug fixes, backwards-compatible

**Pre-release**: v0.x.x indicates API not yet stable (until v1.0.0)

**📖 Complete Documentation**: See [Versioning Strategy](./docs/conventions/versioning.md) for:

- Detailed bump rules
- Version lifecycle phases
- Pre-release versions
- Breaking change guidelines

## 📝 Documentation

When adding features:

- Update README.md if user-facing
- Add/update guide in `/guides/` if technical
- Include example in `/examples/` if significant
- Update ROADMAP.md if changes future plans
- ~~Update CHANGELOG.md~~ - **Generated automatically** from conventional commits

**📖 More Information**:

- [CHANGELOG Conventions](./docs/conventions/changelog.md) - How CHANGELOG is generated
- [Release Workflow](./docs/conventions/releases.md) - Complete release process
- [Conventions Overview](./docs/conventions/README.md) - Quick reference guide

## 🎨 Color System

**Do NOT** add arbitrary colors. All colors must be semantic:

**States**: operational (green), warning (yellow), error (red), info (blue), inactive (gray)

**Layers**: data (blue light), processing (green light), storage (orange light), communication (purple light),
presentation (cyan light)

**Priority**: critical (red border 3px), important (orange 2px), standard (blue 1px)

See `/guides/` for complete color specifications.

## ⚠️ Common Mistakes

- ❌ Generic node names (A, B, C)
- ❌ Random colors (not semantic)
- ❌ Reserved keywords as node IDs (end, class, style)
- ❌ Special characters unescaped
- ❌ Comments in Spanish (should be English)
- ❌ Commits not following conventional format

## 🏆 Recognition

Contributors will be:

- Listed in README acknowledgments (if significant contribution)
- Credited in CHANGELOG
- Mentioned in release notes

## 📜 Code of Conduct

- Be respectful and inclusive
- Constructive feedback only
- Focus on ideas, not individuals
- Help newcomers
- Assume good intentions

## 📬 Questions?

- Open [Discussion](https://github.com/joserprieto/ai-diagrams-toolkit/discussions)
- Comment on related issue
- Check [guides](./guides/) and [conventions docs](./docs/conventions/) first

---

**Thank you for contributing to make diagrams-as-code better for everyone!**
