# Test: validate-diagram command

## Setup

Create diagram with intentional errors:

```mermaid
graph TD
    start[Begin]
    end[Finish]        %% RESERVED KEYWORD
    class[MyClass]     %% RESERVED KEYWORD
    A --> B            %% NON-SEMANTIC NAMES
    B --> end
```

Save as: `tests/output/diagram-with-errors.mmd`

---

## Prompt

Validate the diagram in `tests/output/diagram-with-errors.mmd`.

Check for:
- Reserved keywords (end, class)
- Non-semantic node names (A, B)
- Syntax errors
- Missing colors
- Best practice violations

Provide validation report with specific fixes.

---

## Execution

### Automated (CLI):
```bash
# Create diagram with errors
cat > tests/output/diagram-with-errors.mmd << 'EOF'
graph TD
    start[Begin]
    end[Finish]
    class[MyClass]
    A --> B
    B --> end
EOF

# Validate
claude -p "Validate this Mermaid diagram and report issues: $(cat tests/output/diagram-with-errors.mmd)" \
    --output-format json \
    > tests/output/validation-report.json

jq -r '.response' tests/output/validation-report.json
```

---

## Expected Output

Validation report identifying:
1. ❌ **Critical**: Reserved keyword "end" (line X)
   - Fix: Rename to "EndNode" or "Finish"

2. ❌ **Critical**: Reserved keyword "class" (line Y)
   - Fix: Rename to "MyClass" or "ClassNode"

3. ⚠️ **Warning**: Non-semantic node names (A, B)
   - Fix: Use SessionStart, DataProcessor, etc.

4. ⚠️ **Warning**: No semantic colors applied
   - Suggestion: Add classDef and apply colors

## Validation

- [ ] Identifies reserved keywords "end" and "class"
- [ ] Identifies non-semantic names A, B
- [ ] Suggests specific fixes
- [ ] Provides actionable recommendations
- [ ] Explains why each is an issue
