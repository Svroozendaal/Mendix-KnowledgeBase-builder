# skills/
## App-Specific Skills

This folder contains skills specific to the Mendix KnowledgeBase Builder pipeline. These complement the generic skills in `.agents/skills/`.

## When to Use App-Specific Skills

App-specific skills are used when:
- The task requires knowledge of Mendix application structure, domain models, or flow patterns.
- The task involves interpreting model overview exports into human/AI-readable documentation.
- The task requires Mendix platform-specific procedures (e.g. SDK operations, Studio Pro constraints).

## Contents

| Skill | Folder | Description |
|---|---|---|
| Mendix SDK | `mendix-sdk/` | Mendix SDK usage and model manipulation |
| Mendix Studio Pro 10 | `mendix-studio-pro-10/` | Studio Pro 10 extension development constraints |
| Mendix Model Overview Export | `mendix-model-overview-export/` | Building full-model overview exports (v2.0 structured format) from single dumps |
| Mendix Model Dump Inspection | `mendix-model-dump-inspection/` | Inspecting raw `mx dump-mpr` output: parser library and rule library for extraction |
| Mendix Overview General Interpretation | `mendix-overview-general-interpretation/` | Converting app-level export artefacts into KB Markdown (app overview, module landscape, security, call graph) |
| Mendix Overview Module Interpretation | `mendix-overview-module-interpretation/` | Converting per-module export artefacts into KB Markdown (domain, flows, pages, resources) |
| Mendix Overview Routing Synthesis | `mendix-overview-routing-synthesis/` | Building cross-reference routing layer (by-entity, by-page, by-flow, cross-module) |

## Pipeline Role

```
Model Overview Export (v2.0)
  ↓
general-interpretation  →  app/APP_OVERVIEW.md, MODULE_LANDSCAPE.md, SECURITY.md, CALL_GRAPH.md
module-interpretation   →  modules/<Module>/README.md, DOMAIN.md, FLOWS.md, PAGES.md, RESOURCES.md
                            modules/<Module>/INTERPRETATION.md (enrichment target)
                            modules/<Module>/flows/INDEX.abstract.md, <slug>.abstract.md, <slug>.overview.md
                            modules/<Module>/pages/INDEX.abstract.md, <slug>.abstract.md, <slug>.overview.md
routing-synthesis       →  ROUTING.md, routes/by-entity.md, by-page.md, by-flow.md, cross-module.md
                            (all route tables include L0/L1/L2 links per object)
```

## Layered Navigation Model

The pipeline produces a three-layer progressive disclosure model for flows and pages:

| Layer | File pattern | Content | Purpose |
|---|---|---|---|
| L0 (Abstract) | `<slug>.abstract.md` | 3-5 line summary | Triage |
| L1 (Overview) | `<slug>.overview.md` | Structured detail | Answer most questions |
| L2 (JSON) | `app-overview/current/.../<slug>.json` | Raw export | Exact verification |

Collection abstracts (`INDEX.abstract.md`) list all objects in a module at L0 with tier ranking. The generated KB also ships two reader skills (`kb-file-structure`, `layered-navigation`) that document the structure and navigation model for consuming AI agents.

## Adding a New App-Specific Skill

Use the `skill-writer` skill (`.agents/skills/skill-writer/SKILL.md`) and place the new skill in a subfolder here.
Then update this OVERVIEW.md with a new row in the Contents table.
