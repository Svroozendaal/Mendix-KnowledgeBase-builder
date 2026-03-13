# agents/
## App-Specific Agents

This folder contains standalone app-specific agents for the Mendix KnowledgeBase Builder pipeline.

## How Extensions Work

An extension file supplements or overrides behaviour from the base agent without modifying it.

- **Sections without a marker** -> add to the base section (default).
- **Sections marked `[OVERRIDE]`** -> fully replace the base section.
- **Sections absent from the extension** -> inherited unchanged from the base.

Read `.agents/FRAMEWORK.md` for the full extension model.

## Contents

### Standalone App-Specific Agents

| Agent | File | Responsibility |
|---|---|---|
| KnowledgeBase Creator | `KNOWLEDGEBASE_CREATOR.md` | Top-level orchestrator: validates export, scaffolds KB folder, delegates to KB Builder, embeds reader, and enforces completeness + quality gate validation |
| Overview KB Builder | `OVERVIEW_KB_BUILDER.md` | Orchestrates app/module interpretation and routing synthesis to build an AI-navigable application knowledge base |
| Overview KB Reader | `OVERVIEW_KB_READER.md` | Reads the generated knowledge base and answers architecture/functionality questions with pointer-backed evidence |
| GapSmith | `GAPSMITH.md` | Investigates generated KB structural gaps, classifies `PARSER_GAP` vs `AI_INTERPRETATION_GAP`, and writes a prioritised TODO backlog |
| Context Conversation Agent (planned) | `APP_CONTEXT_CONVERSATION.md` (planned) | Conducts product-owner-first context interviews and writes additive context overlay/TODO artifacts for pre-GAPSMITH handoff |
| OverviewSmith | `OVERVIEWSMITH.md` | Own the full-model overview exporter lifecycle: parsing, flow ordering, exports, and pseudocode readability |

## Pipeline

```
Model Export:
  OVERVIEWSMITH  (parser improvement)
  GAPSMITH       (structural gap diagnosis + parser/AI-interpretation split)

Knowledge Base:
  KNOWLEDGEBASE_CREATOR  (orchestrator)
    -> OVERVIEW_KB_BUILDER  (interpretation + writing)
       -> mendix-overview-general-interpretation   (app-level docs)
       -> mendix-overview-module-interpretation    (per-module docs)
       -> mendix-overview-routing-synthesis        (cross-reference layer)
    -> READER.md embedding
    -> KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1 -Validate
    -> KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1
```

## Adding a New Agent

1. Create `<AGENT>.md` in this folder.
2. Include `This is an app-specific agent for this project. It does not have a generic base in .agents/agents/.` in the Role section.
3. Add a row to the Contents table above.

## Portable Product Direction

The repository now also ships a portable `KnowledgeBase-Creator/` package.
That package contains a curated subset of these KB-generation agents and skills, plus parser binaries, for use on other laptops.

