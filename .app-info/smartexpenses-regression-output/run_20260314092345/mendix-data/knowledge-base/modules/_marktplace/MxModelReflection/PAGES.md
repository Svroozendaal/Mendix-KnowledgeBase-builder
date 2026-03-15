# Pages: MxModelReflection

## Page Inventory

| Page | Title | Allowed roles | Parameters | Popup |
|---|---|---|---|---|
| MxModelReflection.DbSizeEstimate_NewEdit | Edit Db Size Estimate | MxModelReflection.ModelAdministrator | DbSizeEstimate:MxModelReflection.DbSizeEstimate | True |
| MxModelReflection.EnumValue_Select | Select an enumeration value | none | none | True |
| MxModelReflection.Member_Select | Select an object member | none | none | True |
| MxModelReflection.Member_View | View member | MxModelReflection.ModelAdministrator | MxObjectMember:MxModelReflection.MxObjectMember | True |
| MxModelReflection.MemberEnum_View | View enum member | MxModelReflection.ModelAdministrator | MxObjectEnum:MxModelReflection.MxObjectEnum | True |
| MxModelReflection.Microflow_Select | Select a microflow | none | none | True |
| MxModelReflection.Microflow_View | Microflow details | MxModelReflection.ModelAdministrator | Microflows:MxModelReflection.Microflows | True |
| MxModelReflection.MxObject_Details | Object details | MxModelReflection.ModelAdministrator | MxObjectType:MxModelReflection.MxObjectType | True |
| MxModelReflection.MxObjectReference_Select | Select an object reference | none | none | True |
| MxModelReflection.MxObjectReference_View | Referentie details | MxModelReflection.ModelAdministrator | MxObjectReference:MxModelReflection.MxObjectReference | True |
| MxModelReflection.MxObjects_Overview | Domain model reflection | MxModelReflection.ModelAdministrator | none | False |
| MxModelReflection.MxObjectType_Select | Select an objecttype | none | none | True |
| MxModelReflection.SizeEstimate_Overview | Size estimate | MxModelReflection.ModelAdministrator | none | False |
| MxModelReflection.TestPattern_Edit | Test a Pattern | none | TestPattern:MxModelReflection.TestPattern | True |
| MxModelReflection.Token_NewEdit | Token details | MxModelReflection.ModelAdministrator, MxModelReflection.TokenUser | Token:MxModelReflection.Token | True |
| MxModelReflection.TokenOverview | Tokens | MxModelReflection.ModelAdministrator, MxModelReflection.Readonly | none | False |
| MxModelReflection.ValueType_View | Type details | MxModelReflection.ModelAdministrator | ValueType:MxModelReflection.ValueType | True |

## Page-Flow Links

| Page | Shown by flows |
|---|---|
| MxModelReflection.DbSizeEstimate_NewEdit | none |
| MxModelReflection.EnumValue_Select | none |
| MxModelReflection.Member_Select | none |
| MxModelReflection.Member_View | MxModelReflection.ACT_ShowMemberPage |
| MxModelReflection.MemberEnum_View | MxModelReflection.ACT_ShowMemberPage |
| MxModelReflection.Microflow_Select | none |
| MxModelReflection.Microflow_View | none |
| MxModelReflection.MxObject_Details | MxModelReflection.IVK_OpenReferencedMendixObject |
| MxModelReflection.MxObjectReference_Select | none |
| MxModelReflection.MxObjectReference_View | none |
| MxModelReflection.MxObjects_Overview | none |
| MxModelReflection.MxObjectType_Select | none |
| MxModelReflection.SizeEstimate_Overview | none |
| MxModelReflection.TestPattern_Edit | MxModelReflection.MB_TestTokenPattern |
| MxModelReflection.Token_NewEdit | none |
| MxModelReflection.TokenOverview | none |
| MxModelReflection.ValueType_View | none |

## Journey Groups

| User intent group | Pages |
|---|---|
| DbSizeEstimate | MxModelReflection.DbSizeEstimate_NewEdit |
| EnumValue | MxModelReflection.EnumValue_Select |
| General | MxModelReflection.TokenOverview |
| Member | MxModelReflection.Member_Select, MxModelReflection.Member_View |
| MemberEnum | MxModelReflection.MemberEnum_View |
| Microflow | MxModelReflection.Microflow_Select, MxModelReflection.Microflow_View |
| MxObject | MxModelReflection.MxObject_Details |
| MxObjectReference | MxModelReflection.MxObjectReference_Select, MxModelReflection.MxObjectReference_View |
| MxObjects | MxModelReflection.MxObjects_Overview |
| MxObjectType | MxModelReflection.MxObjectType_Select |
| SizeEstimate | MxModelReflection.SizeEstimate_Overview |
| TestPattern | MxModelReflection.TestPattern_Edit |
| Token | MxModelReflection.Token_NewEdit |
| ValueType | MxModelReflection.ValueType_View |

## Page Links

| Page | Entry provenance | L0 | L1 | L2 |
|---|---|---|---|---|
| MxModelReflection.DbSizeEstimate_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-dbsizeestimate-newedit.abstract.md) | [L1](pages/mxmodelreflection-dbsizeestimate-newedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-dbsizeestimate-newedit.json) |
| MxModelReflection.EnumValue_Select | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-enumvalue-select.abstract.md) | [L1](pages/mxmodelreflection-enumvalue-select.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-enumvalue-select.json) |
| MxModelReflection.Member_Select | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-member-select.abstract.md) | [L1](pages/mxmodelreflection-member-select.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-member-select.json) |
| MxModelReflection.Member_View | ShowPageAction | [L0](pages/mxmodelreflection-member-view.abstract.md) | [L1](pages/mxmodelreflection-member-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-member-view.json) |
| MxModelReflection.MemberEnum_View | ShowPageAction | [L0](pages/mxmodelreflection-memberenum-view.abstract.md) | [L1](pages/mxmodelreflection-memberenum-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-memberenum-view.json) |
| MxModelReflection.Microflow_Select | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-microflow-select.abstract.md) | [L1](pages/mxmodelreflection-microflow-select.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-microflow-select.json) |
| MxModelReflection.Microflow_View | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-microflow-view.abstract.md) | [L1](pages/mxmodelreflection-microflow-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-microflow-view.json) |
| MxModelReflection.MxObject_Details | ShowPageAction | [L0](pages/mxmodelreflection-mxobject-details.abstract.md) | [L1](pages/mxmodelreflection-mxobject-details.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-mxobject-details.json) |
| MxModelReflection.MxObjectReference_Select | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-mxobjectreference-select.abstract.md) | [L1](pages/mxmodelreflection-mxobjectreference-select.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-mxobjectreference-select.json) |
| MxModelReflection.MxObjectReference_View | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-mxobjectreference-view.abstract.md) | [L1](pages/mxmodelreflection-mxobjectreference-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-mxobjectreference-view.json) |
| MxModelReflection.MxObjects_Overview | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-mxobjects-overview.abstract.md) | [L1](pages/mxmodelreflection-mxobjects-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-mxobjects-overview.json) |
| MxModelReflection.MxObjectType_Select | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-mxobjecttype-select.abstract.md) | [L1](pages/mxmodelreflection-mxobjecttype-select.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-mxobjecttype-select.json) |
| MxModelReflection.SizeEstimate_Overview | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-sizeestimate-overview.abstract.md) | [L1](pages/mxmodelreflection-sizeestimate-overview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-sizeestimate-overview.json) |
| MxModelReflection.TestPattern_Edit | ShowPageAction | [L0](pages/mxmodelreflection-testpattern-edit.abstract.md) | [L1](pages/mxmodelreflection-testpattern-edit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-testpattern-edit.json) |
| MxModelReflection.Token_NewEdit | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-token-newedit.abstract.md) | [L1](pages/mxmodelreflection-token-newedit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-token-newedit.json) |
| MxModelReflection.TokenOverview | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-tokenoverview.abstract.md) | [L1](pages/mxmodelreflection-tokenoverview.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-tokenoverview.json) |
| MxModelReflection.ValueType_View | Unknown (navigation metadata not exported) | [L0](pages/mxmodelreflection-valuetype-view.abstract.md) | [L1](pages/mxmodelreflection-valuetype-view.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/pages/mxmodelreflection-valuetype-view.json) |
