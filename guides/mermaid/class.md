# 🏗️ Class Diagrams - Mermaid

Class diagrams for OOP structures, data models, and system architecture.

## ✅ Styling Capabilities

| Feature | Support | Notes |
|---------|---------|-------|
| Class definitions | ✅ Complete | Properties and methods |
| Relationships | ✅ Complete | Inheritance, composition, association |
| Stereotypes | ✅ Complete | <<interface>>, <<abstract>>, etc. |
| Visibility | ✅ Complete | +public, -private, #protected |
| Annotations | ✅ Complete | Notes and labels |
| Namespaces | ⚠️ Limited | Can use subgraph-like grouping |

## 📐 Relationship Types

| Relationship | Syntax | Visual | Meaning |
|--------------|--------|--------|---------|
| Inheritance | `<\|--` | `─▷` | Extends/implements |
| Composition | `*--` | `─◆` | Strong ownership |
| Aggregation | `o--` | `─◇` | Weak ownership |
| Association | `-->` | `─→` | Uses/knows |
| Dependency | `..>` | `┄→` | Depends on |
| Realization | `..\|>` | `┄▷` | Implements interface |

## 🎨 Semantic Class Stereotypes

### Common Stereotypes

```mermaid
classDiagram
    class DomainEntity {
        <<entity>>
        +UUID id
        +createdAt Date
    }

    class ValueObject {
        <<value-object>>
        +equals() bool
    }

    class Service {
        <<service>>
        +execute() Result
    }

    class Repository {
        <<repository>>
        +findById() Entity
        +save() void
    }

    class Interface {
        <<interface>>
        +method() abstract
    }
```

### Stereotype Categories

- `<<entity>>`: Domain entities (mutable, identity)
- `<<value-object>>`: Value objects (immutable, equality by value)
- `<<service>>`: Business logic/services
- `<<repository>>`: Data access layer
- `<<interface>>`: Contracts/interfaces
- `<<abstract>>`: Abstract classes
- `<<concrete>>`: Concrete implementations
- `<<factory>>`: Factory patterns
- `<<singleton>>`: Singleton patterns

## 📋 Complete Example

```mermaid
%%{init: {'theme':'base', 'themeVariables': {'primaryColor':'#f0f0f0'}}}%%
classDiagram
    class Document {
        <<entity>>
        +String id
        +String title
        +String content
        +Date createdAt
        +validate() bool
        +save() void
    }

    class DocumentValidator {
        <<service>>
        -ValidationRules rules
        +validate(Document) ValidationResult
        +sanitize(String) String
    }

    class ValidationResult {
        <<value-object>>
        +bool isValid
        +String[] errors
        +String[] warnings
    }

    class IDocumentRepository {
        <<interface>>
        +findById(String) Document
        +save(Document) void
        +delete(String) void
    }

    class PostgresDocumentRepository {
        <<repository>>
        -Connection connection
        +findById(String) Document
        +save(Document) void
        +delete(String) void
    }

    %% Relationships
    Document ..> DocumentValidator : uses
    DocumentValidator ..> ValidationResult : returns
    IDocumentRepository <|.. PostgresDocumentRepository : implements
    PostgresDocumentRepository --> Document : manages
```

## 🔍 Visibility Modifiers

```mermaid
classDiagram
    class Example {
        +publicField String
        -privateField int
        #protectedField bool
        ~packageField Date
        +publicMethod() void
        -privateMethod() String
        #protectedMethod() bool
    }
```

| Symbol | Visibility | Meaning |
|--------|------------|---------|
| `+` | Public | Accessible from anywhere |
| `-` | Private | Accessible only within class |
| `#` | Protected | Accessible in class and subclasses |
| `~` | Package | Accessible within package |

## 💡 Best Practices

1. **Semantic Names**: Use domain language (Invoice, not Doc1)
2. **Stereotypes**: Clarify purpose with stereotypes
3. **Visibility**: Use appropriate visibility modifiers
4. **Relationships**: Choose correct relationship type (composition vs association)
5. **Grouping**: Use namespaces/packages for large models
6. **Limit Scope**: Show 5-10 classes max per diagram

## 🚫 Common Pitfalls

- **Generics with commas**: `List<K, V>` not supported (use `List~K,V~` or avoid)
- **Reserved keywords**: Avoid "class", "end" as class names
- **Method overloading**: Show only representative signature
- **Deep hierarchies**: Flatten or split into multiple diagrams

See [`common-pitfalls.md`](./common-pitfalls.md) for complete list.

---

*For other diagram types, see other guides in this directory.*
