# PROMPT 08: Query Gap Feedback Loop

## Priority

Medium — creates a feedback mechanism so that gaps encountered during KB reading improve future KB generations.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/AI_WORKFLOW.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/AGENTS.md` (scope boundary section)

## Problem Statement

When a bot encounters a gap while reading the KB (missing entity tags, absent page-flow links, stubbed INTERPRETATION.md sections), it has no way to record this for future improvement. The bot notes the gap in its answer to the user, but that information is lost when the conversation ends.

The KB already has `_reports/UNKNOWN_TODO.md` with 64 known gaps from generation time. But gaps discovered during actual usage — the ones that blocked real questions — are never captured. This means:

1. The KB Creator team does not know which gaps actually matter to users.
2. Repeat queries hit the same gaps with no improvement.
3. The `/enrichkb` process has no signal for what to prioritise.

## Entry Criteria

1. The KB agent framework is functional.
2. The `_reports/` folder exists in the generated KB.

## Deliverable

### 1. New file: `_reports/QUERY_GAPS.md`

Create a query gap log that reading agents append to when they encounter a gap:

```markdown
# Query Gap Log

This file records gaps encountered during KB reading sessions. Use it to prioritise improvements for the next KB generation or `/enrichkb` run.

## How to Read

- **Severity**: `blocking` = could not answer the question; `degraded` = answered partially; `minor` = answered but with caveats.
- **Resolution**: what the bot did to work around the gap.
- **Priority**: number of times this gap has been logged (auto-incremented on duplicates).

## Gaps

| Date | Query (summary) | Gap Description | KB File | Severity | Resolution | Priority |
|---|---|---|---|---|---|---|
```

### 2. Update agent workflow to log gaps

Add to `AI_WORKFLOW.md` under "Definition of Done":

```markdown
6. If the answer required information not present in the KB, or if a KB file was missing expected content, append an entry to `_reports/QUERY_GAPS.md`.
   - Summarise the query (do not include full user messages).
   - Describe what was missing.
   - Note which KB file should have contained the information.
   - Rate severity: blocking, degraded, or minor.
   - Describe the resolution (e.g., "used L2 JSON", "reported gap to user", "inferred from flow names").
   - If the same gap already exists in the log, increment its priority count instead of adding a duplicate.
```

### 3. Update scope boundary

The current scope says "This KB is read-only except `/enrichkb`." The query gap log is a controlled exception:

Add to `.agents/AGENTS.md` scope boundary section:

```markdown
`_reports/QUERY_GAPS.md` is a second controlled write exception:
- Reading agents may append gap entries during KB interpretation sessions.
- Entries must follow the table format defined in the file header.
- Agents must not modify or delete existing entries.
- This file is advisory — it feeds into future KB improvement cycles.
```

### 4. Feed gaps into `/enrichkb`

Update `.agents/skills/enrichkb/SKILL.md` to include a step:

```markdown
Before starting enrichment, read `_reports/QUERY_GAPS.md` if it exists. Prioritise enriching modules and files that have blocking or degraded gaps logged against them. This ensures enrichment addresses real user needs rather than enriching uniformly.
```

### 5. Feed gaps into KB Creator quality gate

Update the quality gate process (in the KB Creator pipeline) to read `_reports/QUERY_GAPS.md` from the previous KB generation (if available) and include a section in the quality report:

```markdown
## User-Reported Gaps (from previous KB)

| Gap | Severity | Times Hit | Status |
|---|---|---|---|
| Missing entity tags in ACT_X flow | blocking | 3 | Fixed in this generation / Still present |
```

### 6. Initialise the file during compose

The compose step should create `_reports/QUERY_GAPS.md` with the header and an empty table. If a previous QUERY_GAPS.md exists (from a prior KB generation), carry over unresolved gaps.

## Exit Criteria

1. `_reports/QUERY_GAPS.md` is created during compose with the header template.
2. Reading agents append gap entries when they encounter missing or incomplete KB content.
3. The `/enrichkb` process reads the gap log to prioritise enrichment.
4. The quality gate reports user-discovered gaps alongside generation-time gaps.
5. Duplicate gaps are aggregated by incrementing the priority count.

## Skills to Use

- Agent: **Developer** (compose step, agent workflow updates)
- Agent: **Documenter** (file format, scope documentation)

## Notes

- The gap log is intentionally simple — a markdown table, not a database. It should survive being read and written by any LLM without special tooling.
- Query summaries should be generic ("How does registration work?") not verbatim user messages. This avoids storing potentially sensitive content.
- The priority count is the key metric: a gap hit 10 times is far more important than one hit once. This naturally prioritises the most impactful improvements.
- The gap log should not grow unbounded. During KB regeneration, resolved gaps should be removed and unresolved gaps carried over. Add a "Last regenerated" timestamp to track staleness.
- This is a lightweight version of a feedback loop. A more advanced version could include structured gap categories (entity-extraction, page-flow-link, flow-parameter, security-rule) for automated prioritisation.
