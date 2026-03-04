# Page Index

Cross-reference of all pages with the flows that show them.

## SmartExpenses Pages

| Page | Title | Shown by Flows | Roles | Entity Parameters |
|------|-------|----------------|-------|-------------------|
| SmartExpenses.BalanceType_Overview | Overzicht van alle saldo's | — | User, Admin | FBGProfile |
| SmartExpenses.Balance_MasterNewEdit | Edit Balance | — | Admin | Balance |
| SmartExpenses.Balance_MasterOverview | Balance Overview | — | Admin, Parent | — |
| SmartExpenses.Balance_NewEdit | Saldo | ACT_Balance_Create | Admin, User | Balance |
| SmartExpenses.BudgetTerm_EditQuick | Edit Budget Type | — | Admin, User | BudgetTerm |
| SmartExpenses.BudgetTerm_MasterNewEdit | Edit Budget Term | — | Admin | BudgetTerm |
| SmartExpenses.BudgetTerm_MasterOverview | Budget Term Overview | — | Admin | — |
| SmartExpenses.BudgetTerm_NewEdit | Budget | ACT_BudgetTerm_BudgetType_Edit, ACT_BudgetType_New | Admin, User | BudgetType, BudgetTerm |
| SmartExpenses.BudgetTerm_Overview | Budget Term Overview | — | Admin, User, Parent | BudgetType |
| SmartExpenses.BudgetType_NewEdit_Master | Edit Budget Type | — | Admin | BudgetType |
| SmartExpenses.BudgetType_Overview | Budget Type Overview | ACT_BudgetType_OpenOverviewPAge, Nanoflow | User, Admin, Parent | FBGProfile, DateHelper |
| SmartExpenses.BudgetType_Overview_2 | Budget Type Overview | — | Admin | — |
| SmartExpenses.datagid | datagid | — | — | — |
| SmartExpenses.FBGProfile_NewEdit | Edit FBG Profile | — | Admin | FBGProfile |
| SmartExpenses.FBGProfile_Overview | FBG Environment Overview | — | Admin | — |
| SmartExpenses.FBGProfile_Overview_2 | FBG Profile Overview | — | Admin | — |
| SmartExpenses.Homepage_Admin | Homepage Admin | — | Admin | — |
| SmartExpenses.Home_Parent | Homepage | ACT_FBGProfile_showParentPage | Admin, Parent, User | FBGProfile |
| SmartExpenses.Home_Web | Homepage | — | User, Admin, Parent | — |
| SmartExpenses.Login_Overview | Login Overview | — | Anonymous, Admin | — |
| SmartExpenses.StandardBudget_NewEdit | Edit Standard Budget | ACT_StandardBudget_Edit, ACT_StandardBudget_New | Admin | StandardBudget |
| SmartExpenses.StandardBudget_Overview | Standard Budget Overview | — | Admin | — |
| SmartExpenses.Transaction_BulkEdit | Transaction Bulk edit | ACT_Transaction_BulkEditCreate | Admin, User | BulkEditHelper, FBGProfile |
| SmartExpenses.Transaction_Edit | Pas transactie aan | — | Admin, User | Transaction |
| SmartExpenses.Transaction_EditQuick | Snel verwerken | — | Admin, User | Transaction |
| SmartExpenses.Transaction_New | Nieuwe transactie | ACT_Transaction_Create | Admin, User | Transaction |
| SmartExpenses.Transaction_NewEdit | Edit Transaction | — | Admin | Transaction |
| SmartExpenses.Transaction_Overview | Transaction Overview | — | Admin, User, Parent | FBGProfile |
| SmartExpenses.Transaction_Overview_2 | Transaction Overview | — | Admin | — |

## ImporterHelper Pages

| Page | Title | Shown by Flows | Roles | Entity Parameters |
|------|-------|----------------|-------|-------------------|
| ImporterHelper.ExcelFileImport_Upload | Excel file import Upload | ACT_ExcelFileImport_Create | — | ExcelFileImport |
| ImporterHelper.ImportTransaction_Edit | Pas transactie aan | — | ExcelImporter | ImportTransaction |
| ImporterHelper.ImportTransaction_Overview | Page | ACT_ImportTransaction_ShowPage | ExcelImporter | ImportTransactionHelper, SmartExpenses.FBGProfile |

## Notes
- Pages shown as "—" in the "Shown by Flows" column are likely opened from page navigation widgets (buttons, links) or configured as default home pages, not from ShowPageAction in microflows.
