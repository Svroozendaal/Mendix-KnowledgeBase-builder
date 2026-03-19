---
objectType: flow
module: Inspection
qualifiedName: Inspection.BCo_Inspector
stableId: fec16b8c-4bf1-4157-be70-ca001f0c5b56
slug: inspection-bco-inspector
layer: L1
l0: inspection-bco-inspector.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json
l2Logical: flow:Inspection.BCo_Inspector
sourceRun: cli_2026-03-18T20-57-13.045Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.BCo_Inspector

## Summary

- Likely acts as a save, process, or background step for Administration.Account because it mutates data without showing a page.
- L0: [abstract](inspection-bco-inspector.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json)

## Main Steps

- retrieve from System.UserRole WHERE Name = 'Inspector' LIMIT 1
- $Inspector/Inspection.Inspector_Account = empty
- create Administration.Account (FullName = $Inspector/Name, Email = $Inspector/EmailAddress, Name = $Inspector/EmailAddress, Password = 'Mendix123456', UserRoles = $UserRole_Inspector, Inspector_Account = $Inspector)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=n002-retrieve; sourceKind=Database; entity=System.UserRole; xPath=Name = 'Inspector'; summary=retrieve from System.UserRole WHERE Name = 'Inspector' LIMIT 1
- nodeId=n003-decision; caption=IF; expression=$Inspector/Inspection.Inspector_Account = empty
- nodeId=n004-create; actionKind=Create; entity=Administration.Account; members=(FullName = $Inspector/Name, Email = $Inspector/EmailAddress, Name = $Inspector/EmailAddress, Password = 'Mendix123456', UserRoles = $UserRole_Inspector, Inspector_Account = $Inspector); summary=create Administration.Account (FullName = $Inspector/Name, Email = $Inspector/EmailAddress, Name = $Inspector/EmailAddress, Password = 'Mendix123456', UserRoles = $UserRole_Inspector, Inspector_Account = $Inspector)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-57-13.045Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-57-13.045Z
