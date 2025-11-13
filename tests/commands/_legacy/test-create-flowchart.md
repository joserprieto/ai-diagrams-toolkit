# Test: create-flowchart command

## Prompt

Create a Mermaid flowchart diagram with semantic colors for the following process:

**User Authentication Process**:
1. User enters credentials (email and password)
2. System validates format (email valid, password min length)
3. If format invalid → Show error message
4. If format valid → Check against database
5. Query user table in database
6. If user not found → Show "user not found" error
7. If user found → Verify password hash
8. If password doesn't match → Show "invalid password" error
9. If password matches → Generate session token
10. Store session in session database
11. Return success with token
12. User logged in successfully

**Requirements**:
- Use semantic node names in English (SessionStart, ValidateFormat, not A, B, C)
- Apply semantic colors:
  - Start/End: info (blue)
  - Decision points: warning (yellow)
  - Error paths: error (red)
  - Success: operational (green)
  - Processing steps: processingLayer (green light)
  - Database operations: storageLayer (orange light)
- Include complete classDef block
- Add comments explaining flow sections
- Avoid reserved keywords (end, class, style)

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
claude -p "$(cat tests/commands/test-create-flowchart.md)" \
    --output-format json \
    --allowedTools "Read" \
    > tests/output/01-flowchart.json

jq -r '.response' tests/output/01-flowchart.json > tests/output/01-flowchart.mmd
```

---

## Expected Output

See `tests/expected/01-process-flow.mmd` for reference diagram.

## Validation

- [ ] Diagram generated successfully
- [ ] Uses semantic node names (no A, B, C)
- [ ] Semantic colors applied (green, yellow, red)
- [ ] No reserved keywords used
- [ ] classDef block complete
- [ ] Comments in English
- [ ] Renders in Mermaid preview without errors
