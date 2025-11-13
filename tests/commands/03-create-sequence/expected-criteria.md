# Expected Validation Criteria

## Automated (checked by test.sh)
- [x] Contains `sequenceDiagram` declaration
- [x] Has participant definitions
- [x] Has message arrows (->>, ->)
- [x] Has at least one activation box (activate/deactivate or +/-)

## Manual Verification Required
- [ ] Diagram renders without errors in Mermaid preview
- [ ] Includes all required participants:
  - User
  - Frontend
  - API Gateway
  - Auth Service
  - Database
- [ ] Shows complete authentication flow:
  - User submits credentials
  - Frontend → API Gateway
  - API Gateway → Auth Service
  - Auth Service → Database validation
  - Success path with JWT generation
  - Failure path with error response
- [ ] Uses appropriate arrow types (->>, ->, -->>)
- [ ] Has activation boxes in logical places
- [ ] Includes explanatory notes for critical steps
- [ ] Flow is chronologically correct
