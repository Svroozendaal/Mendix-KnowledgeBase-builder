# Domain: MxModelReflection

## Entities

| Entity | Persistable | Attribute count | Access rule count |
|---|---|---:|---:|
| MxModelReflection.DbSizeEstimate | True | 4 | 1 |
| MxModelReflection.InheritsFromContainer | False | 1 | 1 |
| MxModelReflection.Microflows | True | 3 | 2 |
| MxModelReflection.Module | True | 2 | 2 |
| MxModelReflection.MxObjectEnum | True | 0 | 2 |
| MxModelReflection.MxObjectEnumCaptions | True | 3 | 2 |
| MxModelReflection.MxObjectEnumValue | True | 1 | 2 |
| MxModelReflection.MxObjectMember | True | 7 | 2 |
| MxModelReflection.MxObjectReference | True | 7 | 2 |
| MxModelReflection.MxObjectType | True | 5 | 2 |
| MxModelReflection.Parameter | True | 1 | 2 |
| MxModelReflection.StringValue | False | 1 | 1 |
| MxModelReflection.TestPattern | False | 9 | 1 |
| MxModelReflection.Token | True | 15 | 2 |
| MxModelReflection.ValueType | True | 2 | 2 |

Confidence: Export-backed

## Entity Lifecycle Matrix

| Entity | Create flows | Update flows | Delete flows | Read flows |
|---|---|---|---|---|
| MxModelReflection.DbSizeEstimate | none | MxModelReflection.IVK_RecalculateSize | none | MxModelReflection.IVK_RecalculateSize |
| MxModelReflection.InheritsFromContainer | MxModelReflection.DSO_InheritsFromContainer | MxModelReflection.DSO_InheritsFromContainer | none | MxModelReflection.DSO_InheritsFromContainer |
| MxModelReflection.Microflows | none | none | MxModelReflection.IVK_deleteAll | MxModelReflection.FindMicroflow, MxModelReflection.IVK_deleteAll |
| MxModelReflection.Module | none | none | none | MxModelReflection.DSL_Modules |
| MxModelReflection.MxObjectEnum | none | none | none | none |
| MxModelReflection.MxObjectEnumCaptions | none | none | none | none |
| MxModelReflection.MxObjectEnumValue | none | none | none | none |
| MxModelReflection.MxObjectMember | ExcelImporter.Sub_CreateColumnsFromTemplate | ExcelImporter.IVK_Template_ConnectMatchingAttributes, ExcelImporter.Sub_CreateColumnsFromTemplate, MxModelReflection.IVK_RecalculateSize | none | ExcelImporter.IVK_Template_ConnectMatchingAttributes, ExcelImporter.Sub_CreateColumnsFromTemplate, ExcelImporter.ValidateColumn, MxModelReflection.FindMember, MxModelReflection.IVK_RecalculateSize |
| MxModelReflection.MxObjectReference | none | none | none | ExcelImporter.ValidateColumn, MxModelReflection.FindReference |
| MxModelReflection.MxObjectType | none | ExcelImporter.Column_SetCorrectRefObjectType | MxModelReflection.IVK_deleteAll | ExcelImporter.Column_SetCorrectRefObjectType, ExcelImporter.ValidateColumn, MxModelReflection.FindObjectType, MxModelReflection.IVK_deleteAll |
| MxModelReflection.Parameter | none | none | none | none |
| MxModelReflection.StringValue | MxModelReflection.EnumValueCaptions, MxModelReflection.EnumValueLanguages, MxModelReflection.ReferenceObjects | none | none | none |
| MxModelReflection.TestPattern | MxModelReflection.MB_TestTokenPattern | none | none | none |
| MxModelReflection.Token | none | none | none | none |
| MxModelReflection.ValueType | none | none | MxModelReflection.IVK_deleteAll | MxModelReflection.IVK_deleteAll |

Confidence: Inferred

## Role impacts per sensitive entity

| Entity | Module roles | Default member rights | XPath constraint |
|---|---|---|---|
| MxModelReflection.DbSizeEstimate | MxModelReflection.ModelAdministrator, MxModelReflection.Readonly | ReadOnly | none |
| MxModelReflection.InheritsFromContainer | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.Microflows | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.Microflows | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.Module | MxModelReflection.ModelAdministrator | ReadWrite | none |
| MxModelReflection.Module | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.MxObjectEnum | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.MxObjectEnum | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.MxObjectEnumCaptions | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.MxObjectEnumCaptions | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.MxObjectEnumValue | MxModelReflection.Readonly | None | none |
| MxModelReflection.MxObjectEnumValue | MxModelReflection.ModelAdministrator | None | none |
| MxModelReflection.MxObjectMember | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.MxObjectMember | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.MxObjectReference | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.MxObjectReference | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.MxObjectType | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.MxObjectType | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.Parameter | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.Parameter | MxModelReflection.ModelAdministrator | ReadOnly | none |
| MxModelReflection.StringValue | MxModelReflection.ModelAdministrator, MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadWrite | none |
| MxModelReflection.TestPattern | MxModelReflection.ModelAdministrator, MxModelReflection.TokenUser | ReadWrite | none |
| MxModelReflection.Token | MxModelReflection.ModelAdministrator, MxModelReflection.TokenUser | ReadWrite | none |
| MxModelReflection.Token | MxModelReflection.Readonly | ReadOnly | none |
| MxModelReflection.ValueType | MxModelReflection.Readonly, MxModelReflection.TokenUser | ReadOnly | none |
| MxModelReflection.ValueType | MxModelReflection.ModelAdministrator | ReadWrite | none |

Confidence: Export-backed

## Associations

| Association | Parent | Child | Cardinality | Type | Owner |
|---|---|---|---|---|---|
| MxModelReflection.Captions | MxModelReflection.MxObjectEnumValue | MxModelReflection.MxObjectEnumCaptions | *-* | ReferenceSet | Default |
| MxModelReflection.DbSizeEstimate_MxObjectType | MxModelReflection.DbSizeEstimate | MxModelReflection.MxObjectType | *-1 | Reference | Default |
| MxModelReflection.Microflows_InputParameter | MxModelReflection.Microflows | MxModelReflection.Parameter | *-* | ReferenceSet | Default |
| MxModelReflection.Microflows_Module | MxModelReflection.Microflows | MxModelReflection.Module | *-1 | Reference | Default |
| MxModelReflection.Microflows_Output_Type | MxModelReflection.Microflows | MxModelReflection.ValueType | *-1 | Reference | Default |
| MxModelReflection.MxObjectMember_MxObjectType | MxModelReflection.MxObjectMember | MxModelReflection.MxObjectType | *-1 | Reference | Default |
| MxModelReflection.MxObjectMember_Type | MxModelReflection.MxObjectMember | MxModelReflection.ValueType | *-1 | Reference | Default |
| MxModelReflection.MxObjectReference_Module | MxModelReflection.MxObjectReference | MxModelReflection.Module | *-1 | Reference | Default |
| MxModelReflection.MxObjectReference_MxObjectType | MxModelReflection.MxObjectReference | MxModelReflection.MxObjectType | *-* | ReferenceSet | Default |
| MxModelReflection.MxObjectReference_MxObjectType_Child | MxModelReflection.MxObjectReference | MxModelReflection.MxObjectType | *-* | ReferenceSet | Default |
| MxModelReflection.MxObjectReference_MxObjectType_Parent | MxModelReflection.MxObjectReference | MxModelReflection.MxObjectType | *-* | ReferenceSet | Default |
| MxModelReflection.MxObjectType_Module | MxModelReflection.MxObjectType | MxModelReflection.Module | *-1 | Reference | Default |
| MxModelReflection.MxObjectType_SubClassOf_MxObjectType | MxModelReflection.MxObjectType | MxModelReflection.MxObjectType | *-* | ReferenceSet | Default |
| MxModelReflection.Parameter_MxObjectType | MxModelReflection.Parameter | MxModelReflection.MxObjectType | *-1 | Reference | Default |
| MxModelReflection.Parameter_ValueType | MxModelReflection.Parameter | MxModelReflection.ValueType | *-1 | Reference | Default |
| MxModelReflection.Token_MxObjectMember | MxModelReflection.Token | MxModelReflection.MxObjectMember | *-1 | Reference | Default |
| MxModelReflection.Token_MxObjectReference | MxModelReflection.Token | MxModelReflection.MxObjectReference | *-1 | Reference | Default |
| MxModelReflection.Token_MxObjectType_Referenced | MxModelReflection.Token | MxModelReflection.MxObjectType | *-1 | Reference | Default |
| MxModelReflection.Token_MxObjectType_Start | MxModelReflection.Token | MxModelReflection.MxObjectType | *-1 | Reference | Default |
| MxModelReflection.Values | MxModelReflection.MxObjectEnum | MxModelReflection.MxObjectEnumValue | *-* | ReferenceSet | Default |
| MxModelReflection.ValueType_MxObjectType | MxModelReflection.ValueType | MxModelReflection.MxObjectType | *-1 | Reference | Default |

## Enumerations

| Enumeration | Value count | Sample values |
|---|---:|---|
| MxModelReflection.AssociationOwner | 2 | _Default, Both |
| MxModelReflection.AttributeTypes | 9 | AutoNumber, BooleanType, DateTime, Decimal |
| MxModelReflection.PersistenceType | 2 | Non_persistent, Persistable |
| MxModelReflection.PrimitiveTypes | 11 | AutoNumber, BooleanType, DateTime, Decimal |
| MxModelReflection.ReferenceType | 2 | Reference, ReferenceSet |
| MxModelReflection.Status | 2 | Invalid, Valid |
| MxModelReflection.TokenType | 2 | Attribute, Reference |

## Entity Index

<a id="entity-mxmodelreflection-dbsizeestimate"></a>
### MxModelReflection.DbSizeEstimate

- Generalization: none.
- Lifecycle: create=none; update=MxModelReflection.IVK_RecalculateSize; delete=none; read=MxModelReflection.IVK_RecalculateSize.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-inheritsfromcontainer"></a>
### MxModelReflection.InheritsFromContainer

- Generalization: none.
- Lifecycle: create=MxModelReflection.DSO_InheritsFromContainer; update=MxModelReflection.DSO_InheritsFromContainer; delete=none; read=MxModelReflection.DSO_InheritsFromContainer.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-microflows"></a>
### MxModelReflection.Microflows

- Generalization: none.
- Lifecycle: create=none; update=none; delete=MxModelReflection.IVK_deleteAll; read=MxModelReflection.FindMicroflow, MxModelReflection.IVK_deleteAll.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-module"></a>
### MxModelReflection.Module

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=MxModelReflection.DSL_Modules.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjectenum"></a>
### MxModelReflection.MxObjectEnum

- Generalization: MxModelReflection.MxObjectMember.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjectenumcaptions"></a>
### MxModelReflection.MxObjectEnumCaptions

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjectenumvalue"></a>
### MxModelReflection.MxObjectEnumValue

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjectmember"></a>
### MxModelReflection.MxObjectMember

- Generalization: none.
- Lifecycle: create=ExcelImporter.Sub_CreateColumnsFromTemplate; update=ExcelImporter.IVK_Template_ConnectMatchingAttributes, ExcelImporter.Sub_CreateColumnsFromTemplate, MxModelReflection.IVK_RecalculateSize; delete=none; read=ExcelImporter.IVK_Template_ConnectMatchingAttributes, ExcelImporter.Sub_CreateColumnsFromTemplate, ExcelImporter.ValidateColumn, MxModelReflection.FindMember, MxModelReflection.IVK_RecalculateSize.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjectreference"></a>
### MxModelReflection.MxObjectReference

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=ExcelImporter.ValidateColumn, MxModelReflection.FindReference.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-mxobjecttype"></a>
### MxModelReflection.MxObjectType

- Generalization: none.
- Lifecycle: create=none; update=ExcelImporter.Column_SetCorrectRefObjectType; delete=MxModelReflection.IVK_deleteAll; read=ExcelImporter.Column_SetCorrectRefObjectType, ExcelImporter.ValidateColumn, MxModelReflection.FindObjectType, MxModelReflection.IVK_deleteAll.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-parameter"></a>
### MxModelReflection.Parameter

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-stringvalue"></a>
### MxModelReflection.StringValue

- Generalization: none.
- Lifecycle: create=MxModelReflection.EnumValueCaptions, MxModelReflection.EnumValueLanguages, MxModelReflection.ReferenceObjects; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-testpattern"></a>
### MxModelReflection.TestPattern

- Generalization: none.
- Lifecycle: create=MxModelReflection.MB_TestTokenPattern; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-token"></a>
### MxModelReflection.Token

- Generalization: none.
- Lifecycle: create=none; update=none; delete=none; read=none.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).
<a id="entity-mxmodelreflection-valuetype"></a>
### MxModelReflection.ValueType

- Generalization: none.
- Lifecycle: create=none; update=none; delete=MxModelReflection.IVK_deleteAll; read=MxModelReflection.IVK_deleteAll.
- Security/XPath summary: none.
- Source: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt) / [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json).

## Source

- Domain export pseudo: [domain-model.pseudo.txt](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.pseudo.txt)
- Domain export json: [domain-model.json](../../../../app-overview/cli_2026-03-14T09-23-46.259Z/modules/marketplace/MxModelReflection/domain-model.json)
