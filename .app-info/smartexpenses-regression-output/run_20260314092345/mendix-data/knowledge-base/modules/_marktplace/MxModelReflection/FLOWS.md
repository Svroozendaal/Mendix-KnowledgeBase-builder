# Flows: MxModelReflection

## Flow Catalogue

### Action Flows (ACT_*)

| Flow | Nodes | Key Actions | Pages Shown |
|---|---:|---|---|
| ACT_ShowMemberPage | 9 | none | MxModelReflection.Member_View, MxModelReflection.MemberEnum_View |

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
| AssociationIsReferenceSet | Rule | 18 | none |
| ASu_CheckMetamodel | Microflow | 4 | none |
| BCo_MxObjectMember_CreateCompleteMemberName | Microflow | 8 | none |
| BCo_MxObjectReference | Microflow | 6 | none |
| BCo_MxObjectType | Microflow | 6 | none |
| BCo_Token | Microflow | 21 | none |
| BDe_MxObjectType | Microflow | 12 | none |
| Ch_Member | Microflow | 5 | none |
| Ch_ObjecttypeReference | Microflow | 5 | none |
| Ch_ObjectTypeStart | Microflow | 5 | none |
| Ch_Reference | Microflow | 5 | none |
| DeleteDbSizeEstimate | Microflow | 4 | none |
| DeleteToken | Microflow | 4 | none |
| DSL_Modules | Microflow | 6 | MxModelReflection.Module |
| DSO_InheritsFromContainer | Microflow | 10 | MxModelReflection.InheritsFromContainer |
| EnumValueCaptions | Microflow | 5 | MxModelReflection.StringValue |
| EnumValueLanguages | Microflow | 5 | MxModelReflection.StringValue |
| FindMember | Microflow | 11 | MxModelReflection.MxObjectMember |
| FindMicroflow | Microflow | 9 | MxModelReflection.Microflows |
| FindObjectType | Microflow | 18 | MxModelReflection.MxObjectType |
| FindReference | Microflow | 18 | MxModelReflection.MxObjectReference |
| IVK_deleteAll | Microflow | 8 | MxModelReflection.Microflows, MxModelReflection.MxObjectType, MxModelReflection.ValueType |
| IVK_MxObjectTypeCommit | Microflow | 4 | none |
| IVK_OpenReferencedMendixObject | Microflow | 9 | none |
| IVK_RecalculateSize | Microflow | 27 | MxModelReflection.DbSizeEstimate, MxModelReflection.MxObjectMember |
| IVK_SyncObjects | Microflow | 3 | none |
| IVK_ToggleModule | Microflow | 4 | none |
| Log | Microflow | 10 | none |
| MB_TestThePattern | Microflow | 7 | none |
| MB_TestTokenPattern | Microflow | 5 | MxModelReflection.TestPattern |
| OC_FindObjectType | Microflow | 5 | none |
| ReferenceObjects | Microflow | 5 | MxModelReflection.StringValue |

## Cross-Module Calls

| Flow | Calls | Target Module |
|---|---|---|
| none | none | none |

## Tier 1 Shortlist

| Flow | Shown Pages | Entities |
|---|---|---|
| none | none | none |

## Flow Details

| Flow | Kind | Nodes | Tier | Calls Out | Called By |
|---|---|---:|---:|---:|---:|
| ACT_ShowMemberPage | Microflow | 9 | 3 | 0 | 0 |
| AssociationIsReferenceSet | Rule | 18 | 3 | 0 | 0 |
| ASu_CheckMetamodel | Microflow | 4 | 3 | 0 | 1 |
| BCo_MxObjectMember_CreateCompleteMemberName | Microflow | 8 | 3 | 0 | 0 |
| BCo_MxObjectReference | Microflow | 6 | 3 | 0 | 0 |
| BCo_MxObjectType | Microflow | 6 | 3 | 0 | 0 |
| BCo_Token | Microflow | 21 | 3 | 0 | 0 |
| BDe_MxObjectType | Microflow | 12 | 3 | 0 | 0 |
| Ch_Member | Microflow | 5 | 3 | 0 | 0 |
| Ch_ObjecttypeReference | Microflow | 5 | 3 | 0 | 0 |
| Ch_ObjectTypeStart | Microflow | 5 | 3 | 0 | 0 |
| Ch_Reference | Microflow | 5 | 3 | 0 | 0 |
| DeleteDbSizeEstimate | Microflow | 4 | 3 | 0 | 0 |
| DeleteToken | Microflow | 4 | 3 | 0 | 0 |
| DSL_Modules | Microflow | 6 | 3 | 1 | 0 |
| DSO_InheritsFromContainer | Microflow | 10 | 3 | 0 | 0 |
| EnumValueCaptions | Microflow | 5 | 3 | 0 | 0 |
| EnumValueLanguages | Microflow | 5 | 3 | 0 | 0 |
| FindMember | Microflow | 11 | 3 | 0 | 3 |
| FindMicroflow | Microflow | 9 | 3 | 0 | 2 |
| FindObjectType | Microflow | 18 | 3 | 0 | 3 |
| FindReference | Microflow | 18 | 3 | 0 | 2 |
| IVK_deleteAll | Microflow | 8 | 3 | 0 | 0 |
| IVK_MxObjectTypeCommit | Microflow | 4 | 3 | 0 | 0 |
| IVK_OpenReferencedMendixObject | Microflow | 9 | 3 | 0 | 0 |
| IVK_RecalculateSize | Microflow | 27 | 3 | 1 | 0 |
| IVK_SyncObjects | Microflow | 3 | 3 | 0 | 1 |
| IVK_ToggleModule | Microflow | 4 | 3 | 0 | 0 |
| Log | Microflow | 10 | 3 | 0 | 1 |
| MB_TestThePattern | Microflow | 7 | 3 | 0 | 0 |
| MB_TestTokenPattern | Microflow | 5 | 3 | 0 | 0 |
| OC_FindObjectType | Microflow | 5 | 3 | 1 | 0 |
| ReferenceObjects | Microflow | 5 | 3 | 0 | 0 |

## Tier 1 Deep Narratives

Tier 1 deep narratives are only generated for custom modules; use the flow catalogue and L0/L1 flow files for this module.

## Flow Links

| Flow | Type | Tier | L0 | L1 | L2 |
|---|---|---:|---|---|---|
| MxModelReflection.ACT_ShowMemberPage | Microflow | 3 | [L0](flows/mxmodelreflection-act-showmemberpage.abstract.md) | [L1](flows/mxmodelreflection-act-showmemberpage.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-act-showmemberpage.json) |
| MxModelReflection.AssociationIsReferenceSet | Rule | 3 | [L0](flows/mxmodelreflection-associationisreferenceset.abstract.md) | [L1](flows/mxmodelreflection-associationisreferenceset.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-associationisreferenceset.json) |
| MxModelReflection.ASu_CheckMetamodel | Microflow | 3 | [L0](flows/mxmodelreflection-asu-checkmetamodel.abstract.md) | [L1](flows/mxmodelreflection-asu-checkmetamodel.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-asu-checkmetamodel.json) |
| MxModelReflection.BCo_MxObjectMember_CreateCompleteMemberName | Microflow | 3 | [L0](flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.abstract.md) | [L1](flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectmember-createcompletemembername.json) |
| MxModelReflection.BCo_MxObjectReference | Microflow | 3 | [L0](flows/mxmodelreflection-bco-mxobjectreference.abstract.md) | [L1](flows/mxmodelreflection-bco-mxobjectreference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjectreference.json) |
| MxModelReflection.BCo_MxObjectType | Microflow | 3 | [L0](flows/mxmodelreflection-bco-mxobjecttype.abstract.md) | [L1](flows/mxmodelreflection-bco-mxobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-mxobjecttype.json) |
| MxModelReflection.BCo_Token | Microflow | 3 | [L0](flows/mxmodelreflection-bco-token.abstract.md) | [L1](flows/mxmodelreflection-bco-token.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bco-token.json) |
| MxModelReflection.BDe_MxObjectType | Microflow | 3 | [L0](flows/mxmodelreflection-bde-mxobjecttype.abstract.md) | [L1](flows/mxmodelreflection-bde-mxobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-bde-mxobjecttype.json) |
| MxModelReflection.Ch_Member | Microflow | 3 | [L0](flows/mxmodelreflection-ch-member.abstract.md) | [L1](flows/mxmodelreflection-ch-member.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-member.json) |
| MxModelReflection.Ch_ObjecttypeReference | Microflow | 3 | [L0](flows/mxmodelreflection-ch-objecttypereference.abstract.md) | [L1](flows/mxmodelreflection-ch-objecttypereference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypereference.json) |
| MxModelReflection.Ch_ObjectTypeStart | Microflow | 3 | [L0](flows/mxmodelreflection-ch-objecttypestart.abstract.md) | [L1](flows/mxmodelreflection-ch-objecttypestart.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-objecttypestart.json) |
| MxModelReflection.Ch_Reference | Microflow | 3 | [L0](flows/mxmodelreflection-ch-reference.abstract.md) | [L1](flows/mxmodelreflection-ch-reference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ch-reference.json) |
| MxModelReflection.DeleteDbSizeEstimate | Microflow | 3 | [L0](flows/mxmodelreflection-deletedbsizeestimate.abstract.md) | [L1](flows/mxmodelreflection-deletedbsizeestimate.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-deletedbsizeestimate.json) |
| MxModelReflection.DeleteToken | Microflow | 3 | [L0](flows/mxmodelreflection-deletetoken.abstract.md) | [L1](flows/mxmodelreflection-deletetoken.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-deletetoken.json) |
| MxModelReflection.DSL_Modules | Microflow | 3 | [L0](flows/mxmodelreflection-dsl-modules.abstract.md) | [L1](flows/mxmodelreflection-dsl-modules.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-dsl-modules.json) |
| MxModelReflection.DSO_InheritsFromContainer | Microflow | 3 | [L0](flows/mxmodelreflection-dso-inheritsfromcontainer.abstract.md) | [L1](flows/mxmodelreflection-dso-inheritsfromcontainer.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-dso-inheritsfromcontainer.json) |
| MxModelReflection.EnumValueCaptions | Microflow | 3 | [L0](flows/mxmodelreflection-enumvaluecaptions.abstract.md) | [L1](flows/mxmodelreflection-enumvaluecaptions.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluecaptions.json) |
| MxModelReflection.EnumValueLanguages | Microflow | 3 | [L0](flows/mxmodelreflection-enumvaluelanguages.abstract.md) | [L1](flows/mxmodelreflection-enumvaluelanguages.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-enumvaluelanguages.json) |
| MxModelReflection.FindMember | Microflow | 3 | [L0](flows/mxmodelreflection-findmember.abstract.md) | [L1](flows/mxmodelreflection-findmember.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findmember.json) |
| MxModelReflection.FindMicroflow | Microflow | 3 | [L0](flows/mxmodelreflection-findmicroflow.abstract.md) | [L1](flows/mxmodelreflection-findmicroflow.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findmicroflow.json) |
| MxModelReflection.FindObjectType | Microflow | 3 | [L0](flows/mxmodelreflection-findobjecttype.abstract.md) | [L1](flows/mxmodelreflection-findobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findobjecttype.json) |
| MxModelReflection.FindReference | Microflow | 3 | [L0](flows/mxmodelreflection-findreference.abstract.md) | [L1](flows/mxmodelreflection-findreference.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-findreference.json) |
| MxModelReflection.IVK_deleteAll | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-deleteall.abstract.md) | [L1](flows/mxmodelreflection-ivk-deleteall.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-deleteall.json) |
| MxModelReflection.IVK_MxObjectTypeCommit | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-mxobjecttypecommit.abstract.md) | [L1](flows/mxmodelreflection-ivk-mxobjecttypecommit.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-mxobjecttypecommit.json) |
| MxModelReflection.IVK_OpenReferencedMendixObject | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-openreferencedmendixobject.abstract.md) | [L1](flows/mxmodelreflection-ivk-openreferencedmendixobject.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-openreferencedmendixobject.json) |
| MxModelReflection.IVK_RecalculateSize | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-recalculatesize.abstract.md) | [L1](flows/mxmodelreflection-ivk-recalculatesize.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-recalculatesize.json) |
| MxModelReflection.IVK_SyncObjects | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-syncobjects.abstract.md) | [L1](flows/mxmodelreflection-ivk-syncobjects.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-syncobjects.json) |
| MxModelReflection.IVK_ToggleModule | Microflow | 3 | [L0](flows/mxmodelreflection-ivk-togglemodule.abstract.md) | [L1](flows/mxmodelreflection-ivk-togglemodule.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-ivk-togglemodule.json) |
| MxModelReflection.Log | Microflow | 3 | [L0](flows/mxmodelreflection-log.abstract.md) | [L1](flows/mxmodelreflection-log.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-log.json) |
| MxModelReflection.MB_TestThePattern | Microflow | 3 | [L0](flows/mxmodelreflection-mb-testthepattern.abstract.md) | [L1](flows/mxmodelreflection-mb-testthepattern.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-mb-testthepattern.json) |
| MxModelReflection.MB_TestTokenPattern | Microflow | 3 | [L0](flows/mxmodelreflection-mb-testtokenpattern.abstract.md) | [L1](flows/mxmodelreflection-mb-testtokenpattern.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-mb-testtokenpattern.json) |
| MxModelReflection.OC_FindObjectType | Microflow | 3 | [L0](flows/mxmodelreflection-oc-findobjecttype.abstract.md) | [L1](flows/mxmodelreflection-oc-findobjecttype.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-oc-findobjecttype.json) |
| MxModelReflection.ReferenceObjects | Microflow | 3 | [L0](flows/mxmodelreflection-referenceobjects.abstract.md) | [L1](flows/mxmodelreflection-referenceobjects.overview.md) | [L2](../../../../app-overview/current/modules/marketplace/MxModelReflection/flows/mxmodelreflection-referenceobjects.json) |
