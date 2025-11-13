# Expected Validation Criteria

## Automated (checked by test.sh)
- [x] Response contains "Issues Found" or "issues" keyword
- [x] Response contains severity indicators (ERROR, WARNING, or INFO)
- [x] Response contains corrected diagram code
- [x] Corrected diagram has proper Mermaid syntax

## Manual Verification Required
- [ ] AI identifies these specific reserved keyword issues:
  - `end` (reserved keyword)
  - `class` (reserved keyword)
  - `type` (reserved keyword)
  - `subgraph` (reserved keyword)
- [ ] AI provides severity classification (ERROR level for reserved keywords)
- [ ] AI suggests appropriate fixes (rename to non-reserved alternatives)
- [ ] Corrected diagram:
  - Uses non-reserved node IDs
  - Preserves original logic flow
  - Has semantic node names
  - Renders without errors
- [ ] Response is well-structured and clear
- [ ] Fixes are practical and implementable
