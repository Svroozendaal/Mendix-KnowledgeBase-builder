# SKILL: handoff

## Purpose

Standardised procedure for agent-to-agent hand-offs, ensuring consistent state transfer and session continuity. Use when any agent completes work and needs to pass context to the next agent or end a session.

## When to Use

- Any agent completes a task and the next agent needs context.
- An agent is blocked and needs to escalate with full state.
- A session ends and the final state must be recorded.
- The orchestrator sequences multiple agents and needs clean transitions.

## Procedure

1. **Determine status** — Classify the current state:
   - `COMPLETE` — work is done, no blockers.
   - `BLOCKED` — work cannot continue without resolution.
   - `NEEDS_INPUT` — a question or decision is required before proceeding.

2. **Identify next agent** — Based on the Agent Selection Logic in `.agents/AGENTS.md`, determine which agent should act next. If none, write `none`.

3. **Write the summary** — In 1–3 sentences, describe what was done, what the outcome is, and what the next agent needs to know.

4. **List blockers** — If status is `BLOCKED` or `NEEDS_INPUT`, describe the blocker precisely. If none, write `none`.

5. **Append the handoff block** to `.app-info/memory/SESSION_STATE.md`:

```markdown
## HANDOFF - [Agent Name] - [timestamp]
STATUS: COMPLETE | BLOCKED | NEEDS_INPUT
NEXT_AGENT: [Agent or none]
SUMMARY: [1-3 sentences]
BLOCKERS: [none or details]
```

6. **Verify** — Confirm the handoff block is written and the next agent has sufficient context to pick up work without re-reading the full session history.

## Output / Expected Result

A completed handoff block appended to `.app-info/memory/SESSION_STATE.md`. The receiving agent (or the orchestrator) can read the latest handoff and continue without ambiguity.

## Notes

- Every agent should use this skill at the end of its work, not just when handing off to another agent.
- If multiple handoffs occur in a session, each is appended chronologically — never overwrite previous handoffs.
- The Memory agent uses this skill's output as its primary input for session briefings.
