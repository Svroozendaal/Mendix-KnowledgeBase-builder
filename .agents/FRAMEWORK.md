# FRAMEWORK
## Dual-Folder Operating Model

This file explains the operating model used by any repository that adopts the `.agents` framework.

Read this file immediately after `.agents/AGENTS.md` and before reading any prompt or executing any task.

## Overview

This framework separates concerns into two sibling folders:

| Folder | Purpose | Portability |
|---|---|---|
| `.agents/` | Generic, reusable framework | Copy unchanged to any new project |
| `.app-info/` | App-specific data and context | Copy the skeleton; fill in content per project |

## The `.agents/` Folder

Contains everything that is **generic and reusable across all projects**:

- Governance rules (`AGENTS.md`)
- This framework overview (`FRAMEWORK.md`)
- Operating workflow (`AI_WORKFLOW.md`)
- Agent role definitions (`agents/`)
- Generic skills (`skills/`)
- Reusable command guidance (`commands/`)
- Clean memory templates (`agent-memory/`)

**Rule:** `.agents/` must never contain app-specific content. If you find app-specific references here, invoke the Structure Guardian.

## The `.app-info/` Folder

Contains everything **specific to this application**:

- App identity and product vision (`app/`)
- Development prompts and commands (`development/`)
- App-specific skills and rules (`skills/`)
- Produced documentation (`docs/`)
- Feature registry (`features/`)
- Live agent memory logs (`memory/`)
- App configuration context (`config/`)

Navigate this folder using `.app-info/ROUTING.md`.

## How the Two Folders Work Together

An AI assistant operating in this framework:

1. Reads `.agents/AGENTS.md` — learns the governance rules and agent roster.
2. Reads `.agents/FRAMEWORK.md` — understands the dual-folder model (this file).
3. Reads `.app-info/ROUTING.md` — learns the structure of the app-specific content.
4. Follows the prompt or task using agents from `.agents/agents/` and skills from both `.agents/skills/` and `.app-info/skills/`.
5. Writes results, decisions, and progress to `.app-info/memory/`.

## Example Workflow

> An AI is asked to work on Phase 8 of development.

1. Reads `.agents/AGENTS.md` and this file.
2. Reads `.app-info/ROUTING.md` → finds that prompts live in `.app-info/development/prompts/`.
3. Reads `.app-info/development/prompts/PHASE_8.md`.
4. The prompt mentions design, implementation, and testing steps.
5. Uses the **Agent Finder** (`.agents/agents/AGENT_FINDER.md`) to locate relevant agents: Architect, Implementer, Tester.
6. Uses the **Agent Finder** to locate relevant skills from both folders.
7. Executes the work, pausing at `WAIT_FOR_APPROVAL` before changes.
8. Writes progress and decisions to `.app-info/memory/`.
9. Updates `.app-info/features/` and `.app-info/docs/` with produced artefacts.
10. Appends a handoff block to `.app-info/memory/SESSION_STATE.md`.

## Setting Up a New Project

To reuse this framework in a new repository:

1. Copy the `.agents/` folder — no changes needed.
2. Copy the `.app-info/` skeleton (empty OVERVIEW.md and ROUTING.md files) — do not copy live content.
3. Run the **Init App** agent (`.agents/agents/INIT_APP.md`) — it will ask questions and populate the skeleton.

## Integrity

Run the **Structure Guardian** (`.agents/agents/STRUCTURE_GUARDIAN.md`) at any time to:

- Verify `.agents/` contains only generic content.
- Verify `.app-info/` has the required structure.
- Verify AGENTS.md rosters and skill lists match the actual files present.
- Report and propose fixes for any discrepancies.
