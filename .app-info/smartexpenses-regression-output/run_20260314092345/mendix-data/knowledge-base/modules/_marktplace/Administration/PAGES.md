# Pages: Administration

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| Administration.Account_Edit | Edit Account | Administration.Administrator, Administration.User | Account:Administration.Account | True |
| Administration.Account_New | New Account | Administration.Administrator, Administration.User | AccountPasswordData:Administration.AccountPasswordData | True |
| Administration.Account_Overview | Accounts | Administration.Administrator | none | False |
| Administration.ActiveSessions | Active Sessions | Administration.Administrator | none | False |
| Administration.ChangeMyPasswordForm | Change Password | none | AccountPasswordData:Administration.AccountPasswordData | True |
| Administration.ChangePasswordForm | Change Password | none | AccountPasswordData:Administration.AccountPasswordData | True |
| Administration.MyAccount | My Account | none | Account:Administration.Account | True |
| Administration.RuntimeInstances | Runtime Instances | Administration.Administrator | none | False |
| Administration.ScheduledEvents | Scheduled Events | Administration.Administrator | none | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| Administration.Account_Edit | none |
| Administration.Account_New | Administration.NewAccount, Administration.NewWebServiceAccount |
| Administration.Account_Overview | none |
| Administration.ActiveSessions | none |
| Administration.ChangeMyPasswordForm | Administration.ShowMyPasswordForm |
| Administration.ChangePasswordForm | Administration.ShowPasswordForm |
| Administration.MyAccount | Administration.ManageMyAccount |
| Administration.RuntimeInstances | none |
| Administration.ScheduledEvents | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| Account | Administration.Account_Edit, Administration.Account_New, Administration.Account_Overview |
| General | Administration.ActiveSessions, Administration.ChangeMyPasswordForm, Administration.ChangePasswordForm, Administration.MyAccount, Administration.RuntimeInstances, Administration.ScheduledEvents |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| Administration.Account_Edit | Unknown (navigation metadata not exported) | [L0](pages/administration-account-edit.abstract.md) | [L1](pages/administration-account-edit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-edit.json) |
| Administration.Account_New | ShowPageAction | [L0](pages/administration-account-new.abstract.md) | [L1](pages/administration-account-new.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-new.json) |
| Administration.Account_Overview | Unknown (navigation metadata not exported) | [L0](pages/administration-account-overview.abstract.md) | [L1](pages/administration-account-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-account-overview.json) |
| Administration.ActiveSessions | Unknown (navigation metadata not exported) | [L0](pages/administration-activesessions.abstract.md) | [L1](pages/administration-activesessions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-activesessions.json) |
| Administration.ChangeMyPasswordForm | ShowPageAction | [L0](pages/administration-changemypasswordform.abstract.md) | [L1](pages/administration-changemypasswordform.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-changemypasswordform.json) |
| Administration.ChangePasswordForm | ShowPageAction | [L0](pages/administration-changepasswordform.abstract.md) | [L1](pages/administration-changepasswordform.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-changepasswordform.json) |
| Administration.MyAccount | ShowPageAction | [L0](pages/administration-myaccount.abstract.md) | [L1](pages/administration-myaccount.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-myaccount.json) |
| Administration.RuntimeInstances | Unknown (navigation metadata not exported) | [L0](pages/administration-runtimeinstances.abstract.md) | [L1](pages/administration-runtimeinstances.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-runtimeinstances.json) |
| Administration.ScheduledEvents | Unknown (navigation metadata not exported) | [L0](pages/administration-scheduledevents.abstract.md) | [L1](pages/administration-scheduledevents.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/Administration/pages/administration-scheduledevents.json) |
