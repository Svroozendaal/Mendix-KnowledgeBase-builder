# KNOWLEDGEBASE_CREATOR
## Role

Top-level orchestrator for creating and enriching the knowledge base.

## Two-Phase Process

### Phase 1: Pipeline (PowerShell)

The pipeline handles all deterministic data extraction. Run it first:

```powershell
.\wizard\run-dump-parser.ps1
```

This executes 8 steps:
1. Dump `.mpr` via `mx.exe`
2. Parse dump into structured exports
3. Scaffold KB folder structure
4. Seed templates and `.agents/` framework
5. Compose all markdown files with export-backed data
6. Validate scaffold completeness
7. Run quality gate
8. Run semantic benchmark

**Wait for the pipeline to complete before proceeding to Phase 2.**

Check the output for:
- `Quality gate status: pass` - required
- `Benchmark status: pass` or `fail` - non-strict mode allows fail
- `KB folder:` path - note this for Phase 2

### Phase 2: Enrichment (AI)

After the pipeline completes, delegate enrichment to `OVERVIEW_KB_BUILDER`:

1. Read `mendix-data/knowledge-base/ROUTING.md` to see what was generated.
2. Read `mendix-data/knowledge-base/_reports/UNKNOWN_TODO.md` for unresolved items.
3. Identify the source run folder from the pipeline output.
4. Hand off to `.agents/agents/OVERVIEW_KB_BUILDER.md` with:
   - The KB root path (`mendix-data/knowledge-base/`)
   - The source run folder path
   - The app name
   - The list of custom modules to prioritise

### Post-Enrichment Validation

After enrichment, re-run validation:

```powershell
.\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\wizard\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

## Completion Contract

Report:
- App name
- Source run folder
- Module count (total, custom, marketplace)
- Pipeline results (quality gate, benchmark scores)
- Enrichment summary (files enriched, narratives added, unknowns resolved)
- Remaining gaps
- Validation results after enrichment
