# Cross-Module Dependencies

## Dependency Matrix

| Source / Target | SmartExpenses | ImporterHelper |
|----------------|--------------|----------------|
| **SmartExpenses** | 19 internal | — |
| **ImporterHelper** | 1 call | 2 internal |

## Dependency Details

### ImporterHelper -> SmartExpenses
- **Flow call**: `ImporterHelper.ACT_ImportTransaction_AcceptTransactions` calls `SmartExpenses.SUB_Transaction_setStatus`
- **Purpose**: When imported transactions are accepted, the import module calls SmartExpenses to set the transaction status (Pending/Processed based on balance assignment)
- **Entity creation**: ImporterHelper creates `SmartExpenses.Transaction` objects during import acceptance
- **Page parameter**: `ImporterHelper.ImportTransaction_Overview` accepts `SmartExpenses.FBGProfile` as a parameter to link imports to user profiles

### SmartExpenses -> ImporterHelper
No dependencies. SmartExpenses is self-contained and does not call ImporterHelper flows.

## Module Profiles

### SmartExpenses (Hub)
- Internal call edges: 19
- Inbound from other modules: 1 (ImporterHelper)
- Outbound to other modules: 0
- Profile: **Self-contained core** — all business logic stays within the module

### ImporterHelper (Bridge)
- Internal call edges: 2
- Inbound from other modules: 0
- Outbound to other modules: 1 (SmartExpenses)
- Profile: **Import bridge** — lightweight module that feeds data into SmartExpenses

## Association Links

| Association | From Module | To Module | Nature |
|-------------|-------------|-----------|--------|
| (none) | — | — | No cross-module associations between SmartExpenses and ImporterHelper |

Note: ImporterHelper entities use non-persistent objects (ImportTransaction, ImportTransactionHelper) that do not have direct associations to SmartExpenses entities. The link is established at runtime through flow logic, not through the domain model.

## Marketplace Module Dependencies (inferred)

| Custom Module | Uses Marketplace Module | How |
|--------------|------------------------|-----|
| ImporterHelper | ExcelImporter | Java action `StartImportByTemplate` for Excel parsing |
| ImporterHelper | Toast | JavaScript action `showToast` for notifications |
| SmartExpenses | Toast | JavaScript action `showToast` in one nanoflow |
