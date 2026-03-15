---
objectType: flow
module: SmartExpenses
qualifiedName: SmartExpenses.ACT_FBGProfile_showParentPage
stableId: 973df348-d6eb-460e-a73d-a8622deede0b
slug: smartexpenses-act-fbgprofile-showparentpage
layer: L1
l0: smartexpenses-act-fbgprofile-showparentpage.abstract.md
l2Path: ../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-fbgprofile-showparentpage.json
l2Logical: flow:SmartExpenses.ACT_FBGProfile_showParentPage
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: SmartExpenses.ACT_FBGProfile_showParentPage

## Summary

- Likely acts as a UI entry or navigation handler because it shows SmartExpenses.Home_Parent.
- L0: [abstract](smartexpenses-act-fbgprofile-showparentpage.abstract.md)
- L2: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-fbgprofile-showparentpage.json)

## Main Steps

- retrieve FBGProfile from SmartExpenses.FBGProfile
- ShowPageAction: show page SmartExpenses.Home_Parent show page SmartExpenses.Home_Parent

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows SmartExpenses.Home_Parent.

## Key Entities Touched

- SmartExpenses.FBGProfile

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- SmartExpenses.Home_Parent

## Important Retrieves/Decisions/Mutations

- nodeId=c6094a9f-4c93-48cf-bc47-f514936c012b; sourceKind=Database; entity=SmartExpenses.FBGProfile; summary=retrieve FBGProfile from SmartExpenses.FBGProfile

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/SmartExpenses/flows/smartexpenses-act-fbgprofile-showparentpage.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/SmartExpenses/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
