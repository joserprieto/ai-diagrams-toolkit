---
description: "Validate Mermaid diagram syntax and conventions compliance"
argument-hint: "<diagram-file-or-content>"
allowed-tools: []
---

# Validate Diagram

Validate Mermaid diagram syntax and conventions compliance.

## Arguments
- `$1` or `$ARGUMENTS` - Diagram file path or diagram content to validate

## Instructions

When user invokes this command with a diagram file:

1. **Read the diagram file**

2. **Check syntax validity**:
   - Correct diagram type declaration
   - Balanced delimiters
   - Valid node and connection syntax
   - classDef definitions correct
   - No syntax errors

3. **Verify conventions**:
   - ✅ Semantic node names (not A, B, C)
   - ✅ Comments in English
   - ✅ Reserved keywords avoided
   - ✅ Special characters handled
   - ✅ ClassDef after nodes

4. **Check color system** (if applied):
   - Colors match semantic meaning
   - classDef complete
   - Classes applied correctly

5. **Verify best practices**:
   - Not too many nodes (max ~15-20)
   - Clear flow direction
   - Consistent styling

6. **Return validation report** with:
   - **Syntax status**: VALID or INVALID (clear verdict)
   - **Issues found**: Complete list with severity indicators
   - **Severity levels**: CRITICAL, HIGH, MEDIUM, LOW for each issue
   - **Specific fixes**: Actionable solutions for each problem
   - **Warnings and suggestions**: Best practice recommendations
   - **Recommendations**: Overall improvement suggestions

## Validation Report Format

**MANDATORY structure** for validation output:

### 1. Syntax Status
Clear verdict: `VALID` or `INVALID`

### 2. Issues Found

**Format each issue**:
```
[SEVERITY] Issue description
  → Fix: Specific solution
  → Location: Line number or node ID
  → Reference: Link to guide/pitfall doc
```

**Severity levels**:
- `CRITICAL` - Syntax errors, reserved keywords, diagram won't render
- `HIGH` - Major convention violations, non-semantic names
- `MEDIUM` - Minor improvements needed, missing colors
- `LOW` - Nice-to-have optimizations

**Example**:
```
[CRITICAL] Reserved keyword used as node ID
  → Fix: Rename 'end' to 'EndNode' or 'Finish'
  → Location: Line 15 (node definition)
  → Reference: guides/mermaid/common-pitfalls.md#reserved-keywords

[HIGH] Non-semantic node name 'A'
  → Fix: Use descriptive name like 'SessionStart' or 'UserValidation'
  → Location: Node A (line 10)
  → Reference: AGENTS.md#naming-conventions

[MEDIUM] Missing semantic color system
  → Fix: Add theme configuration with semantic colors
  → Reference: templates/flowchart-template.mmd
```

### 3. Summary Statistics

- Total issues: X
- Critical: X, High: X, Medium: X, Low: X

### 4. Corrected Diagram (if issues found)

Provide corrected version with all fixes applied.

---

## Validation Checklist

### Critical (MUST Fix - Severity: CRITICAL):
- No reserved keywords as node IDs
- Balanced delimiters
- Valid shape syntax
- classDef after nodes (flowchart only)
- Activate/deactivate balanced (sequence)
- No deactivation inside alt/else/loop/opt blocks (sequence)

### High Priority (SHOULD Fix - Severity: HIGH):
- Semantic node names (not A, B, C)
- Comments in English
- Theme configuration with semantic colors

### Medium Priority (NICE TO HAVE - Severity: MEDIUM):
- Reasonable diagram size (max ~15-20 nodes)
- Clear flow direction
- Consistent styling
- classDef for additional node styling (flowchart only)

### Low Priority (OPTIONAL - Severity: LOW):
- Optimizations
- Advanced styling
- Additional comments

## Resources

- Reserved keywords: `guides/mermaid/common-pitfalls.md`
- Shape syntax: `guides/mermaid/flowchart.md`
- Color system: `templates/*.mmd`
