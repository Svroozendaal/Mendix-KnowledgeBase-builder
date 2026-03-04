# Pages: SmartExpenses

Pages: 29, Snippets: 1

## Page Inventory

| Page | Title | Layout | Type | Roles | Parameters |
|------|-------|--------|------|-------|------------|
| BalanceType_Overview | Overzicht van alle saldo's | Atlas_TopBar | Full | User, Admin | FBGProfile |
| Balance_MasterNewEdit | Edit Balance | PopupLayout | Popup | Admin | Balance |
| Balance_MasterOverview | Balance Overview | Atlas_Default | Full | Admin, Parent | — |
| Balance_NewEdit | Saldo | PopupLayout | Popup | Admin, User | Balance |
| BudgetTerm_EditQuick | Edit Budget Type | PopupLayout | Popup | Admin, User | BudgetTerm |
| BudgetTerm_MasterNewEdit | Edit Budget Term | PopupLayout | Popup | Admin | BudgetTerm |
| BudgetTerm_MasterOverview | Budget Term Overview | Atlas_Default | Full | Admin | — |
| BudgetTerm_NewEdit | Budget | PopupLayout | Popup | Admin, User | BudgetType, BudgetTerm |
| BudgetTerm_Overview | Budget Term Overview | Atlas_TopBar | Full | Admin, User, Parent | BudgetType |
| BudgetType_NewEdit_Master | Edit Budget Type | PopupLayout | Popup | Admin | BudgetType |
| BudgetType_Overview | Budget Type Overview | Atlas_TopBar | Full | User, Admin, Parent | FBGProfile, DateHelper |
| BudgetType_Overview_2 | Budget Type Overview | Atlas_Default | Full | Admin | — |
| datagid | datagid | PopupLayout | Popup | — | — |
| FBGProfile_NewEdit | Edit FBG Profile | PopupLayout | Popup | Admin | FBGProfile |
| FBGProfile_Overview | FBG Environment Overview | Atlas_TopBar | Full | Admin | — |
| FBGProfile_Overview_2 | FBG Profile Overview | Atlas_Default | Full | Admin | — |
| Homepage_Admin | Homepage Admin | Atlas_TopBar | Full | Admin | — |
| Home_Parent | Homepage | Atlas_TopBar | Full | Admin, Parent, User | FBGProfile |
| Home_Web | Homepage | Atlas_TopBar | Full | User, Admin, Parent | — |
| Login_Overview | Login Overview | PopupLayout | Popup | Anonymous, Admin | — |
| StandardBudget_NewEdit | Edit Standard Budget | PopupLayout | Popup | Admin | StandardBudget |
| StandardBudget_Overview | Standard Budget Overview | Atlas_TopBar | Full | Admin | — |
| Transaction_BulkEdit | Transaction Bulk edit | PopupLayout | Popup | Admin, User | BulkEditHelper, FBGProfile |
| Transaction_Edit | Pas transactie aan | PopupLayout (800x0) | Popup | Admin, User | Transaction |
| Transaction_EditQuick | Snel verwerken | PopupLayout | Popup | Admin, User | Transaction |
| Transaction_New | Nieuwe transactie | PopupLayout (800x600) | Popup | Admin, User | Transaction |
| Transaction_NewEdit | Edit Transaction | PopupLayout | Popup | Admin | Transaction |
| Transaction_Overview | Transaction Overview | Atlas_TopBar | Full | Admin, User, Parent | FBGProfile |
| Transaction_Overview_2 | Transaction Overview | Atlas_Default | Full | Admin | — |

## Page-Flow Links

| Page | Shown by Flows |
|------|----------------|
| Balance_NewEdit | ACT_Balance_Create |
| BudgetTerm_NewEdit | ACT_BudgetTerm_BudgetType_Edit, ACT_BudgetType_New |
| BudgetType_Overview | ACT_BudgetType_OpenOverviewPAge, Nanoflow |
| Home_Parent | ACT_FBGProfile_showParentPage |
| StandardBudget_NewEdit | ACT_StandardBudget_Edit, ACT_StandardBudget_New |
| Transaction_BulkEdit | ACT_Transaction_BulkEditCreate |
| Transaction_New | ACT_Transaction_Create |
| ImporterHelper.ExcelFileImport_Upload | (shown from ImporterHelper flows) |
| ImporterHelper.ImportTransaction_Overview | (shown from ImporterHelper flows) |

## Page Patterns
- **Overview + Edit pairs**: Most entities follow a pattern of full-page overview (Atlas_TopBar) + popup edit form (PopupLayout)
- **Master variants**: Some entities have "Master" admin-only pages alongside user-facing pages (Balance_MasterOverview vs BalanceType_Overview)
- **Dutch titles**: Several pages use Dutch titles (Saldo, Pas transactie aan, Nieuwe transactie, Snel verwerken, Overzicht van alle saldo's)
- **_2 suffix pages**: Admin-only full-page overviews using Atlas_Default layout — likely alternative admin views

## Snippets

| Snippet | Type |
|---------|------|
| Entity_Menu | Web |
