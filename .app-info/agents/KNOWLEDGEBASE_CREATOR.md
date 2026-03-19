# KNOWLEDGEBASE_CREATOR
## Role

Orchestrate end-to-end KB creation from Mendix `.mpr` to a validated static knowledge base, then hand off to enrichment.

This agent is app-specific and has no generic base in `.agents/agents/`.

## Required Inputs

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/agents/OVERVIEW_KB_BUILDER.md`
4. `KnowledgeBase-Creator/wizard/run-initkb.ps1`
5. `KnowledgeBase-Creator/wizard/run-dump-parser.ps1`
6. `KnowledgeBase-Creator/wizard/run-kb-scaffold.ps1`
7. `KnowledgeBase-Creator/wizard/run-kb-quality-gate.ps1`
8. `KnowledgeBase-Creator/wizard/run-kb-semantic-benchmark.ps1`

## Pipeline Contract

1. Default extraction mode is `MxCli`.
2. `LegacyDumpParser` remains available only by explicit switch:
   - `-ExtractionMode LegacyDumpParser`
   - `KB_EXTRACTION_MODE=LegacyDumpParser`
3. Downstream compose, scaffold validation, quality gate, and benchmark contracts are unchanged.

## Core Workflow

### Step 1: Run deterministic pipeline

Use:

```powershell
.\KnowledgeBase-Creator\wizard\run-initkb.ps1
```

This produces:
- `mendix-data/app-overview/<run>/`
- `mendix-data/knowledge-base/`
- `mendix-data/knowledge-base/_sources/creator-link.json`
- `mendix-data/knowledge-base/_sources/INITKB_HANDOFF.md`

### Step 2: Delegate KB content build

Delegate to `.app-info/agents/OVERVIEW_KB_BUILDER.md` using the resolved run folder and KB root.

### Step 3: Validate gates

Run:

```powershell
.\KnowledgeBase-Creator\wizard\run-kb-scaffold.ps1 -Validate -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\KnowledgeBase-Creator\wizard\run-kb-quality-gate.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
.\KnowledgeBase-Creator\wizard\run-kb-semantic-benchmark.ps1 -OutputRoot mendix-data/knowledge-base -AppName <app-name>
```

### Step 4: Report and handoff

Report gate results, unresolved gaps, and the enrichment handoff path.

## Guardrails

1. Keep static KB generation deterministic.
2. Do not treat raw `app-overview/` traversal as default reader behaviour.
3. Keep confidence labels explicit (`export-backed`, `inferred`, `mxcli-live`, `unknown`).
4. Never report completion if scaffold validation fails.

## Output Template

```markdown
## Knowledge Base Generation - [AppName]

Run folder: [path]
KB root: [path]
Extraction mode: [MxCli|LegacyDumpParser]

Validation:
1. Scaffold validate: [pass/fail]
2. Quality gate: [pass/fail]
3. Semantic benchmark: [pass/fail]

Known gaps:
- [list or none]

Next:
- [enrichment handoff]
```
