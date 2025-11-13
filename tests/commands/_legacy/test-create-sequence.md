# Test: create-sequence command

## Prompt

Create a Mermaid sequence diagram with semantic colors for:

**REST API Call with Redis Caching**

**Participants**:
- Client (web/mobile app)
- API Gateway
- Redis Cache
- Backend Service
- PostgreSQL Database

**Flow**:
1. Client sends GET /users/123 request to API Gateway
2. API Gateway checks Redis cache
3. If cache hit → Return cached data immediately (success path)
4. If cache miss:
   - API Gateway forwards to Backend Service
   - Backend Service queries PostgreSQL
   - Database returns user data
   - Backend Service processes and returns to API Gateway
   - API Gateway stores in Redis cache (TTL 5 min)
   - API Gateway returns to Client
5. Error handling: If database unavailable → Return 503 error

**Requirements**:
- Use semantic participant names with emojis (👤 Client, 🔌 API, 💾 Cache, etc.)
- Color code with rect rgb() blocks:
  - Input: rgb(227, 242, 253) blue light
  - Processing: rgb(243, 229, 245) purple light
  - Storage: rgb(255, 243, 224) orange light
  - Success: rgb(232, 245, 233) green light
  - Error: rgb(255, 235, 238) red light
- Balance activate/deactivate
- Add notes explaining each layer

---

## Execution

### Automated (CLI):
```bash
claude -p "$(cat tests/commands/test-create-sequence.md)" \
    --output-format json \
    > tests/output/04-sequence.json

jq -r '.response' tests/output/04-sequence.json > tests/output/04-sequence.mmd
```

---

## Expected Output

See `tests/expected/04-api-interaction-sequence.mmd`

## Validation

- [ ] Sequence diagram generated
- [ ] Participants have semantic names + emojis
- [ ] rect rgb() blocks for layers
- [ ] activate/deactivate balanced
- [ ] Notes explain layers
- [ ] Renders without errors
