# Testing Strategy - Hybrid Approach for AI-Generated Content

**Decision**: Implement a hybrid testing strategy combining manual interactive testing with automated CLI-based testing.

**Status**: Accepted (v0.2.0)

**Date**: 2025-11-12

**Author**: Jose R. Prieto

---

## 📋 Table of Contents

- [Decision](#decision)
- [Context](#context)
- [Problem Statement](#problem-statement)
- [Rationale](#rationale)
- [Hybrid Testing Architecture](#hybrid-testing-architecture)
- [Benefits](#benefits)
- [Trade-offs](#trade-offs)
- [Alternatives Considered](#alternatives-considered)
- [Implementation](#implementation)
- [Examples](#examples)
- [Future Evolution](#future-evolution)
- [References](#references)

---

## Decision

**We implement a hybrid testing approach** that combines:

1. **Manual/Interactive Testing** - Real user validation in AI assistants
2. **Automated/CLI Testing** - Programmatic execution for repeatability

Both testing modes are **first-class citizens** and serve different, complementary purposes.

---

## Context

### The Unique Challenge of AI-Generated Content

The AI Diagrams Toolkit generates Mermaid diagrams through AI-powered slash commands. This presents unique testing
challenges:

**Traditional testing assumptions don't apply**:

- ❌ Deterministic outputs (AI may generate different valid solutions)
- ❌ Exact string matching (creativity is desired, not problematic)
- ❌ Unit test granularity (whole diagrams are atomic units)

**What we actually need to validate**:

- ✅ Diagrams render without syntax errors
- ✅ Semantic naming conventions followed (not A, B, C)
- ✅ Semantic color system applied correctly
- ✅ No reserved keywords used as node IDs
- ✅ Educational quality (explanations, comments)
- ✅ User experience in real AI assistants

### The Testing Gap

Before v0.2.0, we had:

- ✅ Templates (manually verified)
- ✅ Guides (manually reviewed)
- ✅ Examples (visual inspection)
- ❌ **No automated validation of AI commands**
- ❌ **No way to test slash commands before release**

---

## Problem Statement

**How do we test AI-generated diagram commands effectively?**

Requirements:

1. Validate that slash commands work in real AI assistants (Claude Code, Cursor)
2. Ensure consistent quality (semantic names, colors, no reserved keywords)
3. Enable repeatable testing for CI/CD
4. Support both development iteration and release validation
5. Maintain test suite as documentation/examples

Constraints:

- AI outputs are non-deterministic (same prompt → different valid diagrams)
- Interactive AI assistants can't be easily automated
- Must work for both local development and future CI/CD
- Test suite should be valuable reference material

---

## Rationale

### Why Hybrid (Not Just One Approach)?

The hybrid approach addresses fundamentally different validation needs:

#### Manual Testing Validates: **User Experience**

**What it proves**:

- Slash commands actually work in Claude Code
- Slash commands actually work in Cursor
- AGENTS.md loads and is followed
- AI assistant applies semantic color system
- User workflow is smooth and intuitive
- Educational quality meets standards

**Why automation can't replace it**:

- Interactive context matters (conversation history, user refinement)
- Skills and subagents require interactive sessions
- UX quality is subjective and requires human judgment
- Real-world usage reveals edge cases

#### Automated Testing Validates: **Repeatability & Quality**

**What it proves**:

- Commands work non-interactively (CI/CD readiness)
- Output quality is measurable (syntax, conventions)
- Regression detection (breaking changes)
- Performance baseline (response time)
- Documentation accuracy (examples work)

**Why manual can't replace it**:

- Not repeatable at scale
- Slow for regression testing
- Human fatigue introduces errors
- Can't run on every commit

### The Complementary Nature

```
┌─────────────────────────────────────────────────────────────┐
│                    TESTING PYRAMID                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Manual/Interactive (Top)                                   │
│  ────────────────────────────────────────                   │
│  • User experience validation                               │
│  • Skills & subagent testing                                │
│  • Multi-turn conversation flows                            │
│  • Subjective quality assessment                            │
│  • Edge case discovery                                      │
│                                                             │
│  ═══════════════════════════════════════                    │
│                                                             │
│  Automated/CLI (Base)                                       │
│  ─────────────────────────────────────                      │
│  • Syntax validation                                        │
│  • Convention compliance                                    │
│  • Regression detection                                     │
│  • Performance benchmarks                                   │
│  • CI/CD integration                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Frequency:     Interactive: Pre-release, feature dev
               Automated:    Every commit, pre-release
```

---

## Hybrid Testing Architecture

### Layer 1: Test Definitions (Self-Contained Directories)

**Location**: `tests/commands/XX-test-name/`

**Structure**: Each test is a self-contained directory with:

```
tests/commands/01-create-flowchart/
├── test.sh                    # Executable test script
├── prompt.txt                 # AI prompt (with {INPUT} placeholder support)
├── input.mmd                  # Optional input diagram
└── expected-criteria.md       # Automated + manual validation criteria
```

**Example**: `tests/commands/01-create-flowchart/prompt.txt`

```
Create a Mermaid flowchart diagram for an API request validation system.

Requirements:
1. Use semantic node names (no A, B, C)
2. Apply semantic color system using classDef
3. Use proper Mermaid syntax (graph TD)

Output ONLY the complete Mermaid diagram code.
```

**Example**: `tests/commands/01-create-flowchart/expected-criteria.md`

```markdown
## Automated (checked by test.sh)
- [x] Has graph declaration
- [x] Contains classDef block
- [x] Has class assignments

## Manual Verification Required
- [ ] Diagram renders without errors
- [ ] Semantic names (not A, B, C)
- [ ] Colors match meanings
```

**Key insight**: Self-contained, executable, autodescriptive tests.

### Layer 2: Execution Modes

#### Mode A: Manual/Interactive

**Executor**: Human tester in Claude Code or Cursor

**Process**:

1. Open AI assistant
2. Execute slash command with test prompt
3. Review generated diagram
4. Check quality criteria manually
5. Document results

**Output**: Subjective quality assessment

**Frequency**:

- New feature development
- Pre-release validation
- Edge case investigation

#### Mode B: Automated/CLI

**Executor**: `make test/commands` (Makefile target)

**Process**:

1. Discover all test directories (`[0-9][0-9]-*` pattern)
2. For each test:
   - Execute `test.sh` script
   - Read `prompt.txt` and optional `input.mmd`
   - Replace `{INPUT}` placeholder if present
   - Execute AI CLI: `${AI_CLI_EXECUTOR} -p "${PROMPT}" --output-format json`
   - Parse JSON response with `jq -r '.response'`
   - Extract Mermaid diagram
   - Run automated validations (grep patterns)
   - Store results in `tests/output/test-name/`
3. Report summary (passed/failed)

**Output**:

- Machine-readable results
- Capturable artifacts in `tests/output/`
- Comparable outputs
- Pass/fail exit codes

**Frequency**:

- Pre-commit hooks (future)
- CI/CD pipeline (future)
- Pre-release validation (now)

### Layer 3: Validation

**Automated Validation** (objective):

```bash
# Check 1: Syntax valid (Mermaid parser)
mermaid-cli validate diagram.mmd

# Check 2: No reserved keywords
grep -E "^\s*(end|class|style|click)\[" diagram.mmd && FAIL

# Check 3: Semantic naming (not A, B, C)
grep -E "^\s*[A-Z]\[" diagram.mmd && FAIL

# Check 4: Has color definitions
grep "classDef" diagram.mmd || FAIL
```

**Manual Validation** (subjective):

- [ ] Diagram communicates intent clearly
- [ ] Educational comments present
- [ ] Color choices make semantic sense
- [ ] User would understand this diagram
- [ ] Follows toolkit philosophy

---

## Benefits

### 1. **Comprehensive Coverage**

**Before** (v0.1.0):

- ✅ Templates work (manual verification)
- ❌ AI commands untested
- ❌ No regression detection

**After** (v0.2.0):

- ✅ Templates work
- ✅ AI commands work (both modes)
- ✅ Regression detection (automated)
- ✅ UX validation (manual)

### 2. **Development Velocity**

**Interactive testing during development**:

- Rapid iteration on command prompts
- Immediate feedback on UX
- Quick edge case discovery

**Automated testing for confidence**:

- Run full suite before commit
- Catch regressions immediately
- Validate refactoring safety

### 3. **CI/CD Readiness**

**Foundation for future automation**:

- Tests already designed for `claude -p` execution
- Output format standardized (JSON)
- Validation scripts reusable
- Minimal effort to integrate with GitHub Actions

### 4. **Living Documentation**

**Test files serve as**:

- Usage examples for users
- Reference implementations
- Expected quality standards
- Tutorial material

### 5. **Quality Assurance**

**Objective quality** (automated):

- No syntax errors slip through
- Conventions consistently enforced
- Performance regressions caught

**Subjective quality** (manual):

- Educational value maintained
- User experience validated
- Edge cases discovered

---

## Trade-offs

### Accepted Trade-offs

| Trade-off                              | Why Acceptable                                                            |
|----------------------------------------|---------------------------------------------------------------------------|
| **More complex than single approach**  | Complexity is inherent to the problem; hybrid addresses real needs        |
| **Manual tests not CI/CD integrated**  | Interactive value justifies manual effort; subset will automate later     |
| **Requires `claude` CLI installation** | Reasonable dev dependency; same tool users have                           |
| **Non-deterministic outputs**          | AI creativity is feature, not bug; validation focuses on quality patterns |
| **Initial setup effort**               | One-time cost for long-term maintainability                               |

### Mitigations

**Complexity**:

- Clear documentation (this ADR + testing guide)
- Shared test definitions reduce duplication
- Makefile abstracts automation complexity

**Manual effort**:

- Prioritize critical paths for manual testing
- Automate subset as smoke tests
- Manual tests double as demos

**Tool dependency**:

- `claude` CLI is same tool users install
- Graceful degradation if missing
- `make check/deps` validates availability

---

## Alternatives Considered

### Alternative 1: Manual Testing Only

**Approach**: Only test slash commands interactively

**Pros**:

- Simple (no automation)
- Real user experience
- Catches UX issues

**Cons**:

- ❌ Not repeatable
- ❌ No CI/CD integration
- ❌ Slow regression testing
- ❌ Human fatigue errors
- ❌ Can't run on every commit

**Rejected because**: No path to automation, doesn't scale.

### Alternative 2: Automated Testing Only

**Approach**: Only use `claude -p` CLI testing

**Pros**:

- Repeatable
- CI/CD ready
- Fast execution
- Scalable

**Cons**:

- ❌ Misses interactive context
- ❌ Can't test skills/subagents
- ❌ UX issues invisible
- ❌ Multi-turn flows impossible

**Rejected because**: Doesn't validate real user experience.

### Alternative 3: Mock-Based Unit Tests

**Approach**: Mock AI responses, test command parsing/validation

**Pros**:

- Very fast
- Deterministic
- Traditional TDD

**Cons**:

- ❌ Doesn't test actual AI integration
- ❌ Mocks drift from reality
- ❌ Misses AI quality issues
- ❌ High maintenance (mock updates)

**Rejected because**: Testing toolkit without AI is testing the wrong thing.

### Alternative 4: Snapshot Testing

**Approach**: Record AI outputs, compare future runs to snapshots

**Pros**:

- Catches regressions
- Low initial effort

**Cons**:

- ❌ Brittleness (AI non-determinism)
- ❌ Snapshots become outdated
- ❌ Doesn't validate quality, just consistency
- ❌ False positives common

**Rejected because**: AI non-determinism makes this impractical.

### Alternative 5: Property-Based Testing

**Approach**: Define properties (has colors, no reserved keywords), generate random inputs

**Pros**:

- Finds edge cases
- Validates invariants

**Cons**:

- ❌ Doesn't validate specific use cases
- ❌ Hard to generate meaningful diagram prompts
- ❌ Unclear which properties matter for UX

**Rejected because**: Better as complement, not replacement.

### Decision Matrix

| Approach       | Repeatability | UX Validation | CI/CD Ready | Effort | Decision     |
|----------------|---------------|---------------|-------------|--------|--------------|
| Manual Only    | ❌ Low         | ✅ High        | ❌ No        | Low    | ❌ Reject     |
| Automated Only | ✅ High        | ❌ Low         | ✅ Yes       | Medium | ❌ Reject     |
| Mock-Based     | ✅ High        | ❌ None        | ✅ Yes       | High   | ❌ Reject     |
| Snapshot       | ⚠️ Medium     | ❌ Low         | ✅ Yes       | Low    | ❌ Reject     |
| Property-Based | ✅ High        | ❌ Low         | ✅ Yes       | High   | ⚠️ Future    |
| **Hybrid**     | ✅ High        | ✅ High        | ✅ Yes       | Medium | ✅ **Accept** |

---

## Implementation

### Phase 1: Foundation (v0.2.0) ✅

**Deliverables**:

- ✅ Self-contained test directories (`tests/commands/01-create-flowchart/`, etc.)
- ✅ Executable test scripts (`test.sh` with automated validations)
- ✅ Separated concerns (`prompt.txt`, `input.mmd`, `expected-criteria.md`)
- ✅ Test orchestration (`run-all.sh` with automatic discovery)
- ✅ Automated execution via `make test/commands`
- ✅ Graceful dependency handling (early checks for AI executor and jq)
- ✅ Manual testing checklist in `expected-criteria.md`
- ✅ This ADR + TESTING-UPDATE.md documentation

**Implemented Tests**:

1. `01-create-flowchart/` - Create flowchart from description
2. `02-apply-colors/` - Apply semantic colors to existing diagram
3. `03-create-sequence/` - Create sequence diagram
4. `04-validate-diagram/` - Identify issues and provide corrections

**Automation**:

```makefile
.PHONY: test/commands
test/commands: check/deps ## Test AI slash commands (automated)
	$(call print_header,Testing AI Commands)
	@bash tests/commands/run-all.sh

.PHONY: test/commands/single
test/commands/single: check/deps ## Test single command
	@bash "tests/commands/$(TEST)/test.sh"
```

**Test Structure**:

```bash
# Each test.sh script:
#!/bin/bash
set -euo pipefail

TEST_NAME="create-flowchart"
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${TEST_DIR}/../../output/${TEST_NAME}"

# Read prompt and optional input
PROMPT="$(cat "${TEST_DIR}/prompt.txt")"

# Execute AI CLI
"${AI_CLI_EXECUTOR:-claude}" -p "${PROMPT}" \
    --output-format json > "${OUTPUT_DIR}/response.json"

# Extract and validate
jq -r '.response' "${OUTPUT_DIR}/response.json" \
    > "${OUTPUT_DIR}/diagram.mmd"

# Automated checks (grep patterns)
# - Has graph declaration
# - Contains classDef
# - Has class assignments
# etc.
```

**Dependencies** (with graceful degradation):

```bash
# run-all.sh checks dependencies early:
if ! command -v "${AI_CLI_EXECUTOR}" >/dev/null 2>&1; then
    echo "⚠ AI executor not found"
    echo "Install: https://docs.anthropic.com/claude/docs/claude-cli"
    exit 1
fi
```

### Phase 2: Validation (v0.3.0) - Planned

**Add automated validation**:

```bash
# Syntax validation
mermaid-cli validate tests/output/*.mmd

# Convention validation (script)
./scripts/validate-conventions.sh tests/output/
```

**Add quality metrics**:

```bash
# Measure response time
# Count nodes/edges
# Complexity analysis
```

### Phase 3: CI/CD (v1.0.0) - Planned

**GitHub Actions workflow**:

```yaml
name: Test AI Commands
on: [ push, pull_request ]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: |
          npm install -g @mermaid-js/mermaid-cli
          # Install claude CLI
      - name: Run tests
        run: make test/commands
      - name: Validate outputs
        run: make validate/diagrams
```

---

## Examples

### Example 1: Testing create-flowchart

**Test Definition** (`tests/commands/test-create-flowchart.md`):

```markdown
# Test: create-flowchart command

Create a flowchart for user authentication process with:

- Email/password validation
- Database lookup
- Error handling
- Session generation

Requirements:

- Semantic node names (SessionStart, ValidateFormat)
- Decision points: warning (yellow)
- Error paths: error (red)
- Success: operational (green)
```

**Manual Execution**:

```
# In Claude Code
/create-flowchart [paste test description]

# Visual review:
✅ Diagram renders
✅ Colors semantically correct
✅ No reserved keywords
✅ Educational comments present
```

**Automated Execution**:

```bash
make test/commands

# Output:
✓ Diagram generated: tests/output/01-flowchart.mmd
✓ Syntax valid
✓ No reserved keywords
✓ Has classDef definitions
```

### Example 2: Testing apply-colors

**Test Definition** (`tests/commands/test-apply-colors.md`):

```markdown
# Test: apply-colors command

Given this uncolored diagram:
[Mermaid diagram without colors]

Apply semantic color system based on meaning.
```

**Manual Execution**:

```
/apply-colors [paste diagram]

# Verify:
✅ Colors match semantic meaning
✅ Explanations provided
✅ classDef block added
```

**Automated Execution**:

```bash
# Capture before/after
# Validate color classes exist
# Check explanations in response
```

---

## Future Evolution

### Short Term (v0.3.0)

**Add validation scripts**:

- Syntax checker (mermaid-cli)
- Convention validator (custom script)
- Quality metrics collector

**Expand test coverage**:

- All 4 slash commands tested
- Edge cases documented
- Performance baseline established

### Medium Term (v1.0.0)

**CI/CD integration**:

- GitHub Actions workflow
- Automated PR validation
- Performance regression detection

**Visual regression testing**:

- Render diagrams to SVG
- Compare visual output
- Detect rendering changes

### Long Term (v2.0.0+)

**Property-based testing**:

- Generate random valid prompts
- Validate invariants hold
- Discover edge cases automatically

**Mutation testing**:

- Introduce intentional errors
- Verify validation catches them
- Measure test effectiveness

**User acceptance testing**:

- Real user feedback loop
- A/B testing of prompt variations
- Quality scoring system

---

## References

### Internal Documentation

- [Testing Guide](../development/testing-guide.md) - Practical guide to writing and running tests
- [Makefile Conventions](../conventions/makefile.md) - Test target standards
- [AI Tooling Architecture](./ai-tooling.md) - How slash commands work _(coming soon)_

### External Resources

- [Claude CLI Documentation](https://docs.anthropic.com/claude/docs/claude-cli)
- [Testing AI Systems](https://www.deeplearning.ai/short-courses/evaluating-debugging-generative-ai/) - DeepLearning.AI
  course
- [Property-Based Testing](https://hypothesis.works/articles/what-is-property-based-testing/) - Hypothesis framework
- [Continuous Testing for AI](https://martinfowler.com/articles/cd4ml.html) - Martin Fowler article

### Related ADRs

- [Orchestration Decision](./orchestration.md) - Why Makefile for test automation
- [Versioning System](./versioning-system.md) - Release testing integration

---

**Last Updated**: 2025-11-12
**Version**: 1.0.0
**Status**: Accepted and Implemented (v0.2.0)
