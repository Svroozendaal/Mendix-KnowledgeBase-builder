# MxCLI Command Capability Matrix

## Purpose

This matrix records the real installed `mxcli` contract that the prompt track is allowed to depend on. Prompt 01 creates or updates this file. Later prompts must update it before relying on new commands or output modes.

## Baseline

- Baseline date: 2026-03-18
- CLI version: `mxcli version 0.1.0`
- Validation app: `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`

## Validated Commands

| Capability | Example command | Output style | Status | Notes |
|---|---|---|---|---|
| CLI version | `mxcli --version` | text | Validated | Returns `mxcli version 0.1.0`. |
| Structure overview | `mxcli structure -p <app.mpr> -d 1` | text | Validated | Builds fast catalog and returns module summary. |
| Project tree | `mxcli project-tree -p <app.mpr>` | JSON | Validated | Suitable for programmatic parsing. |
| Show modules | `mxcli show modules -p <app.mpr>` | table | Validated | No JSON flag on `show`. |
| Show associations | `mxcli show associations Inspection -p <app.mpr>` | table | Validated | Association metadata is available at command level. |
| Show constants | `mxcli show constants Inspection -p <app.mpr>` | table | Validated | Works even when no constants exist. |
| Describe entity | `mxcli describe entity Inspection.Task -p <app.mpr>` | MDL | Validated | Includes grants and XPath. |
| Describe enumeration | `mxcli describe enumeration Inspection.Enum_TaskStatus -p <app.mpr>` | MDL | Validated | Returns full enumeration body. |
| Describe page | `mxcli describe page Inspection.Dashboard_Home -p <app.mpr>` | MDL | Validated | Includes layout, widgets, data source, and page grants. |
| Describe microflow | `mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>` | MDL | Validated | Includes control flow and grants. |
| Callers | `mxcli callers Inspection.ACT_Task_Save -p <app.mpr> --transitive` | table | Validated | `--transitive` is supported. |
| References | `mxcli refs Inspection.Dashboard_Home -p <app.mpr>` | table | Validated | Works for pages and other qualified names. |
| Search | `mxcli search -p <app.mpr> Task --format json` | JSON | Validated | JSON output confirmed. |
| Lint | `mxcli lint -p <app.mpr> --format json` | JSON | Validated | JSON output confirmed. |
| Report | `mxcli report -p <app.mpr> --format json` | JSON | Validated | JSON output confirmed. |
| Catalog query | `mxcli -p <app.mpr> -c "SELECT Name FROM CATALOG.modules"` | table | Validated | Use `-c` for SQL-style catalog access. |
| Full catalog refresh | `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT * FROM CATALOG.refs LIMIT 10"` | table | Validated | Required for refs, widgets, permissions, and similar full-mode tables. |
| Project security | `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"` | text | Validated | Works through `-c`. |

## Rejected Commands or Modes

| Assumption | Reality | Status | Required action |
|---|---|---|---|
| `mxcli open <app.mpr>` exists | Command is not available | Rejected | Do not reference it in implementation prompts. |
| `mxcli snapshot ...` exists | Command is not available | Rejected | Treat snapshot-driven plans as future work only. |
| `mxcli show ... --format json` works | `show` has no `--format` flag | Rejected | Parse table output or prefer another validated command. |

## Parsing Guidance

### Table output

Use for `show`, `callers`, `refs`, and catalog queries without JSON output. The parser must ignore warning text that is not part of the table body.

### MDL output

Use for `describe entity`, `describe enumeration`, `describe page`, and `describe microflow`. Preserve raw output for traceability; add structured parsing in the extractor layer.

### JSON output

Use directly for `project-tree`, `search --format json`, `lint --format json`, and `report --format json`.

### Full-mode catalog access

Use `mxcli -c "REFRESH CATALOG FULL; ..."` before querying tables that are only populated in full mode. Record which extraction steps require full mode.

## Output Caveats

- The installed CLI emits `WARNING: This is a vibe-coded PoC, alpha quality, use with caution.` during many commands. Treat this as non-data output and handle it consistently.
- Cached catalog reuse can change command timing and startup logs, but should not change the extraction contract.
- Any new command used by later prompts must be revalidated here first.
