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
| System.WorkflowActivityRecord | False | 18 | 1 |
| System.WorkflowCurrentActivity | False | 1 | 1 |
| System.WorkflowDefinition | True | 4 | 1 |
| System.WorkflowEndedUserTask | True | 9 | 2 |
| System.WorkflowEndedUserTaskOutcome | True | 2 | 2 |
| System.WorkflowEvent | False | 2 | 1 |
| System.WorkflowGroup | True | 2 | 2 |
| System.WorkflowJumpToDetails | False | 1 | 1 |
| System.WorkflowRecord | False | 8 | 1 |
| System.WorkflowSubProcess | True | 5 | 1 |
| System.WorkflowSubProcessDefinition | True | 2 | 1 |
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
| System.TimeZone | none | none | none | Administration.RetrieveTimeZones |
| System.TokenInformation | none | none | none | none |
| System.User | none | none | none | none |
| System.UserReportInfo | none | none | none | none |
| System.UserRole | Inspection.ACT_Registration_Save, Inspection.BCo_Inspector [members unknown] | Inspection.ACT_Registration_Save [members unknown] | none | Inspection.ACT_Registration_Save, Inspection.BCo_Inspector |
| System.Workflow | none | none | none | none |
| System.WorkflowActivityDetails | none | none | none | none |
| System.WorkflowActivityRecord | none | none | none | none |
| System.WorkflowCurrentActivity | none | none | none | none |
| System.WorkflowDefinition | none | none | none | none |
| System.WorkflowEndedUserTask | none | none | none | none |
| System.WorkflowEndedUserTaskOutcome | none | none | none | none |
| System.WorkflowEvent | none | none | none | none |
| System.WorkflowGroup | none | none | none | none |
| System.WorkflowJumpToDetails | none | none | none | none |
| System.WorkflowRecord | none | none | none | none |
| System.WorkflowSubProcess | none | none | none | none |
| System.WorkflowSubProcessDefinition | none | none | none | none |
| System.WorkflowUserTask | none | none | none | none |
| System.WorkflowUserTaskDefinition | none | none | none | none |
| System.WorkflowUserTaskOutcome | none | none | none | none |
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
| System.Workflow | System.User | None | [   System.WorkflowUserTask_Workflow/System.WorkflowUserTask[     State = 'InProgress'   and     (       System.WorkflowUserTask_TargetUsers = '[%CurrentUser%]'     or       System.WorkflowUserTask_TargetGroups/System.WorkflowGroup/System.WorkflowGroup_User = '[%CurrentUser%]'     or       System.WorkflowUserTask_Assignees = '[%CurrentUser%]'     )   ] ] |
| System.WorkflowActivityDetails | System.Administrator, System.User | None | none |
| System.WorkflowActivityRecord | System.Administrator, System.User | ReadOnly | none |
| System.WorkflowCurrentActivity | System.Administrator, System.User | None | none |
| System.WorkflowDefinition | System.Administrator | None | none |
| System.WorkflowEndedUserTask | System.Administrator | None | none |
| System.WorkflowEndedUserTask | System.User | None | [System.WorkflowEndedUserTask_Assignees = '[%CurrentUser%]'] |
| System.WorkflowEndedUserTaskOutcome | System.Administrator | None | none |
| System.WorkflowEndedUserTaskOutcome | System.User | None | [System.WorkflowEndedUserTaskOutcome_WorkflowEndedUserTask/System.WorkflowEndedUserTask/System.WorkflowEndedUserTask_Assignees = '[%CurrentUser%]'] |
| System.WorkflowEvent | System.Administrator, System.User | None | none |
| System.WorkflowGroup | System.Administrator | ReadOnly | none |
| System.WorkflowGroup | System.User | None | [System.WorkflowGroup_User = '[%CurrentUser%]'] |
| System.WorkflowJumpToDetails | System.Administrator, System.User | None | none |
| System.WorkflowRecord | System.Administrator, System.User | None | none |
| System.WorkflowSubProcess | System.Administrator | None | none |
| System.WorkflowSubProcessDefinition | System.Administrator | None | none |
| System.WorkflowUserTask | System.Administrator | None | none |
| System.WorkflowUserTask | System.User | None | [   State = 'InProgress' and   (     System.WorkflowUserTask_TargetUsers = '[%CurrentUser%]'   or     System.WorkflowUserTask_TargetGroups/System.WorkflowGroup/System.WorkflowGroup_User = '[%CurrentUser%]'   or     System.WorkflowUserTask_Assignees = '[%CurrentUser%]'   ) and   System.WorkflowUserTask_Workflow/System.Workflow[State != 'Incompatible' and State != 'Failed'] ] |
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
| System.WorkflowActivityRecord_TaskTargetedGroups | System.WorkflowActivityRecord | System.WorkflowGroup | *-* | ReferenceSet | Default |
| System.WorkflowActivityRecord_TaskTargetedUsers | System.WorkflowActivityRecord | System.User | *-* | ReferenceSet | Default |
| System.WorkflowActivityRecord_UserTask | System.WorkflowActivityRecord | System.WorkflowUserTask | *-1 | Reference | Default |
| System.WorkflowActivityRecord_WorkflowSubProcess | System.WorkflowActivityRecord | System.WorkflowSubProcess | *-1 | Reference | Default |
| System.WorkflowActivityRecord_WorkflowSubProcessDefinition | System.WorkflowActivityRecord | System.WorkflowSubProcessDefinition | *-1 | Reference | Default |
| System.WorkflowActivityRecord_WorkflowUserTaskDefinition | System.WorkflowActivityRecord | System.WorkflowUserTaskDefinition | *-1 | Reference | Default |
| System.WorkflowCurrentActivity_ActivityDetails | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-1 | Reference | Default |
| System.WorkflowCurrentActivity_ApplicableTargets | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-* | ReferenceSet | Default |
| System.WorkflowCurrentActivity_JumpToTarget | System.WorkflowCurrentActivity | System.WorkflowActivityDetails | *-1 | Reference | Default |
| System.WorkflowCurrentActivity_WorkflowSubProcess | System.WorkflowCurrentActivity | System.WorkflowSubProcess | *-1 | Reference | Default |
| System.WorkflowEndedUserTaskOutcome_User | System.WorkflowEndedUserTaskOutcome | System.User | *-1 | Reference | Default |
| System.WorkflowEndedUserTaskOutcome_WorkflowEndedUserTask | System.WorkflowEndedUserTaskOutcome | System.WorkflowEndedUserTask | *-1 | Reference | Default |
| System.WorkflowEndedUserTask_Assignees | System.WorkflowEndedUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowEndedUserTask_TargetGroups | System.WorkflowEndedUserTask | System.WorkflowGroup | *-* | ReferenceSet | Default |
| System.WorkflowEndedUserTask_TargetUsers | System.WorkflowEndedUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowEndedUserTask_Workflow | System.WorkflowEndedUserTask | System.Workflow | *-1 | Reference | Default |
| System.WorkflowEndedUserTask_WorkflowSubProcess | System.WorkflowEndedUserTask | System.WorkflowSubProcess | *-1 | Reference | Default |
| System.WorkflowEndedUserTask_WorkflowUserTaskDefinition | System.WorkflowEndedUserTask | System.WorkflowUserTaskDefinition | *-1 | Reference | Default |
| System.WorkflowEvent_Initiator | System.WorkflowEvent | System.User | *-1 | Reference | Default |
| System.WorkflowGroup_User | System.WorkflowGroup | System.User | *-* | ReferenceSet | Default |
| System.WorkflowJumpToDetails_CurrentActivities | System.WorkflowJumpToDetails | System.WorkflowCurrentActivity | *-* | ReferenceSet | Default |
| System.WorkflowJumpToDetails_Workflow | System.WorkflowJumpToDetails | System.Workflow | *-1 | Reference | Default |
| System.WorkflowRecord_Owner | System.WorkflowRecord | System.User | *-1 | Reference | Default |
| System.WorkflowRecord_Workflow | System.WorkflowRecord | System.Workflow | *-1 | Reference | Default |
| System.WorkflowRecord_WorkflowDefinition | System.WorkflowRecord | System.WorkflowDefinition | *-1 | Reference | Default |
| System.WorkflowSubProcessDefinition_WorkflowDefinition | System.WorkflowSubProcessDefinition | System.WorkflowDefinition | *-1 | Reference | Default |
| System.WorkflowSubProcess_Workflow | System.WorkflowSubProcess | System.Workflow | *-1 | Reference | Default |
| System.WorkflowSubProcess_WorkflowSubProcessDefinition | System.WorkflowSubProcess | System.WorkflowSubProcessDefinition | *-1 | Reference | Default |
| System.WorkflowUserTaskDefinition_WorkflowDefinition | System.WorkflowUserTaskDefinition | System.WorkflowDefinition | *-1 | Reference | Default |
| System.WorkflowUserTaskDefinition_WorkflowSubProcessDefinition | System.WorkflowUserTaskDefinition | System.WorkflowSubProcessDefinition | *-1 | Reference | Default |
| System.WorkflowUserTaskOutcome_User | System.WorkflowUserTaskOutcome | System.User | *-1 | Reference | Default |
| System.WorkflowUserTaskOutcome_WorkflowUserTask | System.WorkflowUserTaskOutcome | System.WorkflowUserTask | *-1 | Reference | Default |
| System.WorkflowUserTask_Assignees | System.WorkflowUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowUserTask_TargetGroups | System.WorkflowUserTask | System.WorkflowGroup | *-* | ReferenceSet | Default |
| System.WorkflowUserTask_TargetUsers | System.WorkflowUserTask | System.User | *-* | ReferenceSet | Default |
| System.WorkflowUserTask_Workflow | System.WorkflowUserTask | System.Workflow | *-1 | Reference | Default |
| System.WorkflowUserTask_WorkflowSubProcess | System.WorkflowUserTask | System.WorkflowSubProcess | *-1 | Reference | Default |
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
| System.WorkflowActivityType | 17 | CallMicroflow, CallWorkflow, End, EndOfBoundaryEventPath |
| System.WorkflowCurrentActivityAction | 2 | DoNothing, JumpTo |
| System.WorkflowEventType | 33 | CallMicroflowEnded, CallMicroflowStarted, CallWorkflowEnded, CallWorkflowStarted |
| System.WorkflowState | 6 | Aborted, Completed, Failed, Incompatible |
| System.WorkflowSubProcessState | 5 | Aborted, Completed, Failed, InProgress |
| System.WorkflowUserTaskCompletionType | 6 | Consensus, Majority, Microflow, Single |
| System.WorkflowUserTaskState | 6 | Aborted, Completed, Created, Failed |

## Entity Index

<a id="entity-system-consumedodataconfiguration"></a>
### System.ConsumedODataConfiguration

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ProxyConfiguration | System.ProxyConfiguration | — | — | — |
| ProxyHost | String | 0 | — | — |
| ProxyPassword | String | 0 | — | — |
| ProxyPort | Integer | — | — | — |
| ProxyUsername | String | 0 | — | — |
| ServiceUrl | String | 0 | — | — |
<a id="entity-system-error"></a>
### System.Error

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ErrorType | String | 0 | — | — |
| Message | String | 0 | — | — |
| Stacktrace | String | 0 | — | — |
<a id="entity-system-filedocument"></a>
### System.FileDocument

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Contents | Binary | — | — | — |
| DeleteAfterDownload | Boolean | — | false | — |
| FileID | AutoNumber | — | 1 | — |
| HasContents | Boolean | — | false | — |
| Name | String | 400 | — | — |
| Size | Long | — | -1 | — |
<a id="entity-system-httpheader"></a>
### System.HttpHeader

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Key | String | 0 | — | — |
| Value | String | 0 | — | — |
<a id="entity-system-httpmessage"></a>
### System.HttpMessage

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Content | String | 0 | — | — |
| HttpVersion | String | 10 | HTTP/1.1 | — |
<a id="entity-system-httprequest"></a>
### System.HttpRequest

- Generalization: System.HttpMessage.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Uri | String | 0 | — | — |
<a id="entity-system-httpresponse"></a>
### System.HttpResponse

- Generalization: System.HttpMessage.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ReasonPhrase | String | 0 | OK | — |
| StatusCode | Integer | — | 200 | — |
<a id="entity-system-image"></a>
### System.Image

- Generalization: System.FileDocument.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| EnableCaching | Boolean | — | true | — |
| PublicThumbnailPath | String | 500 | — | — |
<a id="entity-system-language"></a>
### System.Language

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Code | String | 20 | — | — |
| Description | String | 200 | — | — |
<a id="entity-system-odataresponse"></a>
### System.ODataResponse

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Count | Long | — | -1 | — |
<a id="entity-system-paging"></a>
### System.Paging

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| HasMoreData | Boolean | — | true | — |
| IsSortable | Boolean | — | true | — |
| PageNumber | Long | — | 1 | — |
| SortAscending | Boolean | — | true | — |
| SortAttribute | String | 200 | — | — |
<a id="entity-system-processedqueuetask"></a>
### System.ProcessedQueueTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Arguments | String | 0 | — | — |
| ContextData | String | 0 | — | — |
| ContextType | System.ContextType | — | — | — |
| Created | DateTime | — | — | — |
| Duration | Long | — | — | — |
| ErrorMessage | String | 0 | — | — |
| Finished | DateTime | — | — | — |
| MicroflowName | String | 200 | — | — |
| QueueId | String | 36 | — | — |
| QueueName | String | 200 | — | — |
| Retried | Long | — | — | — |
| ScheduledEventName | String | 200 | — | — |
| Sequence | Long | — | — | — |
| StartAt | DateTime | — | — | — |
| Started | DateTime | — | — | — |
| Status | System.QueueTaskStatus | — | — | — |
| ThreadId | Long | — | — | — |
| UserActionName | String | 200 | — | — |
| XASId | String | 50 | — | — |
<a id="entity-system-queuedtask"></a>
### System.QueuedTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Arguments | String | 0 | — | — |
| ContextData | String | 0 | — | — |
| ContextType | System.ContextType | — | — | — |
| Created | DateTime | — | [%CurrentDateTime%] | — |
| MicroflowName | String | 200 | — | — |
| QueueId | String | 36 | — | — |
| QueueName | String | 200 | — | — |
| Retried | Long | — | 0 | — |
| Retry | String | 200 | — | — |
| ScheduledEventName | String | 200 | — | — |
| Sequence | AutoNumber | — | 1 | — |
| StartAt | DateTime | — | — | — |
| Started | DateTime | — | — | — |
| Status | System.QueueTaskStatus | — | Idle | — |
| ThreadId | Long | — | — | — |
| UserActionName | String | 200 | — | — |
| XASId | String | 50 | — | — |
<a id="entity-system-scheduledeventinformation"></a>
### System.ScheduledEventInformation

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Description | String | 0 | — | — |
| EndTime | DateTime | — | — | — |
| Name | String | 200 | — | — |
| StartTime | DateTime | — | — | — |
| Status | System.EventStatus | — | — | — |
<a id="entity-system-session"></a>
### System.Session

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| CSRFToken | String | 36 | — | — |
| LastActive | DateTime | — | — | — |
| SessionId | String | 50 | — | — |
<a id="entity-system-soapfault"></a>
### System.SoapFault

- Generalization: System.Error.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Code | String | 0 | — | — |
| Detail | String | 0 | — | — |
| Node | String | 0 | — | — |
| Reason | String | 0 | — | — |
| Role | String | 0 | — | — |
<a id="entity-system-synchronizationerror"></a>
### System.SynchronizationError

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ObjectContent | String | 0 | — | — |
| ObjectId | String | 200 | — | — |
| ObjectType | String | 1000 | — | — |
| Reason | String | 0 | — | — |
<a id="entity-system-synchronizationerrorfile"></a>
### System.SynchronizationErrorFile

- Generalization: System.FileDocument.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

No attributes (excluding system attributes).
<a id="entity-system-taskqueuetoken"></a>
### System.TaskQueueToken

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| QueueName | String | 200 | — | — |
| ValidUntil | DateTime | — | — | — |
| XASId | String | 50 | — | — |
<a id="entity-system-timezone"></a>
### System.TimeZone

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=Administration.RetrieveTimeZones.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Code | String | 50 | — | — |
| Description | String | 100 | — | — |
| RawOffset | Integer | — | — | — |
<a id="entity-system-tokeninformation"></a>
### System.TokenInformation

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ExpiryDate | DateTime | — | — | — |
| Token | HashedStringAttributeType | — | — | — |
| UserAgent | String | 0 | — | — |
<a id="entity-system-user"></a>
### System.User

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Active | Boolean | — | true | — |
| Blocked | Boolean | — | false | — |
| BlockedSince | DateTime | — | — | — |
| FailedLogins | Integer | — | 0 | — |
| IsAnonymous | Boolean | — | false | — |
| LastLogin | DateTime | — | — | — |
| Name | String | 100 | — | Unique |
| Password | HashedStringAttributeType | — | — | Required |
| WebServiceUser | Boolean | — | false | — |
<a id="entity-system-userreportinfo"></a>
### System.UserReportInfo

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Hash | String | 64 | — | — |
| UserType | System.UserType | — | Internal | Required |
<a id="entity-system-userrole"></a>
### System.UserRole

- Generalization: none.
- Lifecycle: create=Inspection.ACT_Registration_Save, Inspection.BCo_Inspector; update=Inspection.ACT_Registration_Save; delete=none; read=Inspection.ACT_Registration_Save, Inspection.BCo_Inspector.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Description | String | 1000 | — | — |
| ModelGUID | String | 36 | — | — |
| Name | String | 100 | — | — |
<a id="entity-system-workflow"></a>
### System.Workflow

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| CanApplyJumpTo | Boolean | — | true | — |
| CanBeContinued | Boolean | — | false | — |
| CanBeRestarted | Boolean | — | false | — |
| Description | String | 0 | — | — |
| DueDate | DateTime | — | — | — |
| EndTime | DateTime | — | — | — |
| Name | String | 200 | — | — |
| Reason | String | 0 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowState | — | InProgress | — |
<a id="entity-system-workflowactivitydetails"></a>
### System.WorkflowActivityDetails

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ActivityCaption | String | 0 | — | — |
| ActivityId | String | 50 | — | — |
| ActivityType | System.WorkflowActivityType | — | — | — |
| ExistsInCurrentVersion | Boolean | — | true | — |
<a id="entity-system-workflowactivityrecord"></a>
### System.WorkflowActivityRecord

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ActivityKey | String | 200 | — | — |
| ActivityType | System.WorkflowActivityType | — | — | — |
| Caption | String | 0 | — | — |
| EndTime | DateTime | — | — | — |
| MicroflowName | String | 200 | — | — |
| ModelGUID | String | 200 | — | — |
| Outcome | String | 200 | — | — |
| PreviousActivityKey | String | 200 | — | — |
| Reason | String | 0 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowActivityExecutionState | — | — | — |
| SubProcessKey | String | 200 | — | — |
| TaskCompletionType | System.WorkflowUserTaskCompletionType | — | — | — |
| TaskDescription | String | 0 | — | — |
| TaskDueDate | DateTime | — | — | — |
| TaskKey | String | 200 | — | — |
| TaskName | String | 0 | — | — |
| TaskRequiredUsers | Integer | — | 0 | — |
<a id="entity-system-workflowcurrentactivity"></a>
### System.WorkflowCurrentActivity

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Action | System.WorkflowCurrentActivityAction | — | DoNothing | — |
<a id="entity-system-workflowdefinition"></a>
### System.WorkflowDefinition

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| IsLocked | Boolean | — | false | — |
| IsObsolete | Boolean | — | false | — |
| Name | String | 200 | — | — |
| Title | String | 200 | — | — |
<a id="entity-system-workflowendedusertask"></a>
### System.WorkflowEndedUserTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| CompletionType | System.WorkflowUserTaskCompletionType | — | Single | — |
| Description | String | 0 | — | — |
| DueDate | DateTime | — | — | — |
| EndTime | DateTime | — | — | — |
| Name | String | 0 | — | — |
| Outcome | String | 200 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowUserTaskState | — | Created | — |
| UserTaskKey | String | 200 | — | — |
<a id="entity-system-workflowendedusertaskoutcome"></a>
### System.WorkflowEndedUserTaskOutcome

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Outcome | String | 200 | — | — |
| Time | DateTime | — | — | — |
<a id="entity-system-workflowevent"></a>
### System.WorkflowEvent

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| EventTime | DateTime | — | — | — |
| EventType | System.WorkflowEventType | — | — | — |
<a id="entity-system-workflowgroup"></a>
### System.WorkflowGroup

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Description | String | 0 | — | — |
| Name | String | 200 | — | Unique |
<a id="entity-system-workflowjumptodetails"></a>
### System.WorkflowJumpToDetails

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Error | String | 0 | — | — |
<a id="entity-system-workflowrecord"></a>
### System.WorkflowRecord

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Description | String | 0 | — | — |
| DueDate | DateTime | — | — | — |
| EndTime | DateTime | — | — | — |
| Name | String | 200 | — | — |
| Reason | String | 0 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowState | — | — | — |
| WorkflowKey | String | 200 | — | — |
<a id="entity-system-workflowsubprocess"></a>
### System.WorkflowSubProcess

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Caption | String | 200 | — | — |
| EndTime | DateTime | — | — | — |
| Reason | String | 0 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowSubProcessState | — | InProgress | — |
<a id="entity-system-workflowsubprocessdefinition"></a>
### System.WorkflowSubProcessDefinition

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Caption | String | 200 | — | — |
| IsObsolete | Boolean | — | false | — |
<a id="entity-system-workflowusertask"></a>
### System.WorkflowUserTask

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| CompletionType | System.WorkflowUserTaskCompletionType | — | Single | — |
| Description | String | 0 | — | — |
| DueDate | DateTime | — | — | — |
| EndTime | DateTime | — | — | — |
| Name | String | 0 | — | — |
| Outcome | String | 200 | — | — |
| StartTime | DateTime | — | — | — |
| State | System.WorkflowUserTaskState | — | Created | — |
<a id="entity-system-workflowusertaskdefinition"></a>
### System.WorkflowUserTaskDefinition

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| IsObsolete | Boolean | — | false | — |
| Name | String | 200 | — | — |
<a id="entity-system-workflowusertaskoutcome"></a>
### System.WorkflowUserTaskOutcome

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Outcome | String | 200 | — | — |
| Time | DateTime | — | — | — |
<a id="entity-system-xasinstance"></a>
### System.XASInstance

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| AllowedNumberOfConcurrentUsers | Integer | — | — | — |
| CustomerName | String | 200 | — | — |
| LastUpdate | DateTime | — | — | — |
| PartnerName | String | 200 | — | — |
| XASId | String | 50 | — | — |

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/System/domain-model.json)
