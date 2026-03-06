# AI_WORKFLOW
## Standard Execution Flow for Any Assistant

Use this file with `.agents/AGENTS.md`.

## Workflow

1. Read `.agents/AGENTS.md` — including the Agent Selection Logic to determine which agent(s) to use.
2. Read `.agents/FRAMEWORK.md`.
3. For each agent you will use, check `.app-info/agents/` for an extension file. Read the base agent first, then the extension if it exists.
4. Read relevant generic skill files from `.agents/skills/`.
5. Read relevant app-specific skill files from `.app-info/skills/`.
6. If the task requires capabilities not covered by existing skills, use the `find-skills` skill to search for installable skills.
7. Ask clarifying questions first, using as many as needed.
8. Confirm scope and non-goals.
9. Plan the work with clear ownership.
10. Execute in small verifiable steps.
11. Record decisions and progress in `.app-info/memory/`.
12. Run tests and review checks.
13. Finalise documentation updates.
14. Write a final hand-off summary.

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
