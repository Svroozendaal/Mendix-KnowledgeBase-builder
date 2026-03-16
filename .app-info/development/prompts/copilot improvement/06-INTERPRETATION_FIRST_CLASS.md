# PROMPT 06: INTERPRETATION.md as First-Class Citizen

## Priority

High — the AI narrative layer is what makes the KB genuinely useful for development guidance, but it is currently treated as an optional afterthought.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md` — current interpreter procedure
4. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md` — current orchestrator
5. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow
6. `KnowledgeBase-Creator/artifacts/.agents/skills/enrichkb/SKILL.md` — current enrichment skill
7. `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md` — current routing template
8. `KnowledgeBase-Creator/artifacts/templates/KNOWLEDGEBASE_READER.md` — current READER.md template
9. Generated KB example: `mendix-data/knowledge-base/modules/MyFirstModule/INTERPRETATION.md`

## Problem Statement

`INTERPRETATION.md` files contain business narratives — Module Purpose, Domain Narrative, Flow Narrative (grouped by intent), and Page Narrative. This is the exact content a bot needs to understand features.

However, the current workflow treats INTERPRETATION.md as optional enrichment:

1. **KB Feature Interpreter (step 7 of 8):** Checked last, after all technical files.
2. **READER.md template:** "Open `INTERPRETATION.md` only after the summary/evidence layers."
3. **Development Team workflow:** INTERPRETATION.md not referenced in any phase.
4. **ROUTING template:** INTERPRETATION.md not listed in quick-lookup table.

Result: a bot working through `/develop` never reads the richest source of business context.

## Entry Criteria

1. The compose step generates INTERPRETATION.md files (even as stubs before `/enrichkb`).
2. Agent artifact files exist in `KnowledgeBase-Creator/artifacts/.agents/`.

## Deliverable

### 1. Add "KB Maturity" indicator to routing template

In `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md`, add a metadata section:

```markdown
## KB Maturity

- **Base layer**: Export-backed content (DOMAIN.md, FLOWS.md, PAGES.md, routes). Always present.
- **Narrative layer**: AI-enriched interpretations (INTERPRETATION.md). Status: **{{EnrichedStatus}}**

If the narrative layer shows "Stub", run `/enrichkb` to add business context. Answers will be significantly more useful with the narrative layer populated.
```

In `KnowledgeBase-Creator/wizard/run-kb-compose.ps1`, add logic to determine `{{EnrichedStatus}}` by checking whether INTERPRETATION.md files contain more than template stubs. Set to `Enriched` or `Stub`.

### 2. Elevate INTERPRETATION.md in KB Feature Interpreter

In `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md`, move INTERPRETATION.md reading to step 3 (after module README, before drilling into flows):

```markdown
1. Parse the question. Extract feature keywords.
2. Invoke the `feature-search` skill (or read `routes/keyword-index.md`).
3. **Read module context.** For each candidate module:
   a. Read `modules/<Module>/README.md` — Capability Map and Primary User Journeys.
   b. Read `modules/<Module>/INTERPRETATION.md` — Module Purpose, Domain Narrative, Flow Narrative. If enriched, this gives you the business-level answer directly.
   c. If INTERPRETATION.md answers the question, you may stop at Level 2 depth.
4. Read flow-level detail only if INTERPRETATION.md is insufficient or stubbed.
   a. Read L0 abstracts for triage.
   b. Read L1 overviews for central flows.
5. Read entity-level detail (routes/by-entity.md, DOMAIN.md) for data model questions.
6. Synthesise the Feature Report.
```

### 3. Reference INTERPRETATION.md in Development Team

In `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`:

**Phase 1 (Story Mapping)** — add:
```markdown
   e. For each candidate module, read `INTERPRETATION.md` for business context. The Flow Narrative section groups flows by business intent — use this to understand how the story relates to existing capabilities.
```

**Phase 2 (High-Level Solution)** — add:
```markdown
   Reference `INTERPRETATION.md` Flow Narrative and Page Narrative when proposing where new functionality fits within the existing module structure.
```

### 4. Update READER.md template

In `KnowledgeBase-Creator/artifacts/templates/KNOWLEDGEBASE_READER.md`, change the guidance:

**Remove:** "For business interpretation, open `INTERPRETATION.md` only after the summary/evidence layers."

**Replace with:** "For behaviour questions: start with `INTERPRETATION.md` for business context, then trace technical detail through `FLOWS.md` → L0 → L1 if needed."

### 5. Add INTERPRETATION.md to routing template quick-lookup

In `KnowledgeBase-Creator/artifacts/templates/ROUTING_TEMPLATE.md`, add:

```markdown
| "What is the business purpose of module X?" | `modules/X/INTERPRETATION.md` | `modules/X/README.md` |
```

### 6. Add enrichment recommendation to QUICKSTART template

In `KnowledgeBase-Creator/artifacts/templates/QUICKSTART_TEMPLATE.md` (from Prompt 03), add a conditional section:

```markdown
{{#if IsStub}}
## Enrichment Recommended

The narrative layer (INTERPRETATION.md) has not been enriched yet. Run `/enrichkb` to add business context. Feature understanding, user story mapping, and development planning will be significantly more useful with enrichment.
{{/if}}
```

### 7. Add quality gate enrichment advisory

In `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`, add an advisory (not error) that reports:
- How many INTERPRETATION.md files are stubs vs enriched (custom modules only).
- Suggestion to run `/enrichkb` if >50% are stubs.

## Files Changed (all under `KnowledgeBase-Creator/`)

| File | Change |
|---|---|
| `artifacts/templates/ROUTING_TEMPLATE.md` | Add KB Maturity section, add INTERPRETATION.md to quick-lookup |
| `artifacts/templates/KNOWLEDGEBASE_READER.md` | Elevate INTERPRETATION.md reading order |
| `artifacts/templates/QUICKSTART_TEMPLATE.md` | Add conditional enrichment recommendation (depends on Prompt 03) |
| `artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md` | Move INTERPRETATION.md to step 3 |
| `artifacts/.agents/agents/DEVELOPMENT_TEAM.md` | Add INTERPRETATION.md references to Phases 1+2 |
| `artifacts/.agents/AI_WORKFLOW.md` | Update reading guidance |
| `wizard/run-kb-compose.ps1` | Add enrichment status detection |
| `wizard/run-kb-quality-gate.ps1` | Add enrichment advisory |

## Exit Criteria

1. INTERPRETATION.md is read early (step 3) in the KB Feature Interpreter procedure.
2. INTERPRETATION.md is referenced in the `/develop` workflow phases.
3. Generated ROUTING.md includes KB maturity status.
4. Generated READER.md no longer deprioritises INTERPRETATION.md.
5. All future KBs include these changes automatically.

## Skills to Use

- Agent: **Developer** (agent artifacts, compose script, quality gate)
- Agent: **Documenter** (template updates)

## Notes

- This prompt does NOT change how INTERPRETATION.md is generated or enriched — that is the domain of `/enrichkb`. This prompt changes how it is consumed by reading agents.
- For marketplace modules, INTERPRETATION.md may remain as stubs permanently. The maturity check should only count custom modules.
- Key insight: INTERPRETATION.md is the only file providing the "why" layer. Everything else is "what" or "how". For development guidance, "why" should come before "what".
