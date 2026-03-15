# Domain: WorkflowCommons

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| WorkflowCommons.AssignmentHelper | False | 1 | 1 |
| WorkflowCommons.AuditTrailViewer | False | 2 | 1 |
| WorkflowCommons.CleanupHelper | False | 8 | 1 |
| WorkflowCommons.Configuration | True | 4 | 1 |
| WorkflowCommons.DashboardContext | False | 5 | 1 |
| WorkflowCommons.DefinitionHelper | False | 2 | 1 |
| WorkflowCommons.DurationHelper | False | 1 | 1 |
| WorkflowCommons.NotificationArea | False | 3 | 1 |
| WorkflowCommons.TaskAssignmentHelper | False | 3 | 1 |
| WorkflowCommons.TaskCount | False | 5 | 1 |
| WorkflowCommons.TaskSeries | False | 6 | 1 |
| WorkflowCommons.TaskSummary | False | 7 | 1 |
| WorkflowCommons.TimelineViewer | False | 0 | 1 |
| WorkflowCommons.UserTaskOutcomeView | True | 2 | 2 |
| WorkflowCommons.UserTaskTimeLine | False | 7 | 1 |
| WorkflowCommons.UserTaskView | True | 9 | 2 |
| WorkflowCommons.WorkflowAttachment | True | 0 | 3 |
| WorkflowCommons.WorkflowAuditTrailRecord | True | 15 | 1 |
| WorkflowCommons.WorkflowComment | True | 1 | 3 |
| WorkflowCommons.WorkflowCommentHelper | False | 1 | 1 |
| WorkflowCommons.WorkflowDefinitionHelper | False | 1 | 1 |
| WorkflowCommons.WorkflowSelectionHelper | False | 0 | 1 |
| WorkflowCommons.WorkflowSeries | False | 5 | 1 |
| WorkflowCommons.WorkflowSummary | False | 6 | 1 |
| WorkflowCommons.WorkflowTaskDetail | False | 2 | 1 |
| WorkflowCommons.WorkflowView | True | 8 | 2 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| WorkflowCommons.AssignmentHelper | WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper | none | none | WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper |
| WorkflowCommons.AuditTrailViewer | WorkflowCommons.DS_AuditTrailViewer | none | none | none |
| WorkflowCommons.CleanupHelper | WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open | none | none | none |
| WorkflowCommons.Configuration | WorkflowCommons.SUB_Configuration_FindOrCreate | none | none | WorkflowCommons.SUB_Configuration_FindOrCreate |
| WorkflowCommons.DashboardContext | WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate | none | none | WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate |
| WorkflowCommons.DefinitionHelper | WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation | WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation | none | WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation |
| WorkflowCommons.DurationHelper | WorkflowCommons.SUB_Duration_Calculate | WorkflowCommons.SUB_Duration_Calculate | none | none |
| WorkflowCommons.NotificationArea | WorkflowCommons.DS_Workflow_LoadNotificationArea, WorkflowCommons.DS_WorkflowTask_LoadNotificationArea, WorkflowCommons.DS_WorkflowView_LoadNotificationArea | none | none | WorkflowCommons.DS_WorkflowTask_LoadNotificationArea |
| WorkflowCommons.TaskAssignmentHelper | WorkflowCommons.ACT_TaskAssignment_Show | none | none | none |
| WorkflowCommons.TaskCount | WorkflowCommons.DS_TaskCount, WorkflowCommons.DS_TaskCount_Admin | none | none | none |
| WorkflowCommons.TaskSeries | WorkflowCommons.SUB_TaskSeries_CreateOrUpdate | WorkflowCommons.SUB_TaskSeries_CreateOrUpdate | none | none |
| WorkflowCommons.TaskSummary | WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate | none | none | WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate |
| WorkflowCommons.TimelineViewer | WorkflowCommons.DS_Workflow_TimelineViewer, WorkflowCommons.DS_WorkflowView_TimelineViewer | none | none | WorkflowCommons.DS_WorkflowView_TimelineViewer |
| WorkflowCommons.UserTaskOutcomeView | WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate | none | none | WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser, WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate |
| WorkflowCommons.UserTaskTimeLine | WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress | WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress | none | WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress |
| WorkflowCommons.UserTaskView | WorkflowCommons.SUB_UserTaskView_FindOrCreate | WorkflowCommons.SUB_Assignee_Migrate, WorkflowCommons.SUB_AssigneeMigration_Verify, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime | none | WorkflowCommons.SUB_Assignee_Migrate, WorkflowCommons.SUB_AssigneeMigration_Verify, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_UserTask_AssignedToUser, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_UserTask_CountCompleted, WorkflowCommons.SUB_UserTask_CountCompletedOnTime, WorkflowCommons.SUB_UserTask_CountCompletedOverdue, WorkflowCommons.SUB_UserTask_CountFailed, WorkflowCommons.SUB_UserTask_CountOverdue, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime, WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted |
| WorkflowCommons.WorkflowAttachment | WorkflowCommons.ACT_Attachment_Create | none | none | none |
| WorkflowCommons.WorkflowAuditTrailRecord | WorkflowCommons.SUB_WorkflowEvent_AuditTrail | WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp | WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey | WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp, WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey |
| WorkflowCommons.WorkflowComment | WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin, WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow | WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin | none | WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow |
| WorkflowCommons.WorkflowCommentHelper | WorkflowCommons.ACT_WorkflowComment_Edit, WorkflowCommons.DS_WorkflowCommentHelper_InitializeNew | none | none | none |
| WorkflowCommons.WorkflowDefinitionHelper | WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate | WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate | none | WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate |
| WorkflowCommons.WorkflowSelectionHelper | WorkflowCommons.DS_WorkflowSelectionHelper | none | none | WorkflowCommons.DS_WorkflowSelectionHelper |
| WorkflowCommons.WorkflowSeries | WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate | WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate | none | none |
| WorkflowCommons.WorkflowSummary | WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate | WorkflowCommons.DS_WorkflowDefinition_Overview | none | WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate |
| WorkflowCommons.WorkflowTaskDetail | WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate | none | none | WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate |
| WorkflowCommons.WorkflowView | WorkflowCommons.DS_WorkflowSelectionHelper, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_WorkflowView_FindOrCreate | WorkflowCommons.OCh_CleanupHelper_UpdateCount, WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_Workflow_AverageHandlingTime, WorkflowCommons.SUB_WorkflowKey_Migrate | WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView | WorkflowCommons.DS_WorkflowSelectionHelper, WorkflowCommons.OCh_CleanupHelper_UpdateCount, WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_Workflow_AverageHandlingTime, WorkflowCommons.SUB_Workflow_CountCompleted, WorkflowCommons.SUB_Workflow_CountCompletedOnTime, WorkflowCommons.SUB_Workflow_CountCompletedOverdue, WorkflowCommons.SUB_Workflow_CountOverdue, WorkflowCommons.SUB_WorkflowKey_Migrate, WorkflowCommons.SUB_WorkflowView_FindOrCreate |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| WorkflowCommons.AssignmentHelper | WorkflowCommons.User | None | none |
| WorkflowCommons.AuditTrailViewer | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.CleanupHelper | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.Configuration | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.DashboardContext | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.DefinitionHelper | WorkflowCommons.User | None | none |
| WorkflowCommons.DurationHelper | WorkflowCommons.Administrator, WorkflowCommons.User | None | none |
| WorkflowCommons.NotificationArea | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.TaskAssignmentHelper | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.TaskCount | WorkflowCommons.Administrator, WorkflowCommons.User | ReadOnly | none |
| WorkflowCommons.TaskSeries | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.TaskSummary | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.TimelineViewer | WorkflowCommons.Administrator, WorkflowCommons.User | None | none |
| WorkflowCommons.UserTaskOutcomeView | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.UserTaskOutcomeView | WorkflowCommons.User | None | [WorkflowCommons.UserTaskOutcomeView_UserTaskView/WorkflowCommons.UserTaskView[WorkflowCommons.UserTaskView_Assignees = '[%CurrentUser%]' or WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]']] |
| WorkflowCommons.UserTaskTimeLine | WorkflowCommons.Administrator, WorkflowCommons.User | ReadOnly | none |
| WorkflowCommons.UserTaskView | WorkflowCommons.User | None | [WorkflowCommons.UserTaskView_Assignees = '[%CurrentUser%]' or WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]'] |
| WorkflowCommons.UserTaskView | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.WorkflowAttachment | WorkflowCommons.Administrator | ReadWrite | none |
| WorkflowCommons.WorkflowAttachment | WorkflowCommons.User | ReadOnly | [WorkflowCommons.WorkflowAttachment_WorkflowComment/WorkflowCommons.WorkflowComment/WorkflowCommons.WorkflowComment_WorkflowView/WorkflowCommons.WorkflowView/WorkflowCommons.UserTaskView_WorkflowView/WorkflowCommons.UserTaskView/WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]'] |
| WorkflowCommons.WorkflowAttachment | WorkflowCommons.User | ReadOnly | [System.owner = '[%CurrentUser%]'] [WorkflowCommons.WorkflowAttachment_WorkflowComment/WorkflowCommons.WorkflowComment/WorkflowCommons.WorkflowComment_WorkflowView/WorkflowCommons.WorkflowView[State = 'InProgress']/WorkflowCommons.UserTaskView_WorkflowView/WorkflowCommons.UserTaskView/WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]'] |
| WorkflowCommons.WorkflowAuditTrailRecord | WorkflowCommons.Administrator | None | none |
| WorkflowCommons.WorkflowComment | WorkflowCommons.Administrator | ReadWrite | none |
| WorkflowCommons.WorkflowComment | WorkflowCommons.User | ReadOnly | [WorkflowCommons.WorkflowComment_WorkflowView/WorkflowCommons.WorkflowView/WorkflowCommons.UserTaskView_WorkflowView/WorkflowCommons.UserTaskView/WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]'] |
| WorkflowCommons.WorkflowComment | WorkflowCommons.User | ReadWrite | [System.owner = '[%CurrentUser%]'] [WorkflowCommons.WorkflowComment_WorkflowView/WorkflowCommons.WorkflowView[State = 'InProgress']/WorkflowCommons.UserTaskView_WorkflowView/WorkflowCommons.UserTaskView/WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]'] |
| WorkflowCommons.WorkflowCommentHelper | WorkflowCommons.Administrator, WorkflowCommons.User | ReadOnly | none |
| WorkflowCommons.WorkflowDefinitionHelper | WorkflowCommons.Administrator | ReadOnly | none |
| WorkflowCommons.WorkflowSelectionHelper | WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.WorkflowSeries | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.WorkflowSummary | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.WorkflowTaskDetail | WorkflowCommons.Administrator, WorkflowCommons.User | ReadWrite | none |
| WorkflowCommons.WorkflowView | WorkflowCommons.User | None | [WorkflowCommons.WorkflowView_Initiator = '[%CurrentUser%]' or WorkflowCommons.UserTaskView_WorkflowView/WorkflowCommons.UserTaskView[WorkflowCommons.UserTaskView_Assignees = '[%CurrentUser%]' or WorkflowCommons.UserTaskView_TargetUsers = '[%CurrentUser%]']] |
| WorkflowCommons.WorkflowView | WorkflowCommons.Administrator | None | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| WorkflowCommons.DashboardContext_DefinitionHelperTask | WorkflowCommons.DashboardContext | WorkflowCommons.DefinitionHelper | 1-1 | Reference | Both |
| WorkflowCommons.DashboardContext_DefinitionHelperWorkflow | WorkflowCommons.DashboardContext | WorkflowCommons.DefinitionHelper | 1-1 | Reference | Both |
| WorkflowCommons.DashboardContext_TaskSummary | WorkflowCommons.DashboardContext | WorkflowCommons.TaskSummary | 1-1 | Reference | Both |
| WorkflowCommons.DashboardContext_WorkflowSummary | WorkflowCommons.DashboardContext | WorkflowCommons.WorkflowSummary | 1-1 | Reference | Both |
| WorkflowCommons.DefinitionHelper_DashboardContext | WorkflowCommons.DefinitionHelper | WorkflowCommons.DashboardContext | *-1 | Reference | Default |
| WorkflowCommons.DefinitionHelper_DefinitionHelperParent | WorkflowCommons.DefinitionHelper | WorkflowCommons.DefinitionHelper | *-1 | Reference | Default |
| WorkflowCommons.TaskSeries_DashboardContext | WorkflowCommons.TaskSeries | WorkflowCommons.DashboardContext | *-1 | Reference | Default |
| WorkflowCommons.UserTaskOutcomeView_UserTaskView | WorkflowCommons.UserTaskOutcomeView | WorkflowCommons.UserTaskView | *-1 | Reference | Default |
| WorkflowCommons.UserTaskView_WorkflowView | WorkflowCommons.UserTaskView | WorkflowCommons.WorkflowView | *-1 | Reference | Default |
| WorkflowCommons.WorkflowAttachment_WorkflowComment | WorkflowCommons.WorkflowAttachment | WorkflowCommons.WorkflowComment | *-1 | Reference | Default |
| WorkflowCommons.WorkflowCommentHelper_WorkflowComment | WorkflowCommons.WorkflowCommentHelper | WorkflowCommons.WorkflowComment | *-1 | Reference | Default |
| WorkflowCommons.WorkflowComment_WorkflowView | WorkflowCommons.WorkflowComment | WorkflowCommons.WorkflowView | *-1 | Reference | Default |
| WorkflowCommons.WorkflowSelectionHelper_WorkflowView | WorkflowCommons.WorkflowSelectionHelper | WorkflowCommons.WorkflowView | *-1 | Reference | Default |
| WorkflowCommons.WorkflowSeries_DashboardContext | WorkflowCommons.WorkflowSeries | WorkflowCommons.DashboardContext | *-1 | Reference | Default |
| WorkflowCommons.WorkflowTaskDetail_DashboardContext | WorkflowCommons.WorkflowTaskDetail | WorkflowCommons.DashboardContext | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| WorkflowCommons.Enum_AuditTrail_EventLevel | 2 | ActivityEvent, WorkflowEvent |
| WorkflowCommons.Enum_AuditTrail_View | 3 | _Default, All, Minimal |
| WorkflowCommons.Enum_DashboardTimeFrame | 5 | Last_3_months, Last_4_weeks, Last_6_months, Last_7_days |
| WorkflowCommons.Enum_DurationUnit | 4 | Days, Hours, Minutes, Seconds |
| WorkflowCommons.Enum_LogNode | 1 | WorkflowCommons |
| WorkflowCommons.Enum_NotificationArea_RenderAs | 4 | Error, Info, Success, Warning |
| WorkflowCommons.Enum_TimeFrameStepUnit | 3 | Day, Month, Week |

## Entity Index

<a id="entity-workflowcommons-assignmenthelper"></a>
### WorkflowCommons.AssignmentHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper; update=none; delete=none; read=WorkflowCommons.DS_WorkflowUserTask_AssigneeHelper.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-audittrailviewer"></a>
### WorkflowCommons.AuditTrailViewer

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_AuditTrailViewer; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-cleanuphelper"></a>
### WorkflowCommons.CleanupHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-configuration"></a>
### WorkflowCommons.Configuration

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_Configuration_FindOrCreate; update=none; delete=none; read=WorkflowCommons.SUB_Configuration_FindOrCreate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-dashboardcontext"></a>
### WorkflowCommons.DashboardContext

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate; update=none; delete=none; read=WorkflowCommons.SUB_DashboardContext_RetrieveOrCreate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-definitionhelper"></a>
### WorkflowCommons.DefinitionHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation; update=WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation; delete=none; read=WorkflowCommons.DS_WorkflowDefinition_SelectableImplementation, WorkflowCommons.DS_WorkflowTaskDefinition_Selectable_UserImplementation.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-durationhelper"></a>
### WorkflowCommons.DurationHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_Duration_Calculate; update=WorkflowCommons.SUB_Duration_Calculate; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-notificationarea"></a>
### WorkflowCommons.NotificationArea

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_Workflow_LoadNotificationArea, WorkflowCommons.DS_WorkflowTask_LoadNotificationArea, WorkflowCommons.DS_WorkflowView_LoadNotificationArea; update=none; delete=none; read=WorkflowCommons.DS_WorkflowTask_LoadNotificationArea.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-taskassignmenthelper"></a>
### WorkflowCommons.TaskAssignmentHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.ACT_TaskAssignment_Show; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-taskcount"></a>
### WorkflowCommons.TaskCount

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_TaskCount, WorkflowCommons.DS_TaskCount_Admin; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-taskseries"></a>
### WorkflowCommons.TaskSeries

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_TaskSeries_CreateOrUpdate; update=WorkflowCommons.SUB_TaskSeries_CreateOrUpdate; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-tasksummary"></a>
### WorkflowCommons.TaskSummary

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate; update=none; delete=none; read=WorkflowCommons.SUB_TaskSummary_RetrieveOrCreate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-timelineviewer"></a>
### WorkflowCommons.TimelineViewer

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_Workflow_TimelineViewer, WorkflowCommons.DS_WorkflowView_TimelineViewer; update=none; delete=none; read=WorkflowCommons.DS_WorkflowView_TimelineViewer.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-usertaskoutcomeview"></a>
### WorkflowCommons.UserTaskOutcomeView

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate; update=none; delete=none; read=WorkflowCommons.SUB_UserTaskOutcomeView_AssignedToUser, WorkflowCommons.SUB_UserTaskOutcomeView_FindOrCreate.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-usertasktimeline"></a>
### WorkflowCommons.UserTaskTimeLine

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress; update=WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress; delete=none; read=WorkflowCommons.DS_WorkflowTask_AssignedToUser_Timeline, WorkflowCommons.SUB_WorkflowTaskTimeline_Completed, WorkflowCommons.SUB_WorkflowTaskTimeline_InProgress.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-usertaskview"></a>
### WorkflowCommons.UserTaskView

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_UserTaskView_FindOrCreate; update=WorkflowCommons.SUB_Assignee_Migrate, WorkflowCommons.SUB_AssigneeMigration_Verify, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime; delete=none; read=WorkflowCommons.SUB_Assignee_Migrate, WorkflowCommons.SUB_AssigneeMigration_Verify, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_TaskCount_Update, WorkflowCommons.SUB_TaskKey_Migrate, WorkflowCommons.SUB_UserTask_AssignedToUser, WorkflowCommons.SUB_UserTask_AverageHandlingTime, WorkflowCommons.SUB_UserTask_CountCompleted, WorkflowCommons.SUB_UserTask_CountCompletedOnTime, WorkflowCommons.SUB_UserTask_CountCompletedOverdue, WorkflowCommons.SUB_UserTask_CountFailed, WorkflowCommons.SUB_UserTask_CountOverdue, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_WorkflowTask_AverageHandlingTime, WorkflowCommons.SUB_WorkflowView_CurrentUserIsTargeted.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowattachment"></a>
### WorkflowCommons.WorkflowAttachment

- Generalization: System.FileDocument.
- Lifecycle: create=WorkflowCommons.ACT_Attachment_Create; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowaudittrailrecord"></a>
### WorkflowCommons.WorkflowAuditTrailRecord

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_WorkflowEvent_AuditTrail; update=WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp; delete=WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey; read=WorkflowCommons.SUB_WorkflowAuditTrailRecord_CleanUp, WorkflowCommons.SUB_WorkflowAuditTrailRecord_DeleteByKey.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowcomment"></a>
### WorkflowCommons.WorkflowComment

- Generalization: none.
- Lifecycle: create=WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin, WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow; update=WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew, WorkflowCommons.ACT_WorkflowCommentHelper_SaveNew_Admin; delete=none; read=WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowcommenthelper"></a>
### WorkflowCommons.WorkflowCommentHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.ACT_WorkflowComment_Edit, WorkflowCommons.DS_WorkflowCommentHelper_InitializeNew; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowdefinitionhelper"></a>
### WorkflowCommons.WorkflowDefinitionHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate; update=WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate; delete=none; read=WorkflowCommons.SUB_WorkflowDefinitionHelper_FindOrCreate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowselectionhelper"></a>
### WorkflowCommons.WorkflowSelectionHelper

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowSelectionHelper; update=none; delete=none; read=WorkflowCommons.DS_WorkflowSelectionHelper.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowseries"></a>
### WorkflowCommons.WorkflowSeries

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate; update=WorkflowCommons.SUB_WorkflowSeries_CreateOrUpdate; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowsummary"></a>
### WorkflowCommons.WorkflowSummary

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate; update=WorkflowCommons.DS_WorkflowDefinition_Overview; delete=none; read=WorkflowCommons.DS_WorkflowDefinition_Overview, WorkflowCommons.SUB_WorkflowSummary_RetrieveOrCreate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowtaskdetail"></a>
### WorkflowCommons.WorkflowTaskDetail

- Generalization: none.
- Lifecycle: create=WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate; update=none; delete=none; read=WorkflowCommons.SUB_WorkflowTaskDetail_CreateOrUpdate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).
<a id="entity-workflowcommons-workflowview"></a>
### WorkflowCommons.WorkflowView

- Generalization: none.
- Lifecycle: create=WorkflowCommons.DS_WorkflowSelectionHelper, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_WorkflowView_FindOrCreate; update=WorkflowCommons.OCh_CleanupHelper_UpdateCount, WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_Workflow_AverageHandlingTime, WorkflowCommons.SUB_WorkflowKey_Migrate; delete=WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView; read=WorkflowCommons.DS_WorkflowSelectionHelper, WorkflowCommons.OCh_CleanupHelper_UpdateCount, WorkflowCommons.SUB_CleanupHelper_Execute_WorkflowView, WorkflowCommons.SUB_KeyMigration_Verify, WorkflowCommons.SUB_UserTaskView_FindOrCreate, WorkflowCommons.SUB_Workflow_AverageHandlingTime, WorkflowCommons.SUB_Workflow_CountCompleted, WorkflowCommons.SUB_Workflow_CountCompletedOnTime, WorkflowCommons.SUB_Workflow_CountCompletedOverdue, WorkflowCommons.SUB_Workflow_CountOverdue, WorkflowCommons.SUB_WorkflowKey_Migrate, WorkflowCommons.SUB_WorkflowView_FindOrCreate.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/WorkflowCommons/domain-model.json)
