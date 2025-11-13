---
description: "Apply semantic color system to existing Mermaid diagram"
argument-hint: "<diagram-file-or-content>"
allowed-tools: []
---

# Apply Semantic Colors

Apply the semantic color system to an existing Mermaid diagram.

## Arguments
- `$1` or `$ARGUMENTS` - Diagram file path or diagram content to colorize

## Instructions

When user invokes this command with a diagram file:

1. **Read the existing diagram**
   - Preserve all logic, nodes, and connections
   - Identify diagram type (flowchart, sequence, class, state)

2. **Analyze node purposes**:
   - Operational/success nodes → `:::operational` (green)
   - Warning/decision nodes → `:::warning` (yellow)
   - Error/failure nodes → `:::error` (red)
   - Info/neutral nodes → `:::info` (blue)
   - Inactive/disabled → `:::inactive` (gray)

3. **Identify architectural layers** (if applicable):
   - Input/data sources → `:::dataLayer` (blue light)
   - Processing/logic → `:::processingLayer` (green light)
   - Storage/persistence → `:::storageLayer` (orange light)
   - Communication/APIs → `:::communicationLayer` (purple light)
   - Presentation/UI → `:::presentationLayer` (cyan light)

4. **Add classDef block** if not present

5. **Apply classes** to nodes:
   - Flowchart: `NodeID[Text]:::className`
   - State: `StateName:::className`
   - Sequence: Add rect rgb() blocks

6. **Return modified diagram** with explanation

## Important

- Preserve original diagram logic (don't change flow)
- Only add/update styling
- Explain color choices
- Suggest improvements if appropriate
