# Test: Makefile Targets (v0.1.0)

## Objective

Validate that Makefile targets work correctly.

## Tests

### Test 1: make help

**Execute**:
```bash
make help
```

**Expected**:
- Shows header with version 0.1.0
- Lists all targets with descriptions
- Formatted with colors (if terminal supports)
- Shows examples at bottom

**Pass Criteria**: ✅ Help displays correctly

---

### Test 2: make check/deps

**Execute**:
```bash
make check/deps
```

**Expected**:
- Checks git installation
- Reports git installed ✓ or missing ✗
- If missing: Shows install instructions
- If all OK: Success message
- If missing: Exit code 1

**Pass Criteria**: ✅ Checks dependency and reports correctly

---

### Test 3: make clean

**Execute**:
```bash
# Create some temp files first
touch test.tmp test.temp .DS_Store

# Run clean
make clean

# Verify cleaned
ls test.tmp 2>/dev/null && echo "FAIL" || echo "PASS"
```

**Expected**:
- Removes .DS_Store files
- Removes *.tmp files
- Removes *.temp files
- Success message displayed

**Pass Criteria**: ✅ Temp files removed

---

### Test 4: make release (if Node.js installed)

**Execute**:
```bash
make check/node  # Check if Node.js available
make release     # Try release
```

**Expected**:
- If Node.js NOT installed: Error message with install instructions
- If Node.js installed but no commit-and-tag-version: Instructions to install
- If all tools available: Runs commit-and-tag-version

**Pass Criteria**: ✅ Gracefully handles missing tools with helpful messages

---

## Summary

All Makefile targets should:
- Use colored output (if terminal supports)
- Provide helpful error messages
- Exit with appropriate codes (0 success, 1 error)
- Be self-documenting (## comments)
