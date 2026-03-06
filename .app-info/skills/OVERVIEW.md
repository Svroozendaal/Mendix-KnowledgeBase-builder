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
routing-synthesis       →  ROUTING.md, routes/by-entity.md, by-page.md, by-flow.md, cross-module.md
```

## Adding a New App-Specific Skill

Use the `skill-writer` skill (`.agents/skills/skill-writer/SKILL.md`) and place the new skill in a subfolder here.
Then update this OVERVIEW.md with a new row in the Contents table.
