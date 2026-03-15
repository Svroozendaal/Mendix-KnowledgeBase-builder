# Flows: ExcelImporter

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| none | 0 | none | none |

### Data Sources (DS_*)

| Flow | Nodes | Key Actions | Returns |
|---|---:|---|---|
| none | 0 | none | none |

### Validation Flows (VAL_*)

| Flow | Nodes | Key Actions |
|---|---:|---|
| none | 0 | none |

### Other Flows

| Flow | Type | Nodes | Key Actions |
|---|---|---:|---|
| _DocumentationDummyXSD | Microflow | 3 | none |
| _DocumentationExportParseFlows | Microflow | 3 | none |
| _DocumentationImportParseFlows | Microflow | 3 | none |
| ACr_Template | Microflow | 6 | ExcelImporter.AdditionalProperties |
| ASu_CheckModelAndTemplates | Microflow | 8 | ExcelImporter.Template |
| BCo_Column | Microflow | 44 | ExcelImporter.Column |
| BDe_Column | Microflow | 6 | none |
| Ch_Column_SetDefaultObject | Microflow | 10 | none |
| Ch_FindAttribute | Microflow | 13 | none |
| Ch_FindAttribute_Reference | Microflow | 16 | none |
| Ch_FindMicroflow | Microflow | 12 | none |
| Ch_FindObjectType_Reference | Microflow | 13 | none |
| Ch_FindReference | Microflow | 14 | none |
| Ch_SetAttribute | Microflow | 8 | none |
| Ch_SetAttribute_Reference | Microflow | 8 | none |
| Ch_SetMicroflow | Microflow | 8 | none |
| Ch_SetObjectType_Reference | Microflow | 8 | none |
| Ch_SetReference | Microflow | 8 | none |
| Ch_Template_ChangeObjectType | Microflow | 8 | ExcelImporter.Column |
| Ch_Template_CheckNrs | Microflow | 4 | none |
| CleanupOldRefHandling | Microflow | 8 | none |
| Column_SetCorrectRefObjectType | Microflow | 21 | MxModelReflection.MxObjectType |
| Column_SetDetails | Microflow | 13 | none |
| ColumnDataSourceToString | Microflow | 3 | none |
| ColumnMappingTypeToString | Microflow | 5 | none |
| ColumnReferenceKeyTypeToString | Microflow | 5 | none |
| ColumnYesNoToString | Microflow | 5 | none |
| Example_SetupImportTemplate | Microflow | 12 | none |
| ExcelImporterTemplateXSD | Microflow | 4 | ExcelImporter.Template |
| ExcelTemplate_ExportToXML | Microflow | 12 | ExcelImporter.XMLDocumentTemplate |
| ExcelTemplate_ImportFromXml | Microflow | 12 | ExcelImporter.Log |
| FormatInteger | Microflow | 5 | none |
| GetAddProperties | Microflow | 9 | ExcelImporter.AdditionalProperties |
| GetCorrectString | Microflow | 7 | none |
| IVK_CancelTemplate | Microflow | 12 | none |
| IVK_Column_Save | Microflow | 55 | none |
| IVK_ColumnEdit | Microflow | 8 | none |
| IVK_ColumnNew | Microflow | 9 | ExcelImporter.Column |
| IVK_DuplicateTemplate | Microflow | 17 | ExcelImporter.Column, ExcelImporter.ReferenceHandling, ExcelImporter.Template |
| IVK_ImportTemplateDocument | Microflow | 14 | none |
| IVK_ImportXML_Upload | Microflow | 6 | ExcelImporter.XMLDocumentTemplate |
| IVK_SaveContinue_CreateTemplateFromDoc | Microflow | 16 | none |
| IVK_SaveNewTemplate | Microflow | 7 | none |
| IVK_SaveNewTemplate_CreateColumns | Microflow | 5 | none |
| IVK_SaveTemplate | Microflow | 12 | none |
| IVK_Template_ConnectMatchingAttributes | Microflow | 25 | ExcelImporter.Column, MxModelReflection.MxObjectMember |
| IVK_Template_NewFromFile | Microflow | 6 | ExcelImporter.Template, ExcelImporter.TemplateDocument |
| IVK_TemplateDoc_Cancel | Microflow | 7 | none |
| MxObjectAttributeTypesEnumToString | Microflow | 4 | none |
| MxObjectReferenceAssociationOwnerToString | Microflow | 5 | none |
| MxObjectReferenceReferenceTypeToString | Microflow | 5 | none |
| ParseEnumToString_StatisticLevel | Microflow | 5 | none |
| ParseStringToEnum_StatisticsLevel | Microflow | 11 | none |
| prepareReferenceHandling | Microflow | 22 | ExcelImporter.Column, ExcelImporter.ReferenceHandling |
| ReferenceHandlingEnumToString | Microflow | 5 | none |
| SetColumnStatus | Microflow | 14 | none |
| SetupColumn | Microflow | 20 | ExcelImporter.Column |
| SetupTemplate | Microflow | 16 | ExcelImporter.Template |
| SF_Template_CheckNrs | Microflow | 35 | none |
| StringToColumnMappingType | Microflow | 5 | none |
| StringToColumnReferenceKeyType | Microflow | 5 | none |
| StringToColumnYesNo | Microflow | 5 | none |
| StringToDataSource | Microflow | 9 | none |
| StringToMxObjectAttributeTypesEnum | Microflow | 4 | none |
| StringToMxObjectReferenceAssociationOwner | Microflow | 5 | none |
| StringToMxObjectReferenceReferenceType | Microflow | 5 | none |
| StringToReferenceDataHandling | Microflow | 5 | none |
| StringToReferenceHandlingEnum | Microflow | 5 | none |
| StringToTemplateImportActions | Microflow | 5 | none |
| StringToTemplateRemoveIndicator | Microflow | 9 | none |
| StringToTemplateStatusEnum | Microflow | 5 | none |
| Sub_CreateColumnsFromTemplate | Microflow | 18 | ExcelImporter.Column, MxModelReflection.MxObjectMember |
| TemplateImportActionsToString | Microflow | 5 | none |
| TemplateReferenceDataHandlingEnumToString | Microflow | 3 | none |
| TemplateReferenceHandlingEnumToString | Microflow | 5 | none |
| TemplateRemoveIndicatorToString | Microflow | 3 | none |
| TemplateStatusEnumToString | Microflow | 5 | none |
| Validate_TemplateDocument | Microflow | 13 | none |
| ValidateColumn | Rule | 44 | MxModelReflection.MxObjectMember, MxModelReflection.MxObjectReference, MxModelReflection.MxObjectType |
| ValidateColumnMF | Rule | 23 | none |
| ValidateTemplate | Microflow | 73 | ExcelImporter.Column, ExcelImporter.ReferenceHandling |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| ASu_CheckModelAndTemplates | MxModelReflection.ASu_CheckMetamodel | MxModelReflection |
| Ch_FindAttribute | MxModelReflection.FindMember | MxModelReflection |
| Ch_FindAttribute_Reference | MxModelReflection.FindMember | MxModelReflection |
| Ch_FindMicroflow | MxModelReflection.FindMicroflow | MxModelReflection |
| Ch_FindObjectType_Reference | MxModelReflection.FindObjectType | MxModelReflection |
| Ch_FindReference | MxModelReflection.FindReference | MxModelReflection |
| SetupColumn | MxModelReflection.FindMember | MxModelReflection |
| SetupColumn | MxModelReflection.FindMicroflow | MxModelReflection |
| SetupTemplate | MxModelReflection.FindObjectType | MxModelReflection |
| SetupTemplate | MxModelReflection.FindReference | MxModelReflection |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| none | none | none |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| _DocumentationDummyXSD | Microflow | 3 | 3 | 0 | 0 |
| _DocumentationExportParseFlows | Microflow | 3 | 3 | 0 | 0 |
| _DocumentationImportParseFlows | Microflow | 3 | 3 | 0 | 0 |
| ACr_Template | Microflow | 6 | 3 | 0 | 0 |
| ASu_CheckModelAndTemplates | Microflow | 8 | 3 | 2 | 0 |
| BCo_Column | Microflow | 44 | 3 | 2 | 1 |
| BDe_Column | Microflow | 6 | 3 | 1 | 0 |
| Ch_Column_SetDefaultObject | Microflow | 10 | 3 | 2 | 0 |
| Ch_FindAttribute | Microflow | 13 | 3 | 1 | 0 |
| Ch_FindAttribute_Reference | Microflow | 16 | 3 | 1 | 0 |
| Ch_FindMicroflow | Microflow | 12 | 3 | 1 | 0 |
| Ch_FindObjectType_Reference | Microflow | 13 | 3 | 1 | 0 |
| Ch_FindReference | Microflow | 14 | 3 | 2 | 0 |
| Ch_SetAttribute | Microflow | 8 | 3 | 0 | 0 |
| Ch_SetAttribute_Reference | Microflow | 8 | 3 | 0 | 0 |
| Ch_SetMicroflow | Microflow | 8 | 3 | 0 | 0 |
| Ch_SetObjectType_Reference | Microflow | 8 | 3 | 0 | 1 |
| Ch_SetReference | Microflow | 8 | 3 | 0 | 1 |
| Ch_Template_ChangeObjectType | Microflow | 8 | 3 | 1 | 0 |
| Ch_Template_CheckNrs | Microflow | 4 | 3 | 1 | 0 |
| CleanupOldRefHandling | Microflow | 8 | 3 | 0 | 1 |
| Column_SetCorrectRefObjectType | Microflow | 21 | 3 | 1 | 2 |
| Column_SetDetails | Microflow | 13 | 3 | 0 | 1 |
| ColumnDataSourceToString | Microflow | 3 | 3 | 0 | 0 |
| ColumnMappingTypeToString | Microflow | 5 | 3 | 0 | 0 |
| ColumnReferenceKeyTypeToString | Microflow | 5 | 3 | 0 | 0 |
| ColumnYesNoToString | Microflow | 5 | 3 | 0 | 0 |
| Example_SetupImportTemplate | Microflow | 12 | 3 | 2 | 0 |
| ExcelImporterTemplateXSD | Microflow | 4 | 3 | 0 | 0 |
| ExcelTemplate_ExportToXML | Microflow | 12 | 3 | 0 | 0 |
| ExcelTemplate_ImportFromXml | Microflow | 12 | 3 | 0 | 0 |
| FormatInteger | Microflow | 5 | 3 | 0 | 0 |
| GetAddProperties | Microflow | 9 | 3 | 0 | 3 |
| GetCorrectString | Microflow | 7 | 3 | 0 | 1 |
| IVK_CancelTemplate | Microflow | 12 | 3 | 1 | 0 |
| IVK_Column_Save | Microflow | 55 | 3 | 1 | 0 |
| IVK_ColumnEdit | Microflow | 8 | 3 | 0 | 0 |
| IVK_ColumnNew | Microflow | 9 | 3 | 0 | 0 |
| IVK_DuplicateTemplate | Microflow | 17 | 3 | 0 | 0 |
| IVK_ImportTemplateDocument | Microflow | 14 | 3 | 0 | 0 |
| IVK_ImportXML_Upload | Microflow | 6 | 3 | 0 | 0 |
| IVK_SaveContinue_CreateTemplateFromDoc | Microflow | 16 | 3 | 2 | 0 |
| IVK_SaveNewTemplate | Microflow | 7 | 3 | 1 | 1 |
| IVK_SaveNewTemplate_CreateColumns | Microflow | 5 | 3 | 2 | 0 |
| IVK_SaveTemplate | Microflow | 12 | 3 | 3 | 1 |
| IVK_Template_ConnectMatchingAttributes | Microflow | 25 | 3 | 0 | 0 |
| IVK_Template_NewFromFile | Microflow | 6 | 3 | 0 | 0 |
| IVK_TemplateDoc_Cancel | Microflow | 7 | 3 | 0 | 0 |
| MxObjectAttributeTypesEnumToString | Microflow | 4 | 3 | 0 | 0 |
| MxObjectReferenceAssociationOwnerToString | Microflow | 5 | 3 | 0 | 0 |
| MxObjectReferenceReferenceTypeToString | Microflow | 5 | 3 | 0 | 0 |
| ParseEnumToString_StatisticLevel | Microflow | 5 | 3 | 0 | 0 |
| ParseStringToEnum_StatisticsLevel | Microflow | 11 | 3 | 0 | 0 |
| prepareReferenceHandling | Microflow | 22 | 3 | 0 | 2 |
| ReferenceHandlingEnumToString | Microflow | 5 | 3 | 0 | 0 |
| SetColumnStatus | Microflow | 14 | 3 | 0 | 2 |
| SetupColumn | Microflow | 20 | 3 | 2 | 1 |
| SetupTemplate | Microflow | 16 | 3 | 3 | 1 |
| SF_Template_CheckNrs | Microflow | 35 | 3 | 0 | 3 |
| StringToColumnMappingType | Microflow | 5 | 3 | 0 | 0 |
| StringToColumnReferenceKeyType | Microflow | 5 | 3 | 0 | 0 |
| StringToColumnYesNo | Microflow | 5 | 3 | 0 | 0 |
| StringToDataSource | Microflow | 9 | 3 | 0 | 0 |
| StringToMxObjectAttributeTypesEnum | Microflow | 4 | 3 | 0 | 0 |
| StringToMxObjectReferenceAssociationOwner | Microflow | 5 | 3 | 0 | 0 |
| StringToMxObjectReferenceReferenceType | Microflow | 5 | 3 | 0 | 0 |
| StringToReferenceDataHandling | Microflow | 5 | 3 | 0 | 0 |
| StringToReferenceHandlingEnum | Microflow | 5 | 3 | 0 | 0 |
| StringToTemplateImportActions | Microflow | 5 | 3 | 0 | 0 |
| StringToTemplateRemoveIndicator | Microflow | 9 | 3 | 0 | 0 |
| StringToTemplateStatusEnum | Microflow | 5 | 3 | 0 | 0 |
| Sub_CreateColumnsFromTemplate | Microflow | 18 | 3 | 0 | 1 |
| TemplateImportActionsToString | Microflow | 5 | 3 | 0 | 0 |
| TemplateReferenceDataHandlingEnumToString | Microflow | 3 | 3 | 0 | 0 |
| TemplateReferenceHandlingEnumToString | Microflow | 5 | 3 | 0 | 0 |
| TemplateRemoveIndicatorToString | Microflow | 3 | 3 | 0 | 0 |
| TemplateStatusEnumToString | Microflow | 5 | 3 | 0 | 0 |
| Validate_TemplateDocument | Microflow | 13 | 3 | 0 | 1 |
| ValidateColumn | Rule | 44 | 3 | 0 | 0 |
| ValidateColumnMF | Rule | 23 | 3 | 0 | 0 |
| ValidateTemplate | Microflow | 73 | 3 | 4 | 3 |

## Tier 1 Deep Narratives

Tier 1 deep narratives are only generated for custom modules; use the flow catalogue and L0/L1 flow files for this module.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| ExcelImporter._DocumentationDummyXSD | Microflow | 3 | [L0](flows/excelimporter-documentationdummyxsd.abstract.md) | [L1](flows/excelimporter-documentationdummyxsd.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-documentationdummyxsd.json) |
| ExcelImporter._DocumentationExportParseFlows | Microflow | 3 | [L0](flows/excelimporter-documentationexportparseflows.abstract.md) | [L1](flows/excelimporter-documentationexportparseflows.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-documentationexportparseflows.json) |
| ExcelImporter._DocumentationImportParseFlows | Microflow | 3 | [L0](flows/excelimporter-documentationimportparseflows.abstract.md) | [L1](flows/excelimporter-documentationimportparseflows.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-documentationimportparseflows.json) |
| ExcelImporter.ACr_Template | Microflow | 3 | [L0](flows/excelimporter-acr-template.abstract.md) | [L1](flows/excelimporter-acr-template.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-acr-template.json) |
| ExcelImporter.ASu_CheckModelAndTemplates | Microflow | 3 | [L0](flows/excelimporter-asu-checkmodelandtemplates.abstract.md) | [L1](flows/excelimporter-asu-checkmodelandtemplates.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-asu-checkmodelandtemplates.json) |
| ExcelImporter.BCo_Column | Microflow | 3 | [L0](flows/excelimporter-bco-column.abstract.md) | [L1](flows/excelimporter-bco-column.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bco-column.json) |
| ExcelImporter.BDe_Column | Microflow | 3 | [L0](flows/excelimporter-bde-column.abstract.md) | [L1](flows/excelimporter-bde-column.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-bde-column.json) |
| ExcelImporter.Ch_Column_SetDefaultObject | Microflow | 3 | [L0](flows/excelimporter-ch-column-setdefaultobject.abstract.md) | [L1](flows/excelimporter-ch-column-setdefaultobject.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-column-setdefaultobject.json) |
| ExcelImporter.Ch_FindAttribute | Microflow | 3 | [L0](flows/excelimporter-ch-findattribute.abstract.md) | [L1](flows/excelimporter-ch-findattribute.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute.json) |
| ExcelImporter.Ch_FindAttribute_Reference | Microflow | 3 | [L0](flows/excelimporter-ch-findattribute-reference.abstract.md) | [L1](flows/excelimporter-ch-findattribute-reference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findattribute-reference.json) |
| ExcelImporter.Ch_FindMicroflow | Microflow | 3 | [L0](flows/excelimporter-ch-findmicroflow.abstract.md) | [L1](flows/excelimporter-ch-findmicroflow.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findmicroflow.json) |
| ExcelImporter.Ch_FindObjectType_Reference | Microflow | 3 | [L0](flows/excelimporter-ch-findobjecttype-reference.abstract.md) | [L1](flows/excelimporter-ch-findobjecttype-reference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findobjecttype-reference.json) |
| ExcelImporter.Ch_FindReference | Microflow | 3 | [L0](flows/excelimporter-ch-findreference.abstract.md) | [L1](flows/excelimporter-ch-findreference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-findreference.json) |
| ExcelImporter.Ch_SetAttribute | Microflow | 3 | [L0](flows/excelimporter-ch-setattribute.abstract.md) | [L1](flows/excelimporter-ch-setattribute.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute.json) |
| ExcelImporter.Ch_SetAttribute_Reference | Microflow | 3 | [L0](flows/excelimporter-ch-setattribute-reference.abstract.md) | [L1](flows/excelimporter-ch-setattribute-reference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setattribute-reference.json) |
| ExcelImporter.Ch_SetMicroflow | Microflow | 3 | [L0](flows/excelimporter-ch-setmicroflow.abstract.md) | [L1](flows/excelimporter-ch-setmicroflow.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setmicroflow.json) |
| ExcelImporter.Ch_SetObjectType_Reference | Microflow | 3 | [L0](flows/excelimporter-ch-setobjecttype-reference.abstract.md) | [L1](flows/excelimporter-ch-setobjecttype-reference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setobjecttype-reference.json) |
| ExcelImporter.Ch_SetReference | Microflow | 3 | [L0](flows/excelimporter-ch-setreference.abstract.md) | [L1](flows/excelimporter-ch-setreference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-setreference.json) |
| ExcelImporter.Ch_Template_ChangeObjectType | Microflow | 3 | [L0](flows/excelimporter-ch-template-changeobjecttype.abstract.md) | [L1](flows/excelimporter-ch-template-changeobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-template-changeobjecttype.json) |
| ExcelImporter.Ch_Template_CheckNrs | Microflow | 3 | [L0](flows/excelimporter-ch-template-checknrs.abstract.md) | [L1](flows/excelimporter-ch-template-checknrs.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ch-template-checknrs.json) |
| ExcelImporter.CleanupOldRefHandling | Microflow | 3 | [L0](flows/excelimporter-cleanupoldrefhandling.abstract.md) | [L1](flows/excelimporter-cleanupoldrefhandling.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-cleanupoldrefhandling.json) |
| ExcelImporter.Column_SetCorrectRefObjectType | Microflow | 3 | [L0](flows/excelimporter-column-setcorrectrefobjecttype.abstract.md) | [L1](flows/excelimporter-column-setcorrectrefobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setcorrectrefobjecttype.json) |
| ExcelImporter.Column_SetDetails | Microflow | 3 | [L0](flows/excelimporter-column-setdetails.abstract.md) | [L1](flows/excelimporter-column-setdetails.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-column-setdetails.json) |
| ExcelImporter.ColumnDataSourceToString | Microflow | 3 | [L0](flows/excelimporter-columndatasourcetostring.abstract.md) | [L1](flows/excelimporter-columndatasourcetostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columndatasourcetostring.json) |
| ExcelImporter.ColumnMappingTypeToString | Microflow | 3 | [L0](flows/excelimporter-columnmappingtypetostring.abstract.md) | [L1](flows/excelimporter-columnmappingtypetostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnmappingtypetostring.json) |
| ExcelImporter.ColumnReferenceKeyTypeToString | Microflow | 3 | [L0](flows/excelimporter-columnreferencekeytypetostring.abstract.md) | [L1](flows/excelimporter-columnreferencekeytypetostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnreferencekeytypetostring.json) |
| ExcelImporter.ColumnYesNoToString | Microflow | 3 | [L0](flows/excelimporter-columnyesnotostring.abstract.md) | [L1](flows/excelimporter-columnyesnotostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-columnyesnotostring.json) |
| ExcelImporter.Example_SetupImportTemplate | Microflow | 3 | [L0](flows/excelimporter-example-setupimporttemplate.abstract.md) | [L1](flows/excelimporter-example-setupimporttemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-example-setupimporttemplate.json) |
| ExcelImporter.ExcelImporterTemplateXSD | Microflow | 3 | [L0](flows/excelimporter-excelimportertemplatexsd.abstract.md) | [L1](flows/excelimporter-excelimportertemplatexsd.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-excelimportertemplatexsd.json) |
| ExcelImporter.ExcelTemplate_ExportToXML | Microflow | 3 | [L0](flows/excelimporter-exceltemplate-exporttoxml.abstract.md) | [L1](flows/excelimporter-exceltemplate-exporttoxml.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-exporttoxml.json) |
| ExcelImporter.ExcelTemplate_ImportFromXml | Microflow | 3 | [L0](flows/excelimporter-exceltemplate-importfromxml.abstract.md) | [L1](flows/excelimporter-exceltemplate-importfromxml.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-exceltemplate-importfromxml.json) |
| ExcelImporter.FormatInteger | Microflow | 3 | [L0](flows/excelimporter-formatinteger.abstract.md) | [L1](flows/excelimporter-formatinteger.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-formatinteger.json) |
| ExcelImporter.GetAddProperties | Microflow | 3 | [L0](flows/excelimporter-getaddproperties.abstract.md) | [L1](flows/excelimporter-getaddproperties.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getaddproperties.json) |
| ExcelImporter.GetCorrectString | Microflow | 3 | [L0](flows/excelimporter-getcorrectstring.abstract.md) | [L1](flows/excelimporter-getcorrectstring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-getcorrectstring.json) |
| ExcelImporter.IVK_CancelTemplate | Microflow | 3 | [L0](flows/excelimporter-ivk-canceltemplate.abstract.md) | [L1](flows/excelimporter-ivk-canceltemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-canceltemplate.json) |
| ExcelImporter.IVK_Column_Save | Microflow | 3 | [L0](flows/excelimporter-ivk-column-save.abstract.md) | [L1](flows/excelimporter-ivk-column-save.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-column-save.json) |
| ExcelImporter.IVK_ColumnEdit | Microflow | 3 | [L0](flows/excelimporter-ivk-columnedit.abstract.md) | [L1](flows/excelimporter-ivk-columnedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnedit.json) |
| ExcelImporter.IVK_ColumnNew | Microflow | 3 | [L0](flows/excelimporter-ivk-columnnew.abstract.md) | [L1](flows/excelimporter-ivk-columnnew.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-columnnew.json) |
| ExcelImporter.IVK_DuplicateTemplate | Microflow | 3 | [L0](flows/excelimporter-ivk-duplicatetemplate.abstract.md) | [L1](flows/excelimporter-ivk-duplicatetemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-duplicatetemplate.json) |
| ExcelImporter.IVK_ImportTemplateDocument | Microflow | 3 | [L0](flows/excelimporter-ivk-importtemplatedocument.abstract.md) | [L1](flows/excelimporter-ivk-importtemplatedocument.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importtemplatedocument.json) |
| ExcelImporter.IVK_ImportXML_Upload | Microflow | 3 | [L0](flows/excelimporter-ivk-importxml-upload.abstract.md) | [L1](flows/excelimporter-ivk-importxml-upload.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-importxml-upload.json) |
| ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc | Microflow | 3 | [L0](flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.abstract.md) | [L1](flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savecontinue-createtemplatefromdoc.json) |
| ExcelImporter.IVK_SaveNewTemplate | Microflow | 3 | [L0](flows/excelimporter-ivk-savenewtemplate.abstract.md) | [L1](flows/excelimporter-ivk-savenewtemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savenewtemplate.json) |
| ExcelImporter.IVK_SaveNewTemplate_CreateColumns | Microflow | 3 | [L0](flows/excelimporter-ivk-savenewtemplate-createcolumns.abstract.md) | [L1](flows/excelimporter-ivk-savenewtemplate-createcolumns.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savenewtemplate-createcolumns.json) |
| ExcelImporter.IVK_SaveTemplate | Microflow | 3 | [L0](flows/excelimporter-ivk-savetemplate.abstract.md) | [L1](flows/excelimporter-ivk-savetemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-savetemplate.json) |
| ExcelImporter.IVK_Template_ConnectMatchingAttributes | Microflow | 3 | [L0](flows/excelimporter-ivk-template-connectmatchingattributes.abstract.md) | [L1](flows/excelimporter-ivk-template-connectmatchingattributes.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-connectmatchingattributes.json) |
| ExcelImporter.IVK_Template_NewFromFile | Microflow | 3 | [L0](flows/excelimporter-ivk-template-newfromfile.abstract.md) | [L1](flows/excelimporter-ivk-template-newfromfile.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-template-newfromfile.json) |
| ExcelImporter.IVK_TemplateDoc_Cancel | Microflow | 3 | [L0](flows/excelimporter-ivk-templatedoc-cancel.abstract.md) | [L1](flows/excelimporter-ivk-templatedoc-cancel.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-ivk-templatedoc-cancel.json) |
| ExcelImporter.MxObjectAttributeTypesEnumToString | Microflow | 3 | [L0](flows/excelimporter-mxobjectattributetypesenumtostring.abstract.md) | [L1](flows/excelimporter-mxobjectattributetypesenumtostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectattributetypesenumtostring.json) |
| ExcelImporter.MxObjectReferenceAssociationOwnerToString | Microflow | 3 | [L0](flows/excelimporter-mxobjectreferenceassociationownertostring.abstract.md) | [L1](flows/excelimporter-mxobjectreferenceassociationownertostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferenceassociationownertostring.json) |
| ExcelImporter.MxObjectReferenceReferenceTypeToString | Microflow | 3 | [L0](flows/excelimporter-mxobjectreferencereferencetypetostring.abstract.md) | [L1](flows/excelimporter-mxobjectreferencereferencetypetostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-mxobjectreferencereferencetypetostring.json) |
| ExcelImporter.ParseEnumToString_StatisticLevel | Microflow | 3 | [L0](flows/excelimporter-parseenumtostring-statisticlevel.abstract.md) | [L1](flows/excelimporter-parseenumtostring-statisticlevel.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-parseenumtostring-statisticlevel.json) |
| ExcelImporter.ParseStringToEnum_StatisticsLevel | Microflow | 3 | [L0](flows/excelimporter-parsestringtoenum-statisticslevel.abstract.md) | [L1](flows/excelimporter-parsestringtoenum-statisticslevel.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-parsestringtoenum-statisticslevel.json) |
| ExcelImporter.prepareReferenceHandling | Microflow | 3 | [L0](flows/excelimporter-preparereferencehandling.abstract.md) | [L1](flows/excelimporter-preparereferencehandling.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-preparereferencehandling.json) |
| ExcelImporter.ReferenceHandlingEnumToString | Microflow | 3 | [L0](flows/excelimporter-referencehandlingenumtostring.abstract.md) | [L1](flows/excelimporter-referencehandlingenumtostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-referencehandlingenumtostring.json) |
| ExcelImporter.SetColumnStatus | Microflow | 3 | [L0](flows/excelimporter-setcolumnstatus.abstract.md) | [L1](flows/excelimporter-setcolumnstatus.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setcolumnstatus.json) |
| ExcelImporter.SetupColumn | Microflow | 3 | [L0](flows/excelimporter-setupcolumn.abstract.md) | [L1](flows/excelimporter-setupcolumn.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setupcolumn.json) |
| ExcelImporter.SetupTemplate | Microflow | 3 | [L0](flows/excelimporter-setuptemplate.abstract.md) | [L1](flows/excelimporter-setuptemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-setuptemplate.json) |
| ExcelImporter.SF_Template_CheckNrs | Microflow | 3 | [L0](flows/excelimporter-sf-template-checknrs.abstract.md) | [L1](flows/excelimporter-sf-template-checknrs.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sf-template-checknrs.json) |
| ExcelImporter.StringToColumnMappingType | Microflow | 3 | [L0](flows/excelimporter-stringtocolumnmappingtype.abstract.md) | [L1](flows/excelimporter-stringtocolumnmappingtype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnmappingtype.json) |
| ExcelImporter.StringToColumnReferenceKeyType | Microflow | 3 | [L0](flows/excelimporter-stringtocolumnreferencekeytype.abstract.md) | [L1](flows/excelimporter-stringtocolumnreferencekeytype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnreferencekeytype.json) |
| ExcelImporter.StringToColumnYesNo | Microflow | 3 | [L0](flows/excelimporter-stringtocolumnyesno.abstract.md) | [L1](flows/excelimporter-stringtocolumnyesno.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtocolumnyesno.json) |
| ExcelImporter.StringToDataSource | Microflow | 3 | [L0](flows/excelimporter-stringtodatasource.abstract.md) | [L1](flows/excelimporter-stringtodatasource.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtodatasource.json) |
| ExcelImporter.StringToMxObjectAttributeTypesEnum | Microflow | 3 | [L0](flows/excelimporter-stringtomxobjectattributetypesenum.abstract.md) | [L1](flows/excelimporter-stringtomxobjectattributetypesenum.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectattributetypesenum.json) |
| ExcelImporter.StringToMxObjectReferenceAssociationOwner | Microflow | 3 | [L0](flows/excelimporter-stringtomxobjectreferenceassociationowner.abstract.md) | [L1](flows/excelimporter-stringtomxobjectreferenceassociationowner.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectreferenceassociationowner.json) |
| ExcelImporter.StringToMxObjectReferenceReferenceType | Microflow | 3 | [L0](flows/excelimporter-stringtomxobjectreferencereferencetype.abstract.md) | [L1](flows/excelimporter-stringtomxobjectreferencereferencetype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtomxobjectreferencereferencetype.json) |
| ExcelImporter.StringToReferenceDataHandling | Microflow | 3 | [L0](flows/excelimporter-stringtoreferencedatahandling.abstract.md) | [L1](flows/excelimporter-stringtoreferencedatahandling.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtoreferencedatahandling.json) |
| ExcelImporter.StringToReferenceHandlingEnum | Microflow | 3 | [L0](flows/excelimporter-stringtoreferencehandlingenum.abstract.md) | [L1](flows/excelimporter-stringtoreferencehandlingenum.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtoreferencehandlingenum.json) |
| ExcelImporter.StringToTemplateImportActions | Microflow | 3 | [L0](flows/excelimporter-stringtotemplateimportactions.abstract.md) | [L1](flows/excelimporter-stringtotemplateimportactions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateimportactions.json) |
| ExcelImporter.StringToTemplateRemoveIndicator | Microflow | 3 | [L0](flows/excelimporter-stringtotemplateremoveindicator.abstract.md) | [L1](flows/excelimporter-stringtotemplateremoveindicator.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplateremoveindicator.json) |
| ExcelImporter.StringToTemplateStatusEnum | Microflow | 3 | [L0](flows/excelimporter-stringtotemplatestatusenum.abstract.md) | [L1](flows/excelimporter-stringtotemplatestatusenum.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-stringtotemplatestatusenum.json) |
| ExcelImporter.Sub_CreateColumnsFromTemplate | Microflow | 3 | [L0](flows/excelimporter-sub-createcolumnsfromtemplate.abstract.md) | [L1](flows/excelimporter-sub-createcolumnsfromtemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-sub-createcolumnsfromtemplate.json) |
| ExcelImporter.TemplateImportActionsToString | Microflow | 3 | [L0](flows/excelimporter-templateimportactionstostring.abstract.md) | [L1](flows/excelimporter-templateimportactionstostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templateimportactionstostring.json) |
| ExcelImporter.TemplateReferenceDataHandlingEnumToString | Microflow | 3 | [L0](flows/excelimporter-templatereferencedatahandlingenumtostring.abstract.md) | [L1](flows/excelimporter-templatereferencedatahandlingenumtostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatereferencedatahandlingenumtostring.json) |
| ExcelImporter.TemplateReferenceHandlingEnumToString | Microflow | 3 | [L0](flows/excelimporter-templatereferencehandlingenumtostring.abstract.md) | [L1](flows/excelimporter-templatereferencehandlingenumtostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatereferencehandlingenumtostring.json) |
| ExcelImporter.TemplateRemoveIndicatorToString | Microflow | 3 | [L0](flows/excelimporter-templateremoveindicatortostring.abstract.md) | [L1](flows/excelimporter-templateremoveindicatortostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templateremoveindicatortostring.json) |
| ExcelImporter.TemplateStatusEnumToString | Microflow | 3 | [L0](flows/excelimporter-templatestatusenumtostring.abstract.md) | [L1](flows/excelimporter-templatestatusenumtostring.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-templatestatusenumtostring.json) |
| ExcelImporter.Validate_TemplateDocument | Microflow | 3 | [L0](flows/excelimporter-validate-templatedocument.abstract.md) | [L1](flows/excelimporter-validate-templatedocument.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validate-templatedocument.json) |
| ExcelImporter.ValidateColumn | Rule | 3 | [L0](flows/excelimporter-validatecolumn.abstract.md) | [L1](flows/excelimporter-validatecolumn.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumn.json) |
| ExcelImporter.ValidateColumnMF | Rule | 3 | [L0](flows/excelimporter-validatecolumnmf.abstract.md) | [L1](flows/excelimporter-validatecolumnmf.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatecolumnmf.json) |
| ExcelImporter.ValidateTemplate | Microflow | 3 | [L0](flows/excelimporter-validatetemplate.abstract.md) | [L1](flows/excelimporter-validatetemplate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/flows/excelimporter-validatetemplate.json) |
