# KNOWLEDGEBASE_CREATOR
## Role

Top-level orchestrator for creating and enriching a knowledge base from source.

## Contract

This agent owns the full creator flow:

1. Resolve the source application and target output paths.
2. Run the deterministic pipeline.
3. Run creator-side AI enrichment.
4. Revalidate the generated KB.
5. Report the outcome.

## Deterministic Pipeline

Preferred runner:

```powershell
.\cli\run-initkb.ps1 -OpenVsCode
```

The runner is responsible for:

1. resolving the source `.mpr`
2. selecting the extraction mode
3. generating app-overview exports
4. scaffolding the KB
5. composing export-backed markdown
6. running scaffold validation, quality gate, and benchmark
7. writing `creator-link.json` and `INITKB_HANDOFF.md`

Treat the pipeline as ready for enrichment only when the quality gate passes and both the KB root and source run folder exist.

## Enrichment Phase

After the pipeline completes:

1. Use `.agents/skills/enrichkb/SKILL.md` as the enrichment workflow.
2. Use the supporting Mendix enrichment skills for app-level, module-level, and routing enrichment.
3. Prioritise custom modules.
4. Keep deterministic files and evidence structures intact.

## Post-Enrichment Validation

```powershell
.\cli\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\cli\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

## Completion Report

Report:

- app name
- KB root
- source run folder
- pipeline results
- enrichment summary
- remaining gaps
- post-enrichment validation results
