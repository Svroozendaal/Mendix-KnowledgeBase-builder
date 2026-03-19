---
objectType: page
module: Administration
qualifiedName: Administration.Account_New
stableId: Administration.Account_New
slug: administration-account-new
layer: L1
l0: administration-account-new.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-new.json
l2Logical: page:Administration.Account_New
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../PAGES.md
---
# Page Overview: Administration.Account_New

## Summary

- New Account. Likely supports create/edit interactions for account password data because it accepts page parameters.
- L0: [abstract](administration-account-new.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-new.json)

## Roles and Entry Provenance

- Roles: Administration.Administrator
- Entry provenance: ShowPageAction

## Parameters

- AccountPasswordData:Administration.AccountPasswordData

## Datasource Summary

- No datasource metadata was exported for this page; it may rely on parameter-driven context rather than a standalone datasource. Check L2 JSON if exact binding matters.

## Client Actions

- actionId=1568aa0d-c04c-4605-a733-e7726c18625b; actionType=CancelChangesClientAction; summary=CancelChangesClientAction
- actionId=7c3fff45-24cb-4f65-a686-d3565770821f; actionType=MicroflowClientAction; flow=Administration.SaveNewAccount; summary=MicroflowClientAction, flow=Administration.SaveNewAccount
- actionId=029d5ed1-e71c-405b-a7f1-6631ad3a3e8d; actionType=NoClientAction; summary=NoClientAction
- actionId=112ed60d-6aa3-4467-940b-6efd01aa2718; actionType=NoClientAction; summary=NoClientAction
- actionId=11867f33-8a52-5cb2-ab08-d0c4cfa04b27; actionType=NoClientAction; summary=NoClientAction

## Shown by Flows

- Administration.NewAccount, Administration.NewWebServiceAccount

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-new.json)
- Aggregate export: [pages.json](../../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/marketplace/Administration/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/marketplace/Administration/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
