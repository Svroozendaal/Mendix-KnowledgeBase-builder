---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.ReferenceObjects
stableId: 31e8a4ac-f40f-41b8-91ac-96d1ce3a88b9
slug: mxmodelreflection-referenceobjects
layer: L1
l0: mxmodelreflection-referenceobjects.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-referenceobjects.json
l2Logical: flow:MxModelReflection.ReferenceObjects
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.ReferenceObjects

## Summary

- Likely acts as a save, process, or background step for MxModelReflection.StringValue because it mutates data without showing a page.
- L0: [abstract](mxmodelreflection-referenceobjects.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-referenceobjects.json)

## Main Steps

- CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$ReturnValueName) create MxModelReflection.StringValue as NewStringValue (Value=$ReturnValueName)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- MxModelReflection.StringValue

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=20fff5d9-05d8-4ad4-8ee6-97163fb3afd7; actionKind=Create; entity=MxModelReflection.StringValue; members=Value=$ReturnValueName; summary=CreateObjectAction: create MxModelReflection.StringValue as NewStringValue (Value=$ReturnValueName) create MxModelReflection.StringValue as NewStringValue (Value=$ReturnValueName)

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-referenceobjects.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
