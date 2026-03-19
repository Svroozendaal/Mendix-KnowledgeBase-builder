# Pages: Inspection

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| Inspection.Account_LoginPage_SplitLeft | Emixa Inspection App | Inspection.Anonymous | none | False |
| Inspection.Assessory_NewEdit | Edit Equipment | Inspection.Manager | Accessory:Inspection.Accessory | True |
| Inspection.CoverPhoto_NewEdit | Edit profile image | Inspection.Manager | CoverPhoto:Inspection.CoverPhoto | True |
| Inspection.Dashboard_Home | Dashboard | Inspection.Administrator, Inspection.Inspector, Inspection.Manager | none | False |
| Inspection.Equipment_Overview | Equipment Overview | Inspection.Inspector, Inspection.Manager | none | False |
| Inspection.InspectionItem_FromDashboard | Inspection Items | Inspection.Administrator, Inspection.Inspector, Inspection.Manager | InspectionItem:Inspection.InspectionItem | False |
| Inspection.InspectionItem_NewEdit | Edit Inspection Item | Inspection.Manager | InspectionItem:Inspection.InspectionItem | True |
| Inspection.InspectionItem_Overview | Inspection Items | Inspection.Inspector, Inspection.Manager | none | False |
| Inspection.Inspector_Account_NewEdit | Inspector Account New edit | Inspection.Inspector | none | False |
| Inspection.Inspector_NewEdit | Edit Inspector | Inspection.Administrator, Inspection.Manager | Inspector:Inspection.Inspector | True |
| Inspection.Inspector_Overview | Inspectors | Inspection.Administrator, Inspection.Manager | none | False |
| Inspection.InspectorPhoto_NewEdit | Edit profile image | Inspection.Manager | InspectorPhoto:Inspection.InspectorPhoto | True |
| Inspection.Registration_NewEdit | Edit Registration | none | Registration:Inspection.Registration | True |
| Inspection.Report_NewEdit | Generate report | Inspection.Administrator, Inspection.Manager | ReportHelper:Inspection.ReportHelper | True |
| Inspection.Task_NewEdit | Edit Smart Task | Inspection.Inspector, Inspection.Manager | Task:Inspection.Task | False |
| Inspection.Task_Overview | Tasks | Inspection.Inspector, Inspection.Manager | none | False |
| Inspection.Tool_Book | Edit Equipment | Inspection.Manager | Tool:Inspection.Tool | True |
| Inspection.Tool_NewEdit | Edit Equipment | Inspection.Manager | Tool:Inspection.Tool | True |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| Inspection.Account_LoginPage_SplitLeft | none |
| Inspection.Assessory_NewEdit | Inspection.ACT_Accessory_Create |
| Inspection.CoverPhoto_NewEdit | Inspection.ACT_CoverPhoto_Create |
| Inspection.Dashboard_Home | none |
| Inspection.Equipment_Overview | none |
| Inspection.InspectionItem_FromDashboard | none |
| Inspection.InspectionItem_NewEdit | none |
| Inspection.InspectionItem_Overview | none |
| Inspection.Inspector_Account_NewEdit | none |
| Inspection.Inspector_NewEdit | none |
| Inspection.Inspector_Overview | none |
| Inspection.InspectorPhoto_NewEdit | Inspection.ACT_InspectorPhoto_Create |
| Inspection.Registration_NewEdit | Inspection.ACT_Registration_Create |
| Inspection.Report_NewEdit | Inspection.ACT_ReportHelper_Create |
| Inspection.Task_NewEdit | Inspection.ACT_Task_Create |
| Inspection.Task_Overview | none |
| Inspection.Tool_Book | Inspection.ACT_Tool_Book |
| Inspection.Tool_NewEdit | Inspection.ACT_Tool_Create |

## Journey Groups

| User intent group | Pages |
|---|---|
| Account | Inspection.Account_LoginPage_SplitLeft |
| Assessory | Inspection.Assessory_NewEdit |
| CoverPhoto | Inspection.CoverPhoto_NewEdit |
| Dashboard | Inspection.Dashboard_Home |
| Equipment | Inspection.Equipment_Overview |
| InspectionItem | Inspection.InspectionItem_FromDashboard, Inspection.InspectionItem_NewEdit, Inspection.InspectionItem_Overview |
| Inspector | Inspection.Inspector_Account_NewEdit, Inspection.Inspector_NewEdit, Inspection.Inspector_Overview |
| InspectorPhoto | Inspection.InspectorPhoto_NewEdit |
| Registration | Inspection.Registration_NewEdit |
| Report | Inspection.Report_NewEdit |
| Task | Inspection.Task_NewEdit, Inspection.Task_Overview |
| Tool | Inspection.Tool_Book, Inspection.Tool_NewEdit |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| Inspection.Account_LoginPage_SplitLeft | HomePage | [L0](pages/inspection-account-loginpage-splitleft.abstract.md) | [L1](pages/inspection-account-loginpage-splitleft.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-account-loginpage-splitleft.json) |
| Inspection.Assessory_NewEdit | ShowPageAction | [L0](pages/inspection-assessory-newedit.abstract.md) | [L1](pages/inspection-assessory-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-assessory-newedit.json) |
| Inspection.CoverPhoto_NewEdit | ShowPageAction | [L0](pages/inspection-coverphoto-newedit.abstract.md) | [L1](pages/inspection-coverphoto-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-coverphoto-newedit.json) |
| Inspection.Dashboard_Home | MenuItem, RoleBasedHomePage | [L0](pages/inspection-dashboard-home.abstract.md) | [L1](pages/inspection-dashboard-home.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-dashboard-home.json) |
| Inspection.Equipment_Overview | MenuItem | [L0](pages/inspection-equipment-overview.abstract.md) | [L1](pages/inspection-equipment-overview.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-equipment-overview.json) |
| Inspection.InspectionItem_FromDashboard | Unknown (navigation metadata not exported) | [L0](pages/inspection-inspectionitem-fromdashboard.abstract.md) | [L1](pages/inspection-inspectionitem-fromdashboard.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspectionitem-fromdashboard.json) |
| Inspection.InspectionItem_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/inspection-inspectionitem-newedit.abstract.md) | [L1](pages/inspection-inspectionitem-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspectionitem-newedit.json) |
| Inspection.InspectionItem_Overview | Unknown (navigation metadata not exported) | [L0](pages/inspection-inspectionitem-overview.abstract.md) | [L1](pages/inspection-inspectionitem-overview.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspectionitem-overview.json) |
| Inspection.Inspector_Account_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/inspection-inspector-account-newedit.abstract.md) | [L1](pages/inspection-inspector-account-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspector-account-newedit.json) |
| Inspection.Inspector_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/inspection-inspector-newedit.abstract.md) | [L1](pages/inspection-inspector-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspector-newedit.json) |
| Inspection.Inspector_Overview | MenuItem | [L0](pages/inspection-inspector-overview.abstract.md) | [L1](pages/inspection-inspector-overview.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspector-overview.json) |
| Inspection.InspectorPhoto_NewEdit | ShowPageAction | [L0](pages/inspection-inspectorphoto-newedit.abstract.md) | [L1](pages/inspection-inspectorphoto-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-inspectorphoto-newedit.json) |
| Inspection.Registration_NewEdit | ShowPageAction | [L0](pages/inspection-registration-newedit.abstract.md) | [L1](pages/inspection-registration-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-registration-newedit.json) |
| Inspection.Report_NewEdit | ShowPageAction | [L0](pages/inspection-report-newedit.abstract.md) | [L1](pages/inspection-report-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-report-newedit.json) |
| Inspection.Task_NewEdit | ShowPageAction | [L0](pages/inspection-task-newedit.abstract.md) | [L1](pages/inspection-task-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-task-newedit.json) |
| Inspection.Task_Overview | MenuItem | [L0](pages/inspection-task-overview.abstract.md) | [L1](pages/inspection-task-overview.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-task-overview.json) |
| Inspection.Tool_Book | ShowPageAction | [L0](pages/inspection-tool-book.abstract.md) | [L1](pages/inspection-tool-book.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-tool-book.json) |
| Inspection.Tool_NewEdit | ShowPageAction | [L0](pages/inspection-tool-newedit.abstract.md) | [L1](pages/inspection-tool-newedit.overview.md) | [L2](../../../../mendix-data-p05-mxcli-rerun/app-overview/current/modules/Inspection/pages/inspection-tool-newedit.json) |
