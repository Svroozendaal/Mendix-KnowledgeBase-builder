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

- Agent extensions (`agents/`) — optional, per-agent overrides and additions
- App identity and product vision (`app/`)
- Development prompts and commands (`development/`)
- App-specific skills and rules (`skills/`)
- Produced documentation (`docs/`)
- Feature registry (`features/`)
- Live agent memory logs (`memory/`)
- App configuration context (`config/`)

Navigate this folder using `.app-info/ROUTING.md`.

## Agent Extension Model

Generic agents in `.agents/agents/` can be extended without modification.

When invoking any agent:

1. Read the base agent at `.agents/agents/<AGENT>.md`.
2. Check if `.app-info/agents/<AGENT>.md` exists.
3. If it does, read it immediately after. The extension adds to or overrides the base:
   - Sections in the extension **add to** the base by default.
   - Sections marked `[OVERRIDE]` **fully replace** the equivalent base section.
   - Sections absent in the extension **inherit from the base** unchanged.

Use the `agent-extender` skill to write a new extension correctly.

## How the Two Folders Work Together

An AI assistant operating in this framework:

1. Reads `.agents/AGENTS.md` — learns the governance rules and agent roster.
2. Reads `.agents/FRAMEWORK.md` — understands the dual-folder and extension model (this file).
3. Reads `.app-info/ROUTING.md` — learns the structure of the app-specific content.
4. For each agent it will use, checks `.app-info/agents/` for an extension and reads both.
5. Follows the prompt or task using agents from `.agents/agents/` (extended by `.app-info/agents/` where present) and skills from both `.agents/skills/` and `.app-info/skills/`.
6. Writes results, decisions, and progress to `.app-info/memory/`.

## Example Workflow

> An AI is asked to work on Phase 8 of development.

1. Reads `.agents/AGENTS.md` and this file.
2. Reads `.app-info/ROUTING.md` → finds that prompts live in `.app-info/development/prompts/`.
3. Reads `.app-info/development/prompts/PHASE_8.md`.
4. The prompt mentions design, implementation, and testing steps.
5. Uses the **Agent Finder** to locate relevant agents: Architect, Implementer, Tester.
6. For each agent, checks `.app-info/agents/` — finds `ARCHITECT.md` has an extension; reads both.
7. Uses the **Agent Finder** to locate relevant skills from both folders.
8. Executes the work in small verifiable steps.
9. Writes progress and decisions to `.app-info/memory/`.
10. Updates `.app-info/features/` and `.app-info/docs/` with produced artefacts.
11. Appends a handoff block to `.app-info/memory/SESSION_STATE.md`.

## Setting Up a New Project

To reuse this framework in a new repository:

1. Copy the `.agents/` folder — no changes needed.
2. Copy the `.app-info/` skeleton (OVERVIEW.md and ROUTING.md files only) — do not copy live content.
3. Run the **Init App** agent (`.agents/agents/INIT_APP.md`) — it will ask questions and populate the skeleton.

## Integrity

Run the **Structure Guardian** (`.agents/agents/STRUCTURE_GUARDIAN.md`) at any time to:

- Verify `.agents/` contains only generic content.
- Verify `.app-info/` has the required structure.
- Verify agent extension files are correctly formed and have matching base agents.
- Verify AGENTS.md rosters and skill lists match the actual files present.
- Report and propose fixes for any discrepancies.
