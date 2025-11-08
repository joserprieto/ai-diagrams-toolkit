# Test Sample 02: Software Component Architecture

Create a Mermaid flowchart diagram with subgraphs showing a microservices architecture:

**System**: E-commerce platform with microservices

**Components**:

**Frontend Layer**:

- Web Application (React SPA)
- Mobile Application (React Native)

**API Gateway Layer**:

- API Gateway (routes requests)
- Load Balancer

**Service Layer**:

- User Service (authentication, profiles)
- Product Service (catalog, inventory)
- Order Service (cart, checkout, orders)
- Payment Service (payment processing)

**Data Layer**:

- User Database (PostgreSQL)
- Product Database (PostgreSQL)
- Order Database (PostgreSQL)
- Cache (Redis - shared)

**Communication**:

- Message Queue (RabbitMQ) for async events
- Service Mesh for inter-service communication

**Requirements**:

- Use subgraphs to group layers
- Semantic naming (UserService, not Service1)
- Architectural layer colors:
    - Frontend: presentationLayer (cyan light)
    - Gateway/Services: processingLayer (green light)
    - Databases: storageLayer (orange light)
    - Communication: communicationLayer (purple light)
- Show connections between layers
- Style subgraphs with appropriate layer colors

**Diagram type**: Flowchart (graph TB) with subgraphs
