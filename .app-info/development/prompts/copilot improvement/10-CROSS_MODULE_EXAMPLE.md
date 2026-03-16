# PROMPT 10: Cross-Module Worked Example

## Priority

Low — future-proofing for real-world apps with complex module dependencies. The current test app has zero cross-module dependencies, so this improvement is not immediately needed.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/.agents/AI_WORKFLOW.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_ANALYST.md` (or the `impact-analysis` skill after Prompt 07)
5. Generated KB: `mendix-data/knowledge-base/.agents/skills/cross-module-tracing/SKILL.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/skills/impact-analysis/SKILL.md`
7. Generated KB: `mendix-data/knowledge-base/routes/cross-module.md`
8. Generated KB: `mendix-data/knowledge-base/app/CALL_GRAPH.md`

## Problem Statement

The KB has comprehensive infrastructure for cross-module analysis:

- `routes/cross-module.md` — dependency matrix with hub/leaf classification.
- `app/CALL_GRAPH.md` — cross-module flow call graph.
- `cross-module-tracing` skill — procedure for tracing dependencies across module boundaries.
- `impact-analysis` skill — blast radius assessment that cross-references `cross-module.md`.
- KB Analyst agent — responsible for architectural reasoning.

However, the current test KB ("Mastering Advanced XPaths - Starting point") has **zero cross-module dependencies**. The cross-module files are essentially empty tables. This means:

1. A bot has never exercised the cross-module analysis path on real data.
2. The workflow descriptions are abstract — there is no concrete example of how a bot should navigate a real cross-module scenario.
3. When this KB is used on a production app with 30+ modules and complex dependencies, the bot will encounter cross-module patterns for the first time with no worked example to follow.

## Entry Criteria

1. The cross-module KB infrastructure exists (files, skills, agents).
2. Access to a sample or hypothetical cross-module scenario for illustration.

## Deliverable

### 1. Add a worked example to AI_WORKFLOW.md

Add a new section "Worked Example: Cross-Module Analysis" to `AI_WORKFLOW.md`:

```markdown
## Worked Example: Cross-Module Analysis

This example illustrates how to handle a question that spans module boundaries. The example uses a hypothetical app with three modules: `OrderManagement`, `Inventory`, and `Notifications`.

### Scenario

Developer asks: "I need to add a low-stock alert when an order reduces inventory below a threshold. Where should this logic live?"

### Step 1: Identify the modules involved

Read `routes/keyword-index.md` (or `routes/cross-module.md`):
- "order" → `OrderManagement` module
- "inventory", "stock" → `Inventory` module
- "alert", "notification" → `Notifications` module

Three modules are involved. This is a cross-module question.

### Step 2: Check existing cross-module dependencies

Read `routes/cross-module.md`:

| From Module | To Module | Via Flow | Direction |
|---|---|---|---|
| OrderManagement | Inventory | SUB_Inventory_DeductStock | OrderManagement calls Inventory |
| Inventory | Notifications | SUB_Notifications_SendAlert | Inventory calls Notifications |

The dependency chain already exists: Order → Inventory → Notifications.

### Step 3: Read the hub/leaf classification

From `app/CALL_GRAPH.md`:
- `Inventory` is a **hub** (called by OrderManagement, calls Notifications).
- `OrderManagement` is a **leaf caller** (calls Inventory, not called by others).
- `Notifications` is a **leaf callee** (called by Inventory, does not call others).

### Step 4: Trace the relevant flow chain

Invoke `flow-chain-tracing` on `ACT_Order_Confirm` (the order confirmation flow):

```
ACT_Order_Confirm (OrderManagement) [Tier 1]
  → SUB_Inventory_DeductStock (Inventory) [Tier 2]
    → [NEW: threshold check + alert trigger would go here]
  → SUB_Order_SendConfirmation (Notifications) [Tier 2]
```

### Step 5: Assess impact

Invoke `impact-analysis`:
- **Blast radius: Medium** — change touches 2 modules (Inventory, Notifications) beyond the originating module.
- `SUB_Inventory_DeductStock` is called by 3 flows (OrderConfirm, OrderReturn, InventoryAdjust) — high fan-in. Adding threshold logic here means all three callers trigger the alert.
- Recommendation: add the threshold check inside `SUB_Inventory_DeductStock` so all stock-reducing operations benefit from the alert, not just orders.

### Step 6: Recommend module placement

- **Threshold check logic**: `Inventory` module (it owns stock levels).
- **Alert trigger**: `Inventory` calls existing `SUB_Notifications_SendAlert` (follows the existing dependency direction).
- **New entity (StockThreshold)**: `Inventory` module (domain ownership).
- **New page (threshold configuration)**: `Inventory` module.

### Key Principles Illustrated

1. **Follow existing dependency directions.** The Inventory → Notifications dependency already exists. The new feature uses the same path — no new cross-module wiring needed.
2. **Place logic where the data lives.** Stock thresholds belong in the Inventory module because that module owns stock data.
3. **High fan-in = broad impact.** When a flow is called by multiple callers, changes to it affect all of them. This is usually desirable (consistent behaviour) but must be flagged.
4. **Hub modules are high-risk change targets.** Adding logic to a hub module's flow has the widest blast radius.
```

### 2. Add cross-module guidance to the Development Team agent

Add to `DEVELOPMENT_TEAM.md` Phase 1 (Story Mapping):

```markdown
**Cross-module detection.** If the story keywords match entities or flows in 2+ modules, check `routes/cross-module.md` immediately. Determine:
- Whether the modules already have a dependency relationship.
- Which direction the dependency flows (who calls whom).
- Whether the new feature follows or reverses the existing dependency direction.

If the new feature would create a **new** cross-module dependency (one that does not exist in `cross-module.md`), flag this to the developer as an architectural decision that needs explicit approval.
```

Add to `DEVELOPMENT_TEAM.md` Phase 2 (High-Level Solution):

```markdown
**Module placement rule.** When a feature spans modules:
- Place new entities in the module that owns the domain concept.
- Place new flows in the module that initiates the action.
- Use sub-microflow calls (not direct entity manipulation) to cross module boundaries.
- Follow existing dependency directions. Propose new dependencies only when necessary and flag them explicitly.
```

### 3. Add to the impact-analysis skill

Add a "Cross-Module Impact" section to the impact-analysis skill:

```markdown
## Cross-Module Impact Assessment

When the target artefact is involved in cross-module dependencies:

1. Read `routes/cross-module.md` to identify all modules in the dependency chain.
2. Read `app/CALL_GRAPH.md` for hub/leaf classification.
3. For hub modules: rate blast radius one level higher (Small → Medium, Medium → Large).
4. For new cross-module dependencies: always rate as at least Medium.
5. Document the dependency direction and whether the change follows or reverses it.

### Blast Radius Escalation Rules

| Scenario | Base Rating | Escalation |
|---|---|---|
| Change confined to one module | Small | None |
| Change uses existing cross-module dependency | Medium | None |
| Change adds new cross-module dependency | Medium | → Large (architectural decision) |
| Change to hub module flow with 3+ callers | Medium | → Large |
| Change reverses existing dependency direction | Large | Flag as architectural risk |
```

## Exit Criteria

1. AI_WORKFLOW.md contains a worked example showing cross-module analysis on a realistic scenario.
2. DEVELOPMENT_TEAM.md includes cross-module detection and module placement rules.
3. The impact-analysis skill includes cross-module escalation rules.
4. A bot encountering a cross-module question on a real production app can follow the worked example pattern.

## Skills to Use

- Agent: **Architect** (cross-module design principles)
- Agent: **Documenter** (worked example, workflow documentation)

## Notes

- The worked example uses a hypothetical app because the current test KB has no cross-module dependencies. When the KB is generated for a real production app, the example should still be useful as a reference pattern.
- The hypothetical scenario (OrderManagement → Inventory → Notifications) is deliberately simple and common. It should resonate with most Mendix developers.
- The blast radius escalation rules are new guidance that does not exist in any current file. They codify the intuition that cross-module changes are inherently riskier.
- Consider: when a KB has zero cross-module dependencies, the worked example may feel irrelevant. Add a conditional note: "If `routes/cross-module.md` shows no dependencies, this app's modules are independent. Cross-module guidance applies when modules begin to interact."
