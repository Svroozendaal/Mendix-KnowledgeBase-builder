# Domain: Inspection

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Inspection.Accessory | True | 3 | 2 |
| Inspection.Booking | True | 1 | 2 |
| Inspection.CoverPhoto | True | 0 | 3 |
| Inspection.Equipment | True | 2 | 2 |
| Inspection.InspectionItem | True | 4 | 2 |
| Inspection.Inspector | True | 8 | 3 |
| Inspection.InspectorPhoto | True | 0 | 3 |
| Inspection.Registration | False | 6 | 1 |
| Inspection.Report | True | 0 | 1 |
| Inspection.ReportHelper | False | 3 | 1 |
| Inspection.Task | True | 9 | 2 |
| Inspection.Tool | True | 2 | 2 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Inspection.Accessory | Inspection.ACT_Accessory_Create, Inspection.SE_Equipment_OrderNew [members unknown] | Inspection.SE_Equipment_OrderNew [members unknown] | none | Inspection.SE_Equipment_OrderNew |
| Inspection.Booking | Inspection.ACT_Tool_Validate [members unknown] | Inspection.ACT_Tool_Validate [members unknown] | Inspection.SUB_Booking_Delete | Inspection.ACT_Tool_Validate, Inspection.SUB_Booking_Delete |
| Inspection.CoverPhoto | Inspection.ACT_CoverPhoto_Create [members unknown] | none | none | none |
| Inspection.Equipment | Inspection.SE_Equipment_OrderNew [members unknown] | Inspection.SE_Equipment_OrderNew [members unknown] | none | Inspection.SE_Equipment_OrderNew |
| Inspection.InspectionItem | none | none | none | none |
| Inspection.Inspector | Inspection.ACT_Registration_Save [members unknown] | Inspection.ACT_Registration_Save [members unknown] | none | Inspection.ACT_Registration_Save, Inspection.DS_Inspector_GetFromCurrentUSer, Inspection.DSL_Inspector_Selectable |
| Inspection.InspectorPhoto | Inspection.ACT_InspectorPhoto_Create [members unknown] | none | none | none |
| Inspection.Registration | Inspection.ACT_Registration_Create [members unknown] | none | none | none |
| Inspection.Report | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate [members unknown] | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate [members unknown] | none | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate |
| Inspection.ReportHelper | Inspection.ACT_ReportHelper_Create [members unknown] | none | none | none |
| Inspection.Task | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Inspection.ACT_Task_Create, Notification.SE_Notification_SendToInspectors [members unknown] | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Notification.SE_Notification_SendToInspectors [members unknown] | none | Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Inspection.CAL_Inspector_TasksOpen, Inspection.CAL_Inspector_TasksOverdue, Inspection.DS_Task_GetFromNotification, Notification.SE_Notification_SendToInspectors |
| Inspection.Tool | Inspection.ACT_Tool_Create [members unknown] | none | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| Inspection.Accessory | Inspection.Manager | None | none |
| Inspection.Accessory | Inspection.Inspector | None | none |
| Inspection.Booking | Inspection.Inspector | None | none |
| Inspection.Booking | Inspection.Manager | None | none |
| Inspection.CoverPhoto | Inspection.Inspector | ReadWrite | none |
| Inspection.CoverPhoto | Inspection.Manager | ReadOnly | none |
| Inspection.CoverPhoto | Inspection.Administrator | ReadOnly | none |
| Inspection.Equipment | Inspection.Manager | None | none |
| Inspection.Equipment | Inspection.Inspector | None | none |
| Inspection.InspectionItem | Inspection.Inspector | ReadWrite | [Inspection.Task_InspectionItem/Inspection.Task/Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] |
| Inspection.InspectionItem | Inspection.Manager | ReadWrite | none |
| Inspection.Inspector | Inspection.Inspector | ReadOnly | none |
| Inspection.Inspector | Inspection.Manager | ReadWrite | none |
| Inspection.Inspector | Inspection.Administrator | ReadWrite | none |
| Inspection.InspectorPhoto | Inspection.Inspector | ReadWrite | none |
| Inspection.InspectorPhoto | Inspection.Manager | ReadOnly | none |
| Inspection.InspectorPhoto | Inspection.Administrator | ReadOnly | none |
| Inspection.Registration | Inspection.Anonymous | None | none |
| Inspection.Report | Inspection.Manager | None | none |
| Inspection.ReportHelper | Inspection.Administrator, Inspection.Manager | None | none |
| Inspection.Task | Inspection.Inspector | ReadWrite | [Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] |
| Inspection.Task | Inspection.Manager | ReadWrite | none |
| Inspection.Tool | Inspection.Manager | None | none |
| Inspection.Tool | Inspection.Inspector | None | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| Inspection.Booking_Equipment | Inspection.Booking | Inspection.Equipment | *-1 | Reference | Default |
| Inspection.Booking_Inspector | Inspection.Booking | Inspection.Inspector | *-1 | Reference | Default |
| Inspection.InspectorPhoto_Inspector | Inspection.InspectorPhoto | Inspection.Inspector | 1-1 | Reference | Both |
| Inspection.Task_CoverPhoto | Inspection.Task | Inspection.CoverPhoto | 1-1 | Reference | Both |
| Inspection.Task_InspectionItem | Inspection.Task | Inspection.InspectionItem | *-1 | Reference | Default |
| Inspection.Task_Inspector | Inspection.Task | Inspection.Inspector | *-1 | Reference | Default |
| Inspection.Task_Report | Inspection.Task | Inspection.Report | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| Inspection.ENUM_Accessory_Status | 3 | Almost_out_of_stock, In_Stock, Out_of_stock |
| Inspection.ENUM_InspectionItem_Status | 2 | Assigned, InProgress |
| Inspection.ENUM_Inspector_Level | 3 | Junior, Medior, Senior |
| Inspection.Enum_Registration_UserRole | 2 | Inspector, Manager |
| Inspection.ENUM_TaskPriority | 3 | High, Low, Medium |
| Inspection.Enum_TaskStatus | 3 | Done, Running, To_do |
| Inspection.ENUM_TaskType | 7 | EquipmentIssue, FacilityIssue, HygieneIssue, ITIssue |

## Entity Index

<a id="entity-inspection-accessory"></a>
### Inspection.Accessory

- Generalization: Inspection.Equipment.
- Lifecycle: create=Inspection.ACT_Accessory_Create, Inspection.SE_Equipment_OrderNew; update=Inspection.SE_Equipment_OrderNew; delete=none; read=Inspection.SE_Equipment_OrderNew.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| AmountInStock | Integer | — | 0 | — |
| EquipmentStatus | Inspection.ENUM_Accessory_Status | — | In_Stock | — |
| IsOrdered | Boolean | — | false | — |
<a id="entity-inspection-booking"></a>
### Inspection.Booking

- Generalization: none.
- Lifecycle: create=Inspection.ACT_Tool_Validate; update=Inspection.ACT_Tool_Validate; delete=Inspection.SUB_Booking_Delete; read=Inspection.ACT_Tool_Validate, Inspection.SUB_Booking_Delete.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Date | DateTime | — | — | — |
<a id="entity-inspection-coverphoto"></a>
### Inspection.CoverPhoto

- Generalization: System.Image.
- Lifecycle: create=Inspection.ACT_CoverPhoto_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

No attributes (excluding system attributes).
<a id="entity-inspection-equipment"></a>
### Inspection.Equipment

- Generalization: none.
- Lifecycle: create=Inspection.SE_Equipment_OrderNew; update=Inspection.SE_Equipment_OrderNew; delete=none; read=Inspection.SE_Equipment_OrderNew.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Brand | String | 200 | — | — |
| Name | String | 200 | — | — |
<a id="entity-inspection-inspectionitem"></a>
### Inspection.InspectionItem

- Generalization: System.Image.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Description | String | 0 | — | — |
| ItemId | AutoNumber | — | 1 | — |
| ItemLocation | String | 200 | — | — |
| ItemName | String | 200 | — | — |
<a id="entity-inspection-inspector"></a>
### Inspection.Inspector

- Generalization: none.
- Lifecycle: create=Inspection.ACT_Registration_Save; update=Inspection.ACT_Registration_Save; delete=none; read=Inspection.ACT_Registration_Save, Inspection.DS_Inspector_GetFromCurrentUSer, Inspection.DSL_Inspector_Selectable.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Country | String | 200 | — | — |
| EmailAddress | String | 200 | — | — |
| Level | Inspection.ENUM_Inspector_Level | — | — | — |
| Location | String | 200 | — | — |
| Name | String | 200 | — | — |
| TasksOpen | Integer | — | Calculated(Inspection.CAL_Inspector_TasksOpen) | — |
| TasksOverdue | Integer | — | Calculated(Inspection.CAL_Inspector_TasksOverdue) | — |
| Telephone | String | 200 | — | — |
<a id="entity-inspection-inspectorphoto"></a>
### Inspection.InspectorPhoto

- Generalization: System.Image.
- Lifecycle: create=Inspection.ACT_InspectorPhoto_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

No attributes (excluding system attributes).
<a id="entity-inspection-registration"></a>
### Inspection.Registration

- Generalization: none.
- Lifecycle: create=Inspection.ACT_Registration_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| ConfirmPassword | String | 200 | — | — |
| EmailAddress | String | 200 | — | — |
| FullName | String | 200 | — | — |
| Password | String | 200 | — | — |
| Role | Inspection.Enum_Registration_UserRole | — | — | — |
| UserName | String | 200 | — | — |
<a id="entity-inspection-report"></a>
### Inspection.Report

- Generalization: System.FileDocument.
- Lifecycle: create=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate; update=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate; delete=none; read=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

No attributes (excluding system attributes).
<a id="entity-inspection-reporthelper"></a>
### Inspection.ReportHelper

- Generalization: none.
- Lifecycle: create=Inspection.ACT_ReportHelper_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| Category | Inspection.ENUM_TaskType | — | — | — |
| EndDate | DateTime | — | — | — |
| StartDate | DateTime | — | — | — |
<a id="entity-inspection-task"></a>
### Inspection.Task

- Generalization: none.
- Lifecycle: create=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Inspection.ACT_Task_Create, Notification.SE_Notification_SendToInspectors; update=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Notification.SE_Notification_SendToInspectors; delete=none; read=Inspection.ACT_Report_ApplyFilters, Inspection.ACT_Report_Generate, Inspection.CAL_Inspector_TasksOpen, Inspection.CAL_Inspector_TasksOverdue, Inspection.DS_Task_GetFromNotification, Notification.SE_Notification_SendToInspectors.
- Security/XPath summary: [app security](../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| AdditionalRemarks | String | 2000 | — | — |
| Created | DateTime | — | — | — |
| Description | String | 1500 | — | — |
| DueDate | DateTime | — | — | — |
| Priority | Inspection.ENUM_TaskPriority | — | — | — |
| Status | Inspection.Enum_TaskStatus | — | To_do | — |
| TaskID | AutoNumber | — | 1 | — |
| Title | String | 200 | — | — |
| _Type | Inspection.ENUM_TaskType | — | — | — |
<a id="entity-inspection-tool"></a>
### Inspection.Tool

- Generalization: Inspection.Equipment.
- Lifecycle: create=Inspection.ACT_Tool_Create; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt) / [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| PickupLocation | String | 200 | — | — |
| ReservationDate | DateTime | — | — | — |

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../app-overview/cli_2026-03-18T20-52-48.461Z/modules/Inspection/domain-model.json)
