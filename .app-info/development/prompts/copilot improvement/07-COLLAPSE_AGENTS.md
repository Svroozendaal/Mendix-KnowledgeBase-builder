# PROMPT 07: Collapse Interpretation Agents into Skills

## Priority

Medium — reduces persona-switching overhead and simplifies the agent roster without losing functionality.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md` — current KB agent governance
4. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_NAVIGATOR.md`
5. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md`
6. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FLOW_TRACER.md`
7. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_ANALYST.md`
8. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_DOMAIN_EXPERT.md`
9. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_SECURITY_REVIEWER.md`
10. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_UX_INTERPRETER.md`
11. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`

## Problem Statement

The KB defines 7 interpretation agents (Navigator, Feature Interpreter, Flow Tracer, Analyst, Domain Expert, Security Reviewer, UX Interpreter) plus 6 development agents. That is 13 agent personas handled by a single LLM conversation.

In practice, "delegating to the KB Feature Interpreter" means the LLM reads ~100 lines of persona definition, adopts the persona, reads the same KB files it would have read anyway, produces output in that persona's format, then "hands off" back. The persona-switching overhead adds tokens without changing the reasoning.

The 7 interpretation agents differ primarily in what files they read, what output format they produce, and what escalation rules they follow. These are characteristics of **skills**, not agents.

## Entry Criteria

1. The KB agent framework files exist in `KnowledgeBase-Creator/artifacts/.agents/`.
2. Prompts 04 (Merge Phases) and 05 (Reading Budgets) are implemented.

## Deliverable

### 1. Create KB Reader agent (replaces KB Navigator)

Create `KnowledgeBase-Creator/artifacts/.agents/agents/KB_READER.md`:

```markdown
# KB_READER
## Knowledge Base Interpretation Agent

> **Scope:** This agent operates exclusively on the pre-built knowledge base files. It does not run pipelines, access `.mpr` files, call Mendix tooling, or modify any KB content.

## Role

You are the KB Reader — the single agent responsible for reading and interpreting this knowledge base. You answer questions about the application by navigating the KB structure and invoking specialised skills when deeper analysis is needed.

## When to Use

Any question about the application that does not require implementation planning (`/develop`).

## Skills Available

| Skill | File | Use When |
|---|---|---|
| feature-search | `.agents/skills/feature-search/SKILL.md` | Locating KB files from keywords |
| feature-interpretation | `.agents/skills/feature-interpretation/SKILL.md` | Synthesising business-feature-level answers |
| flow-chain-tracing | `.agents/skills/flow-chain-tracing/SKILL.md` | Tracing flow execution chains |
| impact-analysis | `.agents/skills/impact-analysis/SKILL.md` | Assessing blast radius of changes |
| domain-analysis | `.agents/skills/domain-analysis/SKILL.md` | Entity relationships and data lifecycle |
| security-analysis | `.agents/skills/security-analysis/SKILL.md` | Role analysis, access rules, XPath constraints |
| ux-analysis | `.agents/skills/ux-analysis/SKILL.md` | Page structure, UI flows, user journeys |

## Operating Procedure

1. Classify the question using the routing table below.
2. Follow the appropriate reading depth (Level 1-4 from AI_WORKFLOW.md).
3. Invoke the relevant skill if the question requires specialised analysis.
4. Synthesise the answer, citing KB files.

## Routing Table

| Question type | Skill to invoke | Reading depth |
|---|---|---|
| Simple lookup | None — direct KB navigation | Level 1 |
| "How does X work?" | feature-interpretation | Level 2 |
| "Trace flow X" | flow-chain-tracing | Level 3 |
| "What if I change X?" | impact-analysis | Level 3 |
| Security question | security-analysis | Level 2-3 |
| Data model question | domain-analysis | Level 2 |
| Page/UI question | ux-analysis | Level 2 |

## Stop Signal
You have enough information when you can answer the question with specific KB file citations. Start at the lowest reading depth and escalate only if needed.
```

### 2. Convert 5 interpretation agents into skills

Extract the **Operating Procedure** and **Output Format** from each agent file into a new skill file. Remove persona preambles, scope reminders, and escalation sections.

Create these new skill files under `KnowledgeBase-Creator/artifacts/.agents/skills/`:

| New Skill | Source Agent | Location |
|---|---|---|
| `skills/feature-interpretation/SKILL.md` | `agents/KB_FEATURE_INTERPRETER.md` | Extract procedure steps 1-8 and output format |
| `skills/domain-analysis/SKILL.md` | `agents/KB_DOMAIN_EXPERT.md` | Extract entity analysis procedure and output format |
| `skills/security-analysis/SKILL.md` | `agents/KB_SECURITY_REVIEWER.md` | Extract security review procedure and output format |
| `skills/ux-analysis/SKILL.md` | `agents/KB_UX_INTERPRETER.md` | Extract page/UI analysis procedure and output format |

Note: `flow-chain-tracing` and `impact-analysis` skills already exist. KB_FLOW_TRACER and KB_ANALYST are already thin wrappers around these skills — just remove the agent wrappers.

### 3. Delete replaced agent files

Remove from `KnowledgeBase-Creator/artifacts/.agents/agents/`:
- `KB_NAVIGATOR.md` (replaced by `KB_READER.md`)
- `KB_FEATURE_INTERPRETER.md` (replaced by `skills/feature-interpretation/SKILL.md`)
- `KB_FLOW_TRACER.md` (replaced by `skills/flow-chain-tracing/SKILL.md` — already exists)
- `KB_ANALYST.md` (replaced by `skills/impact-analysis/SKILL.md` — already exists)
- `KB_DOMAIN_EXPERT.md` (replaced by `skills/domain-analysis/SKILL.md`)
- `KB_SECURITY_REVIEWER.md` (replaced by `skills/security-analysis/SKILL.md`)
- `KB_UX_INTERPRETER.md` (replaced by `skills/ux-analysis/SKILL.md`)

### 4. Update AGENTS.md roster

In `KnowledgeBase-Creator/artifacts/.agents/AGENTS.md`:

**Agent Roster — replace 7 interpretation rows with 1:**

```markdown
### KB Interpretation

| Agent | File | Responsibility |
|---|---|---|
| KB Reader | `.agents/agents/KB_READER.md` | Read and interpret the KB, invoke skills for specialised analysis |
```

**Skills Overview — add new skills:**

```markdown
### Analysis Skills (invoked by KB Reader)

- `.agents/skills/feature-interpretation/SKILL.md` — synthesise feature-level answers
- `.agents/skills/domain-analysis/SKILL.md` — entity relationships and data lifecycle
- `.agents/skills/security-analysis/SKILL.md` — role analysis, access rules, XPath constraints
- `.agents/skills/ux-analysis/SKILL.md` — page structure, UI flows, user journeys
```

**Agent Selection Logic — simplify routing:**

Replace the 7 interpretation routing rules with:
```markdown
1. Any question about the application? → KB Reader
```

### 5. Update DEVELOPMENT_TEAM.md references

In `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`, replace sub-agent references:

| Old Reference | New Reference |
|---|---|
| "Delegate to KB Feature Interpreter" | "KB Reader invokes `feature-interpretation` skill" |
| "Delegate to KB Flow Tracer" | "KB Reader invokes `flow-chain-tracing` skill" |
| "Delegate to KB Analyst" | "KB Reader invokes `impact-analysis` skill" |
| "Delegate to KB Security Reviewer" | "KB Reader invokes `security-analysis` skill" |

### 6. Update AI_WORKFLOW.md

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, simplify agent routing. Replace 7+ interpretation routing rules with "KB Reader" as the single interpretation entry point.

## Files Changed (all under `KnowledgeBase-Creator/artifacts/.agents/`)

| File | Change |
|---|---|
| `agents/KB_READER.md` | **New** — single interpretation agent |
| `skills/feature-interpretation/SKILL.md` | **New** — extracted from KB_FEATURE_INTERPRETER.md |
| `skills/domain-analysis/SKILL.md` | **New** — extracted from KB_DOMAIN_EXPERT.md |
| `skills/security-analysis/SKILL.md` | **New** — extracted from KB_SECURITY_REVIEWER.md |
| `skills/ux-analysis/SKILL.md` | **New** — extracted from KB_UX_INTERPRETER.md |
| `agents/KB_NAVIGATOR.md` | **Delete** |
| `agents/KB_FEATURE_INTERPRETER.md` | **Delete** |
| `agents/KB_FLOW_TRACER.md` | **Delete** |
| `agents/KB_ANALYST.md` | **Delete** |
| `agents/KB_DOMAIN_EXPERT.md` | **Delete** |
| `agents/KB_SECURITY_REVIEWER.md` | **Delete** |
| `agents/KB_UX_INTERPRETER.md` | **Delete** |
| `AGENTS.md` | Simplified roster and routing |
| `AI_WORKFLOW.md` | Simplified routing section |
| `agents/DEVELOPMENT_TEAM.md` | Update sub-agent references |

## Exit Criteria

1. Agent roster reduced from 13 to 8 agents.
2. 4 new skills replace 7 removed agents.
3. All functionality preserved — same questions produce same quality answers.
4. The `/develop` workflow works with the new structure.
5. A bot loading the KB reads 1 agent definition (KB Reader) instead of potentially 7.
6. All future generated KBs use the simplified structure.

## Skills to Use

- Agent: **Architect** (structural redesign)
- Agent: **Developer** (file creation, deletion, updates)
- Agent: **Documenter** (roster and workflow)

## Notes

- Development/Planning agents remain as agents because they own specific `/develop` phases and have distinct expertise.
- Key insight: interpretation agents are **stateless readers** — they read, apply a procedure, and produce output. That is exactly what skills are. Agents should be reserved for roles with **state** or **distinct expertise**.
- If the team prefers to keep agent abstractions for conceptual clarity, an alternative is to keep the files but mark them as "thin wrappers" that invoke the underlying skill.
