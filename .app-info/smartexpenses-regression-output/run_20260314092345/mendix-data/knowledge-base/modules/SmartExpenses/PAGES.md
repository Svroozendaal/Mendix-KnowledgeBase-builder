# Pages: SmartExpenses

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| SmartExpenses.Balance_MasterNewEdit | Edit Balance | SmartExpenses.Admin | Balance:SmartExpenses.Balance | True |
| SmartExpenses.Balance_MasterOverview | Balance Overview | SmartExpenses.Admin, SmartExpenses.Parent | none | False |
| SmartExpenses.Balance_NewEdit | Saldo | SmartExpenses.Admin, SmartExpenses.User | Balance:SmartExpenses.Balance | True |
| SmartExpenses.BalanceType_Overview | Overzicht van alle saldo's | SmartExpenses.Admin, SmartExpenses.User | FBGProfile:SmartExpenses.FBGProfile | False |
| SmartExpenses.BudgetTerm_EditQuick | Edit Budget Type | SmartExpenses.Admin, SmartExpenses.User | BudgetTerm:SmartExpenses.BudgetTerm | True |
| SmartExpenses.BudgetTerm_MasterNewEdit | Edit Budget Term | SmartExpenses.Admin | BudgetTerm:SmartExpenses.BudgetTerm | True |
| SmartExpenses.BudgetTerm_MasterOverview | Budget Term Overview | SmartExpenses.Admin | none | False |
| SmartExpenses.BudgetTerm_NewEdit | Budget | SmartExpenses.Admin, SmartExpenses.User | BudgetTerm:SmartExpenses.BudgetTerm, BudgetType:SmartExpenses.BudgetType | True |
| SmartExpenses.BudgetTerm_Overview | Budget Term Overview | SmartExpenses.Admin, SmartExpenses.Parent, SmartExpenses.User | BudgetType:SmartExpenses.BudgetType | False |
| SmartExpenses.BudgetType_NewEdit_Master | Edit Budget Type | SmartExpenses.Admin | BudgetType:SmartExpenses.BudgetType | True |
| SmartExpenses.BudgetType_Overview | Budget Type Overview | SmartExpenses.Admin, SmartExpenses.Parent, SmartExpenses.User | DateHelper:SmartExpenses.DateHelper, FBGProfile:SmartExpenses.FBGProfile | False |
| SmartExpenses.BudgetType_Overview_2 | Budget Type Overview | SmartExpenses.Admin | none | False |
| SmartExpenses.datagid | datagid | none | none | True |
| SmartExpenses.FBGProfile_NewEdit | Edit FBG Profile | SmartExpenses.Admin | FBGProfile:SmartExpenses.FBGProfile | True |
| SmartExpenses.FBGProfile_Overview | FBG Environment Overview | SmartExpenses.Admin | none | False |
| SmartExpenses.FBGProfile_Overview_2 | FBG Profile Overview | SmartExpenses.Admin | none | False |
| SmartExpenses.Home_Parent | Homepage | SmartExpenses.Admin, SmartExpenses.Parent, SmartExpenses.User | FBGProfile:SmartExpenses.FBGProfile | False |
| SmartExpenses.Home_Web | Homepage | SmartExpenses.Admin, SmartExpenses.Parent, SmartExpenses.User | none | False |
| SmartExpenses.Homepage_Admin | Homepage Admin | SmartExpenses.Admin | none | False |
| SmartExpenses.Login_Overview | Login Overview | SmartExpenses.Admin, SmartExpenses.Anonymous | none | True |
| SmartExpenses.StandardBudget_NewEdit | Edit Standard Budget | SmartExpenses.Admin | StandardBudget:SmartExpenses.StandardBudget | True |
| SmartExpenses.StandardBudget_Overview | Standard Budget Overview | SmartExpenses.Admin | none | False |
| SmartExpenses.Transaction_BulkEdit | Transaction Bulk edit | SmartExpenses.Admin, SmartExpenses.User | BulkEditHelper:SmartExpenses.BulkEditHelper, FBGProfile:SmartExpenses.FBGProfile | True |
| SmartExpenses.Transaction_Edit | Pas transactie aan | SmartExpenses.Admin, SmartExpenses.User | Transaction:SmartExpenses.Transaction | True |
| SmartExpenses.Transaction_EditQuick | Snel verwerken | SmartExpenses.Admin, SmartExpenses.User | Transaction:SmartExpenses.Transaction | True |
| SmartExpenses.Transaction_New | Nieuwe transactie | SmartExpenses.Admin, SmartExpenses.User | Transaction:SmartExpenses.Transaction | True |
| SmartExpenses.Transaction_NewEdit | Edit Transaction | SmartExpenses.Admin | Transaction:SmartExpenses.Transaction | True |
| SmartExpenses.Transaction_Overview | Transaction Overview | SmartExpenses.Admin, SmartExpenses.Parent, SmartExpenses.User | FBGProfile:SmartExpenses.FBGProfile | False |
| SmartExpenses.Transaction_Overview_2 | Transaction Overview | SmartExpenses.Admin | none | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| SmartExpenses.Balance_MasterNewEdit | none |
| SmartExpenses.Balance_MasterOverview | none |
| SmartExpenses.Balance_NewEdit | SmartExpenses.ACT_Balance_Create |
| SmartExpenses.BalanceType_Overview | none |
| SmartExpenses.BudgetTerm_EditQuick | none |
| SmartExpenses.BudgetTerm_MasterNewEdit | none |
| SmartExpenses.BudgetTerm_MasterOverview | none |
| SmartExpenses.BudgetTerm_NewEdit | SmartExpenses.ACT_BudgetTerm_BudgetType_Edit, SmartExpenses.ACT_BudgetType_New |
| SmartExpenses.BudgetTerm_Overview | none |
| SmartExpenses.BudgetType_NewEdit_Master | none |
| SmartExpenses.BudgetType_Overview | SmartExpenses.ACT_BudgetType_OpenOverviewPAge, SmartExpenses.Nanoflow |
| SmartExpenses.BudgetType_Overview_2 | none |
| SmartExpenses.datagid | none |
| SmartExpenses.FBGProfile_NewEdit | none |
| SmartExpenses.FBGProfile_Overview | none |
| SmartExpenses.FBGProfile_Overview_2 | none |
| SmartExpenses.Home_Parent | SmartExpenses.ACT_FBGProfile_showParentPage |
| SmartExpenses.Home_Web | none |
| SmartExpenses.Homepage_Admin | none |
| SmartExpenses.Login_Overview | none |
| SmartExpenses.StandardBudget_NewEdit | SmartExpenses.ACT_StandardBudget_Edit, SmartExpenses.ACT_StandardBudget_New |
| SmartExpenses.StandardBudget_Overview | none |
| SmartExpenses.Transaction_BulkEdit | SmartExpenses.ACT_Transaction_BulkEditCreate |
| SmartExpenses.Transaction_Edit | none |
| SmartExpenses.Transaction_EditQuick | none |
| SmartExpenses.Transaction_New | SmartExpenses.ACT_Transaction_Create |
| SmartExpenses.Transaction_NewEdit | none |
| SmartExpenses.Transaction_Overview | none |
| SmartExpenses.Transaction_Overview_2 | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| Balance | SmartExpenses.Balance_MasterNewEdit, SmartExpenses.Balance_MasterOverview, SmartExpenses.Balance_NewEdit |
| BalanceType | SmartExpenses.BalanceType_Overview |
| BudgetTerm | SmartExpenses.BudgetTerm_EditQuick, SmartExpenses.BudgetTerm_MasterNewEdit, SmartExpenses.BudgetTerm_MasterOverview, SmartExpenses.BudgetTerm_NewEdit, SmartExpenses.BudgetTerm_Overview |
| BudgetType | SmartExpenses.BudgetType_NewEdit_Master, SmartExpenses.BudgetType_Overview, SmartExpenses.BudgetType_Overview_2 |
| FBGProfile | SmartExpenses.FBGProfile_NewEdit, SmartExpenses.FBGProfile_Overview, SmartExpenses.FBGProfile_Overview_2 |
| General | SmartExpenses.datagid |
| Home | SmartExpenses.Home_Parent, SmartExpenses.Home_Web |
| Homepage | SmartExpenses.Homepage_Admin |
| Login | SmartExpenses.Login_Overview |
| StandardBudget | SmartExpenses.StandardBudget_NewEdit, SmartExpenses.StandardBudget_Overview |
| Transaction | SmartExpenses.Transaction_BulkEdit, SmartExpenses.Transaction_Edit, SmartExpenses.Transaction_EditQuick, SmartExpenses.Transaction_New, SmartExpenses.Transaction_NewEdit, SmartExpenses.Transaction_Overview, SmartExpenses.Transaction_Overview_2 |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| SmartExpenses.Balance_MasterNewEdit | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-balance-masternewedit.abstract.md) | [L1](pages/smartexpenses-balance-masternewedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-balance-masternewedit.json) |
| SmartExpenses.Balance_MasterOverview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-balance-masteroverview.abstract.md) | [L1](pages/smartexpenses-balance-masteroverview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-balance-masteroverview.json) |
| SmartExpenses.Balance_NewEdit | ShowPageAction | [L0](pages/smartexpenses-balance-newedit.abstract.md) | [L1](pages/smartexpenses-balance-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-balance-newedit.json) |
| SmartExpenses.BalanceType_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-balancetype-overview.abstract.md) | [L1](pages/smartexpenses-balancetype-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-balancetype-overview.json) |
| SmartExpenses.BudgetTerm_EditQuick | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgetterm-editquick.abstract.md) | [L1](pages/smartexpenses-budgetterm-editquick.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgetterm-editquick.json) |
| SmartExpenses.BudgetTerm_MasterNewEdit | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgetterm-masternewedit.abstract.md) | [L1](pages/smartexpenses-budgetterm-masternewedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgetterm-masternewedit.json) |
| SmartExpenses.BudgetTerm_MasterOverview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgetterm-masteroverview.abstract.md) | [L1](pages/smartexpenses-budgetterm-masteroverview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgetterm-masteroverview.json) |
| SmartExpenses.BudgetTerm_NewEdit | ShowPageAction | [L0](pages/smartexpenses-budgetterm-newedit.abstract.md) | [L1](pages/smartexpenses-budgetterm-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgetterm-newedit.json) |
| SmartExpenses.BudgetTerm_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgetterm-overview.abstract.md) | [L1](pages/smartexpenses-budgetterm-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgetterm-overview.json) |
| SmartExpenses.BudgetType_NewEdit_Master | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgettype-newedit-master.abstract.md) | [L1](pages/smartexpenses-budgettype-newedit-master.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgettype-newedit-master.json) |
| SmartExpenses.BudgetType_Overview | ShowPageAction | [L0](pages/smartexpenses-budgettype-overview.abstract.md) | [L1](pages/smartexpenses-budgettype-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgettype-overview.json) |
| SmartExpenses.BudgetType_Overview_2 | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-budgettype-overview-2.abstract.md) | [L1](pages/smartexpenses-budgettype-overview-2.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-budgettype-overview-2.json) |
| SmartExpenses.datagid | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-datagid.abstract.md) | [L1](pages/smartexpenses-datagid.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-datagid.json) |
| SmartExpenses.FBGProfile_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-fbgprofile-newedit.abstract.md) | [L1](pages/smartexpenses-fbgprofile-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-fbgprofile-newedit.json) |
| SmartExpenses.FBGProfile_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-fbgprofile-overview.abstract.md) | [L1](pages/smartexpenses-fbgprofile-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-fbgprofile-overview.json) |
| SmartExpenses.FBGProfile_Overview_2 | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-fbgprofile-overview-2.abstract.md) | [L1](pages/smartexpenses-fbgprofile-overview-2.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-fbgprofile-overview-2.json) |
| SmartExpenses.Home_Parent | ShowPageAction | [L0](pages/smartexpenses-home-parent.abstract.md) | [L1](pages/smartexpenses-home-parent.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-home-parent.json) |
| SmartExpenses.Home_Web | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-home-web.abstract.md) | [L1](pages/smartexpenses-home-web.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-home-web.json) |
| SmartExpenses.Homepage_Admin | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-homepage-admin.abstract.md) | [L1](pages/smartexpenses-homepage-admin.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-homepage-admin.json) |
| SmartExpenses.Login_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-login-overview.abstract.md) | [L1](pages/smartexpenses-login-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-login-overview.json) |
| SmartExpenses.StandardBudget_NewEdit | ShowPageAction | [L0](pages/smartexpenses-standardbudget-newedit.abstract.md) | [L1](pages/smartexpenses-standardbudget-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-standardbudget-newedit.json) |
| SmartExpenses.StandardBudget_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-standardbudget-overview.abstract.md) | [L1](pages/smartexpenses-standardbudget-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-standardbudget-overview.json) |
| SmartExpenses.Transaction_BulkEdit | ShowPageAction | [L0](pages/smartexpenses-transaction-bulkedit.abstract.md) | [L1](pages/smartexpenses-transaction-bulkedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-bulkedit.json) |
| SmartExpenses.Transaction_Edit | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-transaction-edit.abstract.md) | [L1](pages/smartexpenses-transaction-edit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-edit.json) |
| SmartExpenses.Transaction_EditQuick | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-transaction-editquick.abstract.md) | [L1](pages/smartexpenses-transaction-editquick.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-editquick.json) |
| SmartExpenses.Transaction_New | ShowPageAction | [L0](pages/smartexpenses-transaction-new.abstract.md) | [L1](pages/smartexpenses-transaction-new.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-new.json) |
| SmartExpenses.Transaction_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-transaction-newedit.abstract.md) | [L1](pages/smartexpenses-transaction-newedit.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-newedit.json) |
| SmartExpenses.Transaction_Overview | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-transaction-overview.abstract.md) | [L1](pages/smartexpenses-transaction-overview.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-overview.json) |
| SmartExpenses.Transaction_Overview_2 | Unknown (navigation metadata not exported) | [L0](pages/smartexpenses-transaction-overview-2.abstract.md) | [L1](pages/smartexpenses-transaction-overview-2.overview.md) | [L2](../../../app-overview/current/modules/SmartExpenses/pages/smartexpenses-transaction-overview-2.json) |
