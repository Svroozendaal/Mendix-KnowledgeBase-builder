# Pages: WorkflowCommons

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| WorkflowCommons.CompletedUserTaskView | Expense request approval | WorkflowCommons.Administrator, WorkflowCommons.User | UserTaskView:WorkflowCommons.UserTaskView | False |
| WorkflowCommons.CompletedWorkflowView | Default workflow admin | WorkflowCommons.Administrator | WorkflowView:WorkflowCommons.WorkflowView | False |
| WorkflowCommons.DefaultWorkflowAdmin | Default workflow admin | WorkflowCommons.Administrator | Workflow:System.Workflow | False |
| WorkflowCommons.ManageTaskAssignments | Manage Task Assignments | WorkflowCommons.Administrator | TaskAssignmentHelper:WorkflowCommons.TaskAssignmentHelper | False |
| WorkflowCommons.MyInitiatedWorkflows | My Initiated Workflows | WorkflowCommons.Administrator, WorkflowCommons.User | none | False |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign | User Search | WorkflowCommons.Administrator | TaskAssignmentHelper:WorkflowCommons.TaskAssignmentHelper | True |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign_TargetUserOptions | Reassign task(s) | WorkflowCommons.Administrator | NewAssignee:Administration.Account, TaskManagementHelper:WorkflowCommons.TaskAssignmentHelper | True |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget | User Search | WorkflowCommons.Administrator | TaskAssignmentHelper:WorkflowCommons.TaskAssignmentHelper | True |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget_TargetUserOptions | Retarget task(s) | WorkflowCommons.Administrator | NewTargetUser:Administration.Account, TaskAssignmentHelper:WorkflowCommons.TaskAssignmentHelper | True |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions | Unassign task(s) | WorkflowCommons.Administrator | TaskAssignmentHelper:WorkflowCommons.TaskAssignmentHelper | True |
| WorkflowCommons.TaskDashboard | My task dashboard | WorkflowCommons.Administrator, WorkflowCommons.User | none | False |
| WorkflowCommons.TaskInbox | Task Inbox | WorkflowCommons.Administrator, WorkflowCommons.User | none | False |
| WorkflowCommons.UserTask_Assign | Assign User | WorkflowCommons.Administrator | WorkflowUserTask:System.WorkflowUserTask | True |
| WorkflowCommons.UserTask_Target | Manage target users | WorkflowCommons.Administrator | WorkflowUserTask:System.WorkflowUserTask | True |
| WorkflowCommons.Workflow_ActionConfirmation | Confirmation | none | Workflow:System.Workflow | True |
| WorkflowCommons.Workflow_Dashboard | Workflow Dashboard | WorkflowCommons.Administrator | none | False |
| WorkflowCommons.Workflow_JumpTo_Options | Jump to activity | none | WorkflowJumpToDetails:System.WorkflowJumpToDetails | True |
| WorkflowCommons.Workflow_Retry_Options | Retry Workflow | none | Workflow:System.Workflow | True |
| WorkflowCommons.Workflow_WithdrawConfirmation | Withdraw Workflow | none | WorkflowComment:WorkflowCommons.WorkflowComment | True |
| WorkflowCommons.WorkflowAdminCenter | Workflow Admin Center | WorkflowCommons.Administrator | none | False |
| WorkflowCommons.WorkflowAttachment_New | New attachment | WorkflowCommons.Administrator, WorkflowCommons.User | WorkflowAttachment:WorkflowCommons.WorkflowAttachment | True |
| WorkflowCommons.WorkflowAttachment_View | Attachment | WorkflowCommons.Administrator, WorkflowCommons.User | WorkflowAttachment:WorkflowCommons.WorkflowAttachment | True |
| WorkflowCommons.WorkflowAuditTrailRecord_Overview | Workflow Audit trail | WorkflowCommons.Administrator | none | False |
| WorkflowCommons.WorkflowComment_Edit_Admin | Edit Comment | WorkflowCommons.Administrator | WorkflowComment:WorkflowCommons.WorkflowComment | True |
| WorkflowCommons.WorkflowCommentHelper_Edit | Edit Comment | WorkflowCommons.Administrator, WorkflowCommons.User | WorkflowCommentHelper:WorkflowCommons.WorkflowCommentHelper | True |
| WorkflowCommons.WorkflowDefinition_ActionConfirmation | Confirmation | none | WorkflowDefinition:System.WorkflowDefinition | True |
| WorkflowCommons.WorkflowDefinition_CleanUp | Clean-up workflow instances | WorkflowCommons.Administrator | CleanupHelper:WorkflowCommons.CleanupHelper | True |
| WorkflowCommons.WorkflowDefinition_CleanUp_Preview | Clean-up workflow instances | WorkflowCommons.Administrator | CleanupHelper:WorkflowCommons.CleanupHelper | True |
| WorkflowCommons.WorkflowDefinition_Lock | Lock workflow | WorkflowCommons.Administrator | WorkflowDefinitionHelper:WorkflowCommons.WorkflowDefinitionHelper | True |
| WorkflowCommons.WorkflowDefinition_Overview | Workflow Definitions | WorkflowCommons.Administrator | none | False |
| WorkflowCommons.WorkflowDefinition_Unlock | Unlock workflow | WorkflowCommons.Administrator | WorkflowDefinitionHelper:WorkflowCommons.WorkflowDefinitionHelper | True |
| WorkflowCommons.WorkflowDefinition_View | Workflow Definition | WorkflowCommons.Administrator | WorkflowDefinition:System.WorkflowDefinition | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| WorkflowCommons.CompletedUserTaskView | WorkflowCommons.ACT_UserTaskView_ShowUserTaskPage |
| WorkflowCommons.CompletedWorkflowView | WorkflowCommons.SUB_WorkflowView_ShowWorkflowAdminPage |
| WorkflowCommons.DefaultWorkflowAdmin | WorkflowCommons.ACT_UserTask_ShowDefaultAdminPage, WorkflowCommons.SUB_Workflow_ShowWorkflowAdminPage |
| WorkflowCommons.ManageTaskAssignments | WorkflowCommons.ACT_TaskAssignment_Show |
| WorkflowCommons.MyInitiatedWorkflows | none |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign | WorkflowCommons.ACT_TaskAssignmentHelper_Reassign_Show |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign_TargetUserOptions | none |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget | WorkflowCommons.ACT_TaskAssignmentHelper_Retarget_Show |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget_TargetUserOptions | none |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions | WorkflowCommons.ACT_TaskAssignmentHelper_Unassign_Show |
| WorkflowCommons.TaskDashboard | none |
| WorkflowCommons.TaskInbox | none |
| WorkflowCommons.UserTask_Assign | none |
| WorkflowCommons.UserTask_Target | none |
| WorkflowCommons.Workflow_ActionConfirmation | WorkflowCommons.ACT_Workflow_Abort, WorkflowCommons.ACT_Workflow_Continue, WorkflowCommons.ACT_Workflow_Pause, WorkflowCommons.ACT_Workflow_Restart, WorkflowCommons.ACT_Workflow_Unpause, WorkflowCommons.ACT_WorkflowJumpToDetails_Apply, WorkflowCommons.SUB_Workflow_Retry |
| WorkflowCommons.Workflow_Dashboard | none |
| WorkflowCommons.Workflow_JumpTo_Options | WorkflowCommons.ACT_Workflow_JumpTo |
| WorkflowCommons.Workflow_Retry_Options | WorkflowCommons.ACT_Workflow_Retry |
| WorkflowCommons.Workflow_WithdrawConfirmation | WorkflowCommons.ACT_WorkflowView_WithdrawWorkflow |
| WorkflowCommons.WorkflowAdminCenter | none |
| WorkflowCommons.WorkflowAttachment_New | WorkflowCommons.ACT_Attachment_Create |
| WorkflowCommons.WorkflowAttachment_View | none |
| WorkflowCommons.WorkflowAuditTrailRecord_Overview | none |
| WorkflowCommons.WorkflowComment_Edit_Admin | none |
| WorkflowCommons.WorkflowCommentHelper_Edit | WorkflowCommons.ACT_WorkflowComment_Edit |
| WorkflowCommons.WorkflowDefinition_ActionConfirmation | WorkflowCommons.ACT_WorkflowDefinition_Lock, WorkflowCommons.ACT_WorkflowDefinition_Unlock |
| WorkflowCommons.WorkflowDefinition_CleanUp | WorkflowCommons.ACT_WorkflowDefinition_CleanUp_Open |
| WorkflowCommons.WorkflowDefinition_CleanUp_Preview | none |
| WorkflowCommons.WorkflowDefinition_Lock | WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowLockPage |
| WorkflowCommons.WorkflowDefinition_Overview | none |
| WorkflowCommons.WorkflowDefinition_Unlock | WorkflowCommons.ACT_WorkflowDefinitionHelper_ShowUnlockPage |
| WorkflowCommons.WorkflowDefinition_View | WorkflowCommons.OCl_WorkflowSummary |

## Journey Groups

| User intent group | Pages |
|---|---|
| General | WorkflowCommons.CompletedUserTaskView, WorkflowCommons.CompletedWorkflowView, WorkflowCommons.DefaultWorkflowAdmin, WorkflowCommons.ManageTaskAssignments, WorkflowCommons.MyInitiatedWorkflows, WorkflowCommons.TaskDashboard, WorkflowCommons.TaskInbox, WorkflowCommons.WorkflowAdminCenter |
| TaskAssignmentHelper | WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign, WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign_TargetUserOptions, WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget, WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget_TargetUserOptions, WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions |
| UserTask | WorkflowCommons.UserTask_Assign, WorkflowCommons.UserTask_Target |
| Workflow | WorkflowCommons.Workflow_ActionConfirmation, WorkflowCommons.Workflow_Dashboard, WorkflowCommons.Workflow_JumpTo_Options, WorkflowCommons.Workflow_Retry_Options, WorkflowCommons.Workflow_WithdrawConfirmation |
| WorkflowAttachment | WorkflowCommons.WorkflowAttachment_New, WorkflowCommons.WorkflowAttachment_View |
| WorkflowAuditTrailRecord | WorkflowCommons.WorkflowAuditTrailRecord_Overview |
| WorkflowComment | WorkflowCommons.WorkflowComment_Edit_Admin |
| WorkflowCommentHelper | WorkflowCommons.WorkflowCommentHelper_Edit |
| WorkflowDefinition | WorkflowCommons.WorkflowDefinition_ActionConfirmation, WorkflowCommons.WorkflowDefinition_CleanUp, WorkflowCommons.WorkflowDefinition_CleanUp_Preview, WorkflowCommons.WorkflowDefinition_Lock, WorkflowCommons.WorkflowDefinition_Overview, WorkflowCommons.WorkflowDefinition_Unlock, WorkflowCommons.WorkflowDefinition_View |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| WorkflowCommons.CompletedUserTaskView | ShowPageAction | [L0](pages/workflowcommons-completedusertaskview.abstract.md) | [L1](pages/workflowcommons-completedusertaskview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-completedusertaskview.json) |
| WorkflowCommons.CompletedWorkflowView | ShowPageAction | [L0](pages/workflowcommons-completedworkflowview.abstract.md) | [L1](pages/workflowcommons-completedworkflowview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-completedworkflowview.json) |
| WorkflowCommons.DefaultWorkflowAdmin | ShowPageAction | [L0](pages/workflowcommons-defaultworkflowadmin.abstract.md) | [L1](pages/workflowcommons-defaultworkflowadmin.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-defaultworkflowadmin.json) |
| WorkflowCommons.ManageTaskAssignments | ShowPageAction | [L0](pages/workflowcommons-managetaskassignments.abstract.md) | [L1](pages/workflowcommons-managetaskassignments.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-managetaskassignments.json) |
| WorkflowCommons.MyInitiatedWorkflows | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-myinitiatedworkflows.abstract.md) | [L1](pages/workflowcommons-myinitiatedworkflows.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-myinitiatedworkflows.json) |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign | ShowPageAction | [L0](pages/workflowcommons-taskassignmenthelper-usertask-reassign.abstract.md) | [L1](pages/workflowcommons-taskassignmenthelper-usertask-reassign.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskassignmenthelper-usertask-reassign.json) |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Reassign_TargetUserOptions | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-taskassignmenthelper-usertask-reassign-targetuseroptions.abstract.md) | [L1](pages/workflowcommons-taskassignmenthelper-usertask-reassign-targetuseroptions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskassignmenthelper-usertask-reassign-targetuseroptions.json) |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget | ShowPageAction | [L0](pages/workflowcommons-taskassignmenthelper-usertask-retarget.abstract.md) | [L1](pages/workflowcommons-taskassignmenthelper-usertask-retarget.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskassignmenthelper-usertask-retarget.json) |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Retarget_TargetUserOptions | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-taskassignmenthelper-usertask-retarget-targetuseroptions.abstract.md) | [L1](pages/workflowcommons-taskassignmenthelper-usertask-retarget-targetuseroptions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskassignmenthelper-usertask-retarget-targetuseroptions.json) |
| WorkflowCommons.TaskAssignmentHelper_UserTask_Unassign_TargetUserOptions | ShowPageAction | [L0](pages/workflowcommons-taskassignmenthelper-usertask-unassign-targetuseroptions.abstract.md) | [L1](pages/workflowcommons-taskassignmenthelper-usertask-unassign-targetuseroptions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskassignmenthelper-usertask-unassign-targetuseroptions.json) |
| WorkflowCommons.TaskDashboard | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-taskdashboard.abstract.md) | [L1](pages/workflowcommons-taskdashboard.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskdashboard.json) |
| WorkflowCommons.TaskInbox | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-taskinbox.abstract.md) | [L1](pages/workflowcommons-taskinbox.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-taskinbox.json) |
| WorkflowCommons.UserTask_Assign | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-usertask-assign.abstract.md) | [L1](pages/workflowcommons-usertask-assign.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-usertask-assign.json) |
| WorkflowCommons.UserTask_Target | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-usertask-target.abstract.md) | [L1](pages/workflowcommons-usertask-target.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-usertask-target.json) |
| WorkflowCommons.Workflow_ActionConfirmation | ShowPageAction | [L0](pages/workflowcommons-workflow-actionconfirmation.abstract.md) | [L1](pages/workflowcommons-workflow-actionconfirmation.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflow-actionconfirmation.json) |
| WorkflowCommons.Workflow_Dashboard | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflow-dashboard.abstract.md) | [L1](pages/workflowcommons-workflow-dashboard.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflow-dashboard.json) |
| WorkflowCommons.Workflow_JumpTo_Options | ShowPageAction | [L0](pages/workflowcommons-workflow-jumpto-options.abstract.md) | [L1](pages/workflowcommons-workflow-jumpto-options.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflow-jumpto-options.json) |
| WorkflowCommons.Workflow_Retry_Options | ShowPageAction | [L0](pages/workflowcommons-workflow-retry-options.abstract.md) | [L1](pages/workflowcommons-workflow-retry-options.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflow-retry-options.json) |
| WorkflowCommons.Workflow_WithdrawConfirmation | ShowPageAction | [L0](pages/workflowcommons-workflow-withdrawconfirmation.abstract.md) | [L1](pages/workflowcommons-workflow-withdrawconfirmation.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflow-withdrawconfirmation.json) |
| WorkflowCommons.WorkflowAdminCenter | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowadmincenter.abstract.md) | [L1](pages/workflowcommons-workflowadmincenter.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowadmincenter.json) |
| WorkflowCommons.WorkflowAttachment_New | ShowPageAction | [L0](pages/workflowcommons-workflowattachment-new.abstract.md) | [L1](pages/workflowcommons-workflowattachment-new.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowattachment-new.json) |
| WorkflowCommons.WorkflowAttachment_View | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowattachment-view.abstract.md) | [L1](pages/workflowcommons-workflowattachment-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowattachment-view.json) |
| WorkflowCommons.WorkflowAuditTrailRecord_Overview | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowaudittrailrecord-overview.abstract.md) | [L1](pages/workflowcommons-workflowaudittrailrecord-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowaudittrailrecord-overview.json) |
| WorkflowCommons.WorkflowComment_Edit_Admin | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowcomment-edit-admin.abstract.md) | [L1](pages/workflowcommons-workflowcomment-edit-admin.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowcomment-edit-admin.json) |
| WorkflowCommons.WorkflowCommentHelper_Edit | ShowPageAction | [L0](pages/workflowcommons-workflowcommenthelper-edit.abstract.md) | [L1](pages/workflowcommons-workflowcommenthelper-edit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowcommenthelper-edit.json) |
| WorkflowCommons.WorkflowDefinition_ActionConfirmation | ShowPageAction | [L0](pages/workflowcommons-workflowdefinition-actionconfirmation.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-actionconfirmation.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-actionconfirmation.json) |
| WorkflowCommons.WorkflowDefinition_CleanUp | ShowPageAction | [L0](pages/workflowcommons-workflowdefinition-cleanup.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-cleanup.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-cleanup.json) |
| WorkflowCommons.WorkflowDefinition_CleanUp_Preview | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowdefinition-cleanup-preview.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-cleanup-preview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-cleanup-preview.json) |
| WorkflowCommons.WorkflowDefinition_Lock | ShowPageAction | [L0](pages/workflowcommons-workflowdefinition-lock.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-lock.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-lock.json) |
| WorkflowCommons.WorkflowDefinition_Overview | Unknown (navigation metadata not exported) | [L0](pages/workflowcommons-workflowdefinition-overview.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-overview.json) |
| WorkflowCommons.WorkflowDefinition_Unlock | ShowPageAction | [L0](pages/workflowcommons-workflowdefinition-unlock.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-unlock.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-unlock.json) |
| WorkflowCommons.WorkflowDefinition_View | ShowPageAction | [L0](pages/workflowcommons-workflowdefinition-view.abstract.md) | [L1](pages/workflowcommons-workflowdefinition-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/WorkflowCommons/pages/workflowcommons-workflowdefinition-view.json) |
