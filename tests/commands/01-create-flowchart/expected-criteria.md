# Expected Validation Criteria

## Automated (checked by test.sh)
- [x] Contains `graph TD` or `flowchart TD` declaration
- [x] Has classDef definitions
- [x] Has class assignments (:::)
- [x] Has node definitions with brackets []
- [x] Has connections (-->)

## Manual Verification Required
- [ ] Diagram renders without errors in Mermaid preview
- [ ] Uses semantic node names (not A, B, C)
- [ ] Includes all required steps:
  - API request reception
  - API key validation
  - Valid/Invalid decision paths
  - Business logic processing
  - Database storage
  - Success/Error responses
- [ ] Colors match semantic meaning:
  - info → lifecycle start
  - operational → success path
  - warning → decision points
  - error → failure paths
  - processingLayer → business logic
  - storageLayer → database operations
- [ ] Arrows have appropriate labels
- [ ] Flow logic is coherent and follows API validation pattern
