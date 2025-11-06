# Create Flowchart

Create a Mermaid flowchart diagram from natural language description.

## Instructions

When user invokes this command with a description:

1. **Analyze the description** to identify:
   - Main process steps
   - Decision points
   - Data inputs/outputs
   - Error handling paths

2. **Choose appropriate shapes**:
   - `([Terminal])` for start/end
   - `[Process]` for standard steps
   - `{Decision}` for decision points
   - `[/Input/]` for data inputs
   - `[\Output\]` for data outputs
   - `[(Storage)]` for databases

3. **Apply semantic colors automatically**:
   - Operational/success states: `:::operational` (green)
   - Decision points: `:::warning` (yellow)
   - Error handling: `:::error` (red)
   - Info/neutral: `:::info` (blue)
   - Architectural layers: `:::dataLayer`, `:::processingLayer`, etc.

4. **Use semantic node names** (English):
   - SessionStart, not A
   - UserValidation, not B
   - ErrorHandler, not X

5. **Add comments** explaining structure

6. **Include complete classDef** definitions at bottom

## Template Base

Use `/templates/flowchart.mmd` as starting point.

## Example

User request: "Create flowchart for user authentication process"

Output:
```mermaid
%%{init: {'theme':'base'}}%%
flowchart TD
    %% Authentication process flow
    Start([Start]):::info
    ReceiveCreds[/Receive Credentials/]:::dataLayer
    ValidateFormat{Valid Format?}:::warning
    CheckDB[[Query User DB]]:::processingLayer
    VerifyPassword{Password Match?}:::warning
    GenerateToken[[Generate JWT]]:::processingLayer
    StoreSession[(Store Session)]:::storageLayer
    Success([Login Success]):::operational
    ErrorInvalid[\Invalid Format\]:::error
    ErrorAuth[\Auth Failed\]:::error

    Start --> ReceiveCreds
    ReceiveCreds --> ValidateFormat
    ValidateFormat -->|Yes| CheckDB
    ValidateFormat -->|No| ErrorInvalid
    CheckDB --> VerifyPassword
    VerifyPassword -->|Match| GenerateToken
    VerifyPassword -->|No Match| ErrorAuth
    GenerateToken --> StoreSession
    StoreSession --> Success

    %% Styles
    classDef operational fill:#4CAF50,stroke:#2E7D32,color:#FFF,stroke-width:2px
    classDef warning fill:#FFC107,stroke:#F57C00,color:#000,stroke-width:2px
    classDef error fill:#F44336,stroke:#C62828,color:#FFF,stroke-width:2px
    classDef info fill:#2196F3,stroke:#1565C0,color:#FFF,stroke-width:2px
    classDef dataLayer fill:#E3F2FD,stroke:#1565C0,color:#0D47A1
    classDef processingLayer fill:#E8F5E9,stroke:#2E7D32,color:#1B5E20
    classDef storageLayer fill:#FFF3E0,stroke:#E65100,color:#BF360C
```

## Important

- Avoid reserved keywords (see guides/mermaid/common-pitfalls.md)
- Use semantic naming (English for node IDs)
- User-visible text can be in any language as specified
- Always include complete classDef block
