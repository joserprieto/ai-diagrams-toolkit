# Semantic Versioning Strategy

This project strictly follows [Semantic Versioning 2.0.0](https://semver.org/).

## 📐 Version Format

```
MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]
```

### Components

- **MAJOR**: Incompatible API changes (breaking changes)
- **MINOR**: Backwards-compatible new features
- **PATCH**: Backwards-compatible bug fixes
- **PRERELEASE**: Optional pre-release identifier (e.g., `alpha.1`, `beta.2`, `rc.1`)
- **BUILD**: Optional build metadata (e.g., `20250111`, `abc123`)

### Examples

```
0.1.0           - Development version
0.2.0           - Development with new features
1.0.0           - First stable release
1.2.3           - Stable with features and fixes
2.0.0           - Major version with breaking changes
2.0.0-alpha.1   - Pre-release (alpha)
2.0.0-beta.2    - Pre-release (beta)
2.0.0-rc.1      - Release candidate
1.0.0+20250101  - Build metadata
```

## 🔄 Bump Rules (Automated)

The release tool automatically calculates version bumps based on commits:

| Commit Type        | Bump      | Example           | When to Use           |
|--------------------|-----------|-------------------|-----------------------|
| `feat:`            | **MINOR** | `1.2.3` → `1.3.0` | New feature added     |
| `fix:`             | **PATCH** | `1.2.3` → `1.2.4` | Bug fixed             |
| `perf:`            | **PATCH** | `1.2.3` → `1.2.4` | Performance improved  |
| `docs:`            | **PATCH** | `1.2.3` → `1.2.4` | Documentation updated |
| `feat!:`           | **MAJOR** | `1.2.3` → `2.0.0` | Breaking change       |
| `BREAKING CHANGE:` | **MAJOR** | `1.2.3` → `2.0.0` | Breaking change       |

### Multiple Commits

When multiple commits are present, the **highest** bump wins:

```bash
# Commits since last release:
feat: add new template      # MINOR bump
fix: resolve parser bug     # PATCH bump
feat: add AI commands       # MINOR bump

# Result: MINOR bump (1.2.3 → 1.3.0)
```

```bash
# Commits since last release:
feat: add feature           # MINOR bump
fix: fix bug                # PATCH bump
feat!: redesign API         # MAJOR bump

# Result: MAJOR bump (1.2.3 → 2.0.0)
```

## 🌱 Version Lifecycle

### Development Phase (0.x.y)

```
0.1.0 → 0.2.0 → 0.3.0 → ... → 1.0.0
```

**Characteristics**:

- API can change freely
- Breaking changes allowed without MAJOR bump
- For initial development and experimentation
- Signals "not production-ready"

**This Project**:

- `0.1.0` - Initial usable release (templates + guides)
- `0.2.0` - AI commands added
- `0.3.0` - Skills and subagents added
- `1.0.0` - Production-ready, stable API

### Stable Phase (≥1.0.0)

```
1.0.0 → 1.1.0 → 1.2.0 → 2.0.0
```

**Characteristics**:

- API is stable
- Breaking changes require MAJOR bump
- MINOR for new features (backwards-compatible)
- PATCH for bug fixes (backwards-compatible)

**Guarantees**:

- `1.x.y` versions are compatible with each other
- `1.2.3` → `1.3.0` is safe to upgrade (no breaking changes)
- `1.x.y` → `2.0.0` requires migration (breaking changes)

## 🎮 Release Commands

### Automatic Version Detection

```bash
# Analyzes commits and auto-detects bump type
make release
```

**How it works**:

1. Finds last git tag (e.g., `v0.1.0`)
2. Analyzes all commits since that tag
3. Determines bump type (MAJOR/MINOR/PATCH)
4. Updates version, CHANGELOG, creates tag

### Manual Override

When you need to force a specific bump:

```bash
# Force PATCH (0.1.2 → 0.1.3)
make release/patch

# Force MINOR (0.1.2 → 0.2.0)
make release/minor

# Force MAJOR (0.1.2 → 1.0.0)
make release/major
```

**Use cases**:

- Force `1.0.0` when ready for production
- Create PATCH for documentation-only changes
- Override auto-detection when needed

### Preview Before Release

```bash
# Simulate release without making changes
make release/dry-run
```

**Output shows**:

- Detected version bump
- New version number
- CHANGELOG preview
- No actual changes made

## 🎯 Special Cases

### First Release

**Scenario**: Creating the very first release

```bash
# Ensure .semver contains desired version
echo "0.1.0" > .semver

# Ensure .versionrc.js has firstRelease: true
# (Already configured correctly)

# Create first release
make release
```

**Result**:

- Creates tag `v0.1.0`
- No version bump (uses existing version in `.semver`)
- Generates initial CHANGELOG

### Pre-releases

**Scenario**: Testing changes before stable release

```bash
# Create alpha pre-release
npx commit-and-tag-version --prerelease alpha
# 1.0.0 → 1.0.1-alpha.0

# Another alpha
npx commit-and-tag-version --prerelease alpha
# 1.0.1-alpha.0 → 1.0.1-alpha.1

# Promote to beta
npx commit-and-tag-version --prerelease beta
# 1.0.1-alpha.1 → 1.0.1-beta.0

# Promote to release candidate
npx commit-and-tag-version --prerelease rc
# 1.0.1-beta.0 → 1.0.1-rc.0

# Final release
npx commit-and-tag-version
# 1.0.1-rc.0 → 1.0.1
```

**Use cases**:

- Beta testing with select users
- Internal testing before public release
- Gradual rollout of major changes

### Breaking Changes

**Scenario**: Making incompatible API changes

**Option 1: Using `!` suffix**

```bash
git commit -m "feat!: redesign template API"
```

**Option 2: Using `BREAKING CHANGE:` footer**

```bash
git commit -m "feat: redesign template API

BREAKING CHANGE: Templates now require explicit color configuration.
The automatic color detection has been removed.

Migration guide:
  Before: template.render()
  After:  template.render({ colors: 'semantic' })"
```

**Both trigger MAJOR version bump**:

- `1.2.3` → `2.0.0`
- `0.2.3` → `0.3.0` (in development phase)

### Hotfix Releases

**Scenario**: Critical bug in production requires immediate fix

```bash
# 1. Branch from production tag
git checkout -b hotfix/v1.2.4 v1.2.3

# 2. Make fix
git commit -m "fix(critical): resolve security vulnerability CVE-2025-1234"

# 3. Create patch release
make release/patch

# 4. Push hotfix
git push origin hotfix/v1.2.4 --follow-tags

# 5. Merge back to main
git checkout main
git merge hotfix/v1.2.4

# 6. Clean up
git branch -d hotfix/v1.2.4
```

**Result**: `v1.2.3` → `v1.2.4` with critical fix

## 📄 Version File (`.semver`)

Single source of truth for version number:

```
0.1.0
```

**Why separate file?**

- No `package.json` needed (project is not Node.js code)
- Simple, clear, language-agnostic
- Easy to parse programmatically
- Updated automatically by release tool

**Manual editing** (rarely needed):

```bash
# Only for first release or version corrections
echo "0.1.0" > .semver
git add .semver
git commit -m "chore: set initial version"
```

## 🏷️ Git Tags

### Format

```
v{VERSION}
```

**Examples**:

- `v0.1.0`
- `v1.2.3`
- `v2.0.0-alpha.1`
- `v1.0.0+20250111`

### Tag Types

This project uses **lightweight tags**:

```bash
# Created automatically by make release
git tag v0.1.0
```

**Not annotated tags**:

```bash
# We don't use this (more complex, less common in automation)
git tag -a v0.1.0 -m "Release v0.1.0"
```

**Why lightweight?**

- Simpler
- Standard in CI/CD automation
- Release notes in CHANGELOG, not tag annotation
- GitHub Release extracts from CHANGELOG

### Viewing Tags

```bash
# List all tags
git tag

# Show tags with dates
git log --tags --simplify-by-decoration --pretty="format:%ai %d"

# Show specific tag
git show v0.1.0
```

## 📊 Version History Example

This project's planned version history:

```
v0.1.0 (2025-11-11)   - Initial release (templates, guides, examples)
  ↓ feat(commands)
v0.2.0 (2025-11-12)   - AI commands added
  ↓ feat(skills)
v0.3.0 (2025-11-13)   - Skills and subagent added
  ↓ feat!, docs, perf (API stable)
v1.0.0 (2025-12-01)   - Production ready, stable API
  ↓ feat(tokens)
v1.1.0 (2026-01-15)   - Design tokens CLI added
  ↓ fix(templates)
v1.1.1 (2026-02-01)   - Template bug fixes
  ↓ feat(ci)
v1.2.0 (2026-03-01)   - GitHub Actions workflows
  ↓ feat! (breaking changes)
v2.0.0 (2026-06-01)   - Major redesign
```

## 🛡️ Best Practices

### 1. Commit Frequently

```bash
# Good: Small, atomic commits
git commit -m "feat(templates): add flowchart template"
git commit -m "feat(templates): add sequence template"
# Release combines both → v0.2.0

# Avoid: One huge commit
git commit -m "feat: add everything"
```

### 2. Plan Breaking Changes

```bash
# Group breaking changes together in one release
# Avoid spreading them across multiple versions
```

### 3. Use Pre-releases for Testing

```bash
# Before jumping to v2.0.0, test with pre-releases
v1.9.0 → v2.0.0-alpha.1 → v2.0.0-beta.1 → v2.0.0-rc.1 → v2.0.0
```

### 4. Document Breaking Changes

```bash
# Always include migration guide in commit body
git commit -m "feat!: redesign API

BREAKING CHANGE: ...

Migration guide:
  Before: ...
  After: ...
"
```

### 5. Verify Before Pushing

```bash
# Always dry-run first
make release/dry-run

# Verify version and CHANGELOG
cat .semver
git show HEAD:CHANGELOG.md

# Then push
git push --follow-tags
```

## 🐛 Troubleshooting

### Wrong Version Bump

```bash
# After make release but before git push
git tag -d v0.2.0                    # Delete wrong tag
git reset --soft HEAD~1              # Undo release commit

# Fix: Use manual override
make release/minor                   # Force correct version
```

### Skipped Version Numbers

**Problem**: Went from `v0.1.0` to `v0.3.0`, skipping `v0.2.0`

**Solution**: This is fine! Semantic Versioning doesn't require sequential MINOR/PATCH numbers.

### Version in Wrong Phase

**Problem**: Jumped to `v1.0.0` too early, API not stable

**Solution**:

```bash
# Can't undo published releases
# Continue with v1.x.x
# Mark clearly in docs: "API unstable, breaking changes may occur"
# Plan v2.0.0 for stable API
```

## 📖 Related Documentation

- [Commits Guide](./commits.md) - How to write conventional commits
- [CHANGELOG Guide](./changelog.md) - How versions appear in CHANGELOG
- [Releases Guide](./releases.md) - Complete release workflow

## 🔗 External Resources

- [Semantic Versioning 2.0.0](https://semver.org/)
- [SemVer FAQ](https://semver.org/#faq)
- [GitHub: About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
