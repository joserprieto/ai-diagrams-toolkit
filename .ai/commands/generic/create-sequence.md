---
description: "Generate Mermaid sequence diagram from natural language description"
argument-hint: "<interaction-description>"
allowed-tools: []
---

# Create Sequence Diagram

Create a Mermaid sequence diagram from natural language description.

## Arguments
- `$1` or `$ARGUMENTS` - Natural language description of the interactions to diagram

## Instructions

When user invokes this command with a description:

1. **Identify participants** (actors, systems, services):
   - Use clear, descriptive names
   - Add emojis for visual clarity (optional)
   - Example: `participant User as 👤 User`

2. **Map interactions** to message types:
   - `->>` for synchronous calls
   - `-->>` for returns/responses
   - `-)` for async messages
   - `--x` for failed/error responses

3. **Apply semantic colors with rect blocks**:
   - Data layer (input): `rect rgb(227, 242, 253)` (blue light)
   - Processing: `rect rgb(243, 229, 245)` (purple light)
   - Storage: `rect rgb(255, 243, 224)` (orange light)
   - Success: `rect rgb(232, 245, 233)` (green light)
   - Error: `rect rgb(255, 235, 238)` (red light)

4. **Use activation boxes** where appropriate:
   - `activate Participant` when processing starts
   - `deactivate Participant` when processing ends
   - Must balance (every activate needs deactivate)

5. **Add notes** for context:
   - `note right of Participant: Context`
   - `note left of Participant: Detail`
   - `note over A,B: Shared context`

6. **Group related interactions** in colored rect blocks

## Template Base

Use `/templates/sequence.mmd` as starting point.

## Important

- Balance activate/deactivate (every activate must have deactivate)
- **NEVER use deactivation inside alt/else/loop/opt blocks** (Mermaid limitation)
  - Place deactivate AFTER the closing `end` of the block
  - See: guides/mermaid/common-pitfalls.md#sequence-diagram-activationdeactivation
- Don't nest rect blocks (not supported)
- Use `-->>` for returns, `->>` for calls
- Keep max 5-6 participants for readability

## Activation Rules

**Correct** ✅:
```mermaid
activate Service
alt Success
    Service->>Database: Query
else Error
    Service->>Logger: Log error
end
deactivate Service  ← AFTER the alt block ends
```

**Incorrect** ❌:
```mermaid
activate Service
alt Success
    Service->>Database: Query
    deactivate Service  ← NEVER inside alt/else/loop/opt
else Error
    Service->>Logger: Log
end
```
