# AI Diagrams Toolkit

> **Professional Mermaid diagrams with semantic colors in 2 minutes**
> Stop fighting with CSS. Start building meaningful diagrams.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Mermaid](https://img.shields.io/badge/Mermaid-Supported-ff69b4.svg)](https://mermaid.js.org/)

---

## 🎯 What You Get

Transform this basic Mermaid diagram:

```mermaid
graph TD
    A[Start] --> B[Process]
    B --> C{Valid?}
    C -->|Yes| D[Success]
    C -->|No| E[Error]
```

Into this **professional, semantic diagram**:

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#f0f0f0',
      'edgeLabelBackground': '#ffffff'
    }
  }
}%%
graph TD
    classDef operational fill: #4CAF50, stroke: #2E7D32, color: #FFFFFF, stroke-width: 2px
    classDef error fill: #F44336, stroke: #C62828, color: #FFFFFF, stroke-width: 2px
    classDef warning fill: #FFC107, stroke: #F57C00, color: #000000, stroke-width: 2px
    classDef info fill: #2196F3, stroke: #1565C0, color: #FFFFFF, stroke-width: 2px
    Start([Start]):::info --> Process[[Process Data]]:::info
    Process --> Validate{Valid?}:::warning
    Validate -->|Yes| Success([Success]):::operational
    Validate -->|No| Error([Error]):::error
```

**The difference?**

- ✅ **Colors communicate meaning** (green = success, red = error, yellow = decision)
- ✅ **Professional appearance** (no default blue boxes)
- ✅ **Semantic naming** (Start, Process, not A, B, C)
- ✅ **Production-ready** (copy-paste and done)

---

## 🚀 5-Minute Tutorial

### Prerequisites

- A Mermaid-compatible
  editor ([GitHub](https://github.com), [VSCode with extension](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid), [Mermaid Live Editor](https://mermaid.live))
- **Optional**: [Claude Code](https://claude.ai/code) or [Cursor](https://cursor.sh) for AI-powered generation

### Step 1: Copy Template

Navigate to [`/templates/flowchart.mmd`](./templates/flowchart.mmd) and copy the **entire file content** (including the
color definitions at the top).

### Step 2: Paste & Customize

Create `my-diagram.mmd` and paste the full template. Then, **replace only the diagram nodes** (lines 37-43) with your
own:

**Example customization:**

```mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#f0f0f0',
      'edgeLabelBackground': '#ffffff'
    }
  }
}%%
graph TD
%% Keep all these classDef lines (already in template)
    classDef operational fill: #4CAF50, stroke: #2E7D32, color: #FFFFFF, stroke-width: 2px
    classDef error fill: #F44336, stroke: #C62828, color: #FFFFFF, stroke-width: 2px
    classDef warning fill: #FFC107, stroke: #F57C00, color: #000000, stroke-width: 2px
    classDef info fill: #2196F3, stroke: #1565C0, color: #FFFFFF, stroke-width: 2px
%% Replace only this part with your flow:
    Start([User Login]):::info --> Auth[[Authenticate]]:::info
    Auth --> Check{Credentials Valid?}:::warning
    Check -->|Yes| Dashboard([Show Dashboard]):::operational
    Check -->|No| Retry[\Retry Login\]:::error
```

**Important**: Keep the `classDef` lines at the top! Only change the nodes and connections.

### Step 3: Render

Open in your Mermaid-compatible tool. **Done!** 🎉

**Time spent**: ~2 minutes
**Result**: Professional diagram with semantic colors

---

## 🎨 Semantic Color System

### Status Colors

Colors communicate **meaning** at a glance:

| Color         | Meaning              | Use For                                |
|---------------|----------------------|----------------------------------------|
| 🟢 **Green**  | Operational, success | Working processes, successful outcomes |
| 🔴 **Red**    | Error, failure       | Error handlers, failed states          |
| 🟡 **Yellow** | Warning, decision    | Decision points, requires attention    |
| 🔵 **Blue**   | Info, neutral        | Entry points, informational nodes      |
| ⚫ **Gray**    | Inactive, disabled   | Deprecated features, unused paths      |

### Architectural Layers

Light colors differentiate system layers:

```mermaid
graph LR
    classDef dataLayer fill: #E3F2FD, stroke: #1565C0, color: #0D47A1
    classDef processingLayer fill: #E8F5E9, stroke: #2E7D32, color: #1B5E20
    classDef storageLayer fill: #FFF3E0, stroke: #E65100, color: #BF360C
    Input[User Input]:::dataLayer --> Process[[Business Logic]]:::processingLayer
    Process --> DB[(Database)]:::storageLayer
```

- **Blue light** = Data layer (inputs, sensors)
- **Green light** = Processing layer (business logic)
- **Orange light** = Storage layer (databases)
- **Purple light** = Communication layer (APIs)
- **Cyan light** = Presentation layer (UI)

---

## 🤖 AI-Powered Generation (v0.2.0+)

**NEW**: Generate diagrams from natural language!

### Setup (One-time)

1. Install [Claude Code](https://claude.ai/code) or [Cursor](https://cursor.sh)
2. Clone this repo:
   ```bash
   git clone https://github.com/joserprieto/ai-diagrams-toolkit.git
   cd ai-diagrams-toolkit
   ```
3. Open in your AI editor

### Usage

Use slash commands to generate diagrams:

```bash
# Generate flowchart from description
/create-flowchart user authentication with email and password

# Generate sequence diagram
/create-sequence REST API with caching and database

# Apply semantic colors to existing diagram
/apply-colors my-existing-diagram.mmd

# Validate diagram syntax
/validate-diagram my-diagram.mmd
```

**Result**: AI generates production-ready Mermaid code with:

- ✅ Semantic color system applied
- ✅ Proper naming conventions
- ✅ No reserved keywords
- ✅ Comments explaining structure

### Example Output

**Your prompt**:

```bash
/create-flowchart payment processing with validation and error handling
```

**AI generates**:

```mermaid
%%{ init: { 'theme': 'base' } }%%
graph TD
    classDef operational fill: #4CAF50, stroke: #2E7D32, color: #FFF
    classDef error fill: #F44336, stroke: #C62828, color: #FFF
    classDef warning fill: #FFC107, stroke: #F57C00, color: #000
    Start([Receive Payment]):::info
    Start --> Validate{Validate Card}:::warning
    Validate -->|Valid| Process[[Process Payment]]:::operational
    Validate -->|Invalid| Error([Payment Failed]):::error
    Process --> Success([Payment Complete]):::operational
```

---

## 📦 What's Included

```
ai-diagrams-toolkit/
├── templates/          # 4 ready-to-use templates
│   ├── flowchart.mmd   # Processes & workflows
│   ├── sequence.mmd    # API interactions
│   ├── class.mmd       # OOP structures
│   └── state.mmd       # State machines
├── examples/           # Real-world examples
│   ├── critical-system.md    # System monitoring
│   └── business-process.md   # Order fulfillment
├── guides/mermaid/     # Comprehensive guides
│   ├── flowchart.md
│   ├── sequence.md
│   ├── class.md
│   └── common-pitfalls.md
└── .ai/commands/       # AI slash commands
```

---

## 🎓 Learn More

### For Template Users

- **[Templates README](./templates/)** - Detailed guide for each template
- **[Examples](./examples/)** - Real-world use cases with explanations
- **[Common Pitfalls](./guides/mermaid/common-pitfalls.md)** - Avoid Mermaid gotchas

### For AI Users

- **[AI Commands Guide](.ai/AGENTS.md)** - Complete AI instructions
- **[Testing](./docs/development/testing-guide.md)** - Automated test suite

### For Contributors

- **[Contributing Guide](./CONTRIBUTING.md)** - How to contribute
- **[Architecture Docs](./docs/architecture/)** - Design decisions
- **[Roadmap](./ROADMAP.md)** - Future plans

---

## 🎨 Gallery - Real-World Examples

> See the semantic color system in action with production-ready diagrams

### 🏗️ Complex System Architecture

**Use case**: 24/7 Critical monitoring system with multiple layers and alert handling

<details>
<summary><b>Click to see diagram (30+ nodes)</b></summary>

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#f0f0f0'}}}%%
flowchart TD
%% === MONITORING SYSTEM ARCHITECTURE ===
    Start([System Start]):::info

    subgraph "Data Collection Layer"
        direction LR
        Sensors[/Collect Metrics/]:::dataLayer
        Agents[/System Agents/]:::dataLayer
        Logs[/Application Logs/]:::dataLayer
    end

    subgraph "Processing Layer"
        direction TB
        Aggregate[[Aggregate Data]]:::processingLayer
        Analyze{Threshold Exceeded?}:::warning
        Classify[[Classify Severity]]:::processingLayer
    end

    subgraph "Storage & State"
        direction LR
        TimeSeries[(Time Series DB)]:::storageLayer
        StateDB[(State Database)]:::storageLayer
    end

    subgraph "Alert Handling"
        direction TB
        Critical[\Critical Alert\]:::error
        Warning[\Warning Alert\]:::warning
        Info[\Info Log\]:::info
    end

    subgraph "Communication"
        direction LR
        PagerDuty[[On-Call System]]:::communicationLayer
        Slack[[Team Chat]]:::communicationLayer
        Dashboard>Monitoring Dashboard]:::presentationLayer
    end

    Success([System Operational]):::operational
    Degraded([Degraded Mode]):::warning
    Failed([System Failed]):::error
%% === FLOW ===
    Start --> Sensors & Agents & Logs
    Sensors & Agents & Logs --> Aggregate
    Aggregate --> TimeSeries
    Aggregate --> Analyze
    Analyze -->|Normal| StateDB
    Analyze -->|Warning| Warning
    Analyze -->|Critical| Critical
    Analyze -->|Info| Info
    StateDB --> Success
    Warning --> Slack
    Warning --> Dashboard
    Warning --> Degraded
    Critical --> PagerDuty
    Critical --> Slack
    Critical --> Dashboard
    Critical --> Failed
    Info --> Dashboard
    Success --> Dashboard
    Degraded --> Dashboard
    Failed --> Dashboard
%% === SEMANTIC COLOR DEFINITIONS ===
    classDef operational fill: #4CAF50, stroke: #2E7D32, color: #FFFFFF, stroke-width: 2px
    classDef warning fill: #FFC107, stroke: #F57C00, color: #000000, stroke-width: 2px
    classDef error fill: #F44336, stroke: #C62828, color: #FFFFFF, stroke-width: 2px
    classDef info fill: #2196F3, stroke: #1565C0, color: #FFFFFF, stroke-width: 2px
    classDef dataLayer fill: #E3F2FD, stroke: #1565C0, color: #0D47A1, stroke-width: 1px
    classDef processingLayer fill: #E8F5E9, stroke: #2E7D32, color: #1B5E20, stroke-width: 1px
    classDef storageLayer fill: #FFF3E0, stroke: #E65100, color: #BF360C, stroke-width: 1px
    classDef communicationLayer fill: #F3E5F5, stroke: #7B1FA2, color: #4A148C, stroke-width: 1px
    classDef presentationLayer fill: #E0F2F1, stroke: #00796B, color: #004D40, stroke-width: 1px
```

**What it demonstrates**:
- ✅ Multiple architectural layers (data, processing, storage, communication, presentation)
- ✅ Complex error handling flows with different severity levels
- ✅ Subgraphs for logical grouping
- ✅ Real-world alerting system architecture
- ✅ 30+ nodes with semantic naming

</details>

### 🔄 API Sequence Diagram

**Use case**: REST API authentication with caching, database lookup, and error handling

<details>
<summary><b>Click to see diagram</b></summary>

```mermaid
%%{init: {
  'theme':'base',
  'themeVariables': {
    'primaryColor': '#f0f0f0',
    'edgeLabelBackground': '#ffffff',
    'tertiaryColor': '#f4f4f4'
  }
}}%%
sequenceDiagram
    autonumber
    participant Client
    participant API as API Gateway
    participant Auth as Auth Service
    participant Cache as Redis Cache
    participant DB as Database
    participant Logger as Log Service

    %% Data Layer (Input)
    rect rgb(227, 242, 253)
        note right of Client: DATA LAYER
        Client->>+API: POST /api/login
    end

    %% Processing Layer (Auth)
    rect rgb(243, 229, 245)
        note right of API: PROCESSING LAYER
        API->>+Auth: Validate credentials
        Auth->>+Cache: Check token cache
        Cache-->>Auth: Cache miss
        deactivate Cache
    end

    %% Storage Layer (DB Query)
    rect rgb(255, 243, 224)
        note right of Auth: STORAGE LAYER
        Auth->>+DB: Query user credentials
    end

    alt User found
        DB-->>Auth: User data
        Auth->>Auth: Validate password

        alt Valid credentials
            %% Success Flow (Green)
            rect rgb(232, 245, 233)
                note right of Auth: SUCCESS
                Auth->>+Cache: Store session token
                Cache-->>Auth: Token stored
                deactivate Cache

                Auth-->>API: 200 OK + token
                API-->>Client: Login successful

                API->>+Logger: Log successful login
                Logger-->>API: Logged
                deactivate Logger
            end
        else Invalid credentials
            %% Error Flow (Red)
            rect rgb(255, 235, 238)
                note right of Auth: AUTH ERROR
                Auth-->>API: 401 Unauthorized
                API-->>Client: Invalid credentials

                API->>+Logger: Log failed attempt
                Logger-->>API: Logged
                deactivate Logger
            end
        end
    else User not found
        %% Error Flow (Red)
        rect rgb(255, 235, 238)
            note right of DB: NOT FOUND
            DB-->>Auth: User not found
            Auth-->>API: 404 Not Found
            API-->>Client: User does not exist

            API->>+Logger: Log failed lookup
            Logger-->>API: Logged
            deactivate Logger
        end
    end

    deactivate DB
    deactivate Auth
    deactivate API

    %% Color Reference
    note over Client,Logger: Colors: Blue=Data, Purple=Processing, Orange=Storage, Green=Success, Red=Error
```

**What it demonstrates**:
- ✅ Multi-actor interactions (Client, API, Auth, Cache, DB, Logger)
- ✅ Alternative flows (alt/else) for error handling
- ✅ Activation/deactivation boxes showing active processing
- ✅ Autonumbering for step tracking
- ✅ Real-world caching and authentication patterns

</details>

### 🎛️ State Machine

**Use case**: E-commerce order lifecycle with transitions, guards, and error states

<details>
<summary><b>Click to see diagram</b></summary>

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#f0f0f0'}}}%%
stateDiagram-v2
    [*] --> Draft: Create order

    Draft --> PendingPayment: Submit order
    Draft --> Cancelled: Cancel by user

    PendingPayment --> PaymentProcessing: Initiate payment
    PendingPayment --> Cancelled: Timeout (15min)

    PaymentProcessing --> Confirmed: Payment successful
    PaymentProcessing --> PaymentFailed: Payment declined

    PaymentFailed --> PendingPayment: Retry payment
    PaymentFailed --> Cancelled: Max retries exceeded

    Confirmed --> Processing: Start fulfillment
    Confirmed --> Cancelled: Cancel by admin

    Processing --> Shipped: Ship order
    Processing --> OnHold: Inventory issue

    OnHold --> Processing: Issue resolved
    OnHold --> Cancelled: Cannot fulfill

    Shipped --> InTransit: Carrier pickup

    InTransit --> Delivered: Delivery confirmed
    InTransit --> DeliveryFailed: Delivery attempt failed

    DeliveryFailed --> InTransit: Reattempt delivery
    DeliveryFailed --> Returned: Max attempts exceeded

    Delivered --> Completed: Customer confirmation
    Delivered --> ReturnRequested: Return initiated

    ReturnRequested --> Returned: Return approved
    ReturnRequested --> Completed: Return denied

    Returned --> Refunded: Refund processed
    Refunded --> [*]
    Completed --> [*]
    Cancelled --> [*]

    note right of Draft
        Initial state
        User building cart
    end note

    note right of PaymentProcessing
        External payment gateway
        Max 3 retry attempts
    end note

    note right of Shipped
        Tracking number assigned
        Customer notified
    end note

    classDef successState fill: #4CAF50, stroke: #2E7D32, color: #FFFFFF
    classDef errorState fill: #F44336, stroke: #C62828, color: #FFFFFF
    classDef warningState fill: #FFC107, stroke: #F57C00, color: #000000
    classDef infoState fill: #2196F3, stroke: #1565C0, color: #FFFFFF

    class Completed,Delivered,Refunded successState
    class Cancelled,PaymentFailed,DeliveryFailed errorState
    class OnHold,PendingPayment,PaymentProcessing warningState
    class Draft,Processing,Shipped,InTransit,ReturnRequested infoState
```

**What it demonstrates**:
- ✅ Complete state machine with 15+ states
- ✅ Guard conditions (timeouts, max retries)
- ✅ Multiple end states (Completed, Refunded, Cancelled)
- ✅ Real-world e-commerce order flow
- ✅ Notes explaining business logic
- ✅ Color-coded states by category

</details>

### 📦 Class Diagram

**Use case**: E-commerce domain model with inheritance, composition, and relationships

<details>
<summary><b>Click to see diagram</b></summary>

```mermaid
%%{init: {
  'theme':'base',
  'themeVariables': {
    'primaryColor': '#f0f0f0',
    'edgeLabelBackground': '#ffffff',
    'tertiaryColor': '#f4f4f4',
    'primaryBorderColor': '#1565C0',
    'primaryTextColor': '#0D47A1'
  }
}}%%
classDiagram
    %% Entities (Domain entities)
    class User {
        <<entity>>
        +String id
        +String email
        +String passwordHash
        +DateTime createdAt
        +login(email, password) bool
        +logout() void
        +resetPassword(newPassword) void
    }

    class Customer {
        <<entity>>
        +String shippingAddress
        +String billingAddress
        +PaymentMethod[] paymentMethods
        +placeOrder(cart) Order
        +viewOrderHistory() Order[]
    }

    class Admin {
        <<entity>>
        +String[] permissions
        +manageProducts() void
        +viewAllOrders() Order[]
        +cancelOrder(orderId) void
    }

    class Product {
        <<entity>>
        +String id
        +String name
        +String description
        +Decimal price
        +Int stockQuantity
        +Category category
        +updateStock(quantity) void
        +applyDiscount(percentage) void
    }

    class Category {
        <<entity>>
        +String id
        +String name
        +Category parent
        +Product[] products
        +getSubcategories() Category[]
    }

    %% Aggregates (Aggregate roots)
    class Order {
        <<aggregate>>
        +String id
        +DateTime createdAt
        +OrderStatus status
        +Decimal total
        +calculateTotal() Decimal
        +updateStatus(newStatus) void
        +cancelOrder() void
    }

    class Cart {
        <<aggregate>>
        +String id
        +DateTime updatedAt
        +addItem(product, quantity) void
        +removeItem(productId) void
        +calculateTotal() Decimal
        +clear() void
    }

    %% Value Objects (Immutable data)
    class OrderItem {
        <<value-object>>
        +String id
        +Int quantity
        +Decimal priceAtPurchase
        +calculateSubtotal() Decimal
    }

    class Payment {
        <<value-object>>
        +String id
        +DateTime processedAt
        +PaymentStatus status
        +Decimal amount
        +process() bool
        +refund() bool
    }

    class ShippingInfo {
        <<value-object>>
        +String trackingNumber
        +String carrier
        +DateTime estimatedDelivery
        +updateTracking(status) void
    }

    %% Inheritance
    User <|-- Customer
    User <|-- Admin

    %% Composition (strong ownership)
    Customer *-- Cart: owns
    Order *-- OrderItem: contains
    Order *-- Payment: has
    Order *-- ShippingInfo: includes

    %% Aggregation (weak relationship)
    Cart o-- Product: references
    OrderItem o-- Product: references
    Category o-- Category: parent

    %% Association
    Customer "1" -- "0..*" Order: places
    Product "1" -- "1" Category: belongs to
    Order "1" -- "1" Customer: placed by

    %% Notes explaining DDD patterns
    note for User "Base class for authentication\nand authorization"
    note for Order "Aggregate root for\norder operations"

    %% Color reference
    note "Stereotypes: <<entity>>=Domain Entity, <<aggregate>>=Aggregate Root, <<value-object>>=Immutable Value"
```

**What it demonstrates**:
- ✅ Inheritance hierarchy (User → Customer/Admin)
- ✅ Composition vs Aggregation relationships
- ✅ One-to-many associations
- ✅ Complete domain model with 10+ classes
- ✅ Methods and properties with types
- ✅ Notes explaining design patterns
- ✅ Color coding by DDD pattern (Entity, Value Object, Aggregate)

</details>

---

**Want more examples?** Check [`/examples/`](./examples/) for complete use cases with detailed explanations.

---

## 🗺️ Roadmap

- ✅ **v0.1.0** (Nov 2025) - Templates, guides, examples
- ✅ **v0.2.0** (Nov 2025) - AI slash commands (Claude Code + Cursor)
- 🔄 **v0.3.0** (Q4 2025) - Skills + Subagent (Claude Code exclusive)
- 📅 **v1.0.0** (2026) - Design tokens + CLI generator

See [ROADMAP.md](./ROADMAP.md) for details.

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING.md) for:

- Reporting bugs
- Suggesting features
- Adding examples
- Improving documentation

**PRs welcome!** 🎉

---

## 📊 Feature Compatibility

| Feature        | Claude Code | Cursor | Manual |
|----------------|-------------|--------|--------|
| Templates      | ✅           | ✅      | ✅      |
| Guides         | ✅           | ✅      | ✅      |
| Slash Commands | ✅           | ✅      | ❌      |
| Auto-testing   | ✅           | ✅      | ❌      |

---

## 💬 Community & Support

- 🐛 **Found a bug?** [Open an issue](https://github.com/joserprieto/ai-diagrams-toolkit/issues/new)
- 💡 **Have an idea?** [Start a discussion](https://github.com/joserprieto/ai-diagrams-toolkit/discussions)
- 📧 **Need help?** Check [examples](./examples/) or ask in discussions

---

## 📝 License

MIT License - see [LICENSE](./LICENSE) for details.

---

**Made with ❤️ for the diagrams-as-code community**

**Star ⭐ this repo if you find it useful!**
