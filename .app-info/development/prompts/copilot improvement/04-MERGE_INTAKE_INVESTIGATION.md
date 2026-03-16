# PROMPT 04: Merge Story Intake and Investigation Phases

## Priority

High — removes a redundant pass over the KB and eliminates one approval gate, saving tokens and developer wait time.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md` — current orchestrator
4. `KnowledgeBase-Creator/artifacts/.agents/agents/USER_STORY_INTERPRETER.md` — current story parser
5. `KnowledgeBase-Creator/artifacts/.agents/agents/KB_FEATURE_INTERPRETER.md` — current feature interpreter
6. `KnowledgeBase-Creator/artifacts/.agents/skills/feature-search/SKILL.md` — current feature-search skill
7. `KnowledgeBase-Creator/artifacts/.agents/skills/develop/SKILL.md` — current develop skill
8. `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md` — current workflow

## Problem Statement

The current `/develop` workflow has two separate early phases:

- **Phase 1 (Intake):** Parse the user story into Actor/Action/Data/Goal. Map to security roles, flows, entities. Produce a gap analysis. Wait for developer approval.
- **Phase 2 (Investigation):** Search the KB for related features, flows, entities. Trace central flows. Analyse cross-module dependencies. Wait for developer approval.

These phases do largely the same work — both read `routes/by-flow.md`, `routes/by-entity.md`, `app/SECURITY.md`, and both produce a "what exists vs. what is missing" analysis. The result is two rounds of file reading, two synthesis steps, and two approval gates for what is conceptually one question.

## Entry Criteria

1. The `/develop` workflow and Development Team agent source files exist in `artifacts/.agents/`.
2. Prompts 01 (Keyword Index) and 03 (QUICKSTART.md) have been implemented (the merged phase benefits from both).

## Deliverable

### 1. Merge into a single "Story Mapping" phase

In `KnowledgeBase-Creator/artifacts/.agents/agents/DEVELOPMENT_TEAM.md`, replace Phase 1 (Intake) and Phase 2 (Investigation) with a single **Phase 1: Story Mapping**:

```markdown
### Phase 1: Story Mapping

1. Receive the user story from the developer.
2. Parse the story into **Actor** (role), **Action** (what), **Data** (entities), **Goal** (why).
3. **Simultaneously map against the KB:**
   a. Map Actor to security roles via `app/SECURITY.md`.
   b. Search for related KB artefacts using `routes/keyword-index.md` (from Prompt 01).
   c. Map Action to existing flows — check matches from the keyword index and `routes/by-flow.md`.
   d. Map Data to existing entities — check matches from the keyword index and `routes/by-entity.md`.
   e. For each candidate module, read `INTERPRETATION.md` for business context.
   f. For the top 1-3 candidate flows, read their L0 abstracts to confirm relevance.
   g. For the top candidate, read its L1 overview for detail.
   h. If the story spans multiple modules, check `routes/cross-module.md`.
4. Synthesise a single **Story Map** that includes:
   - Story breakdown (Actor, Action, Data, Goal).
   - Existing coverage: which modules, flows, entities, and pages already support this story.
   - Patterns: what conventions the app uses in this area (naming, flow structure, page layout).
   - Gap analysis: what is missing to fully implement the story.
5. Ask the developer:
   - "Is this story breakdown correct?"
   - "Should I focus on a specific module or area?"
   - "Are there similar features I should look at?"

**GATE:** Developer confirms the story map. They may redirect the scope.
```

### 2. Renumber remaining phases

In `DEVELOPMENT_TEAM.md`:
- Phase 1: Story Mapping (merged)
- Phase 2: High-Level Solution (was Phase 3)
- Phase 3: Detailed Solution (was Phase 4)
- Phase 4: Impact Analysis (was Phase 5)
- Phase 5: Security Review (was Phase 6)
- Phase 6: Implementation Plan (was Phase 7)

Update all internal phase references, the sub-agent table, and the plan file format section headings.

### 3. Update USER_STORY_INTERPRETER.md

In `KnowledgeBase-Creator/artifacts/.agents/agents/USER_STORY_INTERPRETER.md`, add a section:

```markdown
## Integration with Development Team

When invoked as part of the Story Mapping phase, this agent's procedure is embedded in the larger mapping pass rather than run standalone. The output format remains the same but is included in the Story Map rather than presented separately.
```

### 4. Update develop SKILL.md

In `KnowledgeBase-Creator/artifacts/.agents/skills/develop/SKILL.md`, update the phase summary table to 6 phases.

### 5. Update AI_WORKFLOW.md

In `KnowledgeBase-Creator/artifacts/.agents/AI_WORKFLOW.md`, update the "Development Workflow (`/develop`)" section to describe 6 phases and update the "Common Query Patterns" row for `/develop`.

### 6. Update plan file format

In the DEVELOPMENT_TEAM.md Implementation Plan template, rename "Story Breakdown" to "Story Map" and include investigation findings (existing coverage, patterns, gaps) in the same section.

## Files Changed (all under `KnowledgeBase-Creator/artifacts/.agents/`)

| File | Change |
|---|---|
| `agents/DEVELOPMENT_TEAM.md` | Merge Phase 1+2, renumber phases, update plan format |
| `agents/USER_STORY_INTERPRETER.md` | Add integration note |
| `skills/develop/SKILL.md` | Update phase table to 6 phases |
| `AI_WORKFLOW.md` | Update `/develop` section and query patterns |

## Exit Criteria

1. The `/develop` workflow has 6 phases with 5 approval gates (down from 7/6).
2. The first phase produces a single Story Map combining parsing and investigation.
3. The bot reads the KB once (not twice) to understand the story context.
4. All future generated KBs use the merged workflow.

## Skills to Use

- Agent: **Developer** (agent artifact file updates)
- Agent: **Documenter** (workflow documentation)

## Notes

- The phase bundling rule for small stories still applies. With the merge, small stories could bundle Phases 2+3 and 4+5 as well, reducing to as few as 3 interactions for trivial changes.
- If Prompt 01 (Keyword Index) has not been implemented yet, the merged phase falls back to scanning route files — but the merge is still beneficial because it eliminates the redundant approval gate.
