# Commit Conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org/) specification for all commit messages.

## 📋 Commit Message Format

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Required Elements

- **type**: Commit category (see types below)
- **subject**: Brief description of the change (imperative mood)

### Optional Elements

- **scope**: Component/area affected (e.g., `templates`, `guides`, `commands`)
- **body**: Detailed explanation of the change
- **footer**: Breaking changes, issue references

## 🏷️ Commit Types

| Type        | Description             | CHANGELOG Section | Visible  |
|-------------|-------------------------|-------------------|----------|
| `feat`      | New feature             | **Added**         | ✅ Yes    |
| `fix`       | Bug fix                 | **Fixed**         | ✅ Yes    |
| `perf`      | Performance improvement | **Changed**       | ✅ Yes    |
| `docs`      | Documentation only      | **Documentation** | ✅ Yes    |
| `revert`    | Revert previous commit  | **Reverted**      | ✅ Yes    |
| `security`  | Security fix            | **Security**      | ✅ Yes    |
| `deprecate` | Deprecation notice      | **Deprecated**    | ✅ Yes    |
| `remove`    | Feature removal         | **Removed**       | ✅ Yes    |
| `refactor`  | Code refactoring        | **Changed**       | ❌ Hidden |
| `style`     | Code style/formatting   | **Changed**       | ❌ Hidden |
| `test`      | Test changes            | **Changed**       | ❌ Hidden |
| `build`     | Build system changes    | **Changed**       | ❌ Hidden |
| `ci`        | CI/CD changes           | **Changed**       | ❌ Hidden |
| `chore`     | Maintenance tasks       | **Changed**       | ❌ Hidden |

## 📝 Examples

### Basic Commits

```bash
# New feature
git commit -m "feat(templates): add state diagram template"

# Bug fix
git commit -m "fix(flowchart): resolve reserved keyword conflict"

# Documentation
git commit -m "docs(guides): add troubleshooting section"

# Performance improvement
git commit -m "perf(parser): optimize Mermaid syntax validation"
```

### With Scope

Scopes indicate which part of the project is affected:

```bash
git commit -m "feat(commands): add /validate-diagram slash command"
git commit -m "fix(skills): correct auto-activation trigger phrase"
git commit -m "docs(readme): update installation instructions"
git commit -m "style(templates): improve indentation consistency"
```

### With Body

For more complex changes, add a detailed explanation:

```bash
git commit -m "feat(templates): add state diagram template

State diagram template includes:
- 5 predefined states (idle, processing, success, error, timeout)
- Semantic color system applied
- Transition documentation in comments
- Example implementation for user workflow

Supports all Mermaid state diagram features."
```

### Breaking Changes

Indicate breaking changes with `!` or `BREAKING CHANGE:` footer:

**Option 1: Using `!`**

```bash
git commit -m "feat!: redesign template API

Templates now require explicit color configuration.
Old automatic color detection removed."
```

**Option 2: Using footer**

```bash
git commit -m "feat: redesign template API

BREAKING CHANGE: Templates now require explicit color configuration.
The automatic color detection has been removed. Update your usage:

Before:
  template.render()

After:
  template.render({ colors: 'semantic' })"
```

### Issue References

Reference issues in the footer:

```bash
git commit -m "fix(parser): handle empty nodes correctly

Closes #42
Fixes #38"
```

Or inline:

```bash
git commit -m "fix(parser): handle empty nodes correctly, closes #42"
```

## ✅ Good Commit Messages

### Clear and Specific

```bash
✅ git commit -m "feat(templates): add flowchart template with 8 node types"
✅ git commit -m "fix(guides): correct Mermaid syntax in sequence diagram example"
✅ git commit -m "docs(contributing): add conventional commits section"
```

### Imperative Mood

Use imperative mood (commands) not past tense:

```bash
✅ "add feature"      (correct)
❌ "added feature"    (incorrect)

✅ "fix bug"          (correct)
❌ "fixed bug"        (incorrect)

✅ "update docs"      (correct)
❌ "updated docs"     (incorrect)
```

### Concise but Descriptive

```bash
✅ "feat(commands): add /create-flowchart with natural language support"
✅ "fix(templates): resolve color inheritance in nested nodes"
❌ "feat: stuff"
❌ "fix: bug"
❌ "update"
```

## ❌ Bad Commit Messages

```bash
❌ "wip"                           # Too vague
❌ "fix stuff"                     # Not descriptive
❌ "Added new feature"             # Past tense, no type
❌ "feat: did things"              # Vague subject
❌ "updated files"                 # No type, not specific
❌ "feat(templates) add template"  # Missing colon after scope
```

## 🤖 Using AI for Commit Messages

Many developers use AI to generate descriptive commit messages:

```bash
# 1. Stage your changes
git add .

# 2. Get diff
git diff --cached

# 3. Ask AI to generate commit message
# Example prompt: "Generate a conventional commit message for these changes"

# 4. Review and commit
git commit -m "feat(templates): add comprehensive state diagram template"
```

**Tip**: Review AI-generated messages for accuracy before committing.

## 🔧 Commit Message Validation

This project uses commit message validation (if configured):

```bash
# Valid - will pass
git commit -m "feat(templates): add new template"

# Invalid - will fail
git commit -m "added template"  # Missing type
```

To bypass validation (not recommended):

```bash
git commit --no-verify -m "message"
```

## 📚 Real Examples from This Project

```bash
# Initial release
git commit -m "feat: initial usable release with templates, guides, and examples"

# Documentation improvement
git commit -m "feat: improve readability and add versioning support"

# Future examples
git commit -m "feat(commands): add universal slash commands for Claude Code and Cursor"
git commit -m "feat(skills): add auto-activation skills for diagram creation"
git commit -m "fix(templates): correct flowchart reserved keyword handling"
git commit -m "docs(guides): expand common pitfalls with 5 new scenarios"
```

## 🎯 Best Practices

1. **Commit often**: Small, focused commits are better than large ones
2. **One concern per commit**: Each commit should address one specific change
3. **Use scope**: Helps locate changes quickly (`git log --oneline --grep="scope:"`)
4. **Write for others**: Someone should understand the change without seeing the code
5. **Reference issues**: Link commits to issues/PRs for traceability
6. **Be consistent**: Follow these conventions for every commit

## 📖 Related Documentation

- [CHANGELOG Conventions](./changelog.md) - How commits become CHANGELOG entries
- [Versioning Strategy](./versioning.md) - How commits affect version bumps
- [Release Workflow](./releases.md) - Complete release process

## 🔗 External Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
- [Semantic Release: Commit Message Format](https://semantic-release.gitbook.io/semantic-release/#commit-message-format)
