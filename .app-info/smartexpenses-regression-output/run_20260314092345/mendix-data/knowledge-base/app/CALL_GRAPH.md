# Call Graph

## Cross-Module Dependency Table

| Source module | Target module | Call edges | Key flows |
|---|---|---:|---|
| ExcelImporter | MxModelReflection | 10 | ExcelImporter.ASu_CheckModelAndTemplates -> MxModelReflection.ASu_CheckMetamodel, ExcelImporter.Ch_FindAttribute -> MxModelReflection.FindMember, ExcelImporter.Ch_FindAttribute_Reference -> MxModelReflection.FindMember |
| ImporterHelper | SmartExpenses | 1 | ImporterHelper.ACT_ImportTransaction_AcceptTransactions -> SmartExpenses.SUB_Transaction_setStatus |

Confidence: Export-backed

## Custom Module Boundary

| Custom module | Outbound dependencies | Inbound dependencies |
|---|---|---|
| ImporterHelper | SmartExpenses | none |
| New_Module | none | none |
| SmartExpenses | none | ImporterHelper |

Confidence: Export-backed

## Source

- Export flow call edges: 214
- Derived cross-module edges: 11
