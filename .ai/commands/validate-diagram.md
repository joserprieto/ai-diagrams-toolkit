# Validate Diagram

Validate Mermaid diagram syntax and conventions compliance.

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
   - Syntax status (VALID/INVALID)
   - Issues found with fixes
   - Warnings and suggestions
   - Recommendations

## Validation Checklist

### Critical (Must Fix):
- No reserved keywords as node IDs
- Balanced delimiters
- Valid shape syntax
- classDef after nodes
- Activate/deactivate balanced (sequence)

### Warnings (Should Fix):
- Semantic node names
- Comments in English
- Reasonable diagram size
- Color system applied

## Resources

- Reserved keywords: `guides/mermaid/common-pitfalls.md`
- Shape syntax: `guides/mermaid/flowchart.md`
- Color system: `templates/*.mmd`
