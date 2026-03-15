---
objectType: flow
module: MxModelReflection
qualifiedName: MxModelReflection.DSL_Modules
stableId: 8e23863e-b3e2-42cb-8742-dbf582aecd70
slug: mxmodelreflection-dsl-modules
layer: L1
l0: mxmodelreflection-dsl-modules.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-dsl-modules.json
l2Logical: flow:MxModelReflection.DSL_Modules
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: MxModelReflection.DSL_Modules

## Summary

- Likely orchestrates downstream flow calls without direct UI output.
- L0: [abstract](mxmodelreflection-dsl-modules.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-dsl-modules.json)

## Main Steps

- retrieve ModuleList from MxModelReflection.Module
- $ModuleList != empty not empty expression=$ModuleList != empty

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; the entry point may be navigation, background execution, or an export gap.
- Output/UI context: No page output was exported; this likely delegates work to downstream flows.

## Key Entities Touched

- MxModelReflection.Module

## Called / Called By

- Calls: MxModelReflection.IVK_SyncObjects
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it may serve validation, background processing, or delegate work to other flows.

## Important Retrieves/Decisions/Mutations

- nodeId=b27f43c6-2294-4263-afc0-fbfe39313234; sourceKind=Database; entity=MxModelReflection.Module; summary=retrieve ModuleList from MxModelReflection.Module
- nodeId=9b5bc86b-36b8-4260-babd-bc0d476b1922; caption=not empty; expression=$ModuleList != empty not empty expression=$ModuleList != empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-dsl-modules.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
