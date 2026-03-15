# Security

## Role-to-Module-Role Matrix

| Project role | Custom module roles | All module roles |
|---|---|---|
| Administrator | ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter, SmartExpenses.Admin, SmartExpenses.User | Administration.Administrator, ExcelImporter.Configurator, ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter, MxModelReflection.ModelAdministrator, SmartExpenses.Admin, SmartExpenses.User, System.Administrator |
| FBG | ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter, SmartExpenses.User | Administration.User, ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter, SmartExpenses.User, System.User |
| Anonymous | none | Administration.User, Atlas_Web_Content.Anonymous, System.User |
| Parent | SmartExpenses.Parent | Administration.User, SmartExpenses.Parent, System.User |

Confidence: Export-backed

## Entity Access Summary (Custom Entities)

| Entity | Rule module roles | Allow create | Allow delete | XPath constraint |
|---|---|---|---|---|
| ImporterHelper.ExcelFileImport | ImporterHelper.ExcelImporter | True | True | none |
| ImporterHelper.ImportTransaction | ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter | True | True | none |
| ImporterHelper.ImportTransactionHelper | ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter | True | True | none |
| New_Module.Entitywith10attributes | New_Module.ModuleRole | True | True | none |
| SmartExpenses.Balance | SmartExpenses.Admin | True | True | none |
| SmartExpenses.Balance | SmartExpenses.Parent | False | False | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Balance | SmartExpenses.Admin, SmartExpenses.User | True | True | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetTerm | SmartExpenses.Admin | True | True | none |
| SmartExpenses.BudgetTerm | SmartExpenses.Parent | False | False | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.BudgetTerm | SmartExpenses.User | True | True | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetType | SmartExpenses.Admin | True | True | none |
| SmartExpenses.BudgetType | SmartExpenses.User | True | True | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.BudgetType | SmartExpenses.Parent | False | False | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.BulkEditHelper | SmartExpenses.Admin, SmartExpenses.User | True | True | none |
| SmartExpenses.DateHelper | SmartExpenses.Admin, SmartExpenses.User | True | True | none |
| SmartExpenses.DateHelper | SmartExpenses.Parent | False | False | none |
| SmartExpenses.FBGProfile | SmartExpenses.Admin | True | True | none |
| SmartExpenses.FBGProfile | SmartExpenses.User | True | True | [SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |
| SmartExpenses.FBGProfile | SmartExpenses.Parent | False | False | [SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Logo | SmartExpenses.Admin, SmartExpenses.User | True | True | none |
| SmartExpenses.Logo | SmartExpenses.Parent | False | False | [SmartExpenses.Logo_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.StandardBudget | SmartExpenses.Admin | True | True | none |
| SmartExpenses.StandardBudget | SmartExpenses.User | True | True | none |
| SmartExpenses.Transaction | SmartExpenses.Admin | True | True | none |
| SmartExpenses.Transaction | SmartExpenses.Parent | False | False | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] |
| SmartExpenses.Transaction | SmartExpenses.Admin, SmartExpenses.User | True | True | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] |

Confidence: Export-backed

## XPath Constraints (Plain Language)

| Entity | Module roles | XPath | Access meaning |
|---|---|---|---|
| SmartExpenses.Balance | SmartExpenses.Parent | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.Balance | SmartExpenses.Admin, SmartExpenses.User | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] | [SmartExpenses.Balance_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='current user'] |
| SmartExpenses.BudgetTerm | SmartExpenses.Parent | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.BudgetTerm | SmartExpenses.User | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] | [SmartExpenses.BudgetTerm_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='current user'] |
| SmartExpenses.BudgetType | SmartExpenses.User | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='current user'] |
| SmartExpenses.BudgetType | SmartExpenses.Parent | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.FBGProfile | SmartExpenses.User | [SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] | [SmartExpenses.FBGProfile_Account='current user'] |
| SmartExpenses.FBGProfile | SmartExpenses.Parent | [SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.Logo | SmartExpenses.Parent | [SmartExpenses.Logo_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.Logo_BudgetType/SmartExpenses.BudgetType/SmartExpenses.BudgetType_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.Transaction | SmartExpenses.Parent | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='[%CurrentUser%]'] | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account_Parent='current user'] |
| SmartExpenses.Transaction | SmartExpenses.Admin, SmartExpenses.User | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='[%CurrentUser%]'] | [SmartExpenses.Transaction_FBGProfile/SmartExpenses.FBGProfile/SmartExpenses.FBGProfile_Account='current user'] |

Confidence: Inferred

## Source

- Security level: CheckEverything
- Guest access: True
