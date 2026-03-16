# PROMPT 08: Query Gap Feedback Loop

## Priority

Medium — creates a feedback mechanism so that gaps encountered during KB reading improve future KB generations.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow
4. `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md` — current scope boundary
5. `KnowledgeBase-Creator/artifacts/.agents/skills/enrichkb/SKILL.md` — current enrichment skill
6. `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` — compose script
7. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1` — quality gate script
8. Generated KB example: `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md`

## Problem Statement

When a bot encounters a gap while reading the KB (missing entity tags, absent page-flow links, stubbed INTERPRETATION.md), it notes the gap in its answer but that information is lost when the conversation ends.

The KB has `_reports/UNKNOWN_TODO.md` with known gaps from generation time, but gaps discovered during actual usage — the ones that blocked real questions — are never captured. This means the KB Creator team cannot prioritise fixes based on real user needs, and the `/enrichkb` process has no signal for what to enrich first.

## Entry Criteria

1. The KB agent framework files exist in `KnowledgeBase-Creator/artifacts/.agents/`.
2. The `_reports/` folder is created during scaffold.

## Deliverable

### 1. Create query gaps template

Create `KnowledgeBase-Creator/artifacts/templates/QUERY_GAPS_TEMPLATE.md`:

```markdown
# Query Gap Log

This file records gaps encountered during KB reading sessions. Use it to prioritise improvements for the next KB generation or `/enrichkb` run.

## How to Read

- **Severity**: `blocking` = could not answer the question; `degraded` = answered partially; `minor` = answered but with caveats.
- **Resolution**: what the bot did to work around the gap.
- **Priority**: number of times this gap has been logged (increment on duplicates).

## Gaps

| Date | Query (summary) | Gap Description | KB File | Severity | Resolution | Priority |
|---|---|---|---|---|---|---|
```

### 2. Add query gaps file creation to compose/scaffold

In `KnowledgeBase-Creator/wizard/run-kb-compose.ps1` (or `run-kb-scaffold.ps1`), add logic to:

1. Create `{KB}/_reports/QUERY_GAPS.md` from the template during scaffold/compose.
2. If a previous KB generation exists and contains `_reports/QUERY_GAPS.md` with entries, carry over unresolved gaps to the new file (gaps whose KB file still has the same issue).

### 3. Update agent workflow to log gaps

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, add under "Definition of Done":

```markdown
6. If the answer required information not present in the KB, or if a KB file was missing expected content, append an entry to `_reports/QUERY_GAPS.md`.
   - Summarise the query (do not include full user messages — keep generic).
   - Describe what was missing.
   - Note which KB file should have contained the information.
   - Rate severity: blocking, degraded, or minor.
   - Describe the resolution (e.g., "used L2 JSON", "reported gap to user", "inferred from flow names").
   - If the same gap already exists in the log, increment its priority count instead of adding a duplicate.
```

### 4. Update scope boundary

In `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`, add to the scope boundary section:

```markdown
`_reports/QUERY_GAPS.md` is a second controlled write exception:
- Reading agents may append gap entries during KB interpretation sessions.
- Entries must follow the table format defined in the file header.
- Agents must not modify or delete existing entries.
- This file is advisory — it feeds into future KB improvement cycles.
```

### 5. Feed gaps into `/enrichkb`

In `KnowledgeBase-Creator/artifacts/.agents/skills/enrichkb/SKILL.md`, add a step:

```markdown
Before starting enrichment, read `_reports/QUERY_GAPS.md` if it exists. Prioritise enriching modules and files that have blocking or degraded gaps logged against them. This ensures enrichment addresses real user needs rather than enriching uniformly.
```

### 6. Feed gaps into quality gate

In `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`, add logic to:

1. Read `_reports/QUERY_GAPS.md` from the previous KB generation (if available via `_sources/creator-link.json`).
2. Include a section in the quality report:

```markdown
## User-Reported Gaps (from previous KB)

| Gap | Severity | Times Hit | Status |
|---|---|---|---|
| Missing entity tags in ACT_X flow | blocking | 3 | Fixed / Still present |
```

3. Cross-reference each gap with the current KB content to determine if it has been resolved.

## Files Changed (all under `KnowledgeBase-Creator/`)

| File | Change |
|---|---|
| `artifacts/templates/QUERY_GAPS_TEMPLATE.md` | **New** — template for gap log |
| `artifacts/.agents/AI_WORKFLOW.md` | Add gap logging to Definition of Done |
| `artifacts/.agents/AGENTS.md` | Add QUERY_GAPS.md as controlled write exception |
| `artifacts/.agents/skills/enrichkb/SKILL.md` | Add gap prioritisation step |
| `wizard/run-kb-compose.ps1` or `wizard/run-kb-scaffold.ps1` | Create QUERY_GAPS.md from template, carry over unresolved gaps |
| `wizard/run-kb-quality-gate.ps1` | Report user-discovered gaps and resolution status |

## Exit Criteria

1. `_reports/QUERY_GAPS.md` is created during compose/scaffold for every KB.
2. Reading agents append gap entries when they encounter missing or incomplete KB content.
3. The `/enrichkb` process reads the gap log to prioritise enrichment.
4. The quality gate reports user-discovered gaps alongside generation-time gaps.
5. Unresolved gaps carry over across KB regenerations.

## Skills to Use

- Agent: **Developer** (compose script, quality gate, agent artifacts)
- Agent: **Documenter** (template, scope documentation)

## Notes

- The gap log is a markdown table — simple enough for any LLM to read and write without special tooling.
- Query summaries should be generic ("How does registration work?"), not verbatim user messages.
- The priority count is the key metric: a gap hit 10 times is far more important than one hit once.
- During KB regeneration, resolved gaps are removed and unresolved gaps carried over. Add a "Last regenerated" timestamp.
