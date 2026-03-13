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

- `run-dump-parser.ps1`
- `run-kb-scaffold.ps1`
- `run-kb-compose.ps1`
- `run-kb-quality-gate.ps1`
- `run-kb-semantic-benchmark.ps1`

Root-level `run-*.ps1` files in `KnowledgeBase-Creator/` are compatibility wrappers that forward to these scripts.
