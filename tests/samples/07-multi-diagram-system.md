# Test Sample 07: Multi-Diagram System

Create 4 different diagram types for the SAME system (showing different perspectives):

**System**: Online Food Delivery Platform

## Perspective 1: Process Flow (Flowchart)

Show the order fulfillment process:

1. Customer places order
2. System validates order (items available?)
3. If items unavailable → Notify customer, end
4. If available → Process payment
5. Payment successful → Notify restaurant
6. Restaurant prepares food
7. Assign delivery driver
8. Driver picks up order
9. Driver delivers to customer
10. Mark order complete

Use semantic colors for decisions (yellow), errors (red), success (green).

## Perspective 2: System Interaction (Sequence)

Show API interactions for order placement:

Participants: Customer App, API Gateway, Order Service, Payment Service, Restaurant Service, Database

Flow:

1. Customer App → API Gateway: POST /orders
2. API Gateway → Order Service: Create order
3. Order Service → Database: Save order (pending)
4. Order Service → Payment Service: Process payment
5. Payment Service → External Payment Gateway
6. If payment fails → Error response chain
7. If payment success → Order Service → Restaurant Service: Notify new order
8. Restaurant Service → Database: Update restaurant queue
9. Success response chain back to Customer App

Use rect blocks for layer coloring.

## Perspective 3: State Machine (State Diagram)

Show order lifecycle states:

States: Placed → Validated → PaymentProcessing → Confirmed → Preparing → Ready → PickedUp → InTransit → Delivered →
Completed

Also: Failed, Cancelled states with transitions

Colors: Completed (green), Failed/Cancelled (red), intermediate states (yellow/blue)

## Perspective 4: Data Model (Class Diagram)

Show domain entities:

Classes:

- Order (entity): id, customerId, items[], total, status, createdAt
- OrderItem (value-object): productId, quantity, price
- Customer (entity): id, name, email, address
- Restaurant (entity): id, name, location, menu[]
- DeliveryDriver (entity): id, name, currentLocation, available

Relationships:

- Order has many OrderItem (composition)
- Order belongs to Customer (association)
- Order assigned to Restaurant (association)
- Order assigned to DeliveryDriver (association)

**Requirements for all 4 diagrams**:

- Semantic naming (English)
- Semantic colors applied
- Comments explaining structure
- No reserved keywords
- Production-ready syntax

**Output**: 4 separate .mmd files (one per diagram type)
