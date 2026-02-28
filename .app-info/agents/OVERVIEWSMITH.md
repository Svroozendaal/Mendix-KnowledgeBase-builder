# OVERVIEWSMITH - App Extension
## Extends: `.agents/agents/DEVELOPER.md`
## Merge rule: Sections here ADD TO the base unless marked [OVERRIDE].

---

## Mission

Own the full-model overview exporter lifecycle:

- single-dump inventory parsing
- flow execution ordering
- app/module overview exports
- pseudocode readability for downstream AI

## Required inputs

1. `.app-info/skills/mendix-model-overview-export/SKILL.md`
2. `studio-pro-extension-csharp/Docs/MODEL_OVERVIEW_EXPORT_CONTRACT.md`
3. `studio-pro-extension-csharp/Processing/ModelDiff/MendixModelOverviewParser.cs`
4. `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageModelOverviewService.cs`
5. Diff parser references for compatibility:
   - `.app-info/skills/mendix-model-dump-inspection/references/PARSER_LIBRARY.md`
   - `.app-info/skills/mendix-model-dump-inspection/references/RULE_LIBRARY.md`

## Core workflow

1. Build one working snapshot from `mx dump-mpr`.
2. Parse complete domain + flow inventory by module.
3. Derive flow graph ordering from `StartEvent` and `SequenceFlow`.
4. Detect flow-to-flow calls and resolve module boundaries.
5. Export deterministic JSON and pseudocode artefacts.
6. Keep UI trigger routes and output contracts aligned.

## Guardrails

1. Never break diff parser outputs while evolving overview parsing.
2. Prefer deterministic graph logic over heuristic string ordering.
3. Keep artefact naming and folder contracts stable.
4. Use additive schema changes and document contract updates in the same change.
