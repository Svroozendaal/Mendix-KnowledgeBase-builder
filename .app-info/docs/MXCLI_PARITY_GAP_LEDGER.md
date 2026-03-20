# MxCLI Parity Gap Ledger

## Purpose

This ledger tracks mismatches between the target KnowledgeBase Creator contract and the real installed `mxcli` behaviour. Prompt 01 establishes the baseline. Every later prompt must update this ledger before proceeding when it discovers a new gap, fallback, or resolved issue.

## Status Levels

- `Open` - gap exists and blocks a clean parity claim.
- `Mitigated` - current track has a documented fallback or safe handling.
- `Resolved` - parity requirement is satisfied and validation evidence exists.
- `Deferred` - intentionally out of scope for the current track.

## Baseline Gaps

- Baseline date: 2026-03-18
- CLI version: `mxcli version 0.1.0`
- Validation app: `C:\Workspaces\Mendix\Emixa_InspectionApp\Emixa_InspectionApp.mpr`
- KB reference: `mendix-data/knowledge-base/`

| ID | Area | Status | Finding | Evidence | Required handling |
|---|---|---|---|---|---|
| GAP-001 | CLI contract | Resolved | Research referenced `mxcli open`, but the installed CLI has no such command. | `mxcli open --help` fails with unknown command. | Remove the assumption from prompts and docs. |
| GAP-002 | CLI contract | Resolved | Research referenced a user-facing snapshot command, but the installed CLI has no such command. | `mxcli snapshot --help` fails with unknown command. | Treat snapshot-driven work as future work only. |
| GAP-003 | Output mode | Resolved | `mxcli show` does not support JSON output. | `mxcli show pages Inspection -p <app.mpr> --format json` fails with unknown flag. | Parse table output or use another validated command. |
| GAP-004 | Research freshness | Mitigated | The research notes contain partially stale command assumptions. | Comparison between `App information/` notes and live CLI tests. | Prompt 01 must make the capability matrix the real source of truth. |
| GAP-005 | Stream hygiene | Resolved | JSON-oriented commands are not stream-consistent, but the creator now has a shared runner that separates warnings, strips known status preambles from parsed payloads, and uses quiet mode where available. | Implemented in `KnowledgeBase-Creator/wizard/lib/mxcli-foundation.ps1` and verified by `KnowledgeBase-Creator/wizard/run-mxcli-foundation-check.ps1`. | Reuse the shared foundation instead of bypassing it with ad hoc shell calls. |
| GAP-006 | Pseudo compatibility | Resolved | Prompt 04 now generates phase-1 `.pseudo.txt` companions for general and module aggregate JSON outputs used by the composer path. | `mendix-data/app-overview/mxcli_prompt04_smoke2/` contains `general/*.pseudo.txt` plus module `domain-model/flows/pages/resources.pseudo.txt`; composer and KB gates pass on this run folder. | Keep Option A until a later prompt intentionally redesigns consumers. |
| GAP-007 | Scheduled events | Mitigated | `mxcli` still has no `show scheduled-events` command, but Prompt 04 extracts scheduled-event names via `project-tree` `scheduledevent` nodes. | `mxcli show scheduled-events Inspection -p <app.mpr>` fails (`Unknown type`); `project-tree` contains 2 `scheduledevent` nodes in the baseline app. | Keep schedule/detail fields nullable and record residual risk until a richer source is validated. |
| GAP-008 | Constant source shape | Deferred | `show constants` is validated, but catalog-level and field-level mapping for all v2 resource fields remains unproven. | Baseline confirmed command availability and the explicit empty-result contract (`No constants found.`), but not a non-empty module example. | Non-blocking for Prompt 06/07; revisit when richer non-empty constant coverage is required. |
| GAP-009 | Association source shape | Mitigated | Research treated association detail as a likely gap, but `show associations` is now validated. | `mxcli show associations Inspection -p <app.mpr>` returns parent/child/type/owner/storage. | Prefer `show associations` before falling back to MDL parsing. |
| GAP-010 | Reader live queries | Resolved | `mxcli-live` confidence and static-first escalation are now documented as additive reader behaviour. | Reader guidance updated with allowlist, `.mpr` resolution via `creator-link.json`, and explicit approval boundaries for raw data/non-allowlisted commands. | Keep live-query allowlist read-only and scoped. |
| GAP-011 | Security mapping surface | Resolved | The installed CLI on this machine does not expose `CATALOG.role_mappings`, but command-level security surfaces still provide evidence-backed user-role and module-role mapping. | `SELECT * FROM CATALOG.role_mappings` fails with `no such table`, while `SHOW USER ROLES`, `SHOW MODULE ROLES IN Inspection`, and `describe userrole Administrator` all succeed. | Use command-level security surfaces instead of the missing catalog table. |
| GAP-012 | System module discovery | Deferred | The installed CLI omits `System` from the baseline module inventory surfaces and does not provide a clean evidence-backed system-module export path. | `show modules`, `project-tree`, and `CATALOG.modules` omit `System`; `show entities System` is partial; `describe entity System.User` fails with `module not found`. | Non-blocking for Prompt 06/07 because outputs remain schema-valid; revisit when full System-module parity becomes a release requirement. |
| GAP-013 | Summary parity | Deferred | The installed CLI does not yet provide an evidence-backed rule-only count or flow-edge count for `general/app-info.json.summary`. | Rule-only counting remains unresolved in the schema mapping notes; no validated edge table exists in the installed CLI. | Non-blocking for Prompt 06/07; keep `summary.ruleCount = null` and `summary.flowEdgeCount = null` until a validated source exists. |
| GAP-014 | Access-rule defaults | Deferred | The installed CLI exposes grant members and CRUD state, but does not expose `defaultMemberAccessRights` separately from explicit member grants. | `describe entity` and `CATALOG.permissions` show member grants but not the underlying default baseline. | Non-blocking for Prompt 06/07; keep `defaultMemberAccessRights = null` rather than inventing values. |
| GAP-015 | Attribute length fidelity | Deferred | The installed CLI does not expose reliable max string lengths for Prompt 03 field mapping on this machine. | `describe entity` omits string lengths in the baseline app, while `CATALOG.attributes.Length` reports `0` for fields that the legacy parser exported as sized strings. | Non-blocking for Prompt 06/07; keep `length = null` until evidence-backed length data is available. |
| GAP-016 | Page qualified-name fidelity | Mitigated | `CATALOG.pages.QualifiedName` can be truncated with `...`, causing `describe page` parse failures when used directly. | Baseline row: `Atlas_Web_Content.Tablet_SelectWithTemplateGrid...`; direct describe call fails with parse error. | Prompt 04 reconstructs `<ModuleName>.<Name>` before describe and falls back to metadata-only page records when describe still fails. |
| GAP-017 | Nanoflow detail fidelity | Mitigated | `CATALOG.microflows` includes nanoflows, but the installed CLI has no `describe nanoflow` command. | `mxcli describe nanoflow Atlas_Web_Content.ACT_Login -p <app.mpr>` fails with `Unknown type: nanoflow`. | Prompt 04 emits explicit minimal nanoflow structures and pseudocode instead of fabricating unavailable detail. |
| GAP-018 | Creator dual-path exposure | Resolved | Prompt 05 required exposing `MxCli` extraction in the creator package without breaking legacy defaults. | `run-dump-parser.ps1` and `run-initkb.ps1` accept `-ExtractionMode`; wizard UI exposes `Extraction mode`; both paths remain operational after Prompt 06 switchover. | Keep both paths available; use explicit override for legacy mode. |
| GAP-019 | Default switchover to MxCli | Resolved | Prompt 06 required switching creator defaults to `MxCli` while retaining explicit legacy fallback. | Defaults updated in `run-dump-parser.ps1`, `run-initkb.ps1`, and wizard runtime. Verified on 2026-03-18 with default run `mendix-data-p67-default` (`Extraction mode: MxCli`, scaffold/quality/benchmark PASS after compose refresh) and explicit fallback run `mendix-data-p67-legacy-explicit` (`Extraction mode: LegacyDumpParser`). | Keep legacy path available behind explicit override until planned deprecation. |
| GAP-020 | Reader live-query contract | Resolved | Prompt 07 required additive read-only live-query guidance without weakening static-KB-first behaviour. | Reader agent/template docs now define `mxcli-live`, allowlisted read-only commands, `.mpr` resolution via `creator-link.json`, and approval boundaries for raw-data/non-allowlisted access. Verified 2026-03-18 with allowlisted examples: `describe microflow Inspection.ACT_Task_Save`, `describe page Inspection.Dashboard_Home`, `refs Inspection.Dashboard_Home`, and `SHOW PROJECT SECURITY`. | Keep live-query scope additive and read-only. |
| GAP-021 | ApplyPlan scope boundary | Mitigated | KB framework was read-only except enrichment/init flows; `/applyplan` introduces controlled mutation and could weaken default safety if not isolated. | Prompt 08 adds dedicated execution agent/skill and explicit policy that `/develop` stays planning-only while `/applyplan` is separate and confirmation-gated. | Keep `/applyplan` as explicit opt-in; do not run mutation during normal interpretation or `/develop`. |
| GAP-022 | Missing init assets for execution | Mitigated | Some Mendix app folders do not contain app-local `mxcli init` assets required by `/applyplan` policy. | Baseline app check showed missing `.claude` and `.ai-context` before init; Prompt 08 contract now requires these paths and failure guidance (`mxcli init`/`mxcli add-tool claude`). | Preflight must fail fast with remediation when `.ai-context/skills` or `.claude/commands` is absent. |
| GAP-023 | Partial execution risk | Mitigated | `mxcli exec` applies statements progressively; a mid-script failure can leave partial changes. | Prompt 08 introduces phase-batched scripts plus mandatory `check`, `--references`, and `diff --format struct` before each execution batch. | Keep batches small, require explicit confirmation after preview, and write phase-level execution reports under `_plans/_execution/`. |

## Rules For Updating This Ledger

- Add a row before or during implementation as soon as a parity risk is confirmed.
- Link every `Resolved` status to command evidence and validation steps.
- Do not downgrade a blocking gap to `Mitigated` without documenting the fallback and residual risk.
- Do not switch the creator default to `mxcli` while blocking parity gaps remain open.

## Current Switchover Rule

Prompt 06 switchover completed on 2026-03-18 after green validation evidence for:

- compose flow continuity,
- KB scaffold validation,
- quality gate, and
- semantic benchmark.

Remaining deferred items are tracked as non-blocking fidelity gaps for future improvement work.
