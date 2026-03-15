---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.ACT_WorkflowDefinition_Delete
stableId: 9d99358c-31bc-4ffa-b59b-ceb3ddd98f63
slug: workflowcommons-act-workflowdefinition-delete
layer: L1
l0: workflowcommons-act-workflowdefinition-delete.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-delete.json
l2Logical: flow:WorkflowCommons.ACT_WorkflowDefinition_Delete
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.ACT_WorkflowDefinition_Delete

## Summary

- Likely acts as a save, process, or background step for System.Workflow because it mutates data without showing a page.
- L0: [abstract](workflowcommons-act-workflowdefinition-delete.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-delete.json)

## Main Steps

- retrieve WorkflowList from System.Workflow
- $WorkflowCount = 0 = 0 expression=$WorkflowCount = 0
- $WorkflowDefinition/IsObsolete Obsolete? expression=$WorkflowDefinition/IsObsolete
- DeleteAction: delete WorkflowDefinition (refreshInClient=true) delete WorkflowDefinition (refreshInClient=true)
- ShowMessageAction: show message (text=You can only delete a workflow definition when it is obsolete., type=Information, blocking=true) show message (text=You can only delete a workflow definition when it is obsolete., type=Information, blocking=true)

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: No inbound caller was exported; this likely starts from UI interaction or navigation.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.Workflow

## Called / Called By

- Calls: none
- Called by: none

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=9fa2c875-ea7c-4a7e-91cd-ce1fb19be095; sourceKind=Database; entity=System.Workflow; summary=retrieve WorkflowList from System.Workflow
- nodeId=70e59e01-d1e2-4fe9-8074-b2005a333796; caption== 0; expression=$WorkflowCount = 0 = 0 expression=$WorkflowCount = 0
- nodeId=c0476c9f-cff2-44e4-a7b6-4f3a51c0d1ad; caption=Obsolete?; expression=$WorkflowDefinition/IsObsolete Obsolete? expression=$WorkflowDefinition/IsObsolete
- nodeId=de370fff-8017-441c-b579-b65ce3b1ac70; actionKind=Delete; members=refreshInClient=true; summary=DeleteAction: delete WorkflowDefinition (refreshInClient=true) delete WorkflowDefinition (refreshInClient=true)
- nodeId=993b2edd-5d4b-4f7b-b09e-d6da8e333bd5; actionKind=Delete; members=text=You can only delete a workflow definition when it is obsolete., type=Information, blocking=true; summary=ShowMessageAction: show message (text=You can only delete a workflow definition when it is obsolete., type=Information, blocking=true) show message (text=You can only delete a workflow definition when it is obsolete., type=Information, blocking=true)

## Warnings/Unknowns

- Rollback hint detected in node detail.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-act-workflowdefinition-delete.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
