---
objectType: flow
module: WorkflowCommons
qualifiedName: WorkflowCommons.SUB_WorkflowEvent_AuditTrail
stableId: d6eb7b81-e111-49c3-befa-f7d0830ce6df
slug: workflowcommons-sub-workflowevent-audittrail
layer: L1
l0: workflowcommons-sub-workflowevent-audittrail.abstract.md
l2Path: ../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowevent-audittrail.json
l2Logical: flow:WorkflowCommons.SUB_WorkflowEvent_AuditTrail
sourceRun: cli_2026-03-14T09-23-46.259Z
collectionL0: INDEX.abstract.md
collectionL1: ../FLOWS.md
---
# Flow Overview: WorkflowCommons.SUB_WorkflowEvent_AuditTrail

## Summary

- Likely acts as a save, process, or background step for System.User, WorkflowCommons.WorkflowAuditTrailRecord because it mutates data without showing a page.
- L0: [abstract](workflowcommons-sub-workflowevent-audittrail.abstract.md)
- L2: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowevent-audittrail.json)

## Main Steps

- CreateObjectAction: create WorkflowCommons.WorkflowAuditTrailRecord as NewWorkflowAuditTrail (EventTimestamp=$WorkflowEvent/EventTime, EventType=$WorkflowEvent/EventType, EventLevel=$EventLevel, ActivityCaption=$WorkflowActivityRecord/Caption, EventInitiator=$WorkflowEvent/System.WorkflowEvent_Initiator/System.User/Name, WorkflowKey=$WorkflowRecord/WorkflowKey, WorkflowName=$WorkflowRecord/Name, WorkflowState=$WorkflowRecord/State, +9 more) create WorkflowCommons.WorkflowAuditTrailRecord as NewWorkflowAuditTrail (EventTimestamp=$WorkflowEvent/EventTime, EventType=$WorkflowEvent/EventType, EventLevel=$EventLevel, ActivityCaption=$WorkflowActivityRecord/Caption, EventInitiator=$WorkflowEvent/System.WorkflowEvent_Initiator/System.User/Name, WorkflowKey=$WorkflowRecord/WorkflowKey, WorkflowName=$WorkflowRecord/Name, WorkflowState=$WorkflowRecord/State, +9 more)
- CreateVariableAction: create variable ActivityKey=if $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.UserTask and $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/ActivityKey else emp... create variable ActivityKey=if $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.UserTask and $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/ActivityKey else emp...

## Trigger/Input/Output Context

- Kind: Microflow
- Entry/call context: Called by WorkflowCommons.WFEH_WorkflowEvent_AuditTrail.
- Output/UI context: No page output was exported; this likely completes a save, process, or background step.

## Key Entities Touched

- System.User, WorkflowCommons.WorkflowAuditTrailRecord

## Called / Called By

- Calls: none
- Called by: WorkflowCommons.WFEH_WorkflowEvent_AuditTrail

## Shown Pages

- No ShowPageAction was exported for this flow; it likely completes work without returning a page.

## Important Retrieves/Decisions/Mutations

- nodeId=05a150e0-863e-43c6-b8e4-5979e13ccf8b; actionKind=Create; entity=WorkflowCommons.WorkflowAuditTrailRecord; members=EventTimestamp=$WorkflowEvent/EventTime, EventType=$WorkflowEvent/EventType, EventLevel=$EventLevel, ActivityCaption=$WorkflowActivityRecord/Caption, EventInitiator=$WorkflowEvent/System.WorkflowEvent_Initiator/System.User/Name, WorkflowKey=$WorkflowRecord/WorkflowKey, WorkflowName=$WorkflowRecord/Name, WorkflowState=$WorkflowRecord/State, +9 more; summary=CreateObjectAction: create WorkflowCommons.WorkflowAuditTrailRecord as NewWorkflowAuditTrail (EventTimestamp=$WorkflowEvent/EventTime, EventType=$WorkflowEvent/EventType, EventLevel=$EventLevel, ActivityCaption=$WorkflowActivityRecord/Caption, EventInitiator=$WorkflowEvent/System.WorkflowEvent_Initiator/System.User/Name, WorkflowKey=$WorkflowRecord/WorkflowKey, WorkflowName=$WorkflowRecord/Name, WorkflowState=$WorkflowRecord/State, +9 more) create WorkflowCommons.WorkflowAuditTrailRecord as NewWorkflowAuditTrail (EventTimestamp=$WorkflowEvent/EventTime, EventType=$WorkflowEvent/EventType, EventLevel=$EventLevel, ActivityCaption=$WorkflowActivityRecord/Caption, EventInitiator=$WorkflowEvent/System.WorkflowEvent_Initiator/System.User/Name, WorkflowKey=$WorkflowRecord/WorkflowKey, WorkflowName=$WorkflowRecord/Name, WorkflowState=$WorkflowRecord/State, +9 more)
- nodeId=0acacc5e-170e-4c97-8216-7c5b31c381ee; actionKind=Create; entity=System.WorkflowActivityType; summary=CreateVariableAction: create variable ActivityKey=if $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.UserTask and $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/ActivityKey else emp... create variable ActivityKey=if $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.UserTask and $WorkflowActivityRecord/ActivityType != System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/ActivityKey else emp...
- nodeId=d3c19034-a091-4171-a791-94316e587a34; actionKind=Create; entity=WorkflowCommons.Enum_AuditTrail_EventLevel; summary=CreateVariableAction: create variable EventLevel=if $WorkflowActivityRecord/ActivityType != empty then WorkflowCommons.Enum_AuditTrail_EventLevel.ActivityEvent else WorkflowCommons.Enum_AuditTrail_EventLevel.WorkflowEvent create variable EventLevel=if $WorkflowActivityRecord/ActivityType != empty then WorkflowCommons.Enum_AuditTrail_EventLevel.ActivityEvent else WorkflowCommons.Enum_AuditTrail_EventLevel.WorkflowEvent
- nodeId=3f3b0115-7ba0-4f23-8306-e81650807d23; actionKind=Create; summary=CreateVariableAction: create variable Reason=if $WorkflowActivityRecord/Reason != empty then $WorkflowActivityRecord/Reason else $WorkflowRecord/Reason create variable Reason=if $WorkflowActivityRecord/Reason != empty then $WorkflowActivityRecord/Reason else $WorkflowRecord/Reason
- nodeId=7a397ae8-eeda-4715-aca3-3211577e0839; actionKind=Create; entity=System.WorkflowActivityType; summary=CreateVariableAction: create variable UserTaskKey=if $WorkflowActivityRecord/ActivityType = System.WorkflowActivityType.UserTask or $WorkflowActivityRecord/ActivityType = System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/TaskKey else empty create variable UserTaskKey=if $WorkflowActivityRecord/ActivityType = System.WorkflowActivityType.UserTask or $WorkflowActivityRecord/ActivityType = System.WorkflowActivityType.MultiInputUserTask then $WorkflowActivityRecord/TaskKey else empty

## Warnings/Unknowns

- No material warnings from deterministic export synthesis.

## Source

- Stable JSON: [json](../../../../../app-overview/current/modules/marketplace/WorkflowCommons/flows/workflowcommons-sub-workflowevent-audittrail.json)
- Aggregate export: [flows.json](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.json)
- Aggregate pseudo: [flows.pseudo.txt](../../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/flows.pseudo.txt)
- Traceability: sourceRun=cli_2026-03-14T09-23-46.259Z
