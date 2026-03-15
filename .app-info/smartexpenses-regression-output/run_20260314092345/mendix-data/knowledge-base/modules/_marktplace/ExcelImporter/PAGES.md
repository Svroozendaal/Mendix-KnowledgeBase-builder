# Pages: ExcelImporter

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| ExcelImporter.Column_Hover | New column mapping selection | none | Column:ExcelImporter.Column | True |
| ExcelImporter.Column_NewEdit | Column details | none | Column:ExcelImporter.Column | True |
| ExcelImporter.Credits | ExcelImporterTemplateExporter module | none | none | False |
| ExcelImporter.ExcelImportOverview | Excel Importer | ExcelImporter.Configurator | none | False |
| ExcelImporter.Import_Overview | Import files overview | ExcelImporter.Configurator | none | False |
| ExcelImporter.ImportXML_Upload | Upload template | ExcelImporter.Configurator | XMLDocumentTemplate:ExcelImporter.XMLDocumentTemplate | True |
| ExcelImporter.ReferenceHandling_NewEdit | Edit the reference handling | ExcelImporter.Configurator | ReferenceHandling:ExcelImporter.ReferenceHandling | True |
| ExcelImporter.Template_Edit | Import template settings | ExcelImporter.Configurator | Template:ExcelImporter.Template | False |
| ExcelImporter.Template_New | Import template settings | ExcelImporter.Configurator | Template:ExcelImporter.Template | True |
| ExcelImporter.Template_New_FromDocument | New template by Excel file | ExcelImporter.Configurator | TemplateDocument:ExcelImporter.TemplateDocument | True |
| ExcelImporter.TemplateDocument_NewEdit | Edit Template document | ExcelImporter.Configurator | TemplateDocument:ExcelImporter.TemplateDocument | True |
| ExcelImporter.Templates_Overview | Import templates | ExcelImporter.Configurator | none | False |
| ExcelImporter.VerificationForm | Verification form | ExcelImporter.Configurator | none | False |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| ExcelImporter.Column_Hover | none |
| ExcelImporter.Column_NewEdit | ExcelImporter.IVK_ColumnEdit, ExcelImporter.IVK_ColumnNew |
| ExcelImporter.Credits | none |
| ExcelImporter.ExcelImportOverview | none |
| ExcelImporter.Import_Overview | none |
| ExcelImporter.ImportXML_Upload | ExcelImporter.IVK_ImportXML_Upload |
| ExcelImporter.ReferenceHandling_NewEdit | none |
| ExcelImporter.Template_Edit | ExcelImporter.IVK_SaveContinue_CreateTemplateFromDoc, ExcelImporter.IVK_SaveNewTemplate |
| ExcelImporter.Template_New | none |
| ExcelImporter.Template_New_FromDocument | ExcelImporter.IVK_Template_NewFromFile |
| ExcelImporter.TemplateDocument_NewEdit | none |
| ExcelImporter.Templates_Overview | none |
| ExcelImporter.VerificationForm | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| Column | ExcelImporter.Column_Hover, ExcelImporter.Column_NewEdit |
| General | ExcelImporter.Credits, ExcelImporter.ExcelImportOverview, ExcelImporter.VerificationForm |
| Import | ExcelImporter.Import_Overview |
| ImportXML | ExcelImporter.ImportXML_Upload |
| ReferenceHandling | ExcelImporter.ReferenceHandling_NewEdit |
| Template | ExcelImporter.Template_Edit, ExcelImporter.Template_New, ExcelImporter.Template_New_FromDocument |
| TemplateDocument | ExcelImporter.TemplateDocument_NewEdit |
| Templates | ExcelImporter.Templates_Overview |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| ExcelImporter.Column_Hover | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-column-hover.abstract.md) | [L1](pages/excelimporter-column-hover.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-column-hover.json) |
| ExcelImporter.Column_NewEdit | ShowPageAction | [L0](pages/excelimporter-column-newedit.abstract.md) | [L1](pages/excelimporter-column-newedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-column-newedit.json) |
| ExcelImporter.Credits | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-credits.abstract.md) | [L1](pages/excelimporter-credits.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-credits.json) |
| ExcelImporter.ExcelImportOverview | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-excelimportoverview.abstract.md) | [L1](pages/excelimporter-excelimportoverview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-excelimportoverview.json) |
| ExcelImporter.Import_Overview | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-import-overview.abstract.md) | [L1](pages/excelimporter-import-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-import-overview.json) |
| ExcelImporter.ImportXML_Upload | ShowPageAction | [L0](pages/excelimporter-importxml-upload.abstract.md) | [L1](pages/excelimporter-importxml-upload.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-importxml-upload.json) |
| ExcelImporter.ReferenceHandling_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-referencehandling-newedit.abstract.md) | [L1](pages/excelimporter-referencehandling-newedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-referencehandling-newedit.json) |
| ExcelImporter.Template_Edit | ShowPageAction | [L0](pages/excelimporter-template-edit.abstract.md) | [L1](pages/excelimporter-template-edit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-template-edit.json) |
| ExcelImporter.Template_New | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-template-new.abstract.md) | [L1](pages/excelimporter-template-new.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-template-new.json) |
| ExcelImporter.Template_New_FromDocument | ShowPageAction | [L0](pages/excelimporter-template-new-fromdocument.abstract.md) | [L1](pages/excelimporter-template-new-fromdocument.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-template-new-fromdocument.json) |
| ExcelImporter.TemplateDocument_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-templatedocument-newedit.abstract.md) | [L1](pages/excelimporter-templatedocument-newedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-templatedocument-newedit.json) |
| ExcelImporter.Templates_Overview | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-templates-overview.abstract.md) | [L1](pages/excelimporter-templates-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-templates-overview.json) |
| ExcelImporter.VerificationForm | Unknown (navigation metadata not exported) | [L0](pages/excelimporter-verificationform.abstract.md) | [L1](pages/excelimporter-verificationform.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/ExcelImporter/pages/excelimporter-verificationform.json) |
