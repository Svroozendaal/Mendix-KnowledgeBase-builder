# MxCLI Parity Gap Ledger

## Purpose

This ledger tracks mismatches between the target KnowledgeBase Creator contract and the real installed `mxcli` behaviour. Prompt 01 establishes the baseline. Every later prompt must update this ledger before proceeding when it discovers a new gap, fallback, or resolved issue.

## Status Levels

- `Open` - gap exists and blocks a clean parity claim.
- `Mitigated` - current track has a documented fallback or safe handling.
- `Resolved` - parity requirement is satisfied and validation evidence exists.
- `Deferred` - intentionally out of scope for the current track.

## Baseline Gaps

| ID | Area | Status | Finding | Evidence | Required handling |
|---|---|---|---|---|---|
| GAP-001 | CLI contract | Resolved | Research referenced `mxcli open`, but the installed CLI has no such command. | `mxcli open --help` fails with unknown command. | Remove the assumption from prompts and docs. |
| GAP-002 | CLI contract | Resolved | Research referenced a user-facing snapshot command, but the installed CLI has no such command. | `mxcli snapshot --help` fails with unknown command. | Treat snapshot-driven work as future work only. |
| GAP-003 | Output mode | Resolved | `mxcli show` does not support JSON output. | `mxcli show pages Inspection -p <app.mpr> --format json` fails with unknown flag. | Parse table output or use another validated command. |
| GAP-004 | Research freshness | Mitigated | The research notes contain partially stale command assumptions. | Comparison between `App information/` notes and live CLI tests. | Prompt 01 must make the capability matrix the real source of truth. |
| GAP-005 | Warning noise | Open | Many commands emit a warning line that is not part of the intended data stream. | Validated on `describe`, `refs`, `lint`, and `report`. | Extraction layer must separate data from warning output. |
| GAP-006 | Pseudo compatibility | Open | The legacy pipeline expects `.pseudo.txt` files; `mxcli` natively returns MDL or table/JSON output. | Current composer and enrichment flow reference `.pseudo.txt`. | Phase 1 must keep `.pseudo.txt` compatibility rather than silently dropping it. |
| GAP-007 | Scheduled events | Open | Current validated command set does not yet prove a clean extraction source for `resources.json -> scheduledEvents[]`. | No baseline command validated for scheduled-event detail. | Revalidate or document fallback before claiming parity. |
| GAP-008 | Constant source shape | Open | `show constants` is validated, but catalog-level and field-level mapping for all v2 resource fields remains unproven. | Baseline only confirms command availability and empty-result behaviour. | Validate extraction details during resource implementation. |
| GAP-009 | Association source shape | Mitigated | Research treated association detail as a likely gap, but `show associations` is now validated. | `mxcli show associations Inspection -p <app.mpr>` returns parent/child/type/owner/storage. | Prefer `show associations` before falling back to MDL parsing. |
| GAP-010 | Reader live queries | Deferred | `mxcli-live` confidence and live-query escalation are not part of the core extraction migration. | Track scope. | Handle only in Prompt 07. |

## Rules For Updating This Ledger

- Add a row before or during implementation as soon as a parity risk is confirmed.
- Link every `Resolved` status to command evidence and validation steps.
- Do not downgrade a blocking gap to `Mitigated` without documenting the fallback and residual risk.
- Do not switch the creator default to `mxcli` while blocking parity gaps remain open.

## Current Switchover Rule

Prompt 06 may switch the default extraction path only when:

- composer validation is green,
- KB contract validation is green,
- quality gate is green,
- semantic benchmark is green, and
- remaining ledger items are either `Resolved` or explicitly `Deferred`.
