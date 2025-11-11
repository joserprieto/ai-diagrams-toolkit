# Conventions

This directory contains documentation about project conventions and standards.

## 📚 Contents

- [**Commits**](./commits.md) - Conventional Commits specification and examples
- [**CHANGELOG**](./changelog.md) - CHANGELOG format and automation system
- [**Versioning**](./versioning.md) - Semantic Versioning strategy and bump rules
- [**Releases**](./releases.md) - Complete release workflow and troubleshooting
- [**Makefile**](./makefile.md) - Makefile orchestration and configuration system

## 🎯 Quick Reference

### Making Commits

```bash
# Format: type(scope): subject
git commit -m "feat(templates): add state diagram template"
git commit -m "fix(guides): correct Mermaid syntax in examples"
git commit -m "docs(readme): update quick start section"
```

See [Commits Guide](./commits.md) for details.

### Creating Releases

```bash
# Preview what will happen
make release/dry-run

# Create release (auto-detects version bump)
make release

# Push to GitHub
git push --follow-tags origin main
```

See [Releases Guide](./releases.md) for complete workflow.

### Understanding CHANGELOG

The CHANGELOG is **automatically generated** from commit messages:

- `feat:` commits → **Added** section
- `fix:` commits → **Fixed** section
- `perf:` commits → **Changed** section
- Previous versions are **never modified**

See [CHANGELOG Guide](./changelog.md) for mapping details.

### Version Bumping

| Commit Type                    | Version Bump | Example           |
|--------------------------------|--------------|-------------------|
| `feat:`                        | MINOR        | `0.1.0` → `0.2.0` |
| `fix:`                         | PATCH        | `0.1.0` → `0.1.1` |
| `feat!:` or `BREAKING CHANGE:` | MAJOR        | `0.1.0` → `1.0.0` |

See [Versioning Guide](./versioning.md) for complete strategy.

## 📖 Related Documentation

- [Contributing Guidelines](../../CONTRIBUTING.md) - How to contribute to this project
- [Roadmap](../../ROADMAP.md) - Planned features and timeline
- [Architecture Documentation](../architecture/README.md) - Technical architecture details

## 🔗 External References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version)
