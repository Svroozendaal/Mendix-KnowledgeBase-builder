---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.MB_TestTokenPattern
stableId: bece88a2-3e8b-4811-9534-5f8bcb120ea6
slug: mxmodelreflection-mb-testtokenpattern
layer: L1
l0: mxmodelreflection-mb-testtokenpattern.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-mb-testtokenpattern.json
l2Logical: flow:MxModelReflection.MB_TestTokenPattern
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.MB_TestTokenPattern

## Summary

- Likely acts as a UI entry or navigation handler because it shows MxModelReflection.TestPattern_Edit.
- L0: [abstract](mxmodelreflection-mb-testtokenpattern.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-mb-testtokenpattern.json)

## Main Steps

- ShowPageAction: show page MxModelReflection.TestPattern_Edit show page MxModelReflection.TestPattern_Edit
- CreateObjectAction: create MxModelReflection.TestPattern as NewTestPattern (DisplayPattern=$Token/DisplayPattern) create MxModelReflection.TestPattern as NewTestPattern (DisplayPattern=$Token/DisplayPattern)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: Shows MxModelReflection.TestPattern_Edit.

## Key Entities Touched

- MxModelReflection.TestPattern

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- MxModelReflection.TestPattern_Edit

## Important Retrieves/Decisions/Mutations

- nodeId=12f4b9c7-bbb7-40d0-aa69-ab8a2199df02; actionKind=Create; entity=MxModelReflection.TestPattern; members=DisplayPattern=$Token/DisplayPattern; summary=CreateObjectAction: create MxModelReflection.TestPattern as NewTestPattern (DisplayPattern=$Token/DisplayPattern) create MxModelReflection.TestPattern as NewTestPattern (DisplayPattern=$Token/DisplayPattern)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-mb-testtokenpattern.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
