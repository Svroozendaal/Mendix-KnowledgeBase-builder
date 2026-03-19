# MxCLI Foundation

## Purpose

This document describes the reusable MxCLI extraction foundation added for the Prompt 02 migration step.

## Files

- `lib/mxcli-foundation.ps1` - shared PATH resolution, command runner, parsers, and catalog-stage helpers
- `run-mxcli-foundation-check.ps1` - smoke test for the runner and parsing contract

## Output Kinds

| Output kind | Primary commands | Handling rule |
|---|---|---|
| `Text` | `mxcli --version` | keep the cleaned stdout text |
| `Mdl` | `mxcli describe ...` | strip status and warning lines, keep the MDL body intact |
| `Json` | `mxcli search --format json -q`, `mxcli lint --format json`, `mxcli report --format json` | prefer `-q` where supported; otherwise strip status preamble before parsing |
| `Table` | `mxcli show ...`, `mxcli -c "SELECT ..."` | parse the markdown table block after separating warnings and status lines |

## Warning Handling

- Keep raw `stdout`, `stderr`, and `exit code` on every runner result.
- Treat known `WARNING:` lines as non-data metadata and expose them separately.
- Do not delete real error text from `stderr`.
- Strip known status lines such as `Connected to:` and catalog progress messages only from parsed payloads, not from the raw capture.

## Catalog Stage Plan

| Stage | Rule | Typical use |
|---|---|---|
| `None` | no catalog access | `mxcli --version` |
| `Fast` | no explicit refresh | `describe`, `structure`, `project-tree`, `show modules`, fast catalog tables |
| `CommandManagedFull` | command handles full build itself | `search`, `lint`, `report` |
| `Full` | prepend `REFRESH CATALOG FULL;` in the same `-c` batch | `refs`, `activities`, `widgets`, `permissions`, `xpath_expressions`, `strings` |
| `Source` | prepend `REFRESH CATALOG SOURCE;` in the same `-c` batch | `CATALOG.source` |

## Notes

- The legacy `run-dump-parser.ps1` route remains the active default after this step.
- Prompt 03 should reuse the shared library instead of shelling out to `mxcli` ad hoc.
