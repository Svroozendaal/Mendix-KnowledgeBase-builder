# memory/
## Live Agent Memory

This folder contains all live agent memory logs for this application.

Templates for these files live in `.agents/agent-memory/`. The live content — actual session entries — lives here.

## Contents

| File | Purpose |
|---|---|
| `SESSION_STATE.md` | Current session scope, active agent, open blockers, and handoff log |
| `DECISIONS_LOG.md` | All architectural and implementation decisions with rationale |
| `PROGRESS.md` | Completed work entries per session |
| `REVIEW_NOTES.md` | Quality findings from the Reviewer agent |
| `PROMPT_CHANGES.md` | Record of all prompt edits and their compatibility impact |
| `INCIDENTS.md` | Incidents, root causes, and follow-up actions |

## Writing Rules

1. Never overwrite existing entries — always append.
2. Use the templates in `.agents/agent-memory/` for entry format.
3. Every agent hand-off must append a handoff block to `SESSION_STATE.md`.
4. Do not compact memory logs automatically — ask the user first.
