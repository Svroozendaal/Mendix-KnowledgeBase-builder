# Cross-Module Dependencies

## Dependency matrix

| Source module | Target module | Flow call count | Association link count |
|---|---|---:|---:|
| ExcelImporter | MxModelReflection | 10 | 0 |
| ImporterHelper | SmartExpenses | 1 | 0 |

## Flow-call edges

| Source flow | Target flow | Source module | Target module |
|---|---|---|---|
| ExcelImporter.ASu_CheckModelAndTemplates | MxModelReflection.ASu_CheckMetamodel | ExcelImporter | MxModelReflection |
| ExcelImporter.Ch_FindAttribute | MxModelReflection.FindMember | ExcelImporter | MxModelReflection |
| ExcelImporter.Ch_FindAttribute_Reference | MxModelReflection.FindMember | ExcelImporter | MxModelReflection |
| ExcelImporter.Ch_FindMicroflow | MxModelReflection.FindMicroflow | ExcelImporter | MxModelReflection |
| ExcelImporter.Ch_FindObjectType_Reference | MxModelReflection.FindObjectType | ExcelImporter | MxModelReflection |
| ExcelImporter.Ch_FindReference | MxModelReflection.FindReference | ExcelImporter | MxModelReflection |
| ExcelImporter.SetupColumn | MxModelReflection.FindMember | ExcelImporter | MxModelReflection |
| ExcelImporter.SetupColumn | MxModelReflection.FindMicroflow | ExcelImporter | MxModelReflection |
| ExcelImporter.SetupTemplate | MxModelReflection.FindObjectType | ExcelImporter | MxModelReflection |
| ExcelImporter.SetupTemplate | MxModelReflection.FindReference | ExcelImporter | MxModelReflection |
| ImporterHelper.ACT_ImportTransaction_AcceptTransactions | SmartExpenses.SUB_Transaction_setStatus | ImporterHelper | SmartExpenses |

## Hub/leaf module classification

| Module | Outbound edges | Inbound edges | Classification |
|---|---:|---:|---|
| Administration | 0 | 0 | isolated |
| AIDE_Lite | 0 | 0 | isolated |
| Atlas_Core | 0 | 0 | isolated |
| Atlas_Web_Content | 0 | 0 | isolated |
| DataWidgets | 0 | 0 | isolated |
| ExcelImporter | 10 | 0 | source-leaf |
| FeedbackModule | 0 | 0 | isolated |
| ImporterHelper | 1 | 0 | source-leaf |
| mIcons | 0 | 0 | isolated |
| MxModelReflection | 0 | 10 | sink-leaf |
| NanoflowCommons | 0 | 0 | isolated |
| New_Module | 0 | 0 | isolated |
| SmartExpenses | 0 | 1 | sink-leaf |
| System | 0 | 0 | isolated |
| Toast | 0 | 0 | isolated |
| Unknown | 0 | 0 | isolated |
| WebActions | 0 | 0 | isolated |
| WorkflowCommons | 0 | 0 | isolated |

## Hub Modules

- none

## Leaf Modules

- ExcelImporter (source-leaf), ImporterHelper (source-leaf), MxModelReflection (sink-leaf), SmartExpenses (sink-leaf)

## Association Links

| Association | From module | To module | Parent entity | Child entity |
|---|---|---|---|---|
| none | none | none | none | none |

## Custom-boundary dependency lens

| Custom module | Depends on | Used by |
|---|---|---|
| ImporterHelper | SmartExpenses | none |
| New_Module | none | none |
| SmartExpenses | none | ImporterHelper |
