# Example: Business Process - Order Fulfillment

Example of semantic color system applied to a typical business process workflow.

## Use Case

E-commerce order fulfillment process from order placement to delivery, showing decision points and error handling.

## Diagram

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#f0f0f0'}}}%%
flowchart TD
    %% === ORDER FULFILLMENT PROCESS ===

    Start([Order Received]):::info

    ValidateOrder{Validate Order}:::warning
    CheckInventory{Stock Available?}:::warning
    ProcessPayment[[Process Payment]]:::processingLayer
    PaymentOK{Payment Success?}:::warning

    ReserveStock[[Reserve Items]]:::processingLayer
    CreateShipment[[Create Shipment]]:::processingLayer
    NotifyWarehouse[/Notify Warehouse/]:::communicationLayer

    UpdateInventory[(Update Inventory)]:::storageLayer
    RecordOrder[(Record Order)]:::storageLayer
    LogShipment[(Log Shipment)]:::storageLayer

    Success([Order Confirmed]):::operational
    ShipmentReady([Ready to Ship]):::operational

    ErrorInvalid[\Invalid Order\]:::error
    ErrorStock[\Out of Stock\]:::error
    ErrorPayment[\Payment Failed\]:::error

    NotifyCustomer>Send Confirmation]:::presentationLayer
    NotifyError>Send Error Notice]:::presentationLayer

    %% === MAIN FLOW ===
    Start --> ValidateOrder
    ValidateOrder -->|Valid| CheckInventory
    ValidateOrder -->|Invalid| ErrorInvalid

    CheckInventory -->|Available| ProcessPayment
    CheckInventory -->|Out of Stock| ErrorStock

    ProcessPayment --> PaymentOK
    PaymentOK -->|Success| ReserveStock
    PaymentOK -->|Failed| ErrorPayment

    ReserveStock --> UpdateInventory
    UpdateInventory --> RecordOrder
    RecordOrder --> CreateShipment
    CreateShipment --> LogShipment
    LogShipment --> NotifyWarehouse
    NotifyWarehouse --> ShipmentReady

    ShipmentReady --> NotifyCustomer
    ShipmentReady --> Success

    %% === ERROR HANDLING ===
    ErrorInvalid --> NotifyError
    ErrorStock --> NotifyError
    ErrorPayment --> NotifyError

    %% === SEMANTIC COLOR DEFINITIONS ===
    classDef operational fill:#4CAF50,stroke:#2E7D32,color:#FFFFFF,stroke-width:2px
    classDef warning fill:#FFC107,stroke:#F57C00,color:#000000,stroke-width:2px
    classDef error fill:#F44336,stroke:#C62828,color:#FFFFFF,stroke-width:2px
    classDef info fill:#2196F3,stroke:#1565C0,color:#FFFFFF,stroke-width:2px

    classDef dataLayer fill:#E3F2FD,stroke:#1565C0,color:#0D47A1,stroke-width:1px
    classDef processingLayer fill:#E8F5E9,stroke:#2E7D32,color:#1B5E20,stroke-width:1px
    classDef storageLayer fill:#FFF3E0,stroke:#E65100,color:#BF360C,stroke-width:1px
    classDef communicationLayer fill:#F3E5F5,stroke:#7B1FA2,color:#4A148C,stroke-width:1px
    classDef presentationLayer fill:#E0F2F1,stroke:#00796B,color:#004D40,stroke-width:1px
```

## Color Choices Explained

### States
- **Start** → Info (blue): Entry point
- **Success/Ready** → Operational (green): Successful completion
- **Errors** → Error (red): Critical failures (invalid, no stock, payment failed)

### Decision Points
- **All decisions** → Warning (yellow): Points requiring attention/validation

### Architectural Layers
- **Processing** (green light): Business logic (payment, reserve, create shipment)
- **Storage** (orange light): Database operations (inventory, orders, shipments)
- **Communication** (purple light): External integrations (warehouse notification)
- **Presentation** (cyan light): User-facing notifications

## Pattern Highlights

### Decision Diamond Pattern

All decision points (diamond shape `{}`) use warning color (yellow):
- Immediate visual: "Something is being decided here"
- Consistent across diagram
- Branches labeled clearly (Valid/Invalid, Yes/No)

### Error Handling Grouping

All error nodes:
- Use trapezoid shape `[\Error\]` (visual consistency)
- Use error color (red) (semantic meaning)
- Converge to single notification point (DRY)

### Layer Separation

Process nodes (green light) → Storage nodes (orange light) → Communication (purple light)
- Visual flow follows architectural flow
- Easy to identify which layer you're looking at
- Helps spot architectural issues (e.g., skipping layers)

## Adapting This Example

For your business process:
1. Replace steps with your process (validate, payment, shipping, etc.)
2. Identify your decision points (stock check, approval, etc.)
3. Map error paths specific to your domain
4. Keep color system (meaning stays consistent)
5. Adjust labels to your business language

## Learnings

1. **Yellow = Decision**: Makes all decision points stand out immediately
2. **Red = Error**: Error paths instantly identifiable
3. **Layers by color**: Architecture visible at a glance
4. **Consistency = Clarity**: Same colors = same meaning = faster comprehension

---

*This example shows how semantic colors make business process flows immediately clear and actionable.*
