# Test Sample 05: State Machine

Create a Mermaid state diagram for a deployment pipeline:

**System**: CI/CD deployment pipeline states

**States**:

- Idle (waiting for trigger)
- Building (compiling code)
- Testing (running test suite)
- Deploying (deploying to environment)
- Deployed (successfully deployed)
- Failed (deployment failed)
- Rolling Back (reverting to previous version)

**Transitions**:

- [*] → Idle (initial state)
- Idle → Building (on git push)
- Building → Testing (build successful)
- Building → Failed (build failed)
- Testing → Deploying (tests passed)
- Testing → Failed (tests failed)
- Deploying → Deployed (deployment successful)
- Deploying → Failed (deployment failed)
- Failed → Rolling Back (auto-rollback triggered)
- Rolling Back → Idle (rollback complete)
- Deployed → Idle (ready for next deployment)
- Idle → [*] (system shutdown)

**Requirements**:

- Semantic state names (Building, not State1)
- Apply semantic colors:
    - Deployed: operational (green)
    - Building/Testing/Deploying: warning (yellow)
    - Failed: error (red)
    - Idle: info (blue)
    - Rolling Back: warning (yellow)
- Include complete classDef block
- Add notes for complex transitions (optional)

**Diagram type**: stateDiagram-v2
