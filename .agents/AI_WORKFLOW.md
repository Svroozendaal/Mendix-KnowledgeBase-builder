# AI_WORKFLOW
## Standard Execution Flow for Any Assistant

Use this file with `.agents/AGENTS.md`.

## Workflow

1. Read `.agents/AGENTS.md`.
2. Read relevant skill files from `.agents/skills/`.
3. Ask clarifying questions first, using as many as needed.
4. Confirm scope and non-goals.
5. Ask which skills should be used and suggest relevant defaults.
6. Plan the work with clear ownership.
7. Pause at `WAIT_FOR_APPROVAL` before implementation changes.
8. Execute in small verifiable steps.
9. Record decisions and progress in `.agents/agent-memory/`.
10. Run tests and review checks.
11. Finalise documentation updates.
12. Write a final hand-off summary.

If `AUTO_APPROVE` is explicitly provided, skip step 7.

## Question-First Checklist

Ask before implementation:

1. What behaviour should be preserved exactly?
2. What may change without approval?
3. What is out of scope?
4. What acceptance criteria define done?
5. Which risks must be avoided first?

## Definition of Done

Work is done only when:

1. Requirements are implemented.
2. Tests and validations are complete.
3. Documentation is updated.
4. Memory logs reflect decisions and results.

## Note on Commands

Command documents in `.agents/commands/` are guidance, not strict templates.
