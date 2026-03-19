# Domain: Administration

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| Administration.Account | True | 3 | 3 |
| Administration.AccountPasswordData | False | 3 | 1 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| Administration.Account | Administration.NewAccount, Administration.NewWebServiceAccount, Inspection.ACT_Registration_Save, Inspection.BCo_Inspector, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager [members unknown] | Administration.NewWebServiceAccount, Inspection.ACT_Registration_Save [members unknown] | none | Inspection.ACT_Registration_Save, Inspection.BCo_Inspector, Inspection.DS_UserRole_GetFromCurrentUser, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager |
| Administration.AccountPasswordData | Administration.NewAccount, Administration.NewWebServiceAccount, Administration.ShowMyPasswordForm, Administration.ShowPasswordForm [members unknown] | Administration.NewWebServiceAccount [members unknown] | none | none |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| Administration.Account | Administration.Administrator |  | none |
| Administration.Account | Administration.User |  | none |
| Administration.Account | Administration.User |  | [id='[%CurrentUser%]'] |
| Administration.AccountPasswordData | Administration.Administrator, Administration.User |  | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| Administration.AccountPasswordData_Account | Administration.AccountPasswordData | Administration.Account | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| none | 0 | none |

## Entity Index

<a id="entity-administration-account"></a>
### Administration.Account

- Generalization: System.User.
- Lifecycle: create=Administration.NewAccount, Administration.NewWebServiceAccount, Inspection.ACT_Registration_Save, Inspection.BCo_Inspector, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager; update=Administration.NewWebServiceAccount, Inspection.ACT_Registration_Save; delete=none; read=Inspection.ACT_Registration_Save, Inspection.BCo_Inspector, Inspection.DS_UserRole_GetFromCurrentUser, Notification.SUB_Notification_SendToInspector, Notification.SUB_Notification_SendToManager.
- Security/XPath summary: [app security](../../../app/SECURITY.md).
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| FullName | String | — | — | — |
| Email | String | — | — | — |
| IsLocalUser | Boolean | — | true | — |
<a id="entity-administration-accountpassworddata"></a>
### Administration.AccountPasswordData

- Generalization: none.
- Lifecycle: create=Administration.NewAccount, Administration.NewWebServiceAccount, Administration.ShowMyPasswordForm, Administration.ShowPasswordForm; update=Administration.NewWebServiceAccount; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.json).

| Attribute | Type | Length/Precision | Default | Validation |
|---|---|---|---|---|
| OldPassword | String | — | — | — |
| NewPassword | String | — | — | — |
| ConfirmPassword | String | — | — | — |

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../app-overview/cli_2026-03-18T21-15-38.461Z/modules/marketplace/Administration/domain-model.json)
