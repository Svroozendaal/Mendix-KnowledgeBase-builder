# MxCLI Command Capability Matrix

## Purpose

This matrix records the real installed `mxcli` contract that the prompt track is allowed to depend on. Prompt 01 creates or updates this file. Later prompts must update it before relying on new commands or output modes.

## Baseline

- Baseline date: 2026-03-18
- CLI version: `mxcli version 0.1.0`
- Validation app: `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`
- KB reference: `mendix-data/knowledge-base/`

## Validated Commands

| Capability | Example command | Output style | Status | Notes |
|---|---|---|---|---|
| CLI version | `mxcli --version` | text | Validated | Returns `mxcli version 0.1.0`. |
| Structure overview | `mxcli structure -p <app.mpr> -d 1` | text | Validated | Returns module summary plus scheduled-event counts; also emits connection/catalog status text. |
| Project tree | `mxcli project-tree -p <app.mpr>` | JSON | Validated | `ConvertFrom-Json` succeeded. The root is a JSON array containing system, navigation, security, and module nodes. |
| Show modules | `mxcli show modules -p <app.mpr>` | table | Validated with caveat | No JSON flag on `show`. In the baseline app the installed CLI lists 7 custom and marketplace modules and omits `System`. |
| Show associations | `mxcli show associations Inspection -p <app.mpr>` | table | Validated | Returns `Qualified Name`, `Parent`, `Child`, `Type`, `Owner`, and `Storage` columns for 8 associations. |
| Show constants | `mxcli show constants Inspection -p <app.mpr>` | text or table | Validated | Empty modules return explicit zero-result text: `No constants found.` |
| Describe entity | `mxcli describe entity Inspection.Task -p <app.mpr>` | MDL | Validated | Includes attribute defaults, grants, and XPath constraints. |
| Describe enumeration | `mxcli describe enumeration Inspection.Enum_TaskStatus -p <app.mpr>` | MDL | Validated | Returns full enumeration body. |
| Show user roles | `mxcli -p <app.mpr> -c "SHOW USER ROLES"` | table | Validated | Returns project user roles plus `Manage All` and `Check Security` flags. |
| Show module roles | `mxcli -p <app.mpr> -c "SHOW MODULE ROLES IN Inspection"` | table | Validated | Returns module-role qualified names, local role names, and descriptions. |
| Describe user role | `mxcli describe userrole Administrator -p <app.mpr>` | MDL | Validated | Returns module-role assignments plus `MANAGE ALL ROLES` and check-security state. |
| Describe page | `mxcli describe page Inspection.Dashboard_Home -p <app.mpr>` | MDL | Validated | Includes layout and widget tree output suitable for later parsing. |
| Describe snippet | `mxcli describe snippet Inspection.SNP_Task_Select -p <app.mpr>` | MDL | Validated | Returns snippet tree with parameter metadata (`Params`). |
| Describe microflow | `mxcli describe microflow Inspection.ACT_Task_Save -p <app.mpr>` | MDL | Validated | Includes folder, control flow, and execute grants. |
| Callers | `mxcli callers Inspection.ACT_Task_Save -p <app.mpr> --transitive` | text/table | Validated | `--transitive` is supported. Empty results are valid and must not be treated as failure. |
| References | `mxcli refs Inspection.Dashboard_Home -p <app.mpr>` | text/table | Validated | Returned 4 navigation references in the baseline app. |
| Search (raw) | `mxcli search -p <app.mpr> Task --format json` | JSON with stdout preamble | Validated with caveat | Raw stdout is not directly parseable because it prepends `Connected to` and catalog-status lines. |
| Search (quiet) | `mxcli search -p <app.mpr> Task --format json -q` | JSON | Validated | Preferred machine-readable variant. `ConvertFrom-Json` succeeded with 26 results. |
| Lint | `mxcli lint -p <app.mpr> --format json` | JSON with stdout preamble | Validated with caveat | Raw stdout is not directly parseable; strip the preamble before JSON parsing. Baseline summary: 9 warnings, 0 errors. |
| Report | `mxcli report -p <app.mpr> --format json` | JSON with stdout preamble | Validated with caveat | Raw stdout is not directly parseable; strip the preamble before JSON parsing. Baseline score: 96.2. |
| Catalog query | `mxcli -p <app.mpr> -c "SELECT Name, QualifiedName FROM CATALOG.modules LIMIT 5"` | table | Validated | Use `-c` for SQL-style catalog access. |
| Catalog microflows | `mxcli -p <app.mpr> -c "SELECT Name, QualifiedName, MicroflowType FROM CATALOG.microflows WHERE ModuleName='Inspection' LIMIT 10"` | table | Validated | Includes `MicroflowType`; nanoflows are present in this table with `NANOFLOW`. |
| Catalog pages | `mxcli -p <app.mpr> -c "SELECT ModuleName, Name, QualifiedName FROM CATALOG.pages WHERE ModuleName='Atlas_Web_Content' AND Name='Tablet_SelectWithTemplateGrid_Select'"` | table | Validated with caveat | `QualifiedName` can be truncated (`...`) while `Name` remains complete. |
| Full catalog refresh | `mxcli -p <app.mpr> -c "REFRESH CATALOG FULL; SELECT SourceType, TargetType, RefKind FROM CATALOG.refs LIMIT 5"` | table | Validated | Baseline confirmed `retrieve`, `show_page`, `create`, and `call` ref kinds. |
| Project security | `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"` | text | Validated | Works through `-c`. |
| Script syntax check | `mxcli check <script.mdl>` | text | Validated (interface) | Command contract validated with `mxcli check --help`. |
| Script reference check | `mxcli check <script.mdl> -p <app.mpr> --references` | text | Validated (interface) | Required pre-exec gate for `/applyplan`. |
| Script diff preview | `mxcli diff -p <app.mpr> <script.mdl> --format struct` | text | Validated (interface) | Required preview gate before any mutation. |
| Script execution | `mxcli exec <script.mdl> -p <app.mpr>` | text | Validated (interface) | Mutation command; must be confirmation-gated. |
| Project validation | `mxcli docker check -p <app.mpr>` | text | Validated (interface) | Required quick validation after apply. |
| Local change diff | `mxcli diff-local -p <app.mpr> --format struct` | text | Validated (interface) | Optional evidence step; requires MPR v2 + git tracked `mprcontents`. |

## Rejected Commands or Modes

| Assumption | Reality | Status | Required action |
|---|---|---|---|
| `mxcli open <app.mpr>` exists | Command is not available | Rejected | Do not reference it in implementation prompts. |
| `mxcli snapshot ...` exists | Command is not available | Rejected | Treat snapshot-driven plans as future work only. |
| `mxcli show ... --format json` works | `show` has no `--format` flag | Rejected | Parse table output or prefer another validated command. |
| `--format json` always implies clean JSON stdout | False for raw `search`, `lint`, and `report`; only `project-tree` and `search -q` were clean in baseline tests | Rejected | Apply command-specific stream handling and validate any new mitigation before depending on it. |
| `CATALOG.role_mappings` is available in the installed CLI | `SELECT * FROM CATALOG.role_mappings` fails with `no such table` on this machine | Rejected | Use `SHOW USER ROLES`, `SHOW MODULE ROLES IN <module>`, and `describe userrole <role>` instead. |
| `mxcli show scheduled-events <module>` is available | `mxcli show scheduled-events Inspection -p <app.mpr>` fails with `Unknown type: scheduled-events` | Rejected | Use `project-tree` fallback for scheduled-event discovery and document missing detail fields. |
| `mxcli describe nanoflow <qualified-name>` is available | `mxcli describe nanoflow Atlas_Web_Content.ACT_Login -p <app.mpr>` fails with `Unknown type: nanoflow` | Rejected | Use `CATALOG.microflows` classification and documented nanoflow fallbacks. |
| `CATALOG.pages.QualifiedName` is always complete | Baseline contains truncated `QualifiedName` values (`...`) for long names | Rejected | Reconstruct with `<ModuleName>.<Name>` and keep metadata-only fallback when describe fails. |

## Parsing Guidance

### Table output

Use for `show`, `callers`, `refs`, and catalog queries without JSON output. The parser must ignore connection/status lines and warning text that are not part of the table body.

### MDL output

Use for `describe entity`, `describe enumeration`, `describe userrole`, `describe page`, and `describe microflow`. Preserve raw output for traceability; add structured parsing in the extractor layer.

### JSON output

- `project-tree` is clean JSON on stdout in the baseline and can be parsed directly.
- Prefer `search --format json -q` for machine consumption.
- `lint --format json` and `report --format json` require preamble stripping before JSON parsing.
- Do not assume future JSON-capable commands share the same stream behaviour; revalidate first.

Current creator implementation:

- `KnowledgeBase-Creator/wizard/lib/mxcli-foundation.ps1` is the shared parser and runner layer for these rules.
- `KnowledgeBase-Creator/wizard/lib/mxcli-json-v2-general-domain.ps1` is the current Prompt 03 extractor for manifest, general files, and domain-model files.

### Full-mode catalog access

Use `mxcli -c "REFRESH CATALOG FULL; ..."` before querying tables that are only populated in full mode. Record which extraction steps require full mode.

## Output Caveats

- The installed CLI emits `WARNING: This is a vibe-coded PoC, alpha quality, use with caution.` during many commands. Treat this as non-data output and handle it consistently.
- Several commands also emit connection and catalog-status preambles that are not part of the data contract.
- The installed CLI omits `System` from `show modules`, `project-tree`, and `CATALOG.modules` in the baseline app, even though system-linked artefacts still exist elsewhere in the model.
- The installed SQL subset is narrower than some research notes imply; prefer simple full-table queries plus PowerShell filtering when a more complex query is not already revalidated.
- `CATALOG.pages` can return truncated `QualifiedName` values for long names; extraction must not use those raw values blindly for `describe page`.
- Prompt 06 creator default mode uses `mxcli --version` as the PATH-only preflight for `ExtractionMode = MxCli`.
- Cached catalog reuse can change command timing and startup logs, but should not change the extraction contract.
- Any new command used by later prompts must be revalidated here first.

## Reader Live-Query Allowlist

Prompt 07 defines a read-only `mxcli-live` escalation set for KB reader workflows. The allowlist is intentionally narrow and maps to already-validated commands:

1. `mxcli describe entity <qualified-name> -p <app.mpr>`
2. `mxcli describe enumeration <qualified-name> -p <app.mpr>`
3. `mxcli describe page <qualified-name> -p <app.mpr>`
4. `mxcli describe microflow <qualified-name> -p <app.mpr>`
5. `mxcli callers <qualified-name> -p <app.mpr> --transitive`
6. `mxcli refs <qualified-name> -p <app.mpr>`
7. `mxcli show associations <module> -p <app.mpr>`
8. `mxcli show constants <module> -p <app.mpr>`
9. `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`

Commands outside this allowlist remain approval-gated for reader workflows.

## ApplyPlan Mutation Command Set

Prompt 08 defines a separate `/applyplan` execution flow for approved `_plans/STORY_<slug>.md` plans. The command set is:

1. `mxcli check <batch>.mdl`
2. `mxcli check <batch>.mdl -p <app.mpr> --references`
3. `mxcli diff -p <app.mpr> <batch>.mdl --format struct`
4. `mxcli exec <batch>.mdl -p <app.mpr>`
5. `mxcli docker check -p <app.mpr>`
6. `mxcli lint -p <app.mpr> --format json`
7. `mxcli report -p <app.mpr> --format json`
8. Optional: `mxcli diff-local -p <app.mpr> --format struct`

Execution guardrails:

- `/develop` remains planning-only; `/applyplan` is separate.
- `mxcli exec` is never auto-run; explicit user confirmation is required after diff preview.
- Execution artefacts must be written under `_plans/_execution/STORY_<slug>/`.
