# mxcli Catalog Schema & Output Formats

> Source: `mxcli/mdl/catalog/tables.go` — SQLite catalog table definitions
> Source: `mxcli/mdl/catalog/builder.go` — catalog population from MPR
> Source: `mxcli/mdl/executor/` — command execution and output formatting

## Overview

mxcli builds an in-memory SQLite catalog from the `.mpr` file. This catalog contains structured metadata across 20+ tables, queryable via SQL (`SELECT ... FROM CATALOG.<table>`), and exposed through MDL commands (`SHOW`, `DESCRIBE`, `SEARCH`).

Two catalog modes:
- **Fast mode** (default): modules, entities, attributes, microflows, pages, snippets, layouts, enumerations, java_actions, odata_clients, odata_services, workflows, business_event_services, navigation_profiles, navigation_menu_items, navigation_role_homes, database_connections, role_mappings, permissions
- **Full mode** (`REFRESH CATALOG FULL`): adds activities, widgets, xpath_expressions, refs, strings (FTS), source (FTS)

---

## Catalog Tables

### Core Metadata Tables

#### projects
| Column | Type | Notes |
|--------|------|-------|
| ProjectId | TEXT PK | |
| ProjectName | TEXT | |
| MendixVersion | TEXT | |
| CreatedDate | TEXT | |
| LastSnapshotDate | TEXT | |
| SnapshotCount | INTEGER | |

#### snapshots
| Column | Type | Notes |
|--------|------|-------|
| SnapshotId | TEXT PK | |
| SnapshotName | TEXT | |
| ProjectId | TEXT | FK → projects |
| ProjectName | TEXT | |
| SnapshotDate | TEXT | |
| SnapshotSource | TEXT | |
| SourceId | TEXT | |
| SourceBranch | TEXT | |
| SourceRevision | TEXT | |
| ObjectCount | INTEGER | |
| IsActive | INTEGER | 0/1 |

---

### Domain Model Tables

#### modules
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | UUID |
| Name | TEXT | Local name |
| QualifiedName | TEXT | Same as Name for modules |
| ModuleName | TEXT | Same as Name |
| Folder | TEXT | Folder path within module |
| Description | TEXT | |
| IsSystemModule | INTEGER | 0/1 — distinguishes Custom vs System/Marketplace |
| AppStoreVersion | TEXT | Marketplace module version |
| AppStoreGuid | TEXT | Marketplace GUID |
| ProjectId | TEXT | |
| ProjectName | TEXT | |
| SnapshotId | TEXT | |
| SnapshotDate | TEXT | |
| SnapshotSource | TEXT | |
| SourceId | TEXT | |
| SourceBranch | TEXT | |
| SourceRevision | TEXT | |

#### entities
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | UUID |
| Name | TEXT | Local name |
| QualifiedName | TEXT | Module.EntityName |
| ModuleName | TEXT | |
| Folder | TEXT | |
| EntityType | TEXT | "Persistent", "Non-Persistent", "View", "External", "System" |
| Description | TEXT | |
| Generalization | TEXT | Parent entity qualified name |
| AttributeCount | INTEGER | |
| AssociationCount | INTEGER | |
| AccessRuleCount | INTEGER | |
| ValidationRuleCount | INTEGER | |
| HasEventHandlers | INTEGER | 0/1 |
| IsExternal | INTEGER | 0/1 |
| ExternalService | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### attributes
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | Attribute name |
| EntityId | TEXT | FK → entities |
| EntityQualifiedName | TEXT | |
| ModuleName | TEXT | |
| DataType | TEXT | "String", "Integer", "Long", "Decimal", "DateTime", "Boolean", "Enumeration", "AutoNumber", "Binary", "HashString" |
| Length | INTEGER | String max length |
| IsUnique | INTEGER | 0/1 |
| IsRequired | INTEGER | 0/1 |
| DefaultValue | TEXT | |
| IsCalculated | INTEGER | 0/1 |
| Description | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### enumerations
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Description | TEXT | |
| ValueCount | INTEGER | Number of enum values |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

---

### Behavioral Tables

#### microflows
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| MicroflowType | TEXT | "MICROFLOW" or "NANOFLOW" |
| Description | TEXT | |
| ReturnType | TEXT | Return type string |
| ParameterCount | INTEGER | |
| ActivityCount | INTEGER | |
| Complexity | INTEGER | Cyclomatic complexity |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

**View:** `nanoflows` — `SELECT * FROM microflows WHERE MicroflowType = 'NANOFLOW'`

#### activities (Full mode only)
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| Caption | TEXT | Activity label |
| ActivityType | TEXT | e.g., "CreateObjectAction", "RetrieveAction", "ExclusiveSplit", "ShowFormAction", etc. |
| Sequence | INTEGER | Execution order |
| MicroflowId | TEXT | FK → microflows |
| MicroflowQualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| EntityRef | TEXT | Referenced entity |
| ActionType | TEXT | |
| Description | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### pages
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Title | TEXT | Display title |
| URL | TEXT | Custom URL |
| LayoutRef | TEXT | Layout reference |
| Description | TEXT | |
| ParameterCount | INTEGER | |
| WidgetCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### snippets
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Description | TEXT | |
| ParameterCount | INTEGER | |
| WidgetCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### layouts
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| LayoutType | TEXT | |
| Description | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### widgets (Full mode only)
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| WidgetType | TEXT | e.g., "TextBox", "DataGrid2", "DataView" |
| ContainerId | TEXT | Parent page/snippet ID |
| ContainerQualifiedName | TEXT | |
| ContainerType | TEXT | "PAGE" or "SNIPPET" |
| ModuleName | TEXT | |
| Folder | TEXT | |
| EntityRef | TEXT | Bound entity |
| AttributeRef | TEXT | Bound attribute |
| Description | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### workflows
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Description | TEXT | |
| ExportLevel | TEXT | |
| ParameterEntity | TEXT | Context entity |
| ActivityCount | INTEGER | |
| UserTaskCount | INTEGER | |
| MicroflowCallCount | INTEGER | |
| DecisionCount | INTEGER | |
| DueDate | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

---

### Security & Navigation Tables

#### permissions
| Column | Type | Notes |
|--------|------|-------|
| Id | INTEGER PK | Auto-increment |
| ModuleRoleName | TEXT | |
| ElementType | TEXT | "ENTITY", "MICROFLOW", "PAGE", etc. |
| ElementName | TEXT | Qualified name |
| MemberName | TEXT | Attribute/association name (for entity member access) |
| AccessType | TEXT | "Create", "Delete", "Read", "ReadWrite", "None" |
| XPathConstraint | TEXT | Row-level security |
| ModuleName | TEXT | |
| ProjectId | TEXT | |
| SnapshotId | TEXT | |

#### role_mappings
| Column | Type | Notes |
|--------|------|-------|
| Id | INTEGER PK | Auto-increment |
| UserRoleName | TEXT | |
| ModuleRoleName | TEXT | |
| ModuleName | TEXT | |
| ProjectId | TEXT | |
| SnapshotId | TEXT | |

#### navigation_profiles
| Column | Type | Notes |
|--------|------|-------|
| ProfileName | TEXT PK | |
| Kind | TEXT | |
| IsNative | INTEGER | 0/1 |
| HomePage | TEXT | |
| HomePageType | TEXT | |
| LoginPage | TEXT | |
| NotFoundPage | TEXT | |
| MenuItemCount | INTEGER | |
| RoleBasedHomeCount | INTEGER | |
| OfflineEntityCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### navigation_menu_items
| Column | Type | Notes |
|--------|------|-------|
| Id | INTEGER PK | Auto-increment |
| ProfileName | TEXT | FK → navigation_profiles |
| ItemPath | TEXT | Hierarchical path |
| Depth | INTEGER | Nesting level |
| Caption | TEXT | |
| ActionType | TEXT | |
| TargetPage | TEXT | |
| TargetMicroflow | TEXT | |
| SubItemCount | INTEGER | |
| ProjectId | TEXT | |
| SnapshotId | TEXT | |

#### navigation_role_homes
| Column | Type | Notes |
|--------|------|-------|
| Id | INTEGER PK | Auto-increment |
| ProfileName | TEXT | |
| UserRole | TEXT | |
| Page | TEXT | |
| Microflow | TEXT | |
| ProjectId | TEXT | |
| SnapshotId | TEXT | |

---

### Integration Tables

#### java_actions
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Documentation | TEXT | |
| ExportLevel | TEXT | |
| ReturnType | TEXT | |
| ParameterCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### odata_clients
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Version | TEXT | |
| ODataVersion | TEXT | |
| MetadataUrl | TEXT | |
| Validated | INTEGER | 0/1 |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### odata_services
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Path | TEXT | Service path |
| Version | TEXT | |
| ODataVersion | TEXT | |
| EntitySetCount | INTEGER | |
| AuthenticationTypes | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### business_event_services
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Documentation | TEXT | |
| ServiceName | TEXT | |
| EventNamePrefix | TEXT | |
| MessageCount | INTEGER | |
| PublishCount | INTEGER | |
| SubscribeCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

#### database_connections
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| Name | TEXT | |
| QualifiedName | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| DatabaseType | TEXT | |
| QueryCount | INTEGER | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

---

### Cross-Reference Tables (Full mode only)

#### refs
| Column | Type | Notes |
|--------|------|-------|
| Id | INTEGER PK | Auto-increment |
| SourceType | TEXT | "MICROFLOW", "PAGE", "ENTITY", etc. |
| SourceId | TEXT | |
| SourceName | TEXT | Qualified name |
| TargetType | TEXT | "MICROFLOW", "PAGE", "ENTITY", etc. |
| TargetId | TEXT | |
| TargetName | TEXT | Qualified name |
| RefKind | TEXT | "call", "use", "reference", "contains" |
| ModuleName | TEXT | |
| ProjectId | TEXT | |
| SnapshotId | TEXT | |

#### xpath_expressions
| Column | Type | Notes |
|--------|------|-------|
| Id | TEXT PK | |
| DocumentType | TEXT | "MICROFLOW", "PAGE", etc. |
| DocumentId | TEXT | |
| DocumentQualifiedName | TEXT | |
| ComponentType | TEXT | |
| ComponentId | TEXT | |
| ComponentName | TEXT | |
| XPathExpression | TEXT | Raw XPath string |
| XPathAST | TEXT | Parsed AST |
| TargetEntity | TEXT | |
| ReferencedEntities | TEXT | Comma-separated list |
| IsParameterized | INTEGER | 0/1 |
| UsageType | TEXT | |
| ModuleName | TEXT | |
| Folder | TEXT | |
| Description | TEXT | |
| ProjectId–SourceRevision | TEXT | (standard tracking columns) |

---

### Full-Text Search Tables (Full mode only)

#### strings (FTS5)
| Column | Type | Notes |
|--------|------|-------|
| QualifiedName | TEXT | Owning element |
| ObjectType | TEXT | |
| StringValue | TEXT | The searchable string |
| StringContext | TEXT | Where the string appears (e.g., "caption", "message") |
| ModuleName | TEXT | |

#### source (FTS5)
| Column | Type | Notes |
|--------|------|-------|
| QualifiedName | TEXT | |
| ObjectType | TEXT | |
| SourceText | TEXT | MDL source representation |
| ModuleName | TEXT | |

---

### Unified View

#### objects (VIEW)
Union of all primary tables (modules, entities, microflows, pages, snippets, layouts, enumerations, java_actions, odata_clients, odata_services, workflows, business_event_services, database_connections) with normalized columns:

| Column | Type |
|--------|------|
| Id | TEXT |
| ObjectType | TEXT — "MODULE", "ENTITY", "MICROFLOW", "NANOFLOW", "PAGE", "SNIPPET", "LAYOUT", "ENUMERATION", "JAVA_ACTION", "ODATA_CLIENT", "ODATA_SERVICE", "WORKFLOW", "BUSINESS_EVENT_SERVICE", "DATABASE_CONNECTION" |
| Name | TEXT |
| QualifiedName | TEXT |
| ModuleName | TEXT |
| Folder | TEXT |
| Description | TEXT |
| ProjectId | TEXT |
| ProjectName | TEXT |
| SnapshotId | TEXT |
| SnapshotDate | TEXT |
| SnapshotSource | TEXT |

---

## Command Output Formats

### SHOW Commands

| Command | Output | Format |
|---------|--------|--------|
| `SHOW MODULES` | Module summary table | Markdown table: Module, Source, Entities, Enums, Pages, Snippets, Microflows, Nanoflows, Workflows, Constants, JavaActions, ... |
| `SHOW ENTITIES [IN Module]` | Entity list | Markdown table: Entity, Type, Extends, Attrs, Assocs, Validations, Indexes, Events, AccessRules |
| `SHOW MICROFLOWS [IN Module]` | Microflow list | Catalog query result from microflows table |
| `SHOW PAGES [IN Module]` | Page list | Catalog query result from pages table |
| `SHOW STRUCTURE DEPTH n [IN Module] [ALL]` | Hierarchical overview | Text format, 3 depth levels |
| `SHOW CALLERS OF X [TRANSITIVE]` | Caller chain | Table: Caller, Depth |
| `SHOW CALLEES OF X [TRANSITIVE]` | Callee chain | Table: Callee, Depth |
| `SHOW REFERENCES OF X` | All references | Table: SourceType, SourceName, RefKind |
| `SHOW IMPACT OF X` | Impact analysis | Summary + table |
| `SHOW PROJECT SECURITY` | Security overview | Key-value text |
| `SHOW SECURITY MATRIX [IN Module]` | Full access matrix | Table |
| `SHOW WIDGETS [IN Module]` | Widget inventory | Table from widgets catalog |

### DESCRIBE Commands

All produce **MDL text output** (human-readable, round-trippable to MDL syntax):
- `DESCRIBE ENTITY Module.Name` — full entity with attributes, associations, access rules
- `DESCRIBE MICROFLOW Module.Name` — signature, parameters, return type, activities
- `DESCRIBE PAGE Module.Name` — layout, parameters, widget tree
- `DESCRIBE ENUMERATION Module.Name` — values
- `DESCRIBE NAVIGATION [Profile]` — navigation structure
- `DESCRIBE SETTINGS` — project settings

### SEARCH Command

```bash
mxcli search -p app.mpr "keyword" --format json
```

Output formats: `table` (default), `names`, `json`

**JSON format:**
```json
[
  {
    "qualifiedName": "Module.Element",
    "objectType": "MICROFLOW",
    "match": "matched text snippet",
    "stringContext": "caption",
    "moduleName": "Module",
    "source": "strings"
  }
]
```

### Lint Command

```bash
mxcli lint -p app.mpr --format json
```

Output formats: `text` (default), `json`, `sarif`

**JSON format:**
```json
{
  "violations": [
    {
      "ruleId": "MDL001",
      "severity": "error",
      "message": "...",
      "module": "ModuleName",
      "document": "DocumentName",
      "documentType": "ENTITY",
      "documentId": "...",
      "suggestion": "..."
    }
  ],
  "summary": {
    "total": 5,
    "errors": 2,
    "warnings": 2,
    "infos": 1,
    "hints": 0
  }
}
```

### Report Command

```bash
mxcli report -p app.mpr --format json
```

Output formats: `markdown` (default), `json`, `html`

**JSON format:**
```json
{
  "projectName": "...",
  "date": "2026-03-18",
  "overallScore": 75.5,
  "summary": { "total": 12, "errors": 2, "warnings": 5, "infos": 5 },
  "categories": [
    {
      "name": "Security",
      "score": 85.0,
      "errors": 1,
      "warnings": 2,
      "infos": 0,
      "topActions": ["..."]
    }
  ],
  "violations": [...]
}
```

### Catalog SQL Queries

```mdl
SELECT Name, QualifiedName, EntityType, AttributeCount FROM CATALOG.entities WHERE ModuleName = 'MyModule'
```

Output: Pipe-delimited markdown table (auto-width, max 50 chars per column).

All catalog queries support `WHERE`, `ORDER BY`, `LIMIT`, `GROUP BY`, aggregate functions (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`).
