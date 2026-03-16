# PROMPT 04: Merge Story Intake and Investigation Phases

## Priority

High — removes a redundant pass over the KB and eliminates one approval gate, saving tokens and developer wait time.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.app-info/development/prompts/copilot improvement/INDEX.md`
3. Generated KB: `mendix-data/knowledge-base/.agents/agents/DEVELOPMENT_TEAM.md`
4. Generated KB: `mendix-data/knowledge-base/.agents/agents/USER_STORY_INTERPRETER.md`
5. Generated KB: `mendix-data/knowledge-base/.agents/agents/KB_FEATURE_INTERPRETER.md`
6. Generated KB: `mendix-data/knowledge-base/.agents/skills/feature-search/SKILL.md`
7. Generated KB: `mendix-data/knowledge-base/.agents/skills/develop/SKILL.md`

## Problem Statement

The current `/develop` workflow has two separate early phases:

- **Phase 1 (Intake):** Parse the user story into Actor/Action/Data/Goal. Map to security roles, flows, entities. Produce a gap analysis. Ask clarifying questions. Wait for developer approval.
- **Phase 2 (Investigation):** Search the KB for related features, flows, entities. Trace central flows. Analyse cross-module dependencies. Present findings. Wait for developer approval.

These phases do largely the same work:
- Both read `routes/by-flow.md` and `routes/by-entity.md` to map story concepts to KB artefacts.
- Both read `app/SECURITY.md` to map the actor role.
- Both produce a "what exists vs. what is missing" analysis.
- The investigation in Phase 2 often re-reads the same files that Phase 1 already consulted.

The result is: two rounds of file reading, two synthesis steps, two approval gates, and two presentations to the developer — for what is conceptually one question: "What does this story mean in the context of this app?"

## Entry Criteria

1. The `/develop` workflow and Development Team agent are functional.
2. Prompts 01 (Keyword Index) and 03 (QUICKSTART.md) have been implemented (the merged phase benefits from both).

## Deliverable

### 1. Merge into a single "Story Mapping" phase

Replace Phase 1 (Intake) and Phase 2 (Investigation) with a single **Phase 1: Story Mapping** that does everything in one pass:

```markdown
### Phase 1: Story Mapping

1. Receive the user story from the developer.
2. Parse the story into **Actor** (role), **Action** (what), **Data** (entities), **Goal** (why).
3. **Simultaneously map against the KB:**
   a. Map Actor to security roles via `app/SECURITY.md`.
   b. Search for related KB artefacts using `routes/keyword-index.md` (from Prompt 01).
   c. Map Action to existing flows — check matches from the keyword index and `routes/by-flow.md`.
   d. Map Data to existing entities — check matches from the keyword index and `routes/by-entity.md`.
   e. For the top 1-3 candidate flows, read their L0 abstracts to confirm relevance.
   f. For the top candidate, read its L1 overview for detail.
   g. If the story spans multiple modules, check `routes/cross-module.md`.
4. Synthesise a single **Story Map** that includes:
   - Story breakdown (Actor, Action, Data, Goal).
   - Existing coverage: which modules, flows, entities, and pages already support this story.
   - Patterns: what conventions the app uses in this area (naming, flow structure, page layout).
   - Gap analysis: what is missing to fully implement the story.
   - If KB Feature Interpreter or KB Flow Tracer work is needed, include their findings inline.
5. Ask the developer:
   - "Is this story breakdown correct?"
   - "Should I focus on a specific module or area?"
   - "Are there similar features I should look at?"

**GATE:** Developer confirms the story map. They may redirect the scope.
```

### 2. Update DEVELOPMENT_TEAM.md

Rewrite the phase list:
- **Phase 1: Story Mapping** (merged intake + investigation)
- **Phase 2: High-Level Solution** (was Phase 3)
- **Phase 3: Detailed Solution** (was Phase 4)
- **Phase 4: Impact Analysis** (was Phase 5)
- **Phase 5: Security Review** (was Phase 6)
- **Phase 6: Implementation Plan** (was Phase 7)

Update all phase references, sub-agent table, and the plan file format section headings.

### 3. Update USER_STORY_INTERPRETER.md

Add a section clarifying that the User Story Interpreter's procedure is now invoked as part of the Story Mapping phase, not as a standalone delegation. The output format remains the same but is embedded in the larger Story Map rather than presented separately.

### 4. Update develop SKILL.md

Update the phase summary table to reflect 6 phases instead of 7.

### 5. Update AI_WORKFLOW.md

Update the "Development Workflow (`/develop`)" section to describe 6 phases. Update the "Common Query Patterns" row for `/develop`.

### 6. Update plan file format

In the Implementation Plan template, rename "Story Breakdown" to "Story Map" and include the investigation findings (existing coverage, patterns, gaps) in the same section rather than separately.

## Exit Criteria

1. The `/develop` workflow has 6 phases with 5 approval gates (down from 7 phases with 6 gates).
2. The first phase produces a single Story Map that combines parsing and investigation.
3. The bot reads the KB once (not twice) to understand the story context.
4. The developer sees one combined presentation and answers one set of questions before solution design begins.
5. All file cross-references are updated consistently.

## Skills to Use

- Agent: **Developer** (agent file updates)
- Agent: **Documenter** (workflow documentation)

## Notes

- The phase bundling rule for small stories (from the original Phase 3+4 and 5+6 bundling) still applies. With the merge, small stories could potentially bundle Phases 2+3 (Solution) and 4+5 (Impact + Security) as well, reducing to as few as 3 interactions for trivial changes.
- The merged phase still delegates to User Story Interpreter and KB Feature Interpreter — but conceptually as "skills invoked during the phase" rather than "separate agent delegations with separate outputs". This aligns with the direction in Prompt 07 (Collapse Agents into Skills).
- If Prompt 01 (Keyword Index) has not been implemented yet, the merged phase falls back to scanning route files directly — but the merge is still beneficial because it eliminates the redundant approval gate.
