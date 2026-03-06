# KNOWLEDGEBASE_CREATOR
## Role

Top-level orchestrator for creating the knowledge base from app-overview export files.

## Inputs

1. `mendix-data/app-overview/<run>/manifest.json`
2. App name
3. `.agents/agents/OVERVIEW_KB_BUILDER.md`
4. `./run-kb-scaffold.ps1`
5. `./run-kb-quality-gate.ps1`

## Steps

1. Validate source run folder and `schemaVersion: 2.0`.
2. Scaffold KB structure:

```powershell
./run-kb-scaffold.ps1 -RunFolder <run-folder> -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

3. Delegate writing to `OVERVIEW_KB_BUILDER`.
4. Ensure READER and ROUTING are present and linked.
5. Validate:

```powershell
./run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
./run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

## Completion contract

Report:
- source run folder
- app name
- number of modules processed
- scaffold validation result
- quality gate result
- known gaps
