# AI_WORKFLOW
## Standard Execution Flow for Any Assistant

Use this file with `.agents/AGENTS.md`.

## Workflow

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. For each agent you will use, check `.app-info/agents/` for an extension file. Read the base agent first, then the extension if it exists.
4. Read relevant generic skill files from `.agents/skills/`.
5. Read relevant app-specific skill files from `.app-info/skills/`.
6. Ask clarifying questions first, using as many as needed.
7. Confirm scope and non-goals.
8. Ask which skills should be used and suggest relevant defaults.
9. Plan the work with clear ownership.
10. Pause at `WAIT_FOR_APPROVAL` before implementation changes.
11. Execute in small verifiable steps.
12. Record decisions and progress in `.app-info/memory/`.
13. Run tests and review checks.
14. Finalise documentation updates.
15. Write a final hand-off summary.

If `AUTO_APPROVE` is explicitly provided, skip step 10.

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
4. Memory logs in `.app-info/memory/` reflect decisions and results.

## Note on Commands

Command documents in `.agents/commands/` are guidance, not strict templates.
App-specific command guidance lives in `.app-info/development/commands/`.
