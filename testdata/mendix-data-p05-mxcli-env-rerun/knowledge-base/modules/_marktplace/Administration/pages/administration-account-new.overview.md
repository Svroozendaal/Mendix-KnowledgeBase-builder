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
sourceRun: cli_2026-03-18T20-54-38.903Z
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

- sourceId=dataView2; sourceType=Parameter; entity=Administration.AccountPasswordData; summary=Parameter datasource: $AccountPasswordData

## Client Actions

- actionId=microflowButton1; actionType=MicroflowClientAction; flow=Administration.SaveNewAccount; summary=MicroflowClientAction, flow=Administration.SaveNewAccount

## Shown by Flows

- Administration.NewAccount, Administration.NewWebServiceAccount

## Navigation/Homepage Provenance

- No navigation or homepage provenance was exported; the clearest exported evidence is the flow link shown above.

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-new.json)
- Aggregate export: [pages.json](../../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/marketplace/Administration/pages.json)
- Aggregate pseudo: [pages.pseudo.txt](../../../../../app-overview/cli_2026-03-18T20-54-38.903Z/modules/marketplace/Administration/pages.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-54-38.903Z
