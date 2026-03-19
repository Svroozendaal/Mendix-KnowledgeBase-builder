# Security

## Role-to-Module-Role Matrix

| Project role | Custom module roles | All module roles |
|---|---|---|
| Administrator | Inspection.Administrator, Notification.Administrator | Administration.Administrator, Inspection.Administrator, Notification.Administrator, System.Administrator |
| Inspector | Inspection.Inspector, Notification.Inspector | Administration.User, Inspection.Inspector, Notification.Inspector, System.User |
| Manager | Inspection.Manager, Notification.Manager | Administration.User, Inspection.Manager, Notification.Manager, System.User |
| Anonymous | Inspection.Anonymous | Inspection.Anonymous, System.User |

Confidence: Export-backed

## Entity Access Summary (Custom Entities)

| Entity | Rule module roles | Allow create | Allow delete | XPath constraint |
|---|---|---|---|---|
| Inspection.Accessory | Inspection.Manager | False | False | none |
| Inspection.Accessory | Inspection.Inspector | False | False | none |
| Inspection.Booking | Inspection.Inspector | False | False | none |
| Inspection.Booking | Inspection.Manager | False | False | none |
| Inspection.CoverPhoto | Inspection.Inspector | True | True | none |
| Inspection.CoverPhoto | Inspection.Manager | True | True | none |
| Inspection.CoverPhoto | Inspection.Administrator | True | True | none |
| Inspection.Equipment | Inspection.Manager | False | False | none |
| Inspection.Equipment | Inspection.Inspector | False | False | none |
| Inspection.InspectionItem | Inspection.Inspector | False | False | [Inspection.Task_InspectionItem/Inspection.Task/Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] |
| Inspection.InspectionItem | Inspection.Manager | True | False | none |
| Inspection.Inspector | Inspection.Inspector | False | False | none |
| Inspection.Inspector | Inspection.Manager | True | True | none |
| Inspection.Inspector | Inspection.Administrator | True | True | none |
| Inspection.InspectorPhoto | Inspection.Inspector | True | True | none |
| Inspection.InspectorPhoto | Inspection.Manager | True | True | none |
| Inspection.InspectorPhoto | Inspection.Administrator | True | True | none |
| Inspection.Registration | Inspection.Anonymous | False | False | none |
| Inspection.Report | Inspection.Manager | True | True | none |
| Inspection.ReportHelper | Inspection.Administrator, Inspection.Manager | True | True | none |
| Inspection.Task | Inspection.Inspector | False | False | [Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] |
| Inspection.Task | Inspection.Manager | True | True | none |
| Inspection.Tool | Inspection.Manager | False | False | none |
| Inspection.Tool | Inspection.Inspector | False | False | none |
| Notification.Notification | Notification.Inspector | False | True | none |
| Notification.Notification | Notification.Manager | False | True | none |

Confidence: Export-backed

## XPath Constraints (Plain Language)

| Entity | Module roles | XPath | Access meaning |
|---|---|---|---|
| Inspection.InspectionItem | Inspection.Inspector | [Inspection.Task_InspectionItem/Inspection.Task/Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] | [Inspection.Task_InspectionItem/Inspection.Task/Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='current user'] |
| Inspection.Task | Inspection.Inspector | [Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='[%CurrentUser%]'] | [Inspection.Task_Inspector/Inspection.Inspector/Inspection.Inspector_Account='current user'] |

Confidence: Inferred

## Source

- Security level: CheckEverything
- Guest access: True
