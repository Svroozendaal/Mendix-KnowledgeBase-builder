# MxCLI JSON v2 General and Domain Outputs

## Purpose

This document describes the Prompt 03 generator that writes the first JSON v2 run-folder outputs from the shared MxCLI foundation.

## Files

- `lib/mxcli-json-v2-general-domain.ps1` - reusable generator library
- `run-mxcli-json-v2-general-domain.ps1` - entry script for real run-folder generation
- `run-mxcli-json-v2-general-domain-check.ps1` - Prompt 03 verification script

## Command Set

The generator uses the installed CLI contract validated on this machine:

- `mxcli show modules -p <app.mpr>`
- `mxcli -p <app.mpr> -c "SHOW PROJECT SECURITY"`
- `mxcli -p <app.mpr> -c "SHOW USER ROLES"`
- `mxcli -p <app.mpr> -c "SHOW MODULE ROLES IN <module>"`
- `mxcli describe userrole <role> -p <app.mpr>`
- `mxcli show associations <module> -p <app.mpr>`
- `mxcli describe entity <qualified-name> -p <app.mpr>`
- `mxcli describe enumeration <qualified-name> -p <app.mpr>`
- simple catalog queries for `modules`, `entities`, `enumerations`, `activities`, and `refs`

## Module Classification

Module category is derived from the validated module surface:

- `Marketplace` when `show modules` reports `Marketplace ...` or `CATALOG.modules.AppStoreGuid` is populated
- `System` when the catalog marks the module as system-owned without an app-store GUID
- `Custom` otherwise

## Current Gap Handling

- `manifest.json.generator` is set to `"mxcli"`.
- `general/app-info.json.sourceDumpPath` is kept with a `null` value in MxCLI mode.
- `summary.ruleCount` is `null` because the installed CLI does not prove a rule-only count.
- `summary.flowEdgeCount` is `null` because no validated edge export exists yet.
- `accessRules[].defaultMemberAccessRights` is `null` because the installed CLI does not expose the underlying default directly.
- attribute `length` stays `null` when the installed CLI does not expose a reliable evidence-backed value.
- the installed CLI currently omits `System` from the module inventory surface; this is logged in the parity gap ledger rather than papered over in the export.

## Output Scope

This step writes only:

- `manifest.json`
- `general/app-info.json`
- `general/user-roles.json`
- `general/all-modules.json`
- `general/marketplace-modules.json`
- `modules/<Module>/domain-model.json`

The legacy dump/parser route remains the active default after this step.
