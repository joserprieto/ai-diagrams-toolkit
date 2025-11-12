# Documentation Conventions

_Last Updated: 2025-11-12 | Version: 1.0.0_

Guidelines for writing and organizing documentation in the AI Diagrams Toolkit project.

---

## 📂 File Naming Conventions

### index.md vs README.md

**Decision**: Use `index.md` for **documentation navigation hubs**, use `README.md` for **project/module overviews**.

| Directory Type | File Name | Purpose | Audience |
|---------------|-----------|---------|----------|
| `docs/` (root) | `index.md` | Main documentation hub | Internal contributors |
| `docs/*/` (sections) | `index.md` | Section navigation hub | Topic-specific readers |
| Project root | `README.md` | Project overview | External users, GitHub visitors |
| `scripts/`, `tests/` | `README.md` | Module overview | Developers browsing GitHub |
| `.ai/commands/` | `README.md` | Command catalog | AI assistant users |

---

### Rationale

#### Why `index.md` for Documentation

**Semantic clarity**:
- ✅ `index.md` clearly indicates "this is an index/navigation page"
- ✅ Matches web convention (`index.html`)
- ✅ Separates documentation structure from project description

**Intentional navigation**:
- ✅ User chooses to read index (not auto-rendered by GitHub)
- ✅ Encourages exploring directory structure first
- ✅ Avoids information overload

**Tool compatibility**:
- ✅ MkDocs: `docs/index.md` is entry point
- ✅ VuePress: `index.md` preferred for pages
- ✅ Docusaurus: Supports `index.md`

#### Why `README.md` for Modules

**GitHub auto-render**:
- ✅ Content shown automatically when browsing directory
- ✅ Useful for practical directories (`scripts/`, `tests/`)
- ✅ Provides immediate context without clicking

**Developer expectation**:
- ✅ Standard OSS convention
- ✅ Familiar to all developers
- ✅ Tools search for `README.md` by default

---

### Examples

#### Documentation Hub

```
docs/
├── index.md              # ✅ Main navigation hub
├── conventions/
│   ├── index.md         # ✅ Section hub
│   ├── commits.md       # Content document
│   └── makefile.md      # Content document
└── architecture/
    └── index.md         # ✅ Section hub
```

#### Module Overview

```
scripts/
├── README.md            # ✅ Explains scripts/ structure
├── bin/
│   └── install-symlinks
└── lib/
    └── colors.sh

tests/
├── README.md            # ✅ Explains test organization
└── commands/
    └── 01-create-flowchart/
```

---

## 📝 Document Structure Pattern

### Hub Documents (index.md)

**Required sections**:

1. **Title and Metadata** - Clear title with last updated date
2. **Brief Description** - 1-2 sentences explaining section purpose
3. **Contents** - Bullet list of documents in section
4. **Quick Reference** (optional) - Copy-paste ready examples
5. **Related Documentation** - Links to other sections
6. **External References** (optional) - Links to specs/tools

**Example structure**:

```markdown
# Section Name

_Last Updated: YYYY-MM-DD_

Brief description of this documentation section.

## 📚 Contents

- [**Document 1**](./document-1.md) - Brief description
- [**Document 2**](./document-2.md) - Brief description

## 🎯 Quick Reference

[Optional quick reference for common tasks]

## 📖 Related Documentation

- [Other Section](../other-section/index.md)

## 🔗 External References

- [External Resource](https://example.com)
```

---

### Content Documents

**Required sections**:

1. **Title and Metadata** - Clear title, last updated
2. **Overview** - What this document covers
3. **Main Content** - Organized with clear headers
4. **Examples** - Real, copy-paste ready examples
5. **Related Documentation** - Cross-references
6. **External References** (if applicable)

**Example structure**:

```markdown
# Document Title

_Last Updated: YYYY-MM-DD_

## 🎯 Overview

What this document covers and why it matters.

## Main Section 1

Content with examples.

## Main Section 2

Content with examples.

## 📖 Related Documentation

- [Related Doc](./related.md)

## 🔗 External References

- [Spec](https://example.com)
```

---

## 🎨 Markdown Conventions

### Headers

**Use ATX style** (with #):

```markdown
# Level 1
## Level 2
### Level 3
```

**Don't use** Setext style (underlines):

```markdown
❌ Level 1
========

❌ Level 2
--------
```

**Hierarchy**:
- H1 (`#`) - Document title (once per file)
- H2 (`##`) - Major sections
- H3 (`###`) - Subsections
- H4-H6 - Avoid if possible (indicates too deep nesting)

---

### Lists

**Unordered** - Use hyphens:

```markdown
- Item 1
- Item 2
  - Subitem 2.1
  - Subitem 2.2
- Item 3
```

**Ordered** - Use numbers:

```markdown
1. First step
2. Second step
   1. Substep 2.1
   2. Substep 2.2
3. Third step
```

**Task lists** (GitHub flavor):

```markdown
- [ ] Todo item
- [x] Completed item
```

---

### Code Blocks

**Fenced** with language hint:

````markdown
```bash
echo "Hello, World!"
```

```javascript
console.log("Hello, World!");
```

```yaml
key: value
nested:
  key: value
```
````

**Inline code** for short references:

```markdown
Use the `make release` command to create a release.
The `REPO_ROOT` variable must be set.
```

---

### Tables

**Use** pipe-aligned tables:

```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
| Value 4  | Value 5  | Value 6  |
```

**Alignment** (optional):

```markdown
| Left | Center | Right |
|:-----|:------:|------:|
| L1   | C1     | R1    |
```

---

### Links

**Relative links** (preferred for internal docs):

```markdown
[Architecture Docs](../architecture/index.md)
[Script Conventions](./shell-scripting.md)
[Testing Guide](../development/testing-guide.md)
```

**Directory links** (GitHub auto-finds index/README):

```markdown
[Conventions](./conventions/)  # Finds conventions/index.md
```

**Absolute links** (for external resources):

```markdown
[Conventional Commits](https://www.conventionalcommits.org/)
[Semantic Versioning](https://semver.org/)
```

---

### Emoji Usage

**Consistent emoji** for sections:

- 🎯 Overview / Purpose / Objectives
- 📚 Contents / Documentation / References
- 🚀 Quick Start / Getting Started
- 📂 Structure / Organization
- 🔧 Configuration / Setup / Installation
- 🧪 Testing / Verification
- ⚠️ Warnings / Important Notes
- ✅ Success / Completed / Good practices
- ❌ Errors / Failures / Anti-patterns
- 📖 Related Documentation
- 🔗 External References / Links
- 💡 Examples / Tips / Hints
- 🎨 Style / Formatting
- 🏗️ Architecture / Structure

**Use sparingly** - Only for section headers or emphasis, not in every sentence.

---

## 🔗 Cross-Referencing

### Within Same Section

```markdown
See [Commits Guide](./commits.md) for details.
```

### Across Sections

```markdown
See [Architecture Documentation](../architecture/index.md) for system design.
```

### To Root Files

```markdown
See [Project README](../../README.md) for overview.
See [Contributing Guidelines](../../CONTRIBUTING.md) for process.
```

### Hub-and-Spoke Pattern

**Every document should**:
- Link back to its section hub (index.md)
- Link to related documents in other sections
- Provide "Related Documentation" section at bottom

**Example footer**:

```markdown
## 📖 Related Documentation

- [Section Hub](./index.md) - Back to conventions index
- [Related Doc](./related.md) - Related topic
- [Other Section](../other/index.md) - Cross-section reference

## 🔗 External References

- [Official Spec](https://example.com)
```

---

## 📊 Metadata

### Document Headers

**Standard format**:

```markdown
# Document Title

_Last Updated: YYYY-MM-DD | Version: X.Y.Z_

Brief description or tagline.

---

[Content starts here]
```

**Fields**:
- `Last Updated` - Date of last significant update (YYYY-MM-DD)
- `Version` - SemVer version (optional, for major docs)
- Brief description - One sentence summary

---

### Section Metadata

**For major sections** (conventions/, architecture/, etc.):

```markdown
# Section Name

_Last Updated: YYYY-MM-DD_

This directory contains [description].

## 📚 Contents

[List of documents]

## 🎯 Overview

[Section purpose and scope]
```

---

## ✅ Quality Checklist

Before submitting documentation:

### Content Quality

- [ ] Purpose is clear in first paragraph
- [ ] Examples are copy-paste ready
- [ ] All code blocks have language hints
- [ ] No broken links (verify all links work)
- [ ] External references have URLs
- [ ] Metadata (last updated) is current

### Structure Quality

- [ ] Hub documents have complete contents list
- [ ] Content documents link back to hub
- [ ] Related docs are cross-referenced
- [ ] Headers follow hierarchy (H1 → H2 → H3)
- [ ] Tables are aligned and readable

### Style Quality

- [ ] Markdown conventions followed
- [ ] Emoji used consistently
- [ ] Code blocks properly fenced
- [ ] Lists use consistent markers (- for unordered, 1. for ordered)
- [ ] No trailing whitespace

---

## 🔗 Related Documentation

- [Shell Scripting Conventions](./shell-scripting.md) - How to document shell scripts
- [Commits Conventions](./commits.md) - Commit message format for doc changes
- [Architecture Documentation](../architecture/index.md) - When to create ADRs

---

## 📚 External References

- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Flavored Markdown](https://github.github.com/gfm/)
- [Documentation Guide](https://www.writethedocs.org/guide/)

---

_Consistent documentation makes projects accessible and maintainable._
