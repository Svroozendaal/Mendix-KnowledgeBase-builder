# Domain: System

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| System.ConsumedODataConfiguration | False | 6 | 1 |
| System.Error | False | 3 | 0 |
| System.FileDocument | True | 6 | 0 |
| System.HttpHeader | False | 2 | 1 |
| System.HttpMessage | False | 2 | 1 |
| System.HttpRequest | True | 1 | 1 |
| System.HttpResponse | True | 2 | 1 |
| System.Image | True | 2 | 0 |
| System.Language | True | 2 | 1 |
| System.ODataResponse | False | 1 | 1 |
| System.Paging | False | 5 | 1 |
| System.ProcessedQueueTask | True | 19 | 1 |
| System.QueuedTask | True | 17 | 1 |
| System.ScheduledEventInformation | True | 5 | 1 |
| System.Session | True | 3 | 1 |
| System.SoapFault | True | 5 | 0 |
| System.SynchronizationError | True | 4 | 1 |
| System.SynchronizationErrorFile | True | 0 | 1 |
| System.TaskQueueToken | True | 3 | 1 |
| System.TimeZone | True | 3 | 1 |
| System.TokenInformation | True | 3 | 1 |
| System.User | True | 9 | 1 |
| System.UserReportInfo | True | 2 | 0 |
| System.UserRole | True | 3 | 1 |
| System.Workflow | True | 10 | 2 |
| System.WorkflowActivityDetails | False | 4 | 1 |
| System.WorkflowActivityRecord | False | 17 | 1 |
| System.WorkflowCurrentActivity | False | 1 | 1 |
| System.WorkflowDefinition | True | 4 | 1 |
| System.WorkflowEvent | False | 2 | 1 |
| System.WorkflowJumpToDetails | False | 1 | 1 |
| System.WorkflowRecord | False | 8 | 1 |
| System.WorkflowUserTask | True | 8 | 2 |
| System.WorkflowUserTaskDefinition | True | 2 | 1 |
| System.WorkflowUserTaskOutcome | True | 2 | 2 |
| System.XASInstance | True | 5 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| System.ConsumedODataConfiguration | none | none | none | none |
| System.Error | none | none | none | none |
| System.FileDocument | none | none | none | none |
| System.HttpHeader | none | none | none | none |
| System.HttpMessage | none | none | none | none |
| System.HttpRequest | none | none | none | none |
| System.HttpResponse | none | none | none | none |
| System.Image | none | none | none | none |
| System.Language | none | none | none | none |
| System.ODataResponse | none | none | none | none |
| System.Paging | none | none | none | none |
| System.ProcessedQueueTask | none | none | none | none |
| System.QueuedTask | none | none | none | none |
| System.ScheduledEventInformation | none | none | none | none |
| System.Session | none | none | none | none |
| System.SoapFault | none | none | none | none |
| System.SynchronizationError | none | none | none | none |
| System.SynchronizationErrorFile | none | none | none | none |
| System.TaskQueueToken | none | none | none | none |
| System.TimeZone | none | none | none | none |
| System.TokenInformation | none | none | none | none |
| System.User | WorkflowCommons.SUB_UserTask_Assignee_Add, WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Add, WorkflowCommons.SUB_UserTask_TargetUser_Remove, WorkflowCommons.SUB_WorkflowEvent_AuditTrail | FeedbackModule.PopulateUserAttributes, WorkflowCommons.SUB_UserTask_Assign, WorkflowCommons.SUB_UserTask_Assignee_Add, WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Add, WorkflowCommons.SUB_UserTask_TargetUser_Remove | none | FeedbackModule.PopulateUserAttributes, WorkflowCommons.SUB_UserTask_Assign |
| System.UserReportInfo | none | none | none | none |
| System.UserRole | none | none | none | none |
| System.Workflow | none | WorkflowCommons.SUB_CleanupHelper_Execute_Workflow | WorkflowCommons.ACT_WorkflowDefinition_Delete, WorkflowCommons.SUB_CleanupHelper_Execute_Workflow | WorkflowCommons.ACT_WorkflowDefinition_Delete, WorkflowCommons.SUB_CleanupHelper_Execute_Workflow, WorkflowCommons.SUB_Workflow_CountAlmostDue, WorkflowCommons.SUB_Workflow_CountInProgress, WorkflowCommons.SUB_Workflow_CountOverdue |
| System.WorkflowActivityDetails | none | none | none | none |
| System.WorkflowActivityRecord | none | none | none | none |
| System.WorkflowCurrentActivity | none | none | none | none |
| System.WorkflowDefinition | WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation | WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation | none | WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition, WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation |
| System.WorkflowEvent | none | none | none | none |
| System.WorkflowJumpToDetails | none | none | none | none |
| System.WorkflowRecord | none | none | none | none |
| System.WorkflowUserTask | none | WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting, WorkflowCommons.SUB_TaskCount_Update | none | WorkflowCommons.ACT_Workflow_Retry, WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_UserTask_CountAlmostDue, WorkflowCommons.SUB_UserTask_CountInProgress, WorkflowCommons.SUB_UserTask_CountOverdue |
| System.WorkflowUserTaskDefinition | WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation, WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate | WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation | none | WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_Administrator, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation, WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate |
| System.WorkflowUserTaskOutcome | none | none | none | WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser |
| System.XASInstance | none | none | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| System.ConsumedODataConfiguration | System.Administrator, System.User | ReadWrite | none |
| System.HttpHeader | System.Administrator, System.User | ReadWrite | none |
| System.HttpMessage | System.Administrator, System.User | ReadWrite | none |
| System.HttpRequest | System.Administrator, System.User | ReadWrite | none |
| System.HttpResponse | System.Administrator, System.User | ReadWrite | none |
| System.Language | System.Administrator, System.User | None | none |
| System.ODataResponse | System.Administrator, System.User | ReadWrite | none |
| System.Paging | System.Administrator, System.User | ReadWrite | none |
| System.ProcessedQueueTask | System.Administrator | None | none |
| System.QueuedTask | System.Administrator | None | none |
| System.ScheduledEventInformation | System.Administrator | None | none |
| System.Session | System.Administrator | None | none |
| System.SynchronizationError | System.Administrator | ReadOnly | none |
| System.SynchronizationErrorFile | System.Administrator | ReadOnly | none |
| System.TaskQueueToken | System.Administrator | ReadOnly | none |
| System.TimeZone | System.Administrator, System.User | None | none |
| System.TokenInformation | System.Administrator | None | none |
| System.User | System.Administrator, System.User | None | [id = '[%CurrentUser%]'] |
| System.UserRole | System.Administrator, System.User | None | [System.UserRoles = '[%CurrentUser%]' or System.grantableRoles[reversed()]/System.UserRole/System.UserRoles = '[%CurrentUser%]'] |
| System.Workflow | System.Administrator | None | none |
| System.Workflow | System.User | None | [System.WorkflowUserTask_Workflow/System.WorkflowUserTask[State = 'InProgress' and (System.WorkflowUserTask_TargetUsers = '[%CurrentUser%]' or System.WorkflowUserTask_Assignees = '[%CurrentUser%]')]] |
| System.WorkflowActivityDetails | System.Administrator, System.User | None | none |
| System.WorkflowActivityRecord | System.Administrator, System.User | None | none |
| System.WorkflowCurrentActivity | System.Administrator, System.User | None | none |
| System.WorkflowDefinition | System.Administrator | None | none |
| System.WorkflowEvent | System.Administrator, System.User | None | none |
| System.WorkflowJumpToDetails | System.Administrator, System.User | None | none |
| System.WorkflowRecord | System.Administrator, System.User | None | none |
| System.WorkflowUserTask | System.Administrator | None | none |
| System.WorkflowUserTask | System.User | None | [State = 'InProgress' and (System.WorkflowUserTask_TargetUsers = '[%CurrentUser%]' or System.WorkflowUserTask_Assignees = '[%CurrentUser%]') and System.WorkflowUserTask_Workflow/System.Workflow[State != 'Incompatible' and State != 'Failed']] |
| System.WorkflowUserTaskDefinition | System.Administrator | None | none |
| System.WorkflowUserTaskOutcome | System.Administrator | None | none |
| System.WorkflowUserTaskOutcome | System.User | None | [System.WorkflowUserTaskOutcome_WorkflowUserTask/System.WorkflowUserTask/State = 'InProgress' and (System.WorkflowUserTaskOutcome_WorkflowUserTask/System.WorkflowUserTask/System.WorkflowUserTask_TargetUsers = '[%CurrentUser%]' or System.WorkflowUserTaskOutcome_WorkflowUserTask/System.WorkflowUserTask/System.WorkflowUserTask_Assignees = '[%CurrentUser%]') and System.WorkflowUserTaskOutcome_WorkflowUserTask/System.WorkflowUserTask/System.WorkflowUserTask_Workflow/System.Workflow[State != 'Incompatible' and State != 'Failed']] |
| System.XASInstance | System.Administrator | None | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| System.grantableRoles | System.UserRole | System.UserRole | *-* | ReferenceSet | Default |
| System.HttpHeaders | System.HttpHeader | System.HttpMessage | *-1 | Reference | Default |
| System.HttpHeader_ConsumedODataConfiguration | System.HttpHeader | System.ConsumedODataConfiguration | *-1 | Reference | Default |
| System.ScheduledEventInformation_XASInstance | System.ScheduledEventInformation | System.XASInstance | *-1 | Reference | Default |
| System.Session_User | System.Session | System.User | *-1 | Reference | Default |
| System.SynchronizationErrorFile_SynchronizationError | System.SynchronizationErrorFile | System.SynchronizationError | *-1 | Reference | Default |
| System.TokenInformation_User | System.TokenInformation | System.User | *-1 | Reference | Default |
| System.UserReportInfo_User | System.UserReportInfo | System.User | *-1 | Reference | Default |
| System.UserRoles | System.User | System.UserRole | *-* | ReferenceSet | Default |
| System.User_Language | System.User | System.Language | *-1 | Reference | Default |
| System.User_TimeZone | System.User | System.TimeZone | *-1 | Reference | Default |
| System.WorkflowActivityRecord_Actor | System.WorkflowActivityRecord | System.User | *-1 | Reference | Default |
| System.WorkflowActivityRecord_PreviousActivity | System.WorkflowActivityRecord | System.WorkflowActivityRecord | *-1 | Reference | Default |
| System.WorkflowActivityRecord_SubWorkflow | System.WorkflowActivityRecord | System.WorkflowRecord | *-1 | Reference | Default |
| System.WorkflowActivityRecord_TaskAssignedUsers | System.WorkflowActivityRecord | System.User | *-* | ReferenceSet | Default |
| System.WorkflowActivityRecord_TaskTargetedUsers | System.WorkflowActivityRecord | System.User | *-* | ReferenceSet | Default |
| System.WorkflowActivityRecord_UserTask | System.WorkflowActivityRecord | System.WorkflowUserTask | *-1 | Reference | Default |
| System.WorkflowActivityRecord_WorkflowUserTaskDefinition | System.WorkflowActivityRecord | System.WorkflowUserTaskDefinition | *-1 | Reference | Default |
| System.WorkflowCurrentActivity_ActivityDetails | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-1 | Reference | Default |
| System.WorkflowCurrentActivity_ApplicableTargets | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-* | ReferenceSet | Default |
| System.WorkflowCurrentActivity_JumpToTarget | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-1 | Reference | Default |
| System.WorkflowEvent_Initiator | System.WorkflowEvent | System.User | *-1 | Reference | Default |
| System.WorkflowJumpToDetails_CurrentActivities | System.WorkflowJumpToDetails | System.WorkflowCurrentActivity | *-* | ReferenceSet | Default |
| System.WorkflowJumpToDetails_Workflow | System.WorkflowJumpToDetails | System.Workflow | *-1 | Reference | Default |
| System.WorkflowRecord_Owner | System.WorkflowRecord | System.User | *-1 | Reference | Default |
| System.WorkflowRecord_Workflow | System.WorkflowRecord | System.Workflow | *-1 | Reference | Default |
| System.WorkflowRecord_WorkflowDefinition | System.WorkflowRecord | System.WorkflowDefinition | *-1 | Reference | Default |
| System.WorkflowUserTaskDefinition_WorkflowDefinition | System.WorkflowUserTaskDefinition | System.WorkflowDefinition | *-1 | Reference | Default |
| System.WorkflowUserTaskOutcome_User | System.WorkflowUserTaskOutcome | System.User | *-1 | Reference | Default |
| System.WorkflowUserTaskOutcome_WorkflowUserTask | System.WorkflowUserTaskOutcome | System.WorkflowUserTask | *-1 | Reference | Default |
| System.WorkflowUserTask_Assignees | System.WorkflowUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowUserTask_TargetUsers | System.WorkflowUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowUserTask_Workflow | System.WorkflowUserTask | System.Workflow | *-1 | Reference | Default |
| System.WorkflowUserTask_WorkflowUserTaskDefinition | System.WorkflowUserTask | System.WorkflowUserTaskDefinition | *-1 | Reference | Default |
| System.Workflow_ParentWorkflow | System.Workflow | System.Workflow | *-1 | Reference | Default |
| System.Workflow_WorkflowDefinition | System.Workflow | System.WorkflowDefinition | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| System.ContextType | 4 | Anonymous, ScheduledEvent, System, User |
| System.DeviceType | 3 | Desktop, Phone, Tablet |
| System.EventStatus | 4 | Completed, Error, Running, Stopped |
| System.ProxyConfiguration | 3 | NoProxy, Override, UseAppSettings |
| System.QueueTaskStatus | 7 | Aborted, Completed, Failed, Idle |
| System.UserType | 2 | External, Internal |
| System.WorkflowActivityExecutionState | 6 | Aborted, Completed, Created, Failed |
| System.WorkflowActivityType | 16 | CallMicroflow, CallWorkflow, End, EndOfBoundaryEventPath |
| System.WorkflowCurrentActivityAction | 2 | DoNothing, JumpTo |
| System.WorkflowEventType | 32 | CallMicroflowEnded, CallMicroflowStarted, CallWorkflowEnded, CallWorkflowStarted |
| System.WorkflowState | 6 | Aborted, Completed, Failed, Incompatible |
| System.WorkflowUserTaskCompletionType | 6 | Consensus, Majority, Microflow, Single |
| System.WorkflowUserTaskState | 6 | Aborted, Completed, Created, Failed |

## Entity Index

<a id="entity-system-consumedodataconfiguration"></a>
### System.ConsumedODataConfiguration

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-error"></a>
### System.Error

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-filedocument"></a>
### System.FileDocument

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-httpheader"></a>
### System.HttpHeader

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-httpmessage"></a>
### System.HttpMessage

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-httprequest"></a>
### System.HttpRequest

- Generalization: System.HttpMessage.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-httpresponse"></a>
### System.HttpResponse

- Generalization: System.HttpMessage.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-image"></a>
### System.Image

- Generalization: System.FileDocument.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-language"></a>
### System.Language

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-odataresponse"></a>
### System.ODataResponse

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-paging"></a>
### System.Paging

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-processedqueuetask"></a>
### System.ProcessedQueueTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-queuedtask"></a>
### System.QueuedTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-scheduledeventinformation"></a>
### System.ScheduledEventInformation

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-session"></a>
### System.Session

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-soapfault"></a>
### System.SoapFault

- Generalization: System.Error.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-synchronizationerror"></a>
### System.SynchronizationError

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-synchronizationerrorfile"></a>
### System.SynchronizationErrorFile

- Generalization: System.FileDocument.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-taskqueuetoken"></a>
### System.TaskQueueToken

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-timezone"></a>
### System.TimeZone

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-tokeninformation"></a>
### System.TokenInformation

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-user"></a>
### System.User

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_UserTask_Assignee_Add, WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Add, WorkflowCommons.SUB_UserTask_TargetUser_Remove, WorkflowCommons.SUB_WorkflowEvent_AuditTrail; update=FeedbackModule.PopulateUserAttributes, WorkflowCommons.SUB_UserTask_Assign, WorkflowCommons.SUB_UserTask_Assignee_Add, WorkflowCommons.SUB_UserTask_Assignee_Remove, WorkflowCommons.SUB_UserTask_TargetUser_Add, WorkflowCommons.SUB_UserTask_TargetUser_Remove; delete=none; read=FeedbackModule.PopulateUserAttributes, WorkflowCommons.SUB_UserTask_Assign.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-userreportinfo"></a>
### System.UserReportInfo

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-userrole"></a>
### System.UserRole

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflow"></a>
### System.Workflow

- Generalization: none.
- Lifecycle: create=none; update=WorkflowCommons.SUB_CleanupHelper_Execute_Workflow; delete=WorkflowCommons.ACT_WorkflowDefinition_Delete, WorkflowCommons.SUB_CleanupHelper_Execute_Workflow; read=WorkflowCommons.ACT_WorkflowDefinition_Delete, WorkflowCommons.SUB_CleanupHelper_Execute_Workflow, WorkflowCommons.SUB_Workflow_CountAlmostDue, WorkflowCommons.SUB_Workflow_CountInProgress, WorkflowCommons.SUB_Workflow_CountOverdue.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowactivitydetails"></a>
### System.WorkflowActivityDetails

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowactivityrecord"></a>
### System.WorkflowActivityRecord

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowcurrentactivity"></a>
### System.WorkflowCurrentActivity

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowdefinition"></a>
### System.WorkflowDefinition

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation; update=WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation; delete=none; read=WorkflowCommons.DashboardContext_GetSelectedWorkflowDefinition, WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowevent"></a>
### System.WorkflowEvent

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowjumptodetails"></a>
### System.WorkflowJumpToDetails

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowrecord"></a>
### System.WorkflowRecord

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowusertask"></a>
### System.WorkflowUserTask

- Generalization: none.
- Lifecycle: create=none; update=WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting, WorkflowCommons.SUB_TaskCount_Update; delete=none; read=WorkflowCommons.ACT_Workflow_Retry, WorkflowCommons.ACT_Workflow_Retry_RerunUserTargeting, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_UserTask_CountAlmostDue, WorkflowCommons.SUB_UserTask_CountInProgress, WorkflowCommons.SUB_UserTask_CountOverdue.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowusertaskdefinition"></a>
### System.WorkflowUserTaskDefinition

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation, WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate; update=WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation; delete=none; read=WorkflowCommons.DashboardContext_GetSelectedWorkflowTaskDefinition, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_Administrator, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation, WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-workflowusertaskoutcome"></a>
### System.WorkflowUserTaskOutcome

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=WorkflowCommons.SUB_UserTaskOutcome_AssignedToUser.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).
<a id="entity-system-xasinstance"></a>
### System.XASInstance

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/System/domain-model.json)
