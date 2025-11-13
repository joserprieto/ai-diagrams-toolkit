# Testing Guide - AI Diagrams Toolkit

Practical guide for writing and executing tests for AI slash commands.

**Audience**: Contributors, maintainers, and developers extending the toolkit.

**Prerequisites**: Understanding of [Testing Strategy ADR](../architecture/testing-strategy.md)

---

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Testing Philosophy](#testing-philosophy)
- [Test Structure](#test-structure)
- [Manual Testing](#manual-testing)
- [Automated Testing](#automated-testing)
- [Writing New Tests](#writing-new-tests)
- [Validation Checklist](#validation-checklist)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Quick Start

### Prerequisites

```bash
# Check all dependencies
make check/deps

# Expected output:
✓ git found
✓ claude found
✓ jq found
```

**Install missing dependencies**:

```bash
# macOS
brew install jq

# Install Claude CLI (if not already installed)
# See: https://docs.anthropic.com/claude/docs/claude-cli
```

### Run Automated Tests

```bash
# Run all command tests
make test/commands

# Output location
ls tests/output/
# 01-flowchart.mmd
# 01-flowchart.json
```

### Run Manual Tests

```bash
# In Claude Code or Cursor
/create-flowchart user login with email validation

# Verify:
# ✓ Diagram renders without errors
# ✓ Semantic colors applied
# ✓ No reserved keywords used
```

---

## Testing Philosophy

**Two complementary testing modes:**

### 1. Manual/Interactive Testing

**Purpose**: Validate user experience and AI integration

**When to use**:

- ✅ Developing new slash commands
- ✅ Pre-release validation
- ✅ Testing skills and subagents (v0.3.0+)
- ✅ Investigating edge cases
- ✅ Quality assessment (educational value, clarity)

**What it validates**:

- Real AI assistant behavior
- User workflow smoothness
- Educational quality
- Edge case discovery

### 2. Automated/CLI Testing

**Purpose**: Ensure repeatability and enable CI/CD

**When to use**:

- ✅ Pre-commit validation
- ✅ Regression testing
- ✅ CI/CD pipelines
- ✅ Performance benchmarking
- ✅ Convention compliance

**What it validates**:

- Syntax correctness
- Convention adherence
- Reproducibility
- Performance baseline

**Recommendation**: Use **both** for comprehensive coverage.

---

## Test Structure

### Directory Layout (v0.2.0)

```
tests/
├── commands/              # Self-contained test directories
│   ├── 01-create-flowchart/
│   │   ├── test.sh                    # Executable test script
│   │   ├── prompt.txt                 # AI prompt
│   │   └── expected-criteria.md       # Validation checklist
│   ├── 02-apply-colors/
│   │   ├── test.sh
│   │   ├── prompt.txt
│   │   ├── input.mmd                  # Input diagram
│   │   └── expected-criteria.md
│   ├── 03-create-sequence/
│   │   ├── test.sh
│   │   ├── prompt.txt
│   │   └── expected-criteria.md
│   ├── 04-validate-diagram/
│   │   ├── test.sh
│   │   ├── prompt.txt
│   │   ├── input.mmd
│   │   └── expected-criteria.md
│   ├── run-all.sh                     # Orchestrates all tests
│   └── _legacy/                       # Old markdown tests (reference)
└── output/                # Generated outputs (gitignored)
    ├── create-flowchart/
    │   ├── response.json
    │   └── diagram.mmd
    ├── apply-colors/
    │   └── ...
    └── ...
```

### Test Components (Self-Contained)

**Location**: `tests/commands/XX-test-name/`

Each test directory contains:

#### 1. `test.sh` (Executable Script)

```bash
#!/bin/bash
set -euo pipefail

TEST_NAME="create-flowchart"
TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="${TEST_DIR}/../../output/${TEST_NAME}"

# Read prompt
PROMPT="$(cat "${TEST_DIR}/prompt.txt")"

# Execute AI CLI
"${AI_CLI_EXECUTOR:-claude}" -p "${PROMPT}" \
    --output-format json > "${OUTPUT_DIR}/response.json"

# Extract and validate diagram
jq -r '.response' "${OUTPUT_DIR}/response.json" \
    > "${OUTPUT_DIR}/diagram.mmd"

# Automated validations (grep patterns)
# ...exit 0 or exit 1
```

#### 2. `prompt.txt` (AI Prompt)

```
Create a Mermaid flowchart diagram for an API request validation system.

Requirements:
1. Use semantic node names (no A, B, C)
2. Apply semantic color system using classDef
3. Use proper Mermaid syntax (graph TD)

Output ONLY the complete Mermaid diagram code.
```

Supports `{INPUT}` placeholder for tests needing input diagrams.

#### 3. `expected-criteria.md` (Validation Checklist)

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

#### 4. `input.mmd` (Optional Input)

For tests that need an existing diagram as input (e.g., apply-colors, validate-diagram).

**Example**: See `tests/commands/01-create-flowchart/`

---

## Manual Testing

### Prerequisites

**Claude Code** or **Cursor** installed with:

- `.ai/AGENTS.md` loaded (automatic)
- Slash commands available (`.claude/commands/` or `.cursor/commands/`)

### Step-by-Step Process

#### 1. Open AI Assistant

**Claude Code**:

```bash
# Open project in VS Code with Claude Code
code /path/to/ai-diagrams-toolkit
```

**Cursor**:

```bash
# Open project in Cursor
cursor /path/to/ai-diagrams-toolkit
```

#### 2. Verify Commands Available

```
# In chat, type:
/create-

# Should autocomplete:
/create-flowchart
/create-sequence
```

**Troubleshooting**: If commands don't appear, verify symlinks:

```bash
ls -la .claude/commands  # Should point to ../.ai/commands
ls -la .cursor/commands  # Should point to ../.ai/commands
```

#### 3. Execute Test

**Read test file**:

```bash
cat tests/commands/test-create-flowchart.md
```

**Execute command** in AI assistant:

```
/create-flowchart

Create a flowchart for user authentication with:
- Email and password validation
- Database lookup
- Error handling paths
- Session token generation

Requirements:
- Semantic node names (SessionStart, ValidateFormat)
- Decision points in warning color (yellow)
- Error paths in error color (red)
- Success in operational color (green)
```

#### 4. Validate Output

**Immediate checks**:

- [ ] Diagram renders in Mermaid preview (no syntax errors)
- [ ] Semantic node names used (not A, B, C)
- [ ] No reserved keywords (`end`, `class`, `style`)
- [ ] Colors match semantic meaning

**Quality checks**:

- [ ] Comments explain flow sections
- [ ] classDef block complete and correct
- [ ] Educational explanations provided
- [ ] User would understand diagram intent

**Advanced checks**:

- [ ] Handles edge cases gracefully
- [ ] Suggests improvements if applicable
- [ ] References guides for learning

#### 5. Document Results

**Create report** (optional but recommended):

```markdown
# Manual Test Report: create-flowchart

Date: 2025-11-12
Tester: [Your name]

## Test Execution

Command: /create-flowchart
Input: [Test description]

## Results

✅ Diagram renders correctly
✅ Semantic names used
✅ Colors applied correctly
⚠️ Minor: Could add more comments

## Notes

- Handles complex flows well
- Good educational quality
- Suggests reading guides (positive)
```

---

## Automated Testing

### Prerequisites

```bash
# Verify dependencies
make check/deps

# Install if missing
brew install jq
# Install claude CLI per docs
```

### Execution

#### Single Test

```bash
# Run specific test directory
bash tests/commands/01-create-flowchart/test.sh

# Or via Makefile
make test/commands/single TEST=01-create-flowchart

# View results
cat tests/output/create-flowchart/diagram.mmd
cat tests/output/create-flowchart/response.json
```

#### All Tests (via Makefile)

```bash
# Run all command tests (discovers all XX-* directories)
make test/commands
```

**Expected output (when dependencies available)**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  AI Command Tests - Automated Suite
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ AI Executor: claude
ℹ JSON Parser: jq
ℹ Found 4 test(s)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Test 1/4: 01-create-flowchart
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Running test: create-flowchart
✓ Diagram generated: tests/output/create-flowchart/diagram.mmd
✓ Has graph declaration
✓ Contains classDef block
✓ Test passed (automated checks)

[... Tests 2, 3, 4 ...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Test Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Total:  4
  Passed: 4
  Failed: 0

✓ All tests passed!
```

#### Using Different AI Executor

```bash
# Override default executor
AI_CLI_EXECUTOR=cursor-agent make test/commands

# For single test
AI_CLI_EXECUTOR=junie bash tests/commands/01-create-flowchart/test.sh
```

### Validation

#### Basic Syntax Check

```bash
# Check file exists and has content
test -s tests/output/01-flowchart.mmd || echo "FAIL: Empty output"

# Check starts with graph/flowchart
head -1 tests/output/01-flowchart.mmd | grep -E "^(graph|flowchart)" \
    || echo "FAIL: Invalid diagram type"
```

#### Convention Compliance

```bash
# Check for reserved keywords as node IDs
grep -E "^\s+(end|class|style|click)\[" tests/output/01-flowchart.mmd \
    && echo "FAIL: Reserved keyword used" \
    || echo "PASS: No reserved keywords"

# Check for generic names (A, B, C)
grep -E "^\s+[A-Z]\[" tests/output/01-flowchart.mmd \
    && echo "WARN: Generic node name found" \
    || echo "PASS: Semantic names used"

# Check for classDef
grep "classDef" tests/output/01-flowchart.mmd \
    && echo "PASS: Has color definitions" \
    || echo "FAIL: Missing classDef"
```

#### Advanced Validation (Future)

```bash
# Syntax validation with mermaid-cli (v0.3.0+)
mmdc -i tests/output/01-flowchart.mmd -o /dev/null \
    && echo "PASS: Valid Mermaid syntax" \
    || echo "FAIL: Syntax error"

# Render to SVG for visual regression (v1.0.0+)
mmdc -i tests/output/01-flowchart.mmd -o tests/output/01-flowchart.svg
```

---

## Writing New Tests

### Step 1: Identify Test Case

**Good test cases**:

- ✅ Common real-world scenarios
- ✅ Edge cases (complex flows, error handling)
- ✅ Specific feature validation (colors, shapes)
- ✅ Regression prevention (known bugs)

**Example ideas**:

- User authentication flow
- API request/response sequence
- State machine for order lifecycle
- Multi-layer system architecture

### Step 2: Create Test File

```bash
# Create test file
touch tests/commands/test-create-flowchart-complex.md
```

**Template**:

```markdown
# Test: create-flowchart - Complex Multi-Path Flow

## Prompt

Create a Mermaid flowchart for [scenario description]:

**Process**:

1. [Step 1]
2. [Step 2]
3. [Decision point]
    - If [condition A] → [path A]
    - If [condition B] → [path B]
4. [Final steps]

**Requirements**:

- Use semantic node names in English (PascalCase)
- Apply semantic colors:
    - Start/End: info (blue)
    - Decisions: warning (yellow)
    - Errors: error (red)
    - Success: operational (green)
    - Processing: processingLayer
    - Database: storageLayer
- Include complete classDef block
- Add explanatory comments
- Avoid reserved keywords

**Diagram type**: Flowchart (graph TD)

---

## Execution

### Manual (Interactive):

```bash
# In Claude Code or Cursor
/create-flowchart [paste description above]
```

### Automated (CLI):

```bash
claude -p "$(cat tests/commands/test-create-flowchart-complex.md)" \
    --output-format json \
    > tests/output/02-complex-flow.json

jq -r '.response' tests/output/02-complex-flow.json \
    > tests/output/02-complex-flow.mmd
```

---

## Expected Output

Reference: `tests/expected/02-complex-flow.mmd` (to be created)

**Quality criteria**:

- [ ] All decision paths covered
- [ ] Error handling included
- [ ] Comments explain complex sections
- [ ] Colors semantically meaningful

---

## Validation

### Syntax

- [ ] Diagram renders without errors
- [ ] No reserved keywords used

### Semantics

- [ ] Node names are descriptive (not A, B, C)
- [ ] Colors match meaning (not arbitrary)
- [ ] Flow logic is clear

### Quality

- [ ] Educational comments present
- [ ] Complete classDef definitions
- [ ] User would understand diagram

```

### Step 3: Create Expected Output (Optional)

```bash
# Manually create reference diagram
touch tests/expected/02-complex-flow.mmd
```

**Use for**:

- Documentation of ideal output
- Visual regression baseline
- Quality comparison reference

**Not for**:

- Exact string matching (AI is non-deterministic)
- Failing tests if output differs
- Restricting AI creativity

### Step 4: Test Both Modes

**Manual**:

```bash
# Execute in Claude Code/Cursor
# Document results
# Iterate if needed
```

**Automated**:

```bash
# Add to Makefile (optional)
# Or run directly:
claude -p "$(cat tests/commands/test-create-flowchart-complex.md)" \
    --output-format json \
    > tests/output/02-complex-flow.json
```

### Step 5: Document in README

Update `tests/README.md`:

```markdown
## Test Cases (v0.2.0)

### Command Tests

- 01: Generic authentication flow (test-create-flowchart.md)
- 02: Complex multi-path flow (test-create-flowchart-complex.md) **NEW**
- 03: API sequence diagram (test-create-sequence.md)
```

---

## Validation Checklist

### Pre-Release Validation

**Manual testing**:

- [ ] All slash commands tested in Claude Code
- [ ] All slash commands tested in Cursor
- [ ] Edge cases explored
- [ ] Quality meets educational standard
- [ ] No regressions from previous version

**Automated testing**:

- [ ] `make test/commands` passes
- [ ] All outputs syntactically valid
- [ ] No reserved keywords detected
- [ ] Convention compliance verified

**Documentation**:

- [ ] Test files up to date
- [ ] Expected outputs documented
- [ ] README reflects current tests
- [ ] Changelog mentions test coverage

### Regression Prevention

**When fixing bugs**:

1. Create test case reproducing bug
2. Verify test fails (proves bug exists)
3. Fix bug
4. Verify test passes
5. Add to regression suite

**Example**:

```markdown
# Test: Regression - Reserved Keyword "end"

Previously, AI would occasionally use "end" as node ID.

## Prompt

Create flowchart with explicit finish step...

## Expected

Should use "Finish" or "EndNode", never "end"

## Validation

grep "^\s*end\[" output.mmd && FAIL
```

---

## Troubleshooting

### Issue: Commands Not Found in AI Assistant

**Symptom**: `/create-flowchart` doesn't autocomplete

**Diagnosis**:

```bash
# Check symlinks exist
ls -la .claude/commands
ls -la .cursor/commands

# Check target exists
ls -la .ai/commands/
```

**Fix**:

```bash
# Recreate symlinks
cd .claude && ln -sf ../.ai/commands commands
cd .cursor && ln -sf ../.ai/commands commands
```

### Issue: `claude` Command Not Found

**Symptom**: `make check/deps` reports claude missing

**Fix**:

```bash
# Install Claude CLI
# See: https://docs.anthropic.com/claude/docs/claude-cli

# Verify installation
claude --version
```

### Issue: `jq` Command Not Found

**Symptom**: JSON parsing fails

**Fix**:

```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq

# Verify
jq --version
```

### Issue: Diagram Syntax Errors

**Symptom**: Generated diagram doesn't render

**Diagnosis**:

```bash
# Check for common issues
cat tests/output/01-flowchart.mmd

# Look for:
# - Missing arrows (-->)
# - Unbalanced quotes
# - Reserved keywords
# - Invalid syntax
```

**Fix**:

- Review test prompt (may be ambiguous)
- Check AGENTS.md is loaded
- Try manual execution to see AI reasoning
- Add specific requirements to test

### Issue: Generic Node Names (A, B, C)

**Symptom**: Output uses `A[Start]`, `B[Process]`

**Diagnosis**: Test prompt may not emphasize semantic naming

**Fix**:

```markdown
## Requirements

- **CRITICAL**: Use semantic node names in English (SessionStart, ValidateFormat)
- **NEVER** use generic letters (A, B, C, X, Y, Z)
```

### Issue: Missing Colors

**Symptom**: Diagram has no color definitions

**Diagnosis**: Test may not request color application

**Fix**:

```markdown
## Requirements

- Apply semantic color system:
    - operational: green (#4CAF50)
    - warning: yellow (#FFC107)
    - error: red (#F44336)
- Include complete classDef block at end
```

---

## Best Practices

### Test Design

**DO**:

- ✅ Write clear, unambiguous prompts
- ✅ Specify requirements explicitly
- ✅ Use realistic scenarios
- ✅ Test both happy path and error paths
- ✅ Document expected quality criteria

**DON'T**:

- ❌ Assume AI knows implicit requirements
- ❌ Test only trivial cases
- ❌ Expect exact string matching
- ❌ Ignore edge cases
- ❌ Skip manual validation

### Test Execution

**DO**:

- ✅ Run both manual and automated tests
- ✅ Test before every release
- ✅ Document unexpected results
- ✅ Iterate on failing tests
- ✅ Keep outputs for comparison

**DON'T**:

- ❌ Rely only on automated tests
- ❌ Skip tests to save time
- ❌ Ignore warnings
- ❌ Assume AI is deterministic
- ❌ Delete test outputs prematurely

### Test Maintenance

**DO**:

- ✅ Update tests when commands change
- ✅ Add regression tests for bugs
- ✅ Keep expected outputs current
- ✅ Review test coverage regularly
- ✅ Prune obsolete tests

**DON'T**:

- ❌ Let tests become outdated
- ❌ Keep failing tests without fixing
- ❌ Ignore test maintenance
- ❌ Accumulate unused tests
- ❌ Skip documentation updates

### Quality Standards

**Validate**:

- ✅ Syntax correctness (renders without errors)
- ✅ Convention compliance (semantic names, no reserved keywords)
- ✅ Educational value (comments, explanations)
- ✅ Semantic color usage (meaning-based, not arbitrary)
- ✅ User comprehension (diagram communicates intent)

**Document**:

- ✅ Test purpose and scope
- ✅ Expected quality criteria
- ✅ Known limitations
- ✅ Edge cases covered
- ✅ Regression prevention

---

## Next Steps

**New contributors**:

1. Read [Testing Strategy ADR](../architecture/testing-strategy.md)
2. Run existing tests (manual + automated)
3. Write test for new feature/bug
4. Get feedback on test design

**Maintainers**:

1. Review test coverage gaps
2. Prioritize high-value test cases
3. Plan CI/CD integration
4. Expand validation automation

**Users**:

1. Use tests as usage examples
2. Report issues found in testing
3. Suggest new test scenarios
4. Contribute test cases

---

## References

- [Testing Strategy ADR](../architecture/testing-strategy.md) - Why hybrid approach
- [Test Suite README](../../tests/README.md) - Current test inventory
- [AGENTS.md](../../.ai/AGENTS.md) - AI instructions for diagram generation
- [Claude CLI Docs](https://docs.anthropic.com/claude/docs/claude-cli) - CLI usage

---

**Last Updated**: 2025-11-12
**Version**: 1.0.0
