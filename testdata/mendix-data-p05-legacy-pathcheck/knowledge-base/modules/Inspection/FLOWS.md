# Flows: Inspection

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_Accessory_Create | 4 | Inspection.Accessory | Inspection.Assessory_NewEdit |
| ACT_Assessory_Book | 14 | none | none |
| ACT_Assessory_Delete | 4 | none | none |
| ACT_CoverPhoto_Create | 5 | Inspection.CoverPhoto | Inspection.CoverPhoto_NewEdit |
| ACT_CoverPhoto_Save | 5 | none | none |
| ACT_Inspector_Save | 8 | none | none |
| ACT_InspectorPhoto_Create | 5 | Inspection.InspectorPhoto | Inspection.InspectorPhoto_NewEdit |
| ACT_Registration_Create | 4 | Inspection.Registration | Inspection.Registration_NewEdit |
| ACT_Registration_Save | 15 | Administration.Account, Inspection.Inspector, System.UserRole | none |
| ACT_Report_ApplyFilters | 14 | Inspection.Report, Inspection.Task | none |
| ACT_Report_Generate | 9 | Inspection.Report, Inspection.Task | none |
| ACT_ReportHelper_Create | 4 | Inspection.ReportHelper | Inspection.Report_NewEdit |
| ACT_Task_Create | 5 | Inspection.Task | Inspection.Task_NewEdit |
| ACT_Task_Save | 14 | none | none |
| ACT_Task_SetToDone | 11 | none | none |
| ACT_Task_SetToInProgress | 5 | none | none |
| ACT_Tool_Book | 4 | none | Inspection.Tool_Book |
| ACT_Tool_Create | 4 | Inspection.Tool | Inspection.Tool_NewEdit |
| ACT_Tool_Delete | 4 | none | none |
| ACT_Tool_Validate | 14 | Inspection.Booking | none |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| DS_Booking_RetrieveUpcomming | 7 | none | inferred from node actions |
| DS_Inspector_GetFromCurrentUSer | 3 | Inspection.Inspector | inferred from node actions |
| DS_Task_GetFromNotification | 4 | Inspection.Task | inferred from node actions |
| DS_UserRole_GetFromCurrentUser | 5 | Administration.Account | inferred from node actions |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| VAL_Inspector_Validate | 28 | none |
| VAL_Registration_Validate | 29 | none |
| VAL_Task_Validate | 34 | none |
| VAL_Tool_Validate | 13 | none |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| BCo_Inspector | Microflow | 7 | Administration.Account, System.UserRole |
| CAL_Inspector_TasksOpen | Microflow | 5 | Inspection.Task |
| CAL_Inspector_TasksOverdue | Microflow | 5 | Inspection.Task |
| DSL_Inspector_Selectable | Microflow | 4 | Inspection.Inspector |
| OCH_Task_Refresh | Microflow | 4 | none |
| RUL_Task_Save_Validate | Rule | 23 | none |
| RUL_Task_Title_Validate | Rule | 5 | none |
| SE_Booking_DeleteOlderThenToday | Microflow | 3 | none |
| SE_Equipment_OrderNew | Microflow | 9 | Inspection.Accessory, Inspection.Equipment |
| SUB_Accessory_Order | Microflow | 8 | none |
| SUB_Account_GetFromInspector | Microflow | 4 | none |
| SUB_Booking_Delete | Microflow | 4 | Inspection.Booking |
| SUB_Equipment_Cast | Microflow | 10 | none |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| ACT_Task_Save | Notification.SUB_Notification_SendToInspector | Notification |
| ACT_Task_Save | Notification.SUB_Notification_SendToManager | Notification |
| ACT_Task_SetToDone | Notification.SUB_Notification_SendToManager | Notification |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| Inspection.ACT_Accessory_Create | Inspection.Assessory_NewEdit | Inspection.Accessory |
| Inspection.ACT_Assessory_Book | none | none |
| Inspection.ACT_Assessory_Delete | none | none |
| Inspection.ACT_CoverPhoto_Create | Inspection.CoverPhoto_NewEdit | Inspection.CoverPhoto |
| Inspection.ACT_CoverPhoto_Save | none | none |
| Inspection.ACT_Inspector_Save | none | none |
| Inspection.ACT_InspectorPhoto_Create | Inspection.InspectorPhoto_NewEdit | Inspection.InspectorPhoto |
| Inspection.ACT_Registration_Create | Inspection.Registration_NewEdit | Inspection.Registration |
| Inspection.ACT_Registration_Save | none | Administration.Account, Inspection.Inspector, System.UserRole |
| Inspection.ACT_Report_ApplyFilters | none | Inspection.Report, Inspection.Task |
| Inspection.ACT_Report_Generate | none | Inspection.Report, Inspection.Task |
| Inspection.ACT_ReportHelper_Create | Inspection.Report_NewEdit | Inspection.ReportHelper |
| Inspection.ACT_Task_Create | Inspection.Task_NewEdit | Inspection.Task |
| Inspection.ACT_Task_Save | none | none |
| Inspection.ACT_Task_SetToDone | none | none |
| Inspection.ACT_Task_SetToInProgress | none | none |
| Inspection.ACT_Tool_Book | Inspection.Tool_Book | none |
| Inspection.ACT_Tool_Create | Inspection.Tool_NewEdit | Inspection.Tool |
| Inspection.ACT_Tool_Delete | none | none |
| Inspection.ACT_Tool_Validate | none | Inspection.Booking |
| Inspection.BCo_Inspector | none | Administration.Account, System.UserRole |
| Inspection.SE_Equipment_OrderNew | none | Inspection.Accessory, Inspection.Equipment |
| Inspection.SUB_Account_GetFromInspector | none | none |
| Inspection.SUB_Booking_Delete | none | Inspection.Booking |
| Inspection.VAL_Inspector_Validate | none | none |
| Inspection.VAL_Registration_Validate | none | none |
| Inspection.VAL_Task_Validate | none | none |
| Inspection.VAL_Tool_Validate | none | none |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACT_Accessory_Create | Microflow | 4 | 1 | 0 | 0 |
| ACT_Assessory_Book | Microflow | 14 | 1 | 0 | 0 |
| ACT_Assessory_Delete | Microflow | 4 | 1 | 0 | 0 |
| ACT_CoverPhoto_Create | Microflow | 5 | 1 | 0 | 0 |
| ACT_CoverPhoto_Save | Microflow | 5 | 1 | 0 | 0 |
| ACT_Inspector_Save | Microflow | 8 | 1 | 1 | 0 |
| ACT_InspectorPhoto_Create | Microflow | 5 | 1 | 0 | 0 |
| ACT_Registration_Create | Microflow | 4 | 1 | 0 | 0 |
| ACT_Registration_Save | Microflow | 15 | 1 | 1 | 0 |
| ACT_Report_ApplyFilters | Microflow | 14 | 1 | 0 | 0 |
| ACT_Report_Generate | Microflow | 9 | 1 | 0 | 0 |
| ACT_ReportHelper_Create | Microflow | 4 | 1 | 0 | 0 |
| ACT_Task_Create | Microflow | 5 | 1 | 0 | 0 |
| ACT_Task_Save | Microflow | 14 | 1 | 3 | 0 |
| ACT_Task_SetToDone | Microflow | 11 | 1 | 2 | 0 |
| ACT_Task_SetToInProgress | Microflow | 5 | 1 | 0 | 0 |
| ACT_Tool_Book | Microflow | 4 | 1 | 0 | 0 |
| ACT_Tool_Create | Microflow | 4 | 1 | 0 | 0 |
| ACT_Tool_Delete | Microflow | 4 | 1 | 0 | 0 |
| ACT_Tool_Validate | Microflow | 14 | 1 | 1 | 0 |
| BCo_Inspector | Microflow | 7 | 1 | 0 | 0 |
| CAL_Inspector_TasksOpen | Microflow | 5 | 2 | 0 | 0 |
| CAL_Inspector_TasksOverdue | Microflow | 5 | 2 | 0 | 0 |
| DS_Booking_RetrieveUpcomming | Microflow | 7 | 2 | 0 | 0 |
| DS_Inspector_GetFromCurrentUSer | Microflow | 3 | 2 | 0 | 0 |
| DS_Task_GetFromNotification | Microflow | 4 | 2 | 0 | 0 |
| DS_UserRole_GetFromCurrentUser | Microflow | 5 | 2 | 0 | 1 |
| DSL_Inspector_Selectable | Microflow | 4 | 2 | 0 | 0 |
| OCH_Task_Refresh | Microflow | 4 | 2 | 0 | 0 |
| RUL_Task_Save_Validate | Rule | 23 | 2 | 0 | 0 |
| RUL_Task_Title_Validate | Rule | 5 | 3 | 0 | 0 |
| SE_Booking_DeleteOlderThenToday | Microflow | 3 | 2 | 1 | 0 |
| SE_Equipment_OrderNew | Microflow | 9 | 1 | 2 | 0 |
| SUB_Accessory_Order | Microflow | 8 | 2 | 0 | 1 |
| SUB_Account_GetFromInspector | Microflow | 4 | 1 | 0 | 2 |
| SUB_Booking_Delete | Microflow | 4 | 1 | 0 | 1 |
| SUB_Equipment_Cast | Microflow | 10 | 2 | 0 | 1 |
| VAL_Inspector_Validate | Microflow | 28 | 1 | 0 | 1 |
| VAL_Registration_Validate | Microflow | 29 | 1 | 0 | 1 |
| VAL_Task_Validate | Microflow | 34 | 1 | 1 | 2 |
| VAL_Tool_Validate | Microflow | 13 | 1 | 0 | 1 |

## Tier 1 Deep Narratives

### Inspection.ACT_Accessory_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Accessory.
- UI interactions (shown pages): Inspection.Assessory_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Assessory_Book

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Assessory_Delete

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_CoverPhoto_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.CoverPhoto.
- UI interactions (shown pages): Inspection.CoverPhoto_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_CoverPhoto_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Inspector_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_InspectorPhoto_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.InspectorPhoto.
- UI interactions (shown pages): Inspection.InspectorPhoto_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Registration_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Registration.
- UI interactions (shown pages): Inspection.Registration_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Registration_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Administration.Account, Inspection.Inspector, System.UserRole.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Report_ApplyFilters

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Report, Inspection.Task.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.ACT_Report_Generate

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Report, Inspection.Task.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.ACT_ReportHelper_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.ReportHelper.
- UI interactions (shown pages): Inspection.Report_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Task_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Task.
- UI interactions (shown pages): Inspection.Task_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Task_Save

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=3, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Task_SetToDone

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=2, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Task_SetToInProgress

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Tool_Book

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): Inspection.Tool_Book.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Tool_Create

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Tool.
- UI interactions (shown pages): Inspection.Tool_NewEdit.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Tool_Delete

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.ACT_Tool_Validate

- Intent: User action flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Booking.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.BCo_Inspector

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Administration.Account, System.UserRole.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.SE_Equipment_OrderNew

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Accessory, Inspection.Equipment.
- UI interactions (shown pages): none.
- Calls/called-by: out=2, in=0.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.SUB_Account_GetFromInspector

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.SUB_Booking_Delete

- Intent: General behavioural flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: Inspection.Booking.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: No rollback behaviour was explicitly indicated in exported node detail.

### Inspection.VAL_Inspector_Validate

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.VAL_Registration_Validate

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.VAL_Task_Validate

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=1, in=2.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

### Inspection.VAL_Tool_Validate

- Intent: Validation flow.
- Trigger/entry: microflow/nanoflow entry based on caller or UI action.
- Inputs/outputs: derived from flow node graph; explicit parameter typing is not fully exported.
- Read/write entities: none.
- UI interactions (shown pages): none.
- Calls/called-by: out=0, in=1.
- Security constraints touched: module roles derived via page permissions and entity access rules.
- Failure/rollback notes: Rollback hint detected in flow node detail.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| Inspection.ACT_Accessory_Create | Microflow | 1 | [L0](flows/inspection-act-accessory-create.abstract.md) | [L1](flows/inspection-act-accessory-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-accessory-create.json) |
| Inspection.ACT_Assessory_Book | Microflow | 1 | [L0](flows/inspection-act-assessory-book.abstract.md) | [L1](flows/inspection-act-assessory-book.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-assessory-book.json) |
| Inspection.ACT_Assessory_Delete | Microflow | 1 | [L0](flows/inspection-act-assessory-delete.abstract.md) | [L1](flows/inspection-act-assessory-delete.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-assessory-delete.json) |
| Inspection.ACT_CoverPhoto_Create | Microflow | 1 | [L0](flows/inspection-act-coverphoto-create.abstract.md) | [L1](flows/inspection-act-coverphoto-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-create.json) |
| Inspection.ACT_CoverPhoto_Save | Microflow | 1 | [L0](flows/inspection-act-coverphoto-save.abstract.md) | [L1](flows/inspection-act-coverphoto-save.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-coverphoto-save.json) |
| Inspection.ACT_Inspector_Save | Microflow | 1 | [L0](flows/inspection-act-inspector-save.abstract.md) | [L1](flows/inspection-act-inspector-save.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-inspector-save.json) |
| Inspection.ACT_InspectorPhoto_Create | Microflow | 1 | [L0](flows/inspection-act-inspectorphoto-create.abstract.md) | [L1](flows/inspection-act-inspectorphoto-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-inspectorphoto-create.json) |
| Inspection.ACT_Registration_Create | Microflow | 1 | [L0](flows/inspection-act-registration-create.abstract.md) | [L1](flows/inspection-act-registration-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-registration-create.json) |
| Inspection.ACT_Registration_Save | Microflow | 1 | [L0](flows/inspection-act-registration-save.abstract.md) | [L1](flows/inspection-act-registration-save.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-registration-save.json) |
| Inspection.ACT_Report_ApplyFilters | Microflow | 1 | [L0](flows/inspection-act-report-applyfilters.abstract.md) | [L1](flows/inspection-act-report-applyfilters.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-report-applyfilters.json) |
| Inspection.ACT_Report_Generate | Microflow | 1 | [L0](flows/inspection-act-report-generate.abstract.md) | [L1](flows/inspection-act-report-generate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-report-generate.json) |
| Inspection.ACT_ReportHelper_Create | Microflow | 1 | [L0](flows/inspection-act-reporthelper-create.abstract.md) | [L1](flows/inspection-act-reporthelper-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-reporthelper-create.json) |
| Inspection.ACT_Task_Create | Microflow | 1 | [L0](flows/inspection-act-task-create.abstract.md) | [L1](flows/inspection-act-task-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-create.json) |
| Inspection.ACT_Task_Save | Microflow | 1 | [L0](flows/inspection-act-task-save.abstract.md) | [L1](flows/inspection-act-task-save.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-save.json) |
| Inspection.ACT_Task_SetToDone | Microflow | 1 | [L0](flows/inspection-act-task-settodone.abstract.md) | [L1](flows/inspection-act-task-settodone.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-settodone.json) |
| Inspection.ACT_Task_SetToInProgress | Microflow | 1 | [L0](flows/inspection-act-task-settoinprogress.abstract.md) | [L1](flows/inspection-act-task-settoinprogress.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-task-settoinprogress.json) |
| Inspection.ACT_Tool_Book | Microflow | 1 | [L0](flows/inspection-act-tool-book.abstract.md) | [L1](flows/inspection-act-tool-book.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-book.json) |
| Inspection.ACT_Tool_Create | Microflow | 1 | [L0](flows/inspection-act-tool-create.abstract.md) | [L1](flows/inspection-act-tool-create.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-create.json) |
| Inspection.ACT_Tool_Delete | Microflow | 1 | [L0](flows/inspection-act-tool-delete.abstract.md) | [L1](flows/inspection-act-tool-delete.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-delete.json) |
| Inspection.ACT_Tool_Validate | Microflow | 1 | [L0](flows/inspection-act-tool-validate.abstract.md) | [L1](flows/inspection-act-tool-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-act-tool-validate.json) |
| Inspection.BCo_Inspector | Microflow | 1 | [L0](flows/inspection-bco-inspector.abstract.md) | [L1](flows/inspection-bco-inspector.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-bco-inspector.json) |
| Inspection.CAL_Inspector_TasksOpen | Microflow | 2 | [L0](flows/inspection-cal-inspector-tasksopen.abstract.md) | [L1](flows/inspection-cal-inspector-tasksopen.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksopen.json) |
| Inspection.CAL_Inspector_TasksOverdue | Microflow | 2 | [L0](flows/inspection-cal-inspector-tasksoverdue.abstract.md) | [L1](flows/inspection-cal-inspector-tasksoverdue.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-cal-inspector-tasksoverdue.json) |
| Inspection.DS_Booking_RetrieveUpcomming | Microflow | 2 | [L0](flows/inspection-ds-booking-retrieveupcomming.abstract.md) | [L1](flows/inspection-ds-booking-retrieveupcomming.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-booking-retrieveupcomming.json) |
| Inspection.DS_Inspector_GetFromCurrentUSer | Microflow | 2 | [L0](flows/inspection-ds-inspector-getfromcurrentuser.abstract.md) | [L1](flows/inspection-ds-inspector-getfromcurrentuser.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-inspector-getfromcurrentuser.json) |
| Inspection.DS_Task_GetFromNotification | Microflow | 2 | [L0](flows/inspection-ds-task-getfromnotification.abstract.md) | [L1](flows/inspection-ds-task-getfromnotification.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-task-getfromnotification.json) |
| Inspection.DS_UserRole_GetFromCurrentUser | Microflow | 2 | [L0](flows/inspection-ds-userrole-getfromcurrentuser.abstract.md) | [L1](flows/inspection-ds-userrole-getfromcurrentuser.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-ds-userrole-getfromcurrentuser.json) |
| Inspection.DSL_Inspector_Selectable | Microflow | 2 | [L0](flows/inspection-dsl-inspector-selectable.abstract.md) | [L1](flows/inspection-dsl-inspector-selectable.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-dsl-inspector-selectable.json) |
| Inspection.OCH_Task_Refresh | Microflow | 2 | [L0](flows/inspection-och-task-refresh.abstract.md) | [L1](flows/inspection-och-task-refresh.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-och-task-refresh.json) |
| Inspection.RUL_Task_Save_Validate | Rule | 2 | [L0](flows/inspection-rul-task-save-validate.abstract.md) | [L1](flows/inspection-rul-task-save-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-rul-task-save-validate.json) |
| Inspection.RUL_Task_Title_Validate | Rule | 3 | [L0](flows/inspection-rul-task-title-validate.abstract.md) | [L1](flows/inspection-rul-task-title-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-rul-task-title-validate.json) |
| Inspection.SE_Booking_DeleteOlderThenToday | Microflow | 2 | [L0](flows/inspection-se-booking-deleteolderthentoday.abstract.md) | [L1](flows/inspection-se-booking-deleteolderthentoday.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-se-booking-deleteolderthentoday.json) |
| Inspection.SE_Equipment_OrderNew | Microflow | 1 | [L0](flows/inspection-se-equipment-ordernew.abstract.md) | [L1](flows/inspection-se-equipment-ordernew.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-se-equipment-ordernew.json) |
| Inspection.SUB_Accessory_Order | Microflow | 2 | [L0](flows/inspection-sub-accessory-order.abstract.md) | [L1](flows/inspection-sub-accessory-order.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-accessory-order.json) |
| Inspection.SUB_Account_GetFromInspector | Microflow | 1 | [L0](flows/inspection-sub-account-getfrominspector.abstract.md) | [L1](flows/inspection-sub-account-getfrominspector.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-account-getfrominspector.json) |
| Inspection.SUB_Booking_Delete | Microflow | 1 | [L0](flows/inspection-sub-booking-delete.abstract.md) | [L1](flows/inspection-sub-booking-delete.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-booking-delete.json) |
| Inspection.SUB_Equipment_Cast | Microflow | 2 | [L0](flows/inspection-sub-equipment-cast.abstract.md) | [L1](flows/inspection-sub-equipment-cast.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-sub-equipment-cast.json) |
| Inspection.VAL_Inspector_Validate | Microflow | 1 | [L0](flows/inspection-val-inspector-validate.abstract.md) | [L1](flows/inspection-val-inspector-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-inspector-validate.json) |
| Inspection.VAL_Registration_Validate | Microflow | 1 | [L0](flows/inspection-val-registration-validate.abstract.md) | [L1](flows/inspection-val-registration-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-registration-validate.json) |
| Inspection.VAL_Task_Validate | Microflow | 1 | [L0](flows/inspection-val-task-validate.abstract.md) | [L1](flows/inspection-val-task-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-task-validate.json) |
| Inspection.VAL_Tool_Validate | Microflow | 1 | [L0](flows/inspection-val-tool-validate.abstract.md) | [L1](flows/inspection-val-tool-validate.overview.md) | [L2](../../../../mendix-data-p05-legacy/app-overview/current/modules/Inspection/flows/inspection-val-tool-validate.json) |
