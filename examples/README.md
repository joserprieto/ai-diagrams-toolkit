# Examples - Semantic Color System in Action

Real-world examples showing how the semantic color system improves diagram clarity.

## 📚 Available Examples

### [Critical System Monitoring](./critical-system.md)
**Diagram Type**: Flowchart with subgraphs
**Demonstrates**:
- Architectural layer colors (data, processing, storage, communication, presentation)
- State-based colors (operational, warning, error)
- Alert severity classification
- Complex multi-layer system architecture

**Best For**: Learning how to apply colors to technical system diagrams

---

### [Business Process - Order Fulfillment](./business-process.md)
**Diagram Type**: Flowchart with decision trees
**Demonstrates**:
- Decision point highlighting (yellow)
- Error path identification (red)
- Success states (green)
- Layer separation (processing, storage, communication)

**Best For**: Understanding business process diagram patterns

---

## 🎯 How to Use These Examples

### 1. Study the Diagram
- Look at the rendered diagram
- Notice how colors group related concepts
- See how states are immediately identifiable

### 2. Read Color Explanations
Each example includes "Color Choices Explained" section showing:
- Why each color was chosen
- What meaning it communicates
- How it helps understanding

### 3. Adapt for Your Use Case
- Copy the example structure
- Replace domain-specific parts
- Keep color system intact
- Adjust to your needs

### 4. Learn Patterns
- Decision diamonds = Yellow (warning)
- Error trapezoids = Red (error)
- Database cylinders = Orange light (storage layer)
- API boxes = Purple light (communication layer)

## 💡 Key Learnings

### Before/After Value

**Without semantic colors**:
- All nodes look the same
- Hard to identify critical paths
- Unclear what's operational vs error
- Architectural layers not visible

**With semantic colors**:
- ✅ Critical paths stand out (red)
- ✅ Decisions immediately visible (yellow)
- ✅ Success states clear (green)
- ✅ Architecture layers obvious (light colors)
- ✅ Faster comprehension (colors = meaning)

### Consistency is Key

Once you learn:
- Green = operational/success
- Yellow = warning/decision
- Red = error/critical
- Light blue = data layer
- Light green = processing layer

You can understand **any** diagram using this system instantly.

## 🚀 Creating Your Own

1. **Start from template**: Copy `/templates/[type].mmd`
2. **Read guide**: Check `/guides/mermaid/[type].md`
3. **Reference example**: Look at example closest to your use case
4. **Apply colors**: Use semantic color system
5. **Validate**: Test rendering in [Mermaid Live](https://mermaid.live)

---

*These examples are living documentation. PRs welcome for additional real-world examples.*
