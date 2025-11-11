# CHANGELOG Conventions

## Overview

This project uses an **automated CHANGELOG generation system** based on:

- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format
- [Conventional Commits](https://www.conventionalcommits.org/) specification
- [`commit-and-tag-version`](https://github.com/absolute-version/commit-and-tag-version) tooling

## 📊 Commit Type → CHANGELOG Section Mapping

| Commit Type  | CHANGELOG Section | Visibility | Description              |
|--------------|-------------------|------------|--------------------------|
| `feat:`      | **Added**         | ✅ Visible  | New features             |
| `fix:`       | **Fixed**         | ✅ Visible  | Bug fixes                |
| `perf:`      | **Changed**       | ✅ Visible  | Performance improvements |
| `docs:`      | **Documentation** | ✅ Visible  | Documentation changes    |
| `revert:`    | **Reverted**      | ✅ Visible  | Reverted changes         |
| `security:`  | **Security**      | ✅ Visible  | Security fixes           |
| `deprecate:` | **Deprecated**    | ✅ Visible  | Deprecations             |
| `remove:`    | **Removed**       | ✅ Visible  | Removed features         |
| `refactor:`  | **Changed**       | ❌ Hidden   | Internal refactoring     |
| `style:`     | **Changed**       | ❌ Hidden   | Code style changes       |
| `test:`      | **Changed**       | ❌ Hidden   | Test changes             |
| `build:`     | **Changed**       | ❌ Hidden   | Build system changes     |
| `ci:`        | **Changed**       | ❌ Hidden   | CI/CD changes            |
| `chore:`     | **Changed**       | ❌ Hidden   | Maintenance tasks        |

**Hidden commits** are excluded from the CHANGELOG (internal changes not relevant to users).

## 📝 Format Examples

### Version Header

```markdown
## [0.1.0](https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.1.0) - 2025-11-11
```

Components:

- `[0.1.0]` - Version number (linked to release)
- `(URL)` - GitHub release page
- `2025-11-11` - Release date (ISO 8601)

### Commit Entry

```markdown
- **scope:** Commit subject ([hash](commit-url)), closes [#issue](issue-url)
```

Components:

- `**scope:**` - Optional scope (bolded)
- `Commit subject` - The commit message subject line
- `[hash](commit-url)` - Short hash linked to commit
- `closes [#issue]` - Optional issue references (linked)

### Full Example

```markdown
## [0.2.0](https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v0.2.0) - 2025-11-12

### Added

- **commands:** Universal slash commands for Claude Code and
  Cursor ([a1b2c3d](https://github.com/joserprieto/ai-diagrams-toolkit/commit/a1b2c3d))
- AI-powered diagram generation from natural
  language ([b2c3d4e](https://github.com/joserprieto/ai-diagrams-toolkit/commit/b2c3d4e))

### Fixed

- **templates:** Mermaid syntax error in flowchart
  template ([e4f5g6h](https://github.com/joserprieto/ai-diagrams-toolkit/commit/e4f5g6h)),
  closes [#42](https://github.com/joserprieto/ai-diagrams-toolkit/issues/42)
- **parser:** Handle empty nodes
  correctly ([f5g6h7i](https://github.com/joserprieto/ai-diagrams-toolkit/commit/f5g6h7i))

### Changed

- Improve template readability and
  structure ([i7j8k9l](https://github.com/joserprieto/ai-diagrams-toolkit/commit/i7j8k9l))

### Documentation

- Add comprehensive guides for all diagram
  types ([j8k9l0m](https://github.com/joserprieto/ai-diagrams-toolkit/commit/j8k9l0m))
```

## 🔄 Automation Workflow

### 1. Make Commits

Follow [Conventional Commits](./commits.md):

```bash
git commit -m "feat(templates): add state diagram template"
git commit -m "fix(guides): correct Mermaid syntax in examples"
git commit -m "docs(readme): update quick start section"
```

### 2. Generate Release

```bash
# Preview changes
make release/dry-run

# Create release
make release
```

### 3. CHANGELOG Updates Automatically

The tool:

1. ✅ Analyzes all commits since last tag
2. ✅ Groups commits by type
3. ✅ Maps types to Keep a Changelog sections
4. ✅ Generates links (commits, issues, releases)
5. ✅ Prepends new section to CHANGELOG.md
6. ✅ Previous versions remain untouched

### 4. Result

```markdown
# Changelog

All notable changes to this project will be documented in this file.
...

## [0.2.0](link) - 2025-11-12 ← NEW (just added)

### Added

...

## [0.1.0](link) - 2025-11-11 ← UNTOUCHED (preserved)

### Added

...
```

## 🎯 Key Guarantees

✅ **Previous versions never modified** - Each release only prepends its section

✅ **Automatic links** - Commits, releases, and issues are all hyperlinked

✅ **Rich context** - Scopes, breaking changes, and references are preserved

✅ **Manual override possible** - You can edit CHANGELOG.md if needed before pushing

✅ **Keep a Changelog format** - Industry-standard, human-readable format

## ⚙️ Configuration Files

The CHANGELOG system is configured through three layers:

### 1. Templates (`.changelog-templates/*.hbs`)

Handlebars templates define the exact format:

- `template.hbs` - Main structure (loops versions, groups commits)
- `header.hbs` - Version header format
- `commit.hbs` - Individual commit format
- `footer.hbs` - Footer with links

**Why templates?**: Complete control over format, no implicit defaults from tooling.

### 2. Behavior Configuration (`.versionrc.js`)

JavaScript configuration file that defines:

- Which commit types to include
- How to map types to sections
- Which files to update (`.semver`, `CHANGELOG.md`)
- URL formats for GitHub links
- Lifecycle hooks (prebump, posttag, etc.)

**Why JavaScript?**: Can load external templates, allows dynamic configuration.

### 3. Runtime Variables (`.env.dist`)

Environment configuration for tool selection:

```makefile
NODE_RELEASE_PACKAGE := commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION := 12.4.4
NODE_RELEASE_CONFIG := .versionrc.js
```

**Why external?**: Easy to switch tools, pin versions, configure behavior.

See [Versioning System Architecture](../architecture/versioning-system.md) for detailed explanation.

## ✍️ Writing Good Commit Messages

Since CHANGELOG is auto-generated from commits, write descriptive messages:

### ✅ Good Examples

```bash
git commit -m "feat(templates): add state diagram template with 5 predefined states"
git commit -m "fix(flowchart): resolve reserved keyword 'end' conflict in parser"
git commit -m "docs(guides): add troubleshooting section for common Mermaid errors"
git commit -m "perf(parser): optimize syntax validation by 40%"
```

**Result in CHANGELOG**:

```markdown
### Added

- **templates:** Add state diagram template with 5 predefined states

### Fixed

- **flowchart:** Resolve reserved keyword 'end' conflict in parser

### Documentation

- **guides:** Add troubleshooting section for common Mermaid errors

### Changed

- **parser:** Optimize syntax validation by 40%
```

### ❌ Bad Examples

```bash
git commit -m "feat: stuff"
git commit -m "fix: bug"
git commit -m "update files"
```

**Result in CHANGELOG**:

```markdown
### Added

- Stuff

### Fixed

- Bug

### Changed

- Update files
```

**Tip**: Use AI to generate descriptive commit messages based on `git diff`.

## 🔧 Manual Editing (Advanced)

While automation handles most cases, you can manually edit CHANGELOG.md:

### When to Edit Manually

- Adding context not in commit messages
- Grouping related changes with sub-bullets
- Rewriting auto-generated text for clarity
- Adding migration guides for breaking changes

### How to Edit Safely

1. **Make release**:
   ```bash
   make release
   ```

2. **Edit CHANGELOG.md**:
   ```bash
   vim CHANGELOG.md
   # Add context, rewrite descriptions, add examples
   ```

3. **Amend commit**:
   ```bash
   git add CHANGELOG.md
   git commit --amend --no-edit
   ```

4. **Re-tag** (if needed):
   ```bash
   git tag -f v0.2.0
   ```

5. **Push**:
   ```bash
   git push --follow-tags --force-with-lease
   ```

⚠️ **Warning**: Manual edits will be preserved (automation only prepends new sections).

### Example Manual Enhancement

**Auto-generated**:

```markdown
### Added

- **commands:** Add universal slash commands
```

**Manually enhanced**:

```markdown
### Added

#### Universal Slash Commands

- **commands:** Add universal slash commands for both Claude Code and Cursor
    - `/create-flowchart` - Generate flowchart from natural language
    - `/create-sequence` - Generate sequence diagram
    - `/apply-colors` - Apply semantic color system
    - `/validate-diagram` - Validate Mermaid syntax

  Compatible with both Claude Code and Cursor editors. See [AI Commands Guide](./docs/ai-commands.md) for usage.
```

## 🐛 Troubleshooting

### Commits Not Appearing in CHANGELOG

**Problem**: Made commits but they don't appear in `make release/dry-run`

**Causes**:

- Commit type is `hidden: true` in `.versionrc.js`
- Commit doesn't follow Conventional Commits format
- No commits since last tag

**Solutions**:

```bash
# Check commits since last tag
git log v0.1.0..HEAD --oneline

# Verify commit format
git log --oneline -1

# Check if type is hidden
grep "type: 'feat'" .versionrc.js
```

### Wrong Section for Commit Type

**Problem**: `feat:` commits appearing in wrong section

**Solution**: Check type mapping in `.versionrc.js`:

```javascript
types: [
    {type: 'feat', section: 'Added', hidden: false},  // ← Check this
]
```

### Links Not Working

**Problem**: Commit/issue links in CHANGELOG are broken

**Solution**: Verify GitHub repository URL in templates:

```bash
# Check commit.hbs
grep "github.com" .changelog-templates/commit.hbs

# Should contain your repo URL
https://github.com/joserprieto/ai-diagrams-toolkit
```

### CHANGELOG Formatting Issues

**Problem**: CHANGELOG has formatting problems (extra newlines, broken lists)

**Solution**: Check Handlebars templates syntax:

```bash
# Validate templates
cat .changelog-templates/commit.hbs
cat .changelog-templates/header.hbs
```

Ensure proper use of `~` for whitespace control in Handlebars.

## 📚 Related Documentation

- [Commits Guide](./commits.md) - How to write conventional commits
- [Versioning Guide](./versioning.md) - Semantic versioning strategy
- [Releases Guide](./releases.md) - Complete release workflow
- [Versioning System Architecture](../architecture/versioning-system.md) - Technical details

## 🔗 External Resources

- [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [commit-and-tag-version Documentation](https://github.com/absolute-version/commit-and-tag-version)
- [Handlebars Templates](https://handlebarsjs.com/)
