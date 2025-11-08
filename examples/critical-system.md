# Example: Critical System Monitoring

Real-world example of semantic color system applied to a 24x7 critical system architecture.

## Use Case

Monitoring and alerting system for mission-critical services that must maintain 99.9% uptime.

## Diagram

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

## Color Choices Explained

### States

- **Start** → Info (blue): Entry point, neutral
- **Success** → Operational (green): System working correctly
- **Degraded** → Warning (yellow): Attention needed, not critical
- **Failed** → Error (red): Critical failure

### Architectural Layers

- **Sensors/Agents/Logs** → Data layer (blue light): Data ingestion
- **Aggregate/Classify** → Processing layer (green light): Business logic
- **Databases** → Storage layer (orange light): Persistence
- **PagerDuty/Slack** → Communication layer (purple light): Integration
- **Dashboard** → Presentation layer (cyan light): Visualization

### Alert Types

- **Critical** → Error (red): Requires immediate action
- **Warning** → Warning (yellow): Attention needed
- **Info** → Info (blue): Informational only

## Key Takeaways

1. **Colors communicate severity**: Red=critical, yellow=warning, green=OK
2. **Layers separate concerns**: Data → Process → Store → Communicate → Present
3. **Consistency aids understanding**: Same color = same meaning across all diagrams
4. **Semantic names**: TimeSeriesDB clearer than DB1

## Adapting This Example

To use for your system:

1. Replace layer names with your components
2. Adjust alert severity thresholds to your needs
3. Modify communication channels to your stack
4. Keep color system intact (meaning stays consistent)

---

*This example shows how semantic colors make critical system architecture immediately understandable.*
