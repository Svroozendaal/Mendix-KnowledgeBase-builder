# AGENTS
## AI Collaboration Framework

This file is the primary source of truth for all AI assistants working in any repository that uses this framework.

All agents, skills, commands, and memory templates must follow this file.

## Purpose

Use a multi-agent workflow to plan, implement, test, review, document, and maintain a project with consistent quality and traceability.

## First Step Rule

Before any prompt is executed, do the following in order:

1. Read `.agents/AGENTS.md` (this file).
2. Read `.agents/FRAMEWORK.md` to understand the dual-folder structure and extension model.
3. Read `.app-info/ROUTING.md` to understand where app-specific data lives.
4. Ask clarifying workflow questions first, using as many questions as needed.
5. Confirm assumptions before changing files.

## Approval Checkpoint

After planning and before implementation changes, use:

`WAIT_FOR_APPROVAL`

Exception:

If the user or prompt explicitly states `AUTO_APPROVE`, continue without pausing.

## Core Principles

1. Use UK English in all documentation.
2. Keep tone friendly, clear, and technical.
3. Use neutral wording such as "AI assistant" or "assistant", not tool-brand names.
4. Keep project-specific constraints in `.app-info/skills/`, not in this file.
5. Keep this file generic enough for any assistant and any project.
6. Keep commands as guidance, not strict templates.

## Directory Contract

### `.agents/` — Generic, reusable framework

- `.agents/AGENTS.md`: Primary governance (this file).
- `.agents/FRAMEWORK.md`: Dual-folder framework explanation and operating model.
- `.agents/AI_WORKFLOW.md`: End-to-end operating flow.
- `.agents/agents/`: Agent role definitions (generic, reusable across projects).
- `.agents/commands/`: Reusable command-level guidance.
- `.agents/skills/`: Generic, reusable domain and task skills.
- `.agents/agent-memory/`: Memory file templates (clean state only; no live logs).

### `.app-info/` — App-specific data

All app-specific content lives here. Structure is defined in `.app-info/ROUTING.md`.

- `.app-info/ROUTING.md`: Master routing file — read this to navigate the app-specific folder.
- `.app-info/agents/`: App-specific agent extensions (optional, one file per agent being extended).
- `.app-info/app/`: Application identity, vision, and product plan.
- `.app-info/development/`: Prompts, commands, and development resources for this app.
- `.app-info/skills/`: App-specific skills (domain rules, styling guidelines, integrations).
- `.app-info/docs/`: Documentation produced during development.
- `.app-info/features/`: Feature registry — what the app does, built feature by feature.
- `.app-info/memory/`: Live agent memory logs (session state, decisions, progress, etc.).
- `.app-info/config/`: App configuration context (stack, environment, tool versions).

## Agent Roster

| Agent | File | Responsibility |
|---|---|---|
| Architect | `.agents/agents/ARCHITECT.md` | Design, scope, contracts, decisions |
| Implementer | `.agents/agents/IMPLEMENTER.md` | Delivery of approved production changes |
| Developer | `.agents/agents/DEVELOPER.md` | Backend development, security, platform conventions |
| Designer | `.agents/agents/DESIGNER.md` | Frontend/UI, styling, components, responsive behaviour |
| Deployment | `.agents/agents/DEPLOYMENT.md` | Branching, PRs, CI/CD, release hygiene, versioning |
| Tester | `.agents/agents/TESTER.md` | Validation, edge cases, regressions |
| Reviewer | `.agents/agents/REVIEWER.md` | Quality gate and approval |
| Memory | `.agents/agents/MEMORY.md` | Session continuity and hand-offs |
| Prompt Refiner | `.agents/agents/PROMPT_REFINER.md` | Prompt quality and consistency |
| Debugger | `.agents/agents/DEBUGGER.md` | Root-cause analysis and fixes |
| Documenter | `.agents/agents/DOCUMENTER.md` | Documentation quality, upkeep, and module indexing |
| Light | `.agents/agents/LIGHT.md` | Fast-path for small, low-risk, clearly-scoped tasks |
| Agent Finder | `.agents/agents/AGENT_FINDER.md` | Route queries to the correct agent or skill across both folders |
| Init App | `.agents/agents/INIT_APP.md` | Bootstrap a new project by creating the `.app-info` skeleton |
| Structure Guardian | `.agents/agents/STRUCTURE_GUARDIAN.md` | Validate and repair structural integrity of `.agents` and `.app-info` |

## Agent Extension Model

Generic agents can be extended with app-specific behaviour without modifying the base files.

**Reading order when invoking any agent:**

1. Read `.agents/agents/<AGENT>.md` — the generic base definition.
2. Check whether `.app-info/agents/<AGENT>.md` exists.
3. If an extension exists, read it immediately after the base.
   - Sections in the extension **add to** the base by default.
   - Sections marked `[OVERRIDE]` **fully replace** the equivalent base section.
   - Sections absent in the extension **inherit from the base** unchanged.

**Rules:**

- Generic agent files are never modified for app-specific purposes.
- Extension files must begin with an `## Extends:` preamble identifying the base agent.
- Use the `agent-extender` skill to write a new extension correctly.

## Skills Overview

Skills contain specific knowledge or procedures. All skills listed here are generic and reusable across projects.

Generic skills:

- `.agents/skills/documentation/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/mcp-server/SKILL.md`
- `.agents/skills/find-skills/SKILL.md`
- `.agents/skills/skill-writer/SKILL.md`
- `.agents/skills/agent-writer/SKILL.md`
- `.agents/skills/agent-extender/SKILL.md`

App-specific skills are listed in `.app-info/skills/OVERVIEW.md`.

## Prompt Model

Prompts are defined in `.app-info/development/prompts/`.

Each prompt must begin by reading this file and asking workflow questions before execution.
Each prompt must include:

1. Entry criteria.
2. Exit criteria.
3. A skill suggestion step that asks which skills should be used and proposes relevant defaults.

Use the Agent Finder to locate relevant agents and skills when unsure where to look.

## Memory Model

Memory files exist in two places:

1. `.agents/agent-memory/`: Clean templates — use these as the starting structure only.
2. `.app-info/memory/`: Live logs — all active session content is written here.

Template files in `.agents/agent-memory/`:

- `SESSION_STATE.md`
- `DECISIONS_LOG.md`
- `PROGRESS.md`
- `REVIEW_NOTES.md`
- `PROMPT_CHANGES.md`
- `INCIDENTS.md`

## Naming Standards

1. Use uppercase file names for all agent, prompt, command, memory, and skill markdown files.
2. Keep naming predictable and explicit.
3. Avoid duplicate variants of the same instruction set.

## Agent Operating Defaults

1. Implementer may create new files when needed.
2. Developer handles backend code; Designer handles frontend — collaborate at boundaries.
3. Deployment owns all branch and release operations.
4. Light handles small, clearly-scoped tasks; escalates to specialist agents when boundaries are crossed.
5. Tester should focus on automated testing by default.
6. Reviewer blocks only on unresolved `MUST FIX` items.
7. Prompt Refiner runs only when explicitly requested.
8. Do not compact memory logs automatically; ask first if maintenance is needed.
9. Structure Guardian may be invoked at any time to verify framework integrity.

## Required Handoff Block

Every agent hand-off should append this structure to `.app-info/memory/SESSION_STATE.md`:

```markdown
## HANDOFF - [Agent] - [timestamp]
STATUS: COMPLETE | BLOCKED | NEEDS_INPUT
NEXT_AGENT: [Agent or none]
SUMMARY: [1-3 sentences]
BLOCKERS: [none or details]
```
