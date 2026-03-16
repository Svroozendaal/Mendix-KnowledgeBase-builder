# PROMPT 05: Reading Budgets and Stop Signals

## Priority

High — prevents bots from over-reading KB files and wasting thousands of tokens on irrelevant detail.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/.agents/AI_WORKFLOW.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/FRAMEWORK.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FEATURE_INTERPRETER.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FLOW_TRACER.md`
7. Generated KB: `mendix-data/knowledge-base/.agents/agents/DEVELOPMENT_TEAM.md`

## Problem Statement

The current workflow tells the bot to drill from ROUTING → module README → FLOWS → L0 → L1, but never tells it when to **stop reading**. There are no explicit signals for "you have enough information to answer this question."

A bot trying to understand "registration" will:
1. Read ROUTING.md (full file)
2. Read MODULE_LANDSCAPE.md (full file)
3. Read MyFirstModule/README.md (full file)
4. Read MyFirstModule/FLOWS.md (full file — 48 flows, ~3,000 lines)
5. Read every L0 abstract that mentions "registration"
6. Read every L1 overview for matched flows
7. Read DOMAIN.md (full file)
8. Read INTERPRETATION.md (full file)
9. Read routes/by-entity.md (full file — ~20KB)
10. Read routes/by-flow.md (full file — ~50KB)

That is 10+ file reads, potentially 100KB+ of text, when the answer might have been available after step 3.

## Entry Criteria

1. The KB agent workflow files exist.
2. The L0/L1/L2 layer structure is in place.

## Deliverable

### 1. Define reading depth levels in AI_WORKFLOW.md

Add a new section "Reading Depth Guide" to `AI_WORKFLOW.md`:

```markdown
## Reading Depth Guide

Match your reading depth to the question complexity. Start shallow, go deeper only if needed.

### Level 1: Quick Lookup (1-3 file reads)
**Use when:** The question is a simple lookup — "What module does entity X belong to?", "How many flows are in module Y?", "What roles exist?"
**Read:** ROUTING.md or `routes/keyword-index.md` → one target file → answer.
**Stop when:** You can cite a specific file and section that answers the question.

### Level 2: Feature Understanding (3-6 file reads)
**Use when:** The question asks about a capability — "How does registration work?", "What does module X do?"
**Read:** `routes/keyword-index.md` → module README (Capability Map, Primary User Journeys) → FLOWS.md (scan tier 1 flows only) → top 2-3 L0 abstracts → 1 L1 overview for the central flow.
**Stop when:** You can describe the feature in business terms and cite the key flows and entities involved.

### Level 3: Deep Investigation (6-12 file reads)
**Use when:** The question requires tracing, impact analysis, or development planning — "Trace flow X end-to-end", "What is affected if I change entity Y?", `/develop`.
**Read:** Everything in Level 2, plus: all related L1 overviews → DOMAIN.md → INTERPRETATION.md → routes/by-entity.md (for the relevant entities only, not the whole file) → routes/cross-module.md → app/SECURITY.md.
**Stop when:** You have traced all relevant chains, identified all affected artefacts, and can assess the blast radius.

### Level 4: Full Context (12+ file reads)
**Use when:** The `/develop` workflow is producing an implementation plan (Phases 4-6).
**Read:** Everything in Level 3, plus: all L1 overviews for affected flows → full DOMAIN.md for all affected modules → full SECURITY.md → all route files for cross-referencing.
**Stop when:** The implementation plan has no unresolved references.
```

### 2. Add stop signals to agent procedures

Update each interpretation agent to include explicit stop criteria:

**KB Navigator** — add:
```markdown
## Stop Signal
You have enough information when you can point the user to the specific KB file and section that answers their question. Do NOT read the file yourself unless the user explicitly asks for its content.
```

**KB Feature Interpreter** — add:
```markdown
## Stop Signal
You have enough information when you can describe the feature in business terms, list the key modules/flows/entities involved, and cite the files. Do NOT read every L1 overview — read only the top 1-2 central flows at L1 depth. Use L0 abstracts for triage.
```

**KB Flow Tracer** — add:
```markdown
## Stop Signal
You have enough information when the chain tree is complete (no unresolved calls) and you have cross-referenced entities and pages for the traced chain. Do NOT trace flows that are only tangentially related (e.g., utility sub-flows that are called by many chains).
```

**KB Analyst** — add:
```markdown
## Stop Signal
You have enough information when you can rate the blast radius (Small/Medium/Large) and list all directly affected artefacts. Do NOT trace secondary effects beyond one hop (e.g., if flow A calls flow B which calls flow C, and you are analysing a change to A, trace B but stop at C unless B is high-impact).
```

### 3. Add "partial reads" guidance

Add to `FRAMEWORK.md` or `AI_WORKFLOW.md`:

```markdown
## Partial File Reading

Not every file needs to be read in full. Use these strategies:

- **FLOWS.md**: Read the Tier 1 summary table first. Only read the full Flow Details section if a specific flow is relevant.
- **routes/by-flow.md** and **routes/by-entity.md**: Search for the specific entity/flow name rather than reading the entire file. These files can be 50KB+.
- **L0 abstracts**: Read 3-5 at a time for triage. Only promote to L1 reading for relevant matches.
- **DOMAIN.md**: Read the entity lifecycle matrix first. Only drill into individual entity sections for entities in scope.
- **ROUTING.md**: Read the quick-lookup table and module index. Skip the metadata section unless you need generation context.
```

### 4. Add reading depth to query pattern table

Update the "Common Query Patterns" table in `AI_WORKFLOW.md` to include a "Depth" column:

```markdown
| Query type | Start with | Then check | Depth |
|---|---|---|---|
| "What does module X do?" | `modules/X/README.md` | `DOMAIN.md`, `FLOWS.md` | Level 2 |
| "Which flows use entity Y?" | `routes/by-entity.md` | `modules/<module>/FLOWS.md` | Level 1 |
| "How does feature X work?" | `routes/keyword-index.md` | README, INTERPRETATION.md, L0/L1 | Level 2 |
| "Trace flow X" | `routes/by-flow.md` | L1, flow-chain-tracing | Level 3 |
| "What if I change X?" | `routes/by-flow.md` or `by-entity.md` | impact-analysis skill | Level 3 |
| `/develop` | `DEVELOPMENT_TEAM.md` | Full 6-phase workflow | Level 3-4 |
```

## Exit Criteria

1. AI_WORKFLOW.md has a "Reading Depth Guide" section with 4 levels.
2. Every interpretation agent has an explicit "Stop Signal" section.
3. The Common Query Patterns table includes a Depth column.
4. A bot answering "What module does Course belong to?" reads 1-2 files (Level 1), not 10.
5. A bot answering "How does registration work?" reads 3-6 files (Level 2), not 10+.

## Skills to Use

- Agent: **Developer** (agent file updates)
- Agent: **Documenter** (workflow documentation)

## Notes

- Reading budgets are guidance, not hard limits. If a Level 2 answer is insufficient, the bot should escalate to Level 3 and explain why.
- The partial reads guidance is especially important for `routes/by-flow.md`, which can be 50KB+ for large apps. A bot should search for specific keywords, not load the entire file.
- These changes do not require modifications to the KB Creator pipeline — they are purely agent workflow documentation changes.
