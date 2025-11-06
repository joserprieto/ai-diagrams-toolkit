# Tests - AI Diagrams Toolkit

Test suite for validating templates, guides, and AI functionality.

## 📁 Structure

```
tests/
├── samples/      # Input descriptions for test cases
├── expected/     # Expected diagram outputs
├── output/       # Actual outputs (gitignored)
├── makefile/     # Makefile target tests
├── commands/     # Slash command tests (v0.2.0+)
├── skills/       # Skills tests (v0.3.0+)
├── subagent/     # Subagent tests (v0.3.0+)
└── integration/  # Integration tests (v0.3.0+)
```

## 🧪 Test Cases (v0.1.0)

### Manual Tests

**Templates rendering**:
1. Open each template in Mermaid-capable editor
2. Verify diagram renders without errors
3. Verify semantic colors applied correctly

**Guides validation**:
1. Read each guide
2. Verify no broken links
3. Verify examples render correctly

**Makefile targets**:
1. Run `make help` → Shows categorized help
2. Run `make clean` → Cleans temp files
3. Run `make check/deps` → Validates dependencies

### Test Samples

7 sample descriptions covering common use cases:
- 01: Generic process flow
- 02: Software component architecture
- 03: AWS cloud architecture
- 04: API interaction sequence
- 05: State machine
- 06: Class structure (OOP)
- 07: Multi-diagram system (1 concept → 4 diagram types)

### Expected Outputs

Reference diagrams showing correct implementation:
- Semantic naming (English node IDs)
- Semantic colors applied
- No reserved keywords
- Comments in English
- Production-ready syntax

## 🚀 Running Tests (v0.1.0)

### Manual Validation

```bash
# Check dependencies
make check/deps

# Verify help works
make help

# Clean temp files
make clean

# Open templates and verify they render
# Open guides and verify clarity
# Compare samples with expected outputs
```

## 📋 Test Execution Checklist (v0.1.0)

- [ ] `make check/deps` passes (git installed)
- [ ] `make help` shows categorized targets with colors
- [ ] `make clean` cleans temporary files
- [ ] All 4 templates render in Mermaid preview
- [ ] All 5 guides readable without errors
- [ ] All 3 examples render correctly
- [ ] Expected diagrams match quality standard

If all pass → v0.1.0 ready for commit and tag.

---

## 🔄 Future Tests (v0.2.0+)

**Automated tests** (v0.2.0):
- `make test/commands` - Test slash commands via `claude -p`
- Output captured in `tests/output/`
- Compared with `tests/expected/`

**Manual tests** (v0.3.0):
- Skills auto-activation (interactive Claude Code)
- Subagent multi-turn conversations

---

*Tests evolve with each version. See execution-plan-v2.md for complete test strategy.*
