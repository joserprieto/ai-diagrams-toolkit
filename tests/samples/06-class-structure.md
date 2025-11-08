# Test Sample 06: Class Structure (OOP)

Create a Mermaid class diagram for a document management system:

**Domain Model**: Document management with validation and conversion

**Classes**:

**Entities**:

- Document (domain entity)
    - Properties: id (String), title (String), content (String), createdAt (Date), author (String)
    - Methods: validate(), save(), delete()

**Value Objects**:

- DocumentMetadata (value object)
    - Properties: wordCount (int), pageCount (int), language (String)
    - Methods: equals(), toString()

**Services**:

- DocumentValidator (service)
    - Properties: rules (ValidationRules)
    - Methods: validate(Document), sanitize(String)

- DocumentConverter (service)
    - Methods: toPDF(Document), toHTML(Document), toMarkdown(Document)

**Repositories**:

- IDocumentRepository (interface)
    - Methods: findById(String), save(Document), delete(String), findAll()

- PostgresDocumentRepository (concrete implementation)
    - Properties: connection (Connection)
    - Implements: IDocumentRepository

**Relationships**:

- Document uses DocumentValidator (dependency)
- Document has DocumentMetadata (composition)
- DocumentConverter depends on Document (uses)
- PostgresDocumentRepository implements IDocumentRepository (realization)
- PostgresDocumentRepository manages Document (association)

**Requirements**:

- Use stereotypes (<<entity>>, <<value-object>>, <<service>>, <<repository>>, <<interface>>)
- Use visibility modifiers (+public, -private, #protected)
- Semantic class names (Document, not Doc1)
- Show relationships with correct arrows (inheritance, composition, dependency)
- Avoid reserved keywords

**Diagram type**: classDiagram
