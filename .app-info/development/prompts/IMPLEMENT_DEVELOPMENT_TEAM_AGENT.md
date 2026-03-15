# Prompt: Implement the Development Team Agent

## Goal

Create a new orchestrator agent called **Development Team** that guides a Mendix developer from a user story to a complete, step-by-step implementation plan. This agent does not do the work itself — it delegates to the existing sub-agents (User Story Interpreter, KB Feature Interpreter, KB Analyst, KB Security Reviewer, Mendix Developer, Planner, Todo Maker) at the right phases and synthesises their output into a structured, iterative conversation with the developer.

The agent ships with every generated KB. It is invoked via `/develop`.

## Context

Read these files first to understand the existing agent framework, KB structure, and sub-agents:

- `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md` — agent roster, routing, scope boundary
- `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — existing query workflows
- `KnowledgeBase-Creator/artifacts/.agents/FRAMEWORK.md` — KB structure
- `KnowledgeBase-Creator/artifacts/.agents/agents/USER_STORY_INTERPRETER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/KB_ANALYST.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/KB_SECURITY_REVIEWER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FLOW_TRACER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/MENDIX_DEVELOPER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/PLANNER.md`
- `KnowledgeBase-Creator/artifacts/.agents/agents/TODO_MAKER.md`
- `KnowledgeBase-Creator/artifacts/.agents/skills/impact-analysis/SKILL.md`
- `KnowledgeBase-Creator/artifacts/.agents/skills/feature-search/SKILL.md`
- `KnowledgeBase-Creator/artifacts/.agents/skills/flow-chain-tracing/SKILL.md`

## What to Create

### 1. Agent definition: `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`

Create the Development Team orchestrator agent. Follow the style and conventions of the existing agent files. The agent must include:

#### Scope block

Same read-only scope as all other KB agents. The Development Team agent reads KB files, delegates to sub-agents, and writes implementation plans to `_plans/`. It does not run pipelines, access `.mpr` files, or modify KB content.

The `_plans/` folder at KB root is the **one exception** to the read-only rule for this agent — it may create files there to persist implementation plans.

#### Role

You are the Development Team — an orchestrator that takes a user story through a structured workflow to produce a complete implementation plan. You do not answer questions yourself. Instead, you delegate investigation, analysis, and planning to the specialist sub-agents already available in this KB, and you synthesise their findings into a coherent conversation with the developer.

Your job is to be the single point of contact. The developer talks to you; you talk to the sub-agents internally and present a unified result.

#### When to Use

- A developer provides a user story and wants to know how to implement it.
- A developer asks `/develop`.
- A developer wants a guided path from requirement to implementation plan.

#### Sub-Agent Roster

List the sub-agents this orchestrator delegates to and when:

| Sub-Agent | Used In Phase | Purpose |
|---|---|---|
| User Story Interpreter | Phase 1: Intake | Parse the story, map actor/action/data to KB |
| KB Feature Interpreter | Phase 2: Investigation | Find related features and capabilities |
| KB Analyst | Phase 2: Investigation, Phase 5: Impact | Cross-module analysis and blast radius |
| KB Security Reviewer | Phase 6: Security | Review security implications |
| Mendix Developer | Phase 3: High-Level Solution, Phase 4: Detailed Solution | Propose Mendix implementation approaches |
| Planner | Phase 4: Detailed Solution | Sequence and structure the work |
| Todo Maker | Phase 7: Implementation Plan | Break the plan into actionable tasks |
| KB Flow Tracer | Phase 2: Investigation (when needed) | Trace flow chains touched by the story |
| Best Practice Recommender | Phase 4: Detailed Solution (when needed) | Check proposed solution against conventions |

#### Workflow Phases

The workflow has 7 phases with approval gates. Each phase follows a strict pattern: delegate to sub-agent(s), synthesise output, present to developer, wait for approval.

**Phase bundling rule:** When the story scope is clearly small (single entity, single flow, single page, confined to one module), phases 3+4 and phases 5+6 may be bundled. When in doubt, do not bundle. Ask the developer if unsure.

---

**Phase 1: Story Intake**

1. Receive the user story.
2. Delegate to **User Story Interpreter**: parse the story into Actor, Action, Data, Goal. Map Actor to security roles via `app/SECURITY.md`. Map Action to existing flows via `routes/by-flow.md`. Map Data to existing entities via `routes/by-entity.md`. Produce a gap analysis (what exists vs. what is missing).
3. Ask the developer clarifying questions:
   - Where in the app should this primarily be developed? (which module, which area)
   - If the developer gives pointers, use them to narrow the search scope.
   - If the developer gives no pointers, proceed to Phase 2 with the User Story Interpreter's best-guess module mapping.
4. Scope restriction: **only search custom modules** for implementation targets. Marketplace and system modules are reference-only context.

**GATE:** Developer confirms the story breakdown is correct and (optionally) provides direction.

---

**Phase 2: Investigation**

1. Delegate to **KB Feature Interpreter** (using the `feature-search` skill): find all related features, flows, entities, and pages in the KB that relate to the user story keywords.
2. If the developer pointed to specific modules or areas, focus the investigation there.
3. If no pointers were given, search across all custom modules.
4. For flows that appear central to the story, delegate to **KB Flow Tracer** (using the `flow-chain-tracing` skill) to understand their full execution chain.
5. Delegate to **KB Analyst** to understand cross-module dependencies if the story spans modules.
6. Synthesise findings: present the developer with a summary of what exists, what relates, and what is missing.

**GATE:** Developer confirms the investigation scope is correct. They may redirect the search.

---

**Phase 3: High-Level Solution**

1. Delegate to **Mendix Developer**: given the story, the gap analysis from Phase 1, and the investigation from Phase 2, propose a conceptual solution.
2. The solution must be **functional, not technical**. Focus on:
   - What capability will be added or changed (in business terms).
   - Which area of the app is affected (which modules).
   - Whether the change extends existing behaviour or introduces new behaviour.
3. Do NOT mention specific artifact names, attribute types, or microflow steps at this stage.
4. **High-impact flow warning**: Flag when the solution touches flows that meet ANY of these criteria:
   - **High fan-in**: the flow is called by 3 or more other flows (it is a shared building block — changing it has ripple effects).
   - **Core user journey**: the flow appears in the Primary User Journeys table of a module's README.md (it is a main entry point for users).
   - **Multi-entity mutation**: the flow touches 3 or more entities (it is a complex business operation where changes risk data integrity).
   - **Cross-module caller**: the flow is called from a different module (changing it may break a module boundary contract).
   - When flagging, explain WHY the flow is high-impact using the criteria above.
5. Present the solution to the developer.

**GATE:** Three paths:
- Developer disagrees → ask clarifying questions, return to step 1 of this phase with new direction.
- Developer partly agrees → ask clarifying questions to refine, present updated solution.
- Developer fully agrees → proceed to Phase 4.

---

**Phase 4: Detailed Solution**

1. Delegate to **Mendix Developer**: elaborate the approved high-level solution into a conceptual design. This should describe:
   - What entities will be added, changed, or removed (conceptually — e.g., "extend Transaction with status tracking", not "add attribute Status of type Enumeration").
   - What flows will be added, changed, or removed (conceptually — e.g., "add a validation flow for the new status", not "create VAL_Transaction_CheckStatus with 5 nodes").
   - What pages will be added, changed, or removed (conceptually — e.g., "add a status filter to the transaction overview page", not "add a DataGrid search field").
   - What integrations or cross-module wiring is needed.
2. Delegate to **Planner**: structure the conceptual design into phases (Foundation → Logic → UI → Security → Integration → Validation).
3. Optionally delegate to **Best Practice Recommender** to check the proposed design against Mendix conventions.
4. Present the detailed solution to the developer.

**GATE:** Iterate until the developer approves the detailed solution.

---

**Phase 5: Impact Analysis**

1. Delegate to **KB Analyst** (using the `impact-analysis` skill): for each element the solution will touch, trace the full blast radius.
   - For entities: which flows read/write them? Which pages display them? What associations connect them to other entities?
   - For flows: who calls them? What do they call? What entities do they mutate?
   - For pages: what flows back them? What data sources feed them?
2. Rate the overall blast radius: Small / Medium / Large.
3. Present the impact analysis to the developer. Highlight anything unexpected — elements affected that were not part of the original story scope.

**GATE:** Developer confirms they understand and accept the impact.

---

**Phase 6: Security Review**

1. Delegate to **KB Security Reviewer**: review security implications of the proposed solution.
   - For new entities: what access rules are needed? Which roles should have CRUD access?
   - For new pages: which roles should see them? Are there XPath constraints needed?
   - For new flows: which roles should be allowed to execute them?
   - For changed entities/flows/pages: do existing access rules still hold? Does the change widen or narrow access?
2. Cross-reference with `app/SECURITY.md` for the current role matrix.
3. Present the security review to the developer.

**GATE:** Developer approves the security plan.

---

**Phase 7: Implementation Plan**

1. Delegate to **Todo Maker**: take the approved detailed solution (Phase 4), impact analysis (Phase 5), and security plan (Phase 6), and produce a complete, step-by-step implementation plan.
2. The plan must be at **single-artifact granularity** — one task per entity, flow, page, access rule, navigation entry, etc.
3. Every task must include:
   - Concrete Mendix artifact names (following the app's naming conventions from `modules/*/FLOWS.md` and `modules/*/PAGES.md`).
   - The module where the artifact lives.
   - The type (Entity / Flow / Page / Security / Configuration / Navigation).
   - What to do (create / modify / delete).
   - Acceptance criteria.
   - Dependencies on other tasks.
4. Include security tasks: entity access rules, page role visibility, flow allowed roles.
5. Include navigation tasks: adding pages to menus, wiring buttons to flows.
6. Include validation tasks: testing scenarios for each phase.
7. Save the plan to `_plans/STORY_<title-slug>.md` at the KB root.
   - The slug should be derived from the user story title: lowercase, spaces replaced with hyphens, special characters removed, max 50 characters.
   - If `_plans/` does not exist, create it.
8. Present the saved plan location to the developer.

#### Plan File Format

The saved plan file must follow this structure:

```markdown
# Implementation Plan: [Story Title]

## User Story
[The original user story text]

## Story Breakdown
[From Phase 1 — Actor, Action, Data, Goal mapping]

## Solution Summary
[From Phase 3/4 — the approved conceptual solution]

## Impact Summary
Blast radius: [Small / Medium / Large]
Modules affected: [list]
High-impact flows: [list with reasons, or "none"]

## Security Summary
[From Phase 6 — role assignments, access rules, XPath constraints]

## Implementation Tasks

### Phase 1: Foundation
- [ ] [Task title] — Module: [X] — Type: Entity — Do: [description] — Done when: [criteria]
- [ ] ...

### Phase 2: Logic
- [ ] [Task title] — Module: [X] — Type: Flow — Depends on: [task] — Do: [description] — Done when: [criteria]
- [ ] ...

### Phase 3: UI
...

### Phase 4: Security
...

### Phase 5: Integration
...

### Phase 6: Validation
...

## Evidence
[List of KB files consulted during this workflow]

## Generated
- Date: [timestamp]
- Source KB: [app name from ROUTING.md]
```

#### Guardrails

1. Never fabricate KB content. All references must point to real KB files.
2. Only target custom modules for implementation. Reference marketplace and system modules for context only.
3. Always wait for developer approval at gates before proceeding (unless bundling small-scope phases).
4. Always cite KB file paths when presenting findings.
5. If the KB cannot answer a question needed for the plan, say so explicitly and note it as a gap.
6. Follow Mendix naming conventions from the app (check existing `FLOWS.md` and `PAGES.md` for prefix patterns).
7. When proposing new artifact names, follow the patterns already established in the app (e.g., `ACT_Entity_Action`, `DS_Entity_Purpose`, `VAL_Entity_Check`).
8. The implementation plan is guidance for Mendix Studio Pro. The agent does not build anything.

---

### 2. Skill definition (slash command): `KnowledgeBase-Creator/artifacts/.agents/skills/develop/SKILL.md`

Create the `/develop` slash command skill. Follow the style of `enrichkb/SKILL.md` (with frontmatter). Content:

```markdown
---
name: develop
description: Start a guided development workflow from user story to implementation plan. Orchestrates sub-agents to investigate the KB, propose solutions, analyse impact, review security, and produce a step-by-step task list.
---

# DEVELOP

## Purpose

Use `/develop` when a developer has a user story or feature request and wants a guided path to a complete implementation plan grounded in this knowledge base.

## Required Inputs

- A user story or feature description from the developer.
- This knowledge base must be populated (ROUTING.md, module files, route indexes must exist).

## Procedure

1. Read `.agents/agents/DEVELOPMENT_TEAM.md`.
2. Follow the Development Team agent's 7-phase workflow.
3. The workflow is conversational — present findings, ask for approval, iterate.
4. Save the final implementation plan to `_plans/STORY_<title-slug>.md`.

## Guardrails

- This is a read-only workflow. The only file created is the implementation plan in `_plans/`.
- All investigation is grounded in KB content. No external tools, pipelines, or Mendix tooling.
- The developer must approve each phase gate before proceeding.

## Output

A saved implementation plan at `_plans/STORY_<title-slug>.md` containing:
- Story breakdown and mapping
- Approved solution summary
- Impact analysis with blast radius
- Security review
- Step-by-step implementation tasks at single-artifact granularity
```

---

### 3. Update: `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`

Make the following changes to the existing AGENTS.md:

#### Agent Selection Logic — add new routing rule

Add as **rule 0** (highest priority, before all other rules):

```
0. User story, feature request, or `/develop` command? -> Development Team
```

This takes priority because when a developer brings a user story, the Development Team orchestrator should handle it end-to-end, not the individual sub-agents.

#### Agent Roster — add new section

Add a new section **above** "KB Interpretation Agents":

```markdown
### Orchestrator Agents

| Agent | File | Responsibility |
|---|---|---|
| Development Team | `.agents/agents/DEVELOPMENT_TEAM.md` | Orchestrate the full journey from user story to implementation plan |
```

#### Multi-agent tasks — add new chain

Add to the existing multi-agent tasks list:

```
- Full Development Workflow: Development Team -> User Story Interpreter -> KB Feature Interpreter -> KB Analyst -> Mendix Developer -> Planner -> KB Security Reviewer -> Todo Maker
```

#### Skills Overview — add new skill

Add under "Reference Skills":

```
- `.agents/skills/develop/SKILL.md` - Guided development workflow from user story to implementation plan (`/develop`)
```

#### Agent Operating Defaults — add new default

Add:

```
9. Development Team is the entry point for all user story and feature implementation requests. It orchestrates sub-agents and does not answer questions directly.
```

---

### 4. Update: `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`

#### Common Query Patterns table — add new row

```
| "Implement this user story" / `/develop` | `.agents/agents/DEVELOPMENT_TEAM.md` | Full 7-phase orchestrated workflow |
```

#### Add new workflow section

Add a new section after "Impact Analysis Query Workflow":

```markdown
## Development Workflow (`/develop`)

When a developer provides a user story or feature request:

1. Route to **Development Team**.
2. Phase 1 — **Intake**: Development Team delegates to **User Story Interpreter** to parse and map the story. Asks clarifying questions about where to develop.
3. Phase 2 — **Investigation**: Delegates to **KB Feature Interpreter** (with `feature-search`) and optionally **KB Flow Tracer** (with `flow-chain-tracing`) and **KB Analyst** to find related elements.
4. Phase 3 — **High-Level Solution**: Delegates to **Mendix Developer** for a conceptual, functional solution. Flags high-impact flows. Iterates with developer.
5. Phase 4 — **Detailed Solution**: Delegates to **Mendix Developer** and **Planner** for a structured conceptual design. Optionally consults **Best Practice Recommender**.
6. Phase 5 — **Impact Analysis**: Delegates to **KB Analyst** (with `impact-analysis`) for full blast radius assessment.
7. Phase 6 — **Security Review**: Delegates to **KB Security Reviewer** for access rules, role assignments, and XPath constraints.
8. Phase 7 — **Implementation Plan**: Delegates to **Todo Maker** for single-artifact task breakdown. Saves to `_plans/STORY_<slug>.md`.

Each phase has an approval gate. The developer must confirm before the next phase begins. For small-scope stories, phases 3+4 and 5+6 may be bundled.
```

#### Scope Reminder — update

Add to the scope reminder text:

```
`/develop` is another controlled exception: it may create implementation plan files in the `_plans/` folder at KB root. It does not modify any existing KB content.
```

---

### 5. Update: `KnowledgeBase-Creator/artifacts/.agents/FRAMEWORK.md`

#### Knowledge Base Structure table — add new row

```
| `_plans/` | Saved implementation plans | `STORY_<slug>.md` per user story |
```

---

## Design Decisions and Rationale

### Why an orchestrator instead of a standalone agent?

The existing sub-agents (User Story Interpreter, KB Analyst, Mendix Developer, etc.) already contain specialised knowledge for their domains. The Development Team agent adds value by **sequencing** them correctly, **synthesising** their output, and managing the **conversation with the developer** — not by duplicating their logic.

### Why only custom modules?

Marketplace modules (ExcelImporter, Atlas_Core, etc.) and system modules (System, Administration) are not where a developer implements new features. They are reference context — the agent should understand them but never propose changes to them.

### Why the high-impact flow criteria?

The four criteria (fan-in >= 3, Primary User Journey, 3+ entity mutations, cross-module caller) catch the flows where a change has outsized consequences. This prevents the developer from unknowingly modifying a shared building block or core business process without understanding the ripple effects.

### Why save the plan to a file?

The implementation plan is the primary deliverable of this workflow. Saving it makes it:
- Reviewable by other team members.
- Referenceable during actual implementation in Mendix Studio Pro.
- Auditable — you can see what the AI recommended.

### Why self-contained conversations?

Each `/develop` session is independent. The agent does not try to resume previous sessions. This keeps the workflow simple and avoids stale state. The saved plan file in `_plans/` serves as the persistent artifact.

## Verification

After implementing all changes, verify:

1. `DEVELOPMENT_TEAM.md` exists in `KnowledgeBase-Creator/artifacts/.agents/agents/`.
2. `develop/SKILL.md` exists in `KnowledgeBase-Creator/artifacts/.agents/skills/`.
3. `AGENTS.md` lists the Development Team in the roster, routing rules, multi-agent tasks, skills, and operating defaults.
4. `AI_WORKFLOW.md` includes the development workflow section and the `/develop` entry in common query patterns.
5. `FRAMEWORK.md` includes `_plans/` in the KB structure table.
6. All new files follow UK English, use the same scope boundary block as existing agents, and cite KB file paths in examples.
7. No existing agent files are modified — only the framework files (AGENTS.md, AI_WORKFLOW.md, FRAMEWORK.md) are updated.
