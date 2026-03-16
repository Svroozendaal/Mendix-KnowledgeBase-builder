# PROMPT 07: Collapse Interpretation Agents into Skills

## Priority

Medium — reduces persona-switching overhead and simplifies the agent roster without losing functionality.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/.agents/AGENTS.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_NAVIGATOR.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FEATURE_INTERPRETER.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FLOW_TRACER.md`
7. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_ANALYST.md`
8. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_DOMAIN_EXPERT.md`
9. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_SECURITY_REVIEWER.md`
10. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_UX_INTERPRETER.md`

## Problem Statement

The KB defines 7 interpretation agents (Navigator, Feature Interpreter, Flow Tracer, Analyst, Domain Expert, Security Reviewer, UX Interpreter) plus 6 development agents (Development Team, Mendix Developer, Mendix Syntax, User Story Interpreter, Planner, Todo Maker). That is 13 agent personas in a system where a single LLM conversation handles all of them.

In practice, "delegating to the KB Feature Interpreter" means the LLM:
1. Reads `KB_FEATURE_INTERPRETER.md` (~100 lines of persona definition).
2. Adopts that persona's operating procedure.
3. Reads the same KB files it would have read anyway.
4. Produces output in the agent's specified format.
5. "Hands off" back to the orchestrator.

Steps 1, 2, and 5 add token overhead without changing what files are read (step 3) or what reasoning is done. The persona definition is essentially a skill procedure wrapped in an agent identity.

The 7 interpretation agents differ primarily in:
- **What files they read** (already determined by the routing table).
- **What output format they produce** (a structural template).
- **What escalation rules they follow** (pointing to each other).

These are characteristics of **skills**, not distinct agents.

## Entry Criteria

1. The KB agent framework is functional.
2. Prompts 04 (Merge Phases) and 05 (Reading Budgets) are implemented.

## Deliverable

### 1. Consolidate 7 interpretation agents into 1 agent + 5 skills

**Keep as agents:**
- **KB Reader** (renamed from KB Navigator) — the single interpretation agent. It reads the KB and answers questions, invoking skills as needed.
- **Development Team** — the orchestrator for `/develop`.
- **Mendix Developer** — implementation guidance.
- **Mendix Syntax** — syntax enrichment.
- **User Story Interpreter** — story parsing (can also become a skill within Development Team, but keep for now).
- **Planner** — work sequencing.
- **Todo Maker** — task breakdown.
- **Best Practice Recommender** — convention checking.

**Convert to skills:**
- KB Feature Interpreter → `.agents/skills/feature-interpretation/SKILL.md`
- KB Flow Tracer → `.agents/skills/flow-chain-tracing/SKILL.md` (already mostly a skill wrapper)
- KB Analyst → `.agents/skills/impact-analysis/SKILL.md` (already mostly a skill wrapper)
- KB Domain Expert → `.agents/skills/domain-analysis/SKILL.md`
- KB Security Reviewer → `.agents/skills/security-analysis/SKILL.md`
- KB UX Interpreter → `.agents/skills/ux-analysis/SKILL.md`

### 2. Create the KB Reader agent

`KB_READER.md` replaces `KB_NAVIGATOR.md` and absorbs the routing logic from all 7 interpretation agents:

```markdown
# KB_READER
## Knowledge Base Interpretation Agent

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
```

### 3. Convert each agent to a skill

For each converted agent, extract the **Operating Procedure** and **Output Format** into a skill file. Remove the persona preamble, scope reminder, and escalation section (the KB Reader handles escalation).

Example conversion for KB Feature Interpreter:

**Before (agent):**
```markdown
# KB_FEATURE_INTERPRETER
## Role
You synthesise business-feature-level answers...
## When to Use
...
## Operating Procedure
1. Parse the question...
2. Invoke feature-search...
...
## Output Format
## Feature Report: ...
## Escalation
Hand off to KB Analyst...
```

**After (skill):**
```markdown
# SKILL: Feature Interpretation
## Purpose
Synthesise a business-feature-level answer from technical KB data.
## Used By
KB Reader
## Procedure
1. Parse the question...
2. Invoke feature-search...
...
## Output Format
## Feature Report: ...
```

### 4. Update AGENTS.md roster

Replace the 7 interpretation agent rows with 1 KB Reader row. Add the new skills to the Skills Overview section.

### 5. Update DEVELOPMENT_TEAM.md sub-agent table

Replace references to KB Feature Interpreter, KB Flow Tracer, KB Analyst, KB Security Reviewer with "KB Reader (using [skill-name] skill)".

### 6. Update AI_WORKFLOW.md

Simplify the agent routing section. Replace 13 routing rules with ~7.

## Exit Criteria

1. Agent roster is reduced from 13 to 8 agents.
2. 5 new skills replace 6 removed agents (KB Navigator + KB Feature Interpreter merged into KB Reader + feature-interpretation skill; KB Flow Tracer already has flow-chain-tracing skill so just remove the agent wrapper).
3. All functionality is preserved — the same questions produce the same quality answers.
4. The `/develop` workflow works with the new agent/skill structure.
5. A bot loading the KB reads 1 agent definition (KB Reader) instead of potentially 7 (all interpretation agents).

## Skills to Use

- Agent: **Architect** (structural redesign of agent/skill boundaries)
- Agent: **Developer** (file creation and updates)
- Agent: **Documenter** (roster and workflow documentation)

## Notes

- The Development/Planning agents (Mendix Developer, Mendix Syntax, User Story Interpreter, Planner, Todo Maker, Best Practice Recommender) remain as agents because they have distinct responsibilities in the `/develop` workflow phases. They are not interchangeable and each owns a specific phase.
- The key insight: interpretation agents are **stateless readers** — they read KB files, apply a procedure, and produce output. That is exactly what skills are. Agents should be reserved for roles that have **state** (like the Development Team orchestrator tracking phases) or **distinct expertise** (like Mendix Developer knowing Mendix best practices).
- This change also makes it easier to add new analysis capabilities: just add a skill, register it in the KB Reader's skills table. No need to create a full agent definition.
- If the team prefers to keep the agent abstractions for conceptual clarity, an alternative is to keep the agent files but mark them as "thin wrappers" that just invoke the underlying skill. This avoids the persona overhead while preserving the mental model.
