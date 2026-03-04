# Security Model

## Security Level
- **CheckEverything**: All entity access, page access, and microflow access is verified at runtime.

## User Roles

### Administrator
- Module roles: Administration.Administrator, ExcelImporter.Configurator, MxModelReflection.ModelAdministrator, System.Administrator, SmartExpenses.Admin, SmartExpenses.User, ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter
- Manage all roles: yes
- Check security: yes
- **Summary**: Full access to everything — admin panel, data import, model reflection, and all SmartExpenses functionality.

### FBG
- Module roles: Administration.User, System.User, SmartExpenses.User, ImporterHelper.ExcelImporter, ImporterHelper.RESTImporter
- Manage all roles: no
- Check security: yes
- **Summary**: Regular user with expense management access and data import capabilities. Can manage own budgets, transactions, and balances.

### Anonymous
- Module roles: Administration.User, Atlas_Web_Content.Anonymous, System.User
- Manage all roles: no
- Check security: yes
- **Summary**: Guest access role — limited to login page and public content. No SmartExpenses access.

### Parent
- Module roles: Administration.User, System.User, SmartExpenses.Parent
- Manage all roles: no
- Check security: yes
- **Summary**: Read-only oversight role. Can view budgets, transactions, and balances of linked child profiles but cannot create or modify data.

## Entity Access Patterns

### SmartExpenses.Balance
| Role(s) | Create | Delete | Default | XPath Constraint |
|---------|--------|--------|---------|------------------|
| Admin | yes | yes | ReadWrite | — (unrestricted) |
| Parent | no | no | None | Only balances linked to child's FBGProfile via `FBGProfile_Account_Parent = CurrentUser` |
| Admin, User | yes | yes | ReadWrite | Only own balances via `FBGProfile_Account = CurrentUser` |

### SmartExpenses.BudgetTerm
| Role(s) | Create | Delete | Default | XPath Constraint |
|---------|--------|--------|---------|------------------|
| Admin | yes | yes | ReadWrite | — (unrestricted) |
| Parent | no | no | ReadOnly | Via BudgetType -> FBGProfile -> Account_Parent chain |
| User | yes | yes | ReadWrite | Via BudgetType -> FBGProfile -> Account chain |

### SmartExpenses.BudgetType
| Role(s) | Create | Delete | Default | XPath Constraint |
|---------|--------|--------|---------|------------------|
| Admin | yes | yes | ReadWrite | — (unrestricted) |
| User | yes | yes | ReadWrite | Own profile via `FBGProfile_Account = CurrentUser` |
| Parent | no | no | ReadOnly | Child profile via `FBGProfile_Account_Parent = CurrentUser` |

### SmartExpenses.Transaction
| Role(s) | Create | Delete | Default | XPath Constraint |
|---------|--------|--------|---------|------------------|
| Admin | yes | yes | ReadWrite | — (unrestricted) |
| Parent | no | no | None | Via FBGProfile -> Account_Parent chain (read-only members) |
| Admin, User | yes | yes | ReadWrite | Own transactions via `FBGProfile_Account = CurrentUser` |

### SmartExpenses.FBGProfile
| Role(s) | Create | Delete | Default | XPath Constraint |
|---------|--------|--------|---------|------------------|
| Admin | yes | yes | ReadWrite | — (unrestricted) |
| User | yes | yes | ReadWrite | Own profile via `FBGProfile_Account = CurrentUser` |
| Parent | no | no | None | Child profile via `FBGProfile_Account_Parent = CurrentUser` |

### ImporterHelper.ImportTransaction
| Role(s) | Create | Delete | Default |
|---------|--------|--------|---------|
| ExcelImporter, RESTImporter | yes | yes | ReadWrite |

## Security Observations
- **Row-level security** is consistently enforced via XPath constraints through the FBGProfile ownership chain. Users only see data linked to their own account.
- **Parent role** provides a read-only oversight pattern — parents can view their child's financial data but cannot modify it.
- **Admin role** has unrestricted access to all entities without XPath constraints.
- **Data import roles** (ExcelImporter, RESTImporter) are separate from business roles, allowing fine-grained control over who can import data.
