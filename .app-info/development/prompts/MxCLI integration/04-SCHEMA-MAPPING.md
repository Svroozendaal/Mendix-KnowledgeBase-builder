# Schema Mapping — JSON v2.0 ↔ mxcli

This document maps every field in the current parser's JSON v2.0 output to the equivalent mxcli command or catalog query. This is the blueprint for building a mxcli-based extraction layer that produces **identical JSON output**.

---

## Legend

| Symbol | Meaning |
|--------|---------|
| **Direct** | Field maps 1:1 to a mxcli catalog column or command output |
| **Derived** | Field can be computed from mxcli data with simple logic |
| **DESCRIBE** | Field requires `DESCRIBE` command output (MDL text), needs parsing |
| **Full** | Requires `REFRESH CATALOG FULL` mode |
| **Gap** | No direct mxcli equivalent — needs new mxcli feature or workaround |

---

## 1. manifest.json

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `schemaVersion` | Hardcoded `"2.0"` | Direct |
| `generatedAtUtc` | Generation timestamp | Direct |
| `selectedModules` | Input parameter (pass-through) | Direct |
| `artifactCount` | Count of generated files | Derived |
| `artifacts[].type` | Generated during file writing | Direct |
| `artifacts[].path` | Generated during file writing | Direct |

**mxcli commands:** None needed — manifest is metadata about the generation run itself.

---

## 2. general/app-info.json

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `schemaVersion` | Hardcoded | Direct |
| `generatedAtUtc` | Timestamp | Direct |
| `sourceMprPath` | `-p` flag value | Direct |
| `sourceDumpPath` | N/A (no dump in new flow) | **Changed** — set to `null` or omit |
| `summary.moduleCount` | `SELECT COUNT(*) FROM CATALOG.modules` | Direct |
| `summary.entityCount` | `SELECT COUNT(*) FROM CATALOG.entities` | Direct |
| `summary.associationCount` | `SELECT SUM(AssociationCount) FROM CATALOG.entities` | Derived |
| `summary.enumerationCount` | `SELECT COUNT(*) FROM CATALOG.enumerations` | Direct |
| `summary.flowCount` | `SELECT COUNT(*) FROM CATALOG.microflows` | Direct |
| `summary.microflowCount` | `SELECT COUNT(*) FROM CATALOG.microflows WHERE MicroflowType='MICROFLOW'` | Direct |
| `summary.nanoflowCount` | `SELECT COUNT(*) FROM CATALOG.microflows WHERE MicroflowType='NANOFLOW'` | Direct |
| `summary.ruleCount` | Catalog doesn't distinguish rules | **Gap** — rules are stored as microflows with specific naming |
| `summary.workflowCount` | `SELECT COUNT(*) FROM CATALOG.workflows` | Direct |
| `summary.flowNodeCount` | `SELECT SUM(ActivityCount) FROM CATALOG.microflows` | Derived (approximate) |
| `summary.flowEdgeCount` | Not directly in catalog | **Gap** — needs DESCRIBE parsing or new catalog column |
| `summary.flowCallEdgeCount` | `SELECT COUNT(*) FROM CATALOG.refs WHERE RefKind='call'` | Full |

**Primary mxcli approach:**
```sql
SELECT COUNT(*) as cnt, 'modules' as type FROM CATALOG.modules
UNION ALL SELECT COUNT(*), 'entities' FROM CATALOG.entities
UNION ALL SELECT COUNT(*), 'microflows' FROM CATALOG.microflows WHERE MicroflowType='MICROFLOW'
UNION ALL SELECT COUNT(*), 'nanoflows' FROM CATALOG.microflows WHERE MicroflowType='NANOFLOW'
UNION ALL SELECT COUNT(*), 'enumerations' FROM CATALOG.enumerations
UNION ALL SELECT COUNT(*), 'workflows' FROM CATALOG.workflows
```

---

## 3. general/user-roles.json

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `projectSecurity.securityLevel` | `SHOW PROJECT SECURITY` output → parse "Security Level" | Direct |
| `projectSecurity.adminUserName` | `SHOW PROJECT SECURITY` output → parse "Admin User" | Direct |
| `projectSecurity.enableGuestAccess` | `SHOW PROJECT SECURITY` output → parse "Guest Access" | Direct |
| `projectSecurity.guestUserRoleName` | `SHOW PROJECT SECURITY` output → parse | Direct |
| `projectSecurity.userRoles[].name` | `SELECT UserRoleName FROM CATALOG.role_mappings GROUP BY UserRoleName` | Direct |
| `projectSecurity.userRoles[].moduleRoles` | `SELECT ModuleRoleName FROM CATALOG.role_mappings WHERE UserRoleName='X'` | Direct |
| `projectSecurity.userRoles[].manageAllRoles` | `DESCRIBE SECURITY` or `SHOW PROJECT SECURITY` | DESCRIBE |
| `projectSecurity.userRoles[].checkSecurity` | `DESCRIBE SECURITY` or `SHOW PROJECT SECURITY` | DESCRIBE |

**Primary mxcli approach:**
```bash
mxcli -p app.mpr -c "SHOW PROJECT SECURITY"
mxcli -p app.mpr -c "SHOW USER ROLES"
mxcli -p app.mpr -c "SELECT * FROM CATALOG.role_mappings"
```

---

## 4. general/all-modules.json

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `modules[].module` | `CATALOG.modules.Name` | Direct |
| `modules[].category` | Derived from `IsSystemModule` + `AppStoreGuid` | Derived |
| `modules[].fromAppStore` | `CATALOG.modules.AppStoreGuid IS NOT NULL` | Derived |
| `modules[].moduleRoles[].name` | `SELECT DISTINCT ModuleRoleName FROM CATALOG.role_mappings WHERE ModuleName='X'` | Direct |
| `modules[].moduleRoles[].description` | `DESCRIBE MODULE X` | DESCRIBE |
| `modules[].entityCount` | `SELECT COUNT(*) FROM CATALOG.entities WHERE ModuleName='X'` | Direct |
| `modules[].flowCount` | `SELECT COUNT(*) FROM CATALOG.microflows WHERE ModuleName='X'` | Direct |
| `modules[].pageCount` | `SELECT COUNT(*) FROM CATALOG.pages WHERE ModuleName='X'` | Direct |
| `modules[].constantCount` | Not directly in catalog (constants are not a separate table) | **Gap** — needs new catalog table or DESCRIBE |

**Primary mxcli approach:**
```bash
mxcli -p app.mpr -c "SHOW MODULES"
# Or for structured data:
mxcli -p app.mpr -c "SELECT Name, IsSystemModule, AppStoreVersion, AppStoreGuid FROM CATALOG.modules"
```

**Category derivation logic:**
```
if IsSystemModule=1 and Name in ['System','MxModelReflection',...] → "System"
if AppStoreGuid IS NOT NULL or AppStoreVersion IS NOT NULL → "Marketplace"
else → "Custom"
```

---

## 5. modules/\<Module\>/domain-model.json

### entities[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `name` | `CATALOG.entities.Name` | Direct |
| `isPersistable` | `CATALOG.entities.EntityType = 'Persistent'` | Derived |
| `generalization` | `CATALOG.entities.Generalization` | Direct |
| `attributes[].name` | `CATALOG.attributes.Name WHERE EntityQualifiedName='X'` | Direct |
| `attributes[].type` | `CATALOG.attributes.DataType` | Direct |
| `attributes[].enumerationName` | `CATALOG.attributes.DataType` when type is Enumeration → extract enum name | Derived |
| `attributes[].length` | `CATALOG.attributes.Length` | Direct |
| `attributes[].defaultValue` | `CATALOG.attributes.DefaultValue` | Direct |
| `attributes[].validationSummary` | Not in catalog | **Gap** — needs DESCRIBE or new catalog data |
| `accessRules[].ruleKey` | `CATALOG.permissions` (composite key from role+entity) | Derived |
| `accessRules[].moduleRoles` | `SELECT ModuleRoleName FROM CATALOG.permissions WHERE ElementName='X' GROUP BY ...` | Direct |
| `accessRules[].allowCreate` | `CATALOG.permissions.AccessType = 'Create'` | Derived |
| `accessRules[].allowDelete` | `CATALOG.permissions.AccessType = 'Delete'` | Derived |
| `accessRules[].defaultMemberAccessRights` | Not directly in catalog | **Gap** — needs DESCRIBE |
| `accessRules[].xPathConstraint` | `CATALOG.permissions.XPathConstraint` | Direct |
| `accessRules[].xPathEvidence.constraint` | `CATALOG.permissions.XPathConstraint` | Direct |
| `accessRules[].xPathEvidence.summary` | Not in catalog (generated by parser) | **Gap** — needs generation logic |
| `accessRules[].memberAccesses[].memberName` | `CATALOG.permissions.MemberName` | Direct |
| `accessRules[].memberAccesses[].memberKind` | Derived from member type lookup | Derived |
| `accessRules[].memberAccesses[].accessRights` | `CATALOG.permissions.AccessType` | Direct |

### associations[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `name` | `DESCRIBE ENTITY` → parse association section | DESCRIBE |
| `parentEntity` | `DESCRIBE ENTITY` → parse | DESCRIBE |
| `childEntity` | `DESCRIBE ENTITY` → parse | DESCRIBE |
| `cardinality` | `DESCRIBE ENTITY` → parse | DESCRIBE |
| `type` | `DESCRIBE ENTITY` → parse | DESCRIBE |
| `owner` | `DESCRIBE ENTITY` → parse | DESCRIBE |
| `storageFormat` | Not typically exposed | **Gap** |

**Note:** Association details are **not in the catalog tables** directly — the entities table only has `AssociationCount`. Full association data requires parsing `DESCRIBE ENTITY` MDL output or adding a new `associations` catalog table.

### enumerations[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `name` | `CATALOG.enumerations.Name` | Direct |
| `values` | `DESCRIBE ENUMERATION Module.Name` → parse values | DESCRIBE |

**Note:** Enum values are not in the catalog (only `ValueCount`). Need `DESCRIBE ENUMERATION` output.

**Primary mxcli approach:**
```bash
# Entities + attributes
mxcli -p app.mpr -c "SELECT * FROM CATALOG.entities WHERE ModuleName='MyModule'"
mxcli -p app.mpr -c "SELECT * FROM CATALOG.attributes WHERE ModuleName='MyModule'"

# Associations (need DESCRIBE)
mxcli -p app.mpr -c "DESCRIBE ENTITY MyModule.Customer"

# Access rules
mxcli -p app.mpr -c "SELECT * FROM CATALOG.permissions WHERE ModuleName='MyModule' AND ElementType='ENTITY'"

# Enumerations
mxcli -p app.mpr -c "DESCRIBE ENUMERATION MyModule.Status"
```

---

## 6. modules/\<Module\>/flows.json

### flows[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `flowId` | `CATALOG.microflows.Id` | Direct |
| `kind` | `CATALOG.microflows.MicroflowType` (map "MICROFLOW"→"Microflow", "NANOFLOW"→"Nanoflow") | Derived |
| `qualifiedName` | `CATALOG.microflows.QualifiedName` | Direct |
| `module` | `CATALOG.microflows.ModuleName` | Direct |
| `nodes[]` | `DESCRIBE MICROFLOW` → parse MDL, or `CATALOG.activities` (Full) | DESCRIBE/Full |
| `nodes[].nodeId` | `CATALOG.activities.Id` | Full |
| `nodes[].nodeType` | `CATALOG.activities.ActivityType` | Full |
| `nodes[].label` | `CATALOG.activities.Caption` | Full |
| `nodes[].detail` | `CATALOG.activities.Description` | Full |
| `nodes[].loopOwnerId` | Not in catalog | **Gap** |
| `nodes[].isExecutable` | Not in catalog | **Gap** — always true for activities |
| `nodes[].calls[]` | `CATALOG.refs WHERE SourceName='X' AND RefKind='call'` | Full |
| `edges[]` | Not in catalog (flow graph structure) | **Gap** — needs DESCRIBE parsing |
| `edges[].edgeId` | — | **Gap** |
| `edges[].originNodeId` | — | **Gap** |
| `edges[].destinationNodeId` | — | **Gap** |
| `edges[].condition` | — | **Gap** |
| `edges[].isErrorHandler` | — | **Gap** |
| `calls[]` | `CATALOG.refs WHERE SourceName='X' AND RefKind='call'` | Full |
| `calls[].callKind` | Derived from target type in refs | Derived/Full |
| `calls[].targetFlowName` | `CATALOG.refs.TargetName` | Full |
| `calls[].sourceNodeId` | Not in refs table | **Gap** |
| `startNodeIds` | Not in catalog | **Gap** — needs DESCRIBE parsing |
| `primaryExecutionOrderNodeIds` | Not in catalog | **Gap** — needs DESCRIBE parsing |
| `pseudocode` | `DESCRIBE MICROFLOW` produces MDL which serves as pseudocode | DESCRIBE |
| `retrieveActions[]` | `CATALOG.activities WHERE ActivityType='RetrieveAction' AND MicroflowQualifiedName='X'` | Full |
| `retrieveActions[].nodeId` | `CATALOG.activities.Id` | Full |
| `retrieveActions[].summary` | `CATALOG.activities.Caption` or `.Description` | Full |
| `retrieveActions[].sourceKind` | `CATALOG.activities.ActionType` | Full |
| `retrieveActions[].entity` | `CATALOG.activities.EntityRef` | Full |
| `retrieveActions[].association` | Not directly in activities | **Gap** |
| `retrieveActions[].xpath` | `CATALOG.xpath_expressions WHERE ComponentId='activity-id'` | Full |
| `decisionActions[]` | `CATALOG.activities WHERE ActivityType='ExclusiveSplit'` | Full |
| `decisionActions[].expression` | `CATALOG.activities.Description` or `Caption` | Full (partial) |
| `showPageActions[]` | `CATALOG.activities WHERE ActivityType='ShowFormAction'` | Full |
| `showPageActions[].targetPage` | `CATALOG.activities.EntityRef` (overloaded for page ref) | Full |
| `mutationActions[]` | `CATALOG.activities WHERE ActivityType IN ('CreateObjectAction','ChangeObjectAction','DeleteObjectAction')` | Full |
| `mutationActions[].actionKind` | Derived from ActivityType | Derived/Full |
| `mutationActions[].entity` | `CATALOG.activities.EntityRef` | Full |
| `mutationActions[].memberSummary` | `CATALOG.activities.Description` | Full |

### callEdges[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `callerModule` | `CATALOG.refs` → derive from SourceName | Full |
| `callerFlow` | `CATALOG.refs.SourceName` | Full |
| `callerKind` | Derived from SourceType | Full |
| `callKind` | Derived from TargetType | Full |
| `sourceNodeId` | Not in refs | **Gap** |
| `targetModule` | Derived from TargetName | Full |
| `targetFlow` | `CATALOG.refs.TargetName` | Full |
| `isInternal` | Derived: `callerModule == targetModule` | Full |

**Primary mxcli approach:**
```bash
# Basic flow metadata
mxcli -p app.mpr -c "SELECT * FROM CATALOG.microflows WHERE ModuleName='MyModule'"

# Activities (Full mode)
mxcli -p app.mpr -c "REFRESH CATALOG FULL"
mxcli -p app.mpr -c "SELECT * FROM CATALOG.activities WHERE ModuleName='MyModule'"

# Cross-references (Full mode)
mxcli -p app.mpr -c "SELECT * FROM CATALOG.refs WHERE ModuleName='MyModule' AND RefKind='call'"

# Detailed MDL (for pseudocode and edge/node structure)
mxcli -p app.mpr -c "DESCRIBE MICROFLOW MyModule.ACT_Process"
```

---

## 7. modules/\<Module\>/pages.json

### pages[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `qualifiedName` | `CATALOG.pages.QualifiedName` | Direct |
| `name` | `CATALOG.pages.Name` | Direct |
| `title` | `CATALOG.pages.Title` | Direct |
| `layout` | `CATALOG.pages.LayoutRef` | Direct |
| `allowedRoles` | `CATALOG.permissions WHERE ElementType='PAGE' AND ElementName='X'` | Direct |
| `parameters[].name` | `DESCRIBE PAGE` → parse parameters | DESCRIBE |
| `parameters[].entityType` | `DESCRIBE PAGE` → parse | DESCRIBE |
| `isPopup` | `DESCRIBE PAGE` → parse | DESCRIBE |
| `popupWidth` | `DESCRIBE PAGE` → parse | DESCRIBE |
| `popupHeight` | `DESCRIBE PAGE` → parse | DESCRIBE |
| `popupResizable` | `DESCRIBE PAGE` → parse | DESCRIBE |
| `url` | `CATALOG.pages.URL` | Direct |
| `excluded` | Not in catalog | **Gap** |
| `dataSources[]` | `CATALOG.widgets WHERE ContainerQualifiedName='X'` (partial) or `DESCRIBE PAGE` | Full/DESCRIBE |
| `dataSources[].sourceType` | Not directly in widgets table | **Gap** — needs DESCRIBE |
| `dataSources[].entity` | `CATALOG.widgets.EntityRef` | Full |
| `dataSources[].constraint` | `CATALOG.xpath_expressions WHERE DocumentQualifiedName='X'` | Full |
| `dataSources[].flowName` | `CATALOG.refs WHERE SourceName='X' AND RefKind='use'` | Full |
| `clientActions[]` | `CATALOG.refs WHERE SourceName='page-name' AND RefKind='call'` | Full |
| `clientActions[].actionType` | Derived from ref target type | Full |
| `clientActions[].targetPage` | `CATALOG.refs.TargetName WHERE TargetType='PAGE'` | Full |
| `clientActions[].flowName` | `CATALOG.refs.TargetName WHERE TargetType='MICROFLOW'` | Full |
| `navigationProvenance[]` | `CATALOG.refs WHERE TargetName='page' AND RefKind='call'` (reverse lookup) | Full |
| `navigationProvenance[].sourceType` | Derived from SourceType in refs | Full |
| `navigationProvenance[].flowName` | `CATALOG.refs.SourceName` | Full |

### snippets[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `qualifiedName` | `CATALOG.snippets.QualifiedName` | Direct |
| `name` | `CATALOG.snippets.Name` | Direct |
| `type` | Not in catalog | **Gap** |
| `parameters` | `DESCRIBE SNIPPET` → parse | DESCRIBE |

**Primary mxcli approach:**
```bash
# Page metadata
mxcli -p app.mpr -c "SELECT * FROM CATALOG.pages WHERE ModuleName='MyModule'"

# Page access
mxcli -p app.mpr -c "SELECT * FROM CATALOG.permissions WHERE ElementType='PAGE' AND ModuleName='MyModule'"

# Page widgets (Full mode)
mxcli -p app.mpr -c "SELECT * FROM CATALOG.widgets WHERE ModuleName='MyModule'"

# Page references (Full mode)
mxcli -p app.mpr -c "SELECT * FROM CATALOG.refs WHERE SourceType='PAGE' AND ModuleName='MyModule'"

# Full page MDL
mxcli -p app.mpr -c "DESCRIBE PAGE MyModule.Customer_Overview"
```

---

## 8. modules/\<Module\>/resources.json

### constants[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `qualifiedName` | Not in catalog (no constants table) | **Gap** |
| `name` | — | **Gap** |
| `type` | — | **Gap** |
| `defaultValue` | — | **Gap** |
| `documentation` | — | **Gap** |
| `exposedToClient` | — | **Gap** |

**Note:** Constants are not currently in the mxcli catalog. They appear in `SHOW MODULES` counts but have no dedicated table. Workaround: `DESCRIBE CONSTANT Module.Name` or add a `constants` catalog table.

### scheduledEvents[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `qualifiedName` | Not in catalog | **Gap** |
| `name` | — | **Gap** |
| `documentation` | — | **Gap** |

**Note:** Scheduled events are not in the catalog. Workaround: `SHOW MICROFLOWS` may include them if they're implemented as microflows, or add a `scheduled_events` catalog table.

### otherResources[]

| v2.0 Field | mxcli Source | Coverage |
|------------|-------------|----------|
| `qualifiedName` | `CATALOG.java_actions.QualifiedName` (for JavaActions) | Partial |
| `name` | `CATALOG.java_actions.Name` | Partial |
| `resourceType` | Derived from table source | Partial |

**Note:** Java actions are covered. Import/export mappings, message definitions, document templates, and regex are **not in the catalog**.

---

## 9. Cross-Reference Data (callEdges, navigationProvenance)

The v2.0 schema embeds cross-references directly in flow and page files. In mxcli, this data lives in the `refs` catalog table (Full mode).

| v2.0 Location | mxcli Source |
|----------------|-------------|
| `flows.json → callEdges[]` | `SELECT * FROM CATALOG.refs WHERE RefKind='call'` |
| `pages.json → clientActions[]` | `SELECT * FROM CATALOG.refs WHERE SourceType='PAGE' AND RefKind IN ('call','use')` |
| `pages.json → navigationProvenance[]` | `SELECT * FROM CATALOG.refs WHERE TargetType='PAGE'` (reverse lookup) |
| `pages.json → dataSources[].flowName` | `SELECT * FROM CATALOG.refs WHERE SourceType='PAGE' AND TargetType='MICROFLOW'` |
| `flows.json → showPageActions[].targetPage` | `SELECT * FROM CATALOG.refs WHERE SourceType='MICROFLOW' AND TargetType='PAGE'` |

---

## Gap Summary

### Fields with No Direct mxcli Equivalent

| Gap | v2.0 Fields Affected | Recommended Resolution |
|-----|---------------------|----------------------|
| **Flow graph edges** | `edges[]`, `startNodeIds`, `primaryExecutionOrderNodeIds` | Parse `DESCRIBE MICROFLOW` MDL output for control flow structure |
| **Association details** | `associations[].parentEntity`, `.childEntity`, `.cardinality`, `.type`, `.owner` | Parse `DESCRIBE ENTITY` MDL output; or add `associations` catalog table to mxcli |
| **Enum values** | `enumerations[].values` | Parse `DESCRIBE ENUMERATION` output; or add values to catalog |
| **Constants** | Entire `constants[]` array | Add `constants` catalog table to mxcli |
| **Scheduled events** | Entire `scheduledEvents[]` array | Add `scheduled_events` catalog table; or parse from microflows |
| **Non-Java resources** | Import/export mappings, document templates, regex | Add resource catalog tables; low priority |
| **Access rule details** | `defaultMemberAccessRights`, `xPathEvidence.summary` | Parse `DESCRIBE ENTITY` for defaults; generate summary from XPath |
| **Page popup properties** | `isPopup`, `popupWidth`, `popupHeight`, `popupResizable` | Parse `DESCRIBE PAGE` |
| **Page data sources** | `dataSources[].sourceType`, `.summary` | Parse `DESCRIBE PAGE` |
| **Loop ownership** | `nodes[].loopOwnerId` | Parse `DESCRIBE MICROFLOW` |
| **Source node IDs in calls** | `calls[].sourceNodeId`, `callEdges[].sourceNodeId` | Not tracked in refs table; needs DESCRIBE or catalog enhancement |

### Recommended mxcli Enhancements (for KB Builder)

Priority 1 (eliminates most DESCRIBE parsing):
1. **`associations` catalog table** — parent, child, cardinality, type, owner
2. **`constants` catalog table** — name, type, default value, documentation, exposed
3. **Add enum values to catalog** — either inline in enumerations table or separate `enumeration_values` table

Priority 2 (nice-to-have):
4. **`scheduled_events` catalog table**
5. **Export flow graph structure** — nodes + edges as catalog data or JSON export command
6. **Source node tracking in refs** — which activity made the call

Priority 3 (can work around):
7. **Page data source details** in catalog
8. **Import/export mappings** catalog table

---

## Extraction Strategy Summary

| v2.0 File | Primary mxcli Source | Fallback |
|-----------|---------------------|----------|
| `app-info.json` | Catalog aggregate queries | — |
| `user-roles.json` | `role_mappings` + `SHOW PROJECT SECURITY` | — |
| `all-modules.json` | `modules` table + aggregate counts | — |
| `marketplace-modules.json` | `modules` table filtered | — |
| `domain-model.json` | `entities` + `attributes` + `permissions` tables | `DESCRIBE ENTITY` for associations |
| `flows.json` | `microflows` + `activities` + `refs` (Full) | `DESCRIBE MICROFLOW` for edges/pseudocode |
| `pages.json` | `pages` + `widgets` + `permissions` + `refs` (Full) | `DESCRIBE PAGE` for data sources |
| `resources.json` | `java_actions` table | **Needs new catalog tables** for constants/scheduled events |
| Per-flow detail | `activities` + `refs` + `DESCRIBE MICROFLOW` | — |
| Per-page detail | `widgets` + `refs` + `DESCRIBE PAGE` | — |
