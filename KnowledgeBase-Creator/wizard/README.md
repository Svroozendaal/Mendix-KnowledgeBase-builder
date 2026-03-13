# KnowledgeBase Creator Wizard

This folder contains the pipeline scripts and the wizard source project.

## Start

```powershell
..\KnowledgeBaseCreator.exe
```

The published executable lives in the `KnowledgeBase-Creator/` root folder.
This `wizard/` folder keeps the implementation source and the `run-*` scripts only.

If the executable is not present yet (for local source usage), publish it:

```powershell
dotnet publish .\src\KnowledgeBaseCreator.Wizard\KnowledgeBaseCreator.Wizard.csproj -c Release -r win-x64 -o ..
```

## Scripts

- `run-initkb.ps1`
- `run-dump-parser.ps1`
- `run-kb-scaffold.ps1`
- `run-kb-compose.ps1`
- `run-kb-quality-gate.ps1`
- `run-kb-semantic-benchmark.ps1`

All executable pipeline scripts, including `run-initkb.ps1`, live in `wizard/`.

The standard `run-dump-parser.ps1` pipeline also writes `knowledge-base/_sources/creator-link.json` so generated KBs can run `/enrichkb` in place and use `/initkb` when a creator-side rebuild is required.
