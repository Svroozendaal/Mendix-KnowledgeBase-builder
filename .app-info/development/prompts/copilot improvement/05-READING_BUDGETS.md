# PROMPT 05: Reading Budgets and Stop Signals

## Priority

High — prevents bots from over-reading KB files and wasting thousands of tokens on irrelevant detail.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow
4. `KnowledgeBase-Creator/artifacts/.agents/FRAMEWORK.md` — current framework description
5. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md`
6. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FLOW_TRACER.md`
7. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_ANALYST.md`
8. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_NAVIGATOR.md`
9. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`

## Problem Statement

The current workflow tells the bot to drill from ROUTING → module README → FLOWS → L0 → L1, but never tells it when to **stop reading**. There are no explicit signals for "you have enough information to answer this question."

A bot trying to understand "registration" may read 10+ files and 100KB+ of text when the answer was available after reading 3 files.

## Entry Criteria

1. The KB agent workflow files exist in `artifacts/.agents/`.
2. The L0/L1/L2 layer structure is established.

## Deliverable

### 1. Add reading depth levels to AI_WORKFLOW.md

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, add a new section:

```markdown
## Reading Depth Guide

Match your reading depth to the question complexity. Start shallow, go deeper only if needed.

### Level 1: Quick Lookup (1-3 file reads)
**Use when:** Simple lookup — "What module does entity X belong to?", "How many flows are in module Y?", "What roles exist?"
**Read:** `routes/keyword-index.md` or ROUTING.md → one target file → answer.
**Stop when:** You can cite a specific file and section that answers the question.

### Level 2: Feature Understanding (3-6 file reads)
**Use when:** Capability question — "How does registration work?", "What does module X do?"
**Read:** `routes/keyword-index.md` → module README (Capability Map, Primary User Journeys) → INTERPRETATION.md → FLOWS.md (Tier 1 flows only) → top 2-3 L0 abstracts → 1 L1 overview for the central flow.
**Stop when:** You can describe the feature in business terms and cite the key flows and entities involved.

### Level 3: Deep Investigation (6-12 file reads)
**Use when:** Tracing, impact analysis, or development planning — "Trace flow X end-to-end", "What is affected if I change entity Y?", `/develop`.
**Read:** Everything in Level 2, plus: all related L1 overviews → DOMAIN.md → routes/by-entity.md (relevant entities only) → routes/cross-module.md → app/SECURITY.md.
**Stop when:** You have traced all relevant chains, identified all affected artefacts, and can assess the blast radius.

### Level 4: Full Context (12+ file reads)
**Use when:** `/develop` workflow producing an implementation plan (Phases 3-5).
**Read:** Everything in Level 3, plus: all L1 overviews for affected flows → full DOMAIN.md for all affected modules → full SECURITY.md → all route files for cross-referencing.
**Stop when:** The implementation plan has no unresolved references.
```

### 2. Add stop signals to each interpretation agent

In `KnowledgeBase-Creator/artifacts/.agents/agents/`, add a "Stop Signal" section to each:

**KB_NAVIGATOR.md:**
```markdown
## Stop Signal
You have enough information when you can point the user to the specific KB file and section that answers their question. Do NOT read the file yourself unless the user explicitly asks for its content.
```

**KB_FEATURE_INTERPRETER.md:**
```markdown
## Stop Signal
You have enough information when you can describe the feature in business terms, list the key modules/flows/entities involved, and cite the files. Do NOT read every L1 overview — read only the top 1-2 central flows at L1 depth. Use L0 abstracts for triage.
```

**KB_FLOW_TRACER.md:**
```markdown
## Stop Signal
You have enough information when the chain tree is complete (no unresolved calls) and you have cross-referenced entities and pages for the traced chain. Do NOT trace flows that are only tangentially related (e.g., utility sub-flows called by many chains).
```

**KB_ANALYST.md:**
```markdown
## Stop Signal
You have enough information when you can rate the blast radius (Small/Medium/Large) and list all directly affected artefacts. Do NOT trace secondary effects beyond one hop unless the intermediate flow is high-impact.
```

**KB_DOMAIN_EXPERT.md:**
```markdown
## Stop Signal
You have enough information when you can describe the entity's shape, its associations, its lifecycle flows, and its access rules. Do NOT read flows that only tangentially reference the entity.
```

**KB_SECURITY_REVIEWER.md:**
```markdown
## Stop Signal
You have enough information when you can list the relevant access rules, role assignments, and XPath constraints for the artefacts in question. Do NOT audit the entire app's security model for a question about one entity.
```

**KB_UX_INTERPRETER.md:**
```markdown
## Stop Signal
You have enough information when you can describe the page structure, its data sources, and its role visibility. Do NOT trace every flow called from buttons on the page unless the question specifically asks about page behaviour.
```

### 3. Add partial reads guidance

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, add a section:

```markdown
## Partial File Reading

Not every file needs to be read in full. Use these strategies:

- **FLOWS.md**: Read the Tier 1 summary table first. Only read the full Flow Details section if a specific flow is relevant.
- **routes/by-flow.md** and **routes/by-entity.md**: Search for the specific entity/flow name rather than reading the entire file. These files can be 50KB+.
- **L0 abstracts**: Read 3-5 at a time for triage. Only promote to L1 reading for relevant matches.
- **DOMAIN.md**: Read the entity lifecycle matrix first. Only drill into individual entity sections for entities in scope.
- **ROUTING.md**: Read the quick-lookup table and module index. Skip the metadata section unless you need generation context.
```

### 4. Add depth column to query pattern table

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, update the "Common Query Patterns" table to include a "Depth" column:

```markdown
| Query type | Start with | Then check | Depth |
|---|---|---|---|
| "What does module X do?" | `modules/X/README.md` | `INTERPRETATION.md`, `FLOWS.md` | Level 2 |
| "Which flows use entity Y?" | `routes/by-entity.md` | `modules/<module>/FLOWS.md` | Level 1 |
| "How does feature X work?" | `routes/keyword-index.md` | README, INTERPRETATION.md, L0/L1 | Level 2 |
| "Trace flow X" | `routes/by-flow.md` | L1, flow-chain-tracing | Level 3 |
| "What if I change X?" | `routes/by-flow.md` or `by-entity.md` | impact-analysis skill | Level 3 |
| `/develop` | `DEVELOPMENT_TEAM.md` | Full 6-phase workflow | Level 3-4 |
```

## Files Changed (all under `KnowledgeBase-Creator/artifacts/.agents/`)

| File | Change |
|---|---|
| `AI_WORKFLOW.md` | Add Reading Depth Guide, Partial File Reading, depth column in query table |
| `agents/KB_NAVIGATOR.md` | Add Stop Signal section |
| `agents/KB_FEATURE_INTERPRETER.md` | Add Stop Signal section |
| `agents/KB_FLOW_TRACER.md` | Add Stop Signal section |
| `agents/KB_ANALYST.md` | Add Stop Signal section |
| `agents/KB_DOMAIN_EXPERT.md` | Add Stop Signal section |
| `agents/KB_SECURITY_REVIEWER.md` | Add Stop Signal section |
| `agents/KB_UX_INTERPRETER.md` | Add Stop Signal section |

## Exit Criteria

1. AI_WORKFLOW.md has a "Reading Depth Guide" with 4 levels and a "Partial File Reading" section.
2. Every interpretation agent has an explicit "Stop Signal" section.
3. The Common Query Patterns table includes a Depth column.
4. A bot answering "What module does Course belong to?" reads 1-2 files (Level 1), not 10.
5. All future generated KBs include these reading guides.

## Skills to Use

- Agent: **Developer** (agent artifact file updates)
- Agent: **Documenter** (workflow documentation)

## Notes

- Reading budgets are guidance, not hard limits. If a Level 2 answer is insufficient, the bot should escalate to Level 3 and explain why.
- These changes are purely to agent artifact files — no compose script or template changes needed.
