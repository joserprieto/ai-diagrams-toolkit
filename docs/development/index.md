# Development Documentation

Guides for contributors and developers working on the AI Diagrams Toolkit.

---

## 📚 Contents

- [**Testing Guide**](./testing-guide.md) - How to write and execute tests for AI slash commands
- [**Setup Guide**](./setup-guide.md) - Development environment setup _(Coming soon)_
- [**Contributing Guide**](./contributing-guide.md) - How to contribute to the project _(See root CONTRIBUTING.md)_

---

## 🚀 Quick Start

### For Contributors

1. **Fork and clone** the repository
2. **Install dependencies**: `make check/deps`
3. **Read** [Testing Guide](./testing-guide.md)
4. **Make changes** following conventions in `/docs/conventions/`
5. **Test** using both manual and automated methods
6. **Submit PR** with conventional commit messages

### For Maintainers

1. **Review PRs** against quality standards
2. **Run test suite** before merging
3. **Update documentation** when adding features
4. **Release** using `make release`

---

## 🧪 Testing

**Primary documentation**: [Testing Guide](./testing-guide.md)

**Quick commands**:

```bash
# Check dependencies
make check/deps

# Run automated tests
make test/commands

# View test results
ls tests/output/
```

**Testing philosophy**:

- Hybrid approach (manual + automated)
- See [Testing Strategy ADR](../architecture/testing-strategy.md) for rationale

---

## 📝 Conventions

All project conventions are documented in `/docs/conventions/`:

- [Makefile Conventions](../conventions/makefile.md)
- File naming, code style, commit format

---

## 🏗️ Architecture

Understanding architectural decisions helps make consistent contributions:

- [Testing Strategy](../architecture/testing-strategy.md) - Why hybrid testing
- [Orchestration](../architecture/orchestration.md) - Why Makefile
- [Versioning System](../architecture/versioning-system.md) - Release automation

---

## 🤝 Contributing

See root [`CONTRIBUTING.md`](../../CONTRIBUTING.md) for:

- Code of conduct
- Pull request process
- Commit message format
- Quality standards

---

## 📖 Related Documentation

- [Architecture Documentation](../architecture/index.md) - Technical decisions and system design
- [Conventions Documentation](../conventions/index.md) - Project standards and rules
- [Main README](../../README.md) - Project overview and quick start

---

**Last Updated**: 2025-11-12
