# Test Sample 04: API Interaction Sequence

Create a Mermaid sequence diagram showing REST API interaction with caching:

**Scenario**: User requests data via REST API with Redis caching layer

**Participants**:
- Client (web/mobile app)
- API Gateway
- Redis Cache
- Backend Service
- PostgreSQL Database

**Flow**:
1. Client sends GET request to API Gateway
2. API Gateway checks Redis cache
3. If cache hit → Return cached data immediately
4. If cache miss:
   - API Gateway forwards to Backend Service
   - Backend Service queries PostgreSQL
   - Database returns data
   - Backend Service processes and returns to API Gateway
   - API Gateway stores in Redis cache (TTL 5 min)
   - API Gateway returns to Client
5. Error handling: If database unavailable → Return 503 error

**Requirements**:
- Use semantic participant names (Client, APIGateway, not A, B)
- Use emojis for visual clarity (👤 Client, 🔌 API, 💾 Cache, etc.)
- Color code with rect rgb() blocks:
  - Input layer: rgb(227, 242, 253) blue light
  - Processing: rgb(243, 229, 245) purple light
  - Storage: rgb(255, 243, 224) orange light
  - Success: rgb(232, 245, 233) green light
  - Error: rgb(255, 235, 238) red light
- Balance activate/deactivate
- Add notes explaining each layer

**Diagram type**: sequenceDiagram
