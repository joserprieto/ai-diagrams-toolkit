# AI Instructions - Diagrams as Code Toolkit

Universal AI instructions for creating Mermaid diagrams with semantic color system.

**Compatibility**: Works with Claude Code, Cursor, and other AI-powered editors supporting AGENTS.md spec.

---

## 🎯 Core Principles

When working with diagrams in this repository:

1. **Semantic over generic**: Use meaningful names (SessionStart, not A)
2. **Colors communicate meaning**: Operational=green, error=red, warning=yellow
3. **Consistency matters**: Same concepts same colors across diagrams
4. **Tool-agnostic foundation**: Color system works beyond just Mermaid

---

## 🎨 Semantic Color System

### Apply colors based on MEANING, not aesthetics

**States/Conditions**:

- `operational` (#4CAF50 green): System working correctly, success paths
- `warning` (#FFC107 yellow): Attention needed, degraded, decision points
- `error` (#F44336 red): Failed, critical issues, error paths
- `info` (#2196F3 blue): Informational, neutral, entry points
- `inactive` (#9E9E9E gray): Disabled, unused, deprecated

**Architectural Layers**:

- `dataLayer` (blue light #E3F2FD): Input, sensors, data sources
- `processingLayer` (green light #E8F5E9): Business logic, transformation
- `storageLayer` (orange light #FFF3E0): Persistence, databases, caches
- `communicationLayer` (purple light #F3E5F5): APIs, messaging, protocols
- `presentationLayer` (cyan light #E0F2F1): UI, visualization, dashboards

**Priority Levels**:

- `critical` (red bg, 3px border): Critical systems, cannot fail
- `important` (orange bg, 2px border): Important but not critical
- `standard` (blue bg, 1px border): Standard components

---

## 📐 Diagram Type Selection

Choose diagram type based on what user wants to show:

| User Wants                    | Use Diagram Type | Why                                     |
|-------------------------------|------------------|-----------------------------------------|
| Process/workflow steps        | Flowchart        | Shows sequential flow with decisions    |
| System interactions over time | Sequence         | Shows who-calls-whom with timing        |
| Class/data structure          | Class            | Shows OOP relationships and inheritance |
| State transitions             | State            | Shows lifecycle and state changes       |
| Database schema               | ER               | Shows entities and relationships        |

---

## 🔤 Naming Conventions (STRICT)

### Node IDs (code-level)

**Language**: Always English
**Style**: PascalCase or camelCase, semantic

**Examples**:

- ✅ SessionStart, UserValidation, DataProcessor
- ❌ A, B, C, Nodo1, Nodo2, end, class

**Reserved keywords** (NEVER use as node IDs):

- `end`, `class`, `style`, `click`, `graph`, `subgraph`
- See `/guides/mermaid/common-pitfalls.md` for complete list

### User-Visible Text (labels)

**Language**: English by default (unless user specifies otherwise)

**Examples**:

- `SessionStart["Start session"]` ✅
- `UserValidation["Validate user"]` ✅

### Comments

**Language**: Always English

**Examples**:

```mermaid
%% Authentication flow
%% Handles login with 2FA
graph TD
%% ... diagram ...
```

**Note**: Comments are not rendered in diagrams; one comment needs a separate line (no inline comment is allowed)

---

## 🚫 Critical Pitfalls to Avoid

### 1. Reserved Keywords

```mermaid
%% ❌ BREAKS
graph TD
end[Finish]
%% "end" is reserved

%% ✅ WORKS
graph TD
Finish[Finish]
EndNode[End]  %% Capitalize works
```

### 2. Special Characters

```mermaid
%% ❌ PROBLEMATIC
graph TD
    A[Status: Active]
%% Colon may break

%% ✅ SAFE
    graph TD
    A["Status: Active"]  %% Always quote special chars
```

### 3. ClassDef Position

```mermaid
%% ❌ WRONG ORDER
graph TD
    classDef myClass fill: #f00  %% Before nodes
    A[Node]:::myClass
%% ✅ CORRECT ORDER
    graph TD
    A[Node]:::myClass
    classDef myClass fill: #f00  %% After nodes
```

---

## 🛠️ Available Tools

### Slash Commands (v0.2.0+)

- `/create-flowchart [description]` - Generate flowchart
- `/create-sequence [description]` - Generate sequence diagram
- `/apply-colors [file]` - Apply semantic colors
- `/validate-diagram [file]` - Validate syntax and conventions

**Location**: `.ai/commands/`

---

## 🎯 Core Behaviors

### 1. Proactive Diagram Creation

When user describes a process, system, or structure:

- Recognize it's diagrammable
- Suggest appropriate diagram type
- Offer to create diagram
- Don't wait for explicit "create diagram" request

### 2. Semantic Color Application

When creating or modifying diagrams:

- **Always** apply semantic color system (never generic/random colors)
- Explain color choices briefly
- Use colors to communicate meaning

### 3. Quality Enforcement

Before delivering any diagram:

- ✅ Validate syntax (no parsing errors)
- ✅ Check no reserved keywords used
- ✅ Verify semantic node names (not A, B, C)
- ✅ Ensure classDef after nodes
- ✅ Special characters handled safely
- ✅ Comments in English, labels in specified language

### 4. Educational Approach

When helping users:

- Explain why certain syntax used
- Point out reserved keywords avoided
- Show color system reasoning
- Reference guides for deeper learning
- Teach conventions, don't just apply them

### 5. Iterative Refinement

For complex diagrams:

- Start with working simple version
- Get user feedback
- Iterate and refine
- Don't try to perfect in one shot
- Validate before final delivery

---

## 📚 Resources Available

- **Templates**: `/templates/` (flowchart, sequence, class, state)
- **Guides**: `/guides/mermaid/` (comprehensive references)
- **Examples**: `/examples/` (real-world use cases)
- **Common Pitfalls**: `/guides/mermaid/common-pitfalls.md`

---

## ✅ Quality Commitment

Every diagram created/modified must be:

- ✅ Syntactically valid (renders correctly)
- ✅ Convention-compliant (semantic names, colors)
- ✅ Well-commented (explains structure)
- ✅ Production-ready (no reserved keywords, safe chars)
- ✅ Educational (user learns, doesn't just receive)

---

*These instructions ensure all AI-generated diagrams follow conventions and use semantic color system correctly.*
