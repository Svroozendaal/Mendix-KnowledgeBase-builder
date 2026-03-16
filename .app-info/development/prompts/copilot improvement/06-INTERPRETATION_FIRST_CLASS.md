# PROMPT 06: INTERPRETATION.md as First-Class Citizen

## Priority

High — the AI narrative layer is what makes the KB genuinely useful for development guidance, but it is currently treated as an optional afterthought.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/modules/MyFirstModule/INTERPRETATION.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FEATURE_INTERPRETER.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/AI_WORKFLOW.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/skills/enrichkb/SKILL.md`
7. Generated KB: `mendix-data/knowledge-base/READER.md`
8. Generated KB: `mendix-data/knowledge-base/ROUTING.md`

## Problem Statement

`INTERPRETATION.md` files contain the business narrative that transforms technical artefact listings into human-readable explanations of what a module does and why. They include Module Purpose, Domain Narrative, Flow Narrative (grouped by business intent), and Page Narrative — the exact content a bot needs to understand features.

However, the current workflow treats INTERPRETATION.md as optional enrichment:

1. **In KB Feature Interpreter (step 7 of 8):** "Check whether `INTERPRETATION.md` contains enriched content (not placeholder stubs). If enriched, scan..." — it is the last thing checked, after all technical files.
2. **In READER.md:** "For business interpretation, open `INTERPRETATION.md` only after the summary/evidence layers." — explicitly deprioritised.
3. **In the `/develop` workflow:** INTERPRETATION.md is not referenced at all in any phase.
4. **In ROUTING.md:** INTERPRETATION.md is not listed in the quick-lookup table.
5. **In QUICKSTART.md (Prompt 03):** Not mentioned in the reading depth guide.

The result: a bot working through the development workflow never reads the richest source of business context. It constructs feature understanding from technical tables (FLOWS.md, DOMAIN.md) when a pre-synthesised business narrative already exists.

## Entry Criteria

1. The KB Creator pipeline generates INTERPRETATION.md files (even if as stubs before `/enrichkb`).
2. The `/enrichkb` skill and compose step are functional.

## Deliverable

### 1. Add "KB Maturity" indicator to ROUTING.md and QUICKSTART.md

Add a metadata line to ROUTING.md header:

```markdown
## KB Maturity

- **Base layer**: Export-backed content (DOMAIN.md, FLOWS.md, PAGES.md, routes). Always present.
- **Narrative layer**: AI-enriched interpretations (INTERPRETATION.md). Status: **[Enriched / Stub]**

If the narrative layer shows "Stub", run `/enrichkb` to add business context. Answers will be significantly more useful with the narrative layer populated.
```

Generate this status during compose by checking whether INTERPRETATION.md files contain more than just template stubs.

### 2. Elevate INTERPRETATION.md in reading order

**Update KB Feature Interpreter procedure** — move INTERPRETATION.md to step 3 (after module README, before drilling into flows):

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

**Update READER.md** — change the guidance:

```markdown
- For behaviour questions: start with INTERPRETATION.md for business context, then trace technical detail through FLOWS.md → L0 → L1 if needed.
```

Remove the instruction "open `INTERPRETATION.md` only after the summary/evidence layers."

### 3. Reference INTERPRETATION.md in the `/develop` workflow

**Update DEVELOPMENT_TEAM.md Phase 1 (Story Mapping):**

After mapping the story to modules, add:

```markdown
   e. For each candidate module, read `INTERPRETATION.md` for business context. The Flow Narrative section groups flows by business intent — use this to understand how the story relates to existing capabilities.
```

**Update DEVELOPMENT_TEAM.md Phase 2 (High-Level Solution):**

Add:

```markdown
   Reference `INTERPRETATION.md` Flow Narrative and Page Narrative when proposing where new functionality fits within the existing module structure.
```

### 4. Add INTERPRETATION.md to ROUTING.md quick-lookup

Add a row:

```markdown
| "What is the business purpose of module X?" | `modules/X/INTERPRETATION.md` | `modules/X/README.md` |
```

### 5. Post-compose enrichment prompt

After the KB is generated, if INTERPRETATION.md files are stubs, display a recommendation:

```markdown
## Enrichment Recommended

The narrative layer (INTERPRETATION.md) has not been enriched yet. This KB contains export-backed technical data but lacks business narrative.

Run `/enrichkb` to add the AI narrative layer. This will:
- Describe each module's business purpose.
- Group flows by business intent.
- Explain page layouts in user journey context.
- Add domain model narrative with entity relationship explanations.

Answers about features, user stories, and development planning will be significantly more useful with enrichment.
```

Add this to the QUICKSTART.md template (from Prompt 03) as a conditional section.

### 6. Quality gate enrichment check

Add a quality gate **advisory** (not error) that reports:
- How many INTERPRETATION.md files are stubs vs enriched.
- Total word count of enriched narratives.
- Suggestion to run `/enrichkb` if >50% are stubs.

## Exit Criteria

1. INTERPRETATION.md is read early (step 3) in the KB Feature Interpreter procedure.
2. INTERPRETATION.md is referenced in the `/develop` workflow phases.
3. ROUTING.md and QUICKSTART.md include KB maturity status.
4. READER.md no longer deprioritises INTERPRETATION.md.
5. A bot answering "How does registration work?" checks INTERPRETATION.md before drilling into individual flow L0/L1 files.
6. The quality gate reports enrichment status.

## Skills to Use

- Agent: **Developer** (agent file updates, compose template changes)
- Agent: **Documenter** (workflow documentation)

## Notes

- This prompt does NOT change how INTERPRETATION.md is generated or enriched — that is the domain of `/enrichkb`. This prompt changes how it is consumed by reading agents.
- For marketplace modules, INTERPRETATION.md may remain as stubs permanently (they are reference-only). The maturity check should only count custom modules.
- The key insight: INTERPRETATION.md is the only file in the KB that provides the "why" layer. Everything else is "what" (entities, flows, pages) or "how" (L1 step details). For development guidance, "why" should come before "what".
