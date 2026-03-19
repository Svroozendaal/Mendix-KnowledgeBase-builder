---
objectType: flow
module: Inspection
qualifiedName: Inspection.VAL_Inspector_Validate
stableId: 1866348e-066f-451e-8396-431a8467b19e
slug: inspection-val-inspector-validate
layer: L1
l0: inspection-val-inspector-validate.abstract.md
l2Path: ../../../../app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json
l2Logical: flow:Inspection.VAL_Inspector_Validate
sourceRun: cli_2026-03-18T20-44-56.522Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: Inspection.VAL_Inspector_Validate

## Summary

- Likely acts as a save, process, or background step because it mutates data without showing a page.
- L0: [abstract](inspection-val-inspector-validate.abstract.md)
- L2: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json)

## Main Steps

- trim($Inspector/Name) != '' Is Name not empty? expression=trim($Inspector/Name) != ''
- $Inspector/Level != empty Is level not empty? expression=$Inspector/Level != empty
- ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by Inspection.ACT_Inspector_Save.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- No entity names were resolved from exported nodes; inspect L2 JSON if exact read/write scope matters.

## Called / Called By

- Calls: none
- Called by: Inspection.ACT_Inspector_Save

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=231c0db4-d6b0-4aff-bc47-da1812fee0b7; caption=Is Name not empty?; expression=trim($Inspector/Name) != '' Is Name not empty? expression=trim($Inspector/Name) != ''
- nodeId=30c9624a-e810-4083-8dbf-b2e3128143c3; caption=Is level not empty?; expression=$Inspector/Level != empty Is level not empty? expression=$Inspector/Level != empty
- nodeId=44e88b61-f586-4f4d-840e-35ea3de2e9ab; caption=Is Telephone not empty?; expression=trim($Inspector/Telephone) != '' Is Telephone not empty? expression=trim($Inspector/Telephone) != ''
- nodeId=4a16a2db-fae1-4e73-9cc8-053b6f050093; caption=Is Country not empty?; expression=trim($Inspector/Country) != '' Is Country not empty? expression=trim($Inspector/Country) != ''
- nodeId=a4b3ee91-cac8-4fc5-9d74-2fb2f9e2d904; caption=Is Location not empty?; expression=trim($Inspector/Location) != '' Is Location not empty? expression=trim($Inspector/Location) != ''
- nodeId=ed2eef2d-aab1-4393-bd02-3ea4df6f9979; caption=Is Email address not empty?; expression=trim($Inspector/EmailAddress) != '' Is Email address not empty? expression=trim($Inspector/EmailAddress) != ''
- nodeId=0acb00cd-eebc-4e6d-b1c6-e552860b988f; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false
- nodeId=19db93be-0acc-4541-8674-f71b6f893f39; actionKind=Change; summary=ChangeVariableAction: change variable IsValid=false change variable IsValid=false

## Warnings/Unknowns

- Rollback hint detected in node detail.
- Behavioural actions exist without explicit entity tags.

## Source

- Stable JSON: [json](../../../../app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json)
- Aggregate export: [flows.json](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../app-overview/cli_2026-03-18T20-44-56.522Z/modules/Inspection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-18T20-44-56.522Z
