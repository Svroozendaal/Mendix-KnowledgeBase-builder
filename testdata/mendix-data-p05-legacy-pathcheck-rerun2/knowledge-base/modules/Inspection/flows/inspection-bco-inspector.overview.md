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
sourceRun: cli_2026-03-18T20-56-46.385Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.BCo_Inspector

## Summary

- Likely acts as a save, process, or background step for Administration.Account, System.UserRole because it mutates data without showing a page.
- L0: [abstract](inspection-bco-inspector.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json)

## Main Steps

- RetrieveAction: retrieve UserRole_Inspector from System.UserRole retrieve UserRole_Inspector from System.UserRole
- $Inspector/Inspection.Inspector_Account = empty doesn't have an account? expression=$Inspector/Inspection.Inspector_Account = empty
- CreateObjectAction: create Administration.Account as NewAccount (FullName=$Inspector/Name, Email=$Inspector/EmailAddress, Name=$Inspector/EmailAddress, Password='Mendix123456', UserRoles=$UserRole_Inspector, Inspector_Ac...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- Administration.Account, System.UserRole

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=94812430-5b51-4aec-b29c-b931f7884ec5; sourceKind=Database; entity=System.UserRole; summary=RetrieveAction: retrieve UserRole_Inspector from System.UserRole retrieve UserRole_Inspector from System.UserRole
- nodeId=1fb9d2cc-324b-4820-91d6-cd28c4905438; caption=doesn't have an account?; expression=$Inspector/Inspection.Inspector_Account = empty doesn't have an account? expression=$Inspector/Inspection.Inspector_Account = empty
- nodeId=651bc152-3235-426f-9f0b-0ba340a1493f; actionKind=Create; entity=Administration.Account; summary=CreateObjectAction: create Administration.Account as NewAccount (FullName=$Inspector/Name, Email=$Inspector/EmailAddress, Name=$Inspector/EmailAddress, Password='Mendix123456', UserRoles=$UserRole_Inspector, Inspector_Ac...

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-56-46.385Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-56-46.385Z
