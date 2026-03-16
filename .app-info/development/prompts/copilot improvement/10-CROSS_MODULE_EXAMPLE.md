# PROMPT 10: Cross-Module Worked Example

## Priority

Low — future-proofing for real-world apps with complex module dependencies. The current test app has zero cross-module dependencies, so this is not immediately needed.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow
4. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md` — current orchestrator
5. `KnowledgeBase-Creator/artifacts/.agents/skills/cross-module-tracing/SKILL.md`
6. `KnowledgeBase-Creator/artifacts/.agents/skills/impact-analysis/SKILL.md`
7. Generated KB example: `mendix-data/knowledge-base/routes/cross-module.md`
8. Generated KB example: `mendix-data/knowledge-base/app/CALL_GRAPH.md`

## Problem Statement

The KB has comprehensive cross-module analysis infrastructure (cross-module.md, CALL_GRAPH.md, cross-module-tracing skill, impact-analysis skill). But the current test KB has **zero cross-module dependencies** — the infrastructure is essentially empty.

This means:
1. A bot has never exercised the cross-module analysis path on real data.
2. Workflow descriptions are abstract — no concrete example of how to navigate a real cross-module scenario.
3. When used on a production app with 30+ modules, the bot encounters complex cross-module patterns for the first time with no reference.

## Entry Criteria

1. The cross-module KB infrastructure exists in `KnowledgeBase-Creator/artifacts/.agents/`.

## Deliverable

### 1. Add worked example to AI_WORKFLOW.md

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, add a new section:

```markdown
## Worked Example: Cross-Module Analysis

This example illustrates how to handle a question spanning module boundaries. It uses a hypothetical app with three modules: `OrderManagement`, `Inventory`, and `Notifications`.

### Scenario

Developer asks: "I need to add a low-stock alert when an order reduces inventory below a threshold. Where should this logic live?"

### Step 1: Identify modules involved

Read `routes/keyword-index.md` (or `routes/cross-module.md`):
- "order" → `OrderManagement` module
- "inventory", "stock" → `Inventory` module
- "alert", "notification" → `Notifications` module

Three modules involved — this is a cross-module question.

### Step 2: Check existing cross-module dependencies

Read `routes/cross-module.md`:

| From Module | To Module | Via Flow | Direction |
|---|---|---|---|
| OrderManagement | Inventory | SUB_Inventory_DeductStock | OrderManagement calls Inventory |
| Inventory | Notifications | SUB_Notifications_SendAlert | Inventory calls Notifications |

Dependency chain already exists: Order → Inventory → Notifications.

### Step 3: Read hub/leaf classification

From `app/CALL_GRAPH.md`:
- `Inventory` is a **hub** (called by OrderManagement, calls Notifications).
- `OrderManagement` is a **leaf caller**.
- `Notifications` is a **leaf callee**.

### Step 4: Trace the relevant flow chain

Invoke `flow-chain-tracing` on `ACT_Order_Confirm`:

```
ACT_Order_Confirm (OrderManagement) [Tier 1]
  → SUB_Inventory_DeductStock (Inventory) [Tier 2]
    → [NEW: threshold check + alert trigger would go here]
  → SUB_Order_SendConfirmation (Notifications) [Tier 2]
```

### Step 5: Assess impact

Invoke `impact-analysis`:
- **Blast radius: Medium** — touches 2 modules beyond origin.
- `SUB_Inventory_DeductStock` is called by 3 flows — high fan-in. Adding threshold logic means all callers trigger the alert.
- Recommendation: add threshold check inside `SUB_Inventory_DeductStock` so all stock-reducing operations benefit.

### Step 6: Recommend module placement

- **Threshold check logic**: `Inventory` module (owns stock levels).
- **Alert trigger**: `Inventory` calls existing `SUB_Notifications_SendAlert` (follows existing dependency).
- **New entity (StockThreshold)**: `Inventory` module (domain ownership).
- **New page (threshold config)**: `Inventory` module.

### Key Principles

1. **Follow existing dependency directions.** No new cross-module wiring needed.
2. **Place logic where the data lives.** Stock thresholds belong in Inventory.
3. **High fan-in = broad impact.** Changes to shared flows affect all callers.
4. **Hub modules are high-risk change targets.** Widest blast radius.

> Note: If `routes/cross-module.md` shows no dependencies, the app's modules are independent. This example applies when modules begin to interact.
```

### 2. Add cross-module detection to Development Team

In `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`, add to Phase 1 (Story Mapping):

```markdown
**Cross-module detection.** If story keywords match entities or flows in 2+ modules:
1. Check `routes/cross-module.md` for existing dependencies.
2. Determine dependency direction (who calls whom).
3. Check if the new feature follows or reverses the existing direction.
4. If the feature would create a **new** cross-module dependency (not in `cross-module.md`), flag it as an architectural decision needing explicit developer approval.
```

Add to Phase 2 (High-Level Solution):

```markdown
**Module placement rule for cross-module features:**
- Place new entities in the module that owns the domain concept.
- Place new flows in the module that initiates the action.
- Use sub-microflow calls (not direct entity manipulation) to cross module boundaries.
- Follow existing dependency directions. Propose new dependencies only when necessary and flag them.
```

### 3. Add blast radius escalation to impact-analysis skill

In `KnowledgeBase-Creator/artifacts/.agents/skills/impact-analysis/SKILL.md`, add:

```markdown
## Cross-Module Impact Escalation

| Scenario | Base Rating | Escalation |
|---|---|---|
| Change confined to one module | Small | None |
| Change uses existing cross-module dependency | Medium | None |
| Change adds new cross-module dependency | Medium | → Large (architectural decision) |
| Change to hub module flow with 3+ callers | Medium | → Large |
| Change reverses existing dependency direction | Large | Flag as architectural risk |

When the target artefact is involved in cross-module dependencies:
1. Read `routes/cross-module.md` for all modules in the chain.
2. Read `app/CALL_GRAPH.md` for hub/leaf classification.
3. For hub modules: rate blast radius one level higher.
4. For new dependencies: always rate as at least Medium.
5. Document the dependency direction and whether the change follows or reverses it.
```

## Files Changed (all under `KnowledgeBase-Creator/artifacts/.agents/`)

| File | Change |
|---|---|
| `AI_WORKFLOW.md` | Add worked example section |
| `agents/DEVELOPMENT_TEAM.md` | Add cross-module detection and placement rules |
| `skills/impact-analysis/SKILL.md` | Add blast radius escalation table |

## Exit Criteria

1. AI_WORKFLOW.md contains a concrete worked example for cross-module analysis.
2. DEVELOPMENT_TEAM.md includes cross-module detection and module placement rules.
3. The impact-analysis skill includes escalation rules.
4. All future generated KBs include this guidance.
5. A bot encountering a cross-module question on a production app can follow the worked example.

## Skills to Use

- Agent: **Architect** (cross-module design principles)
- Agent: **Documenter** (worked example, workflow documentation)

## Notes

- The hypothetical scenario (OrderManagement → Inventory → Notifications) is deliberately simple and common. It should resonate with most Mendix developers.
- The blast radius escalation rules are new guidance that codifies the intuition that cross-module changes are inherently riskier.
- When a KB has zero cross-module dependencies, the worked example still serves as a reference for when modules begin to interact.
