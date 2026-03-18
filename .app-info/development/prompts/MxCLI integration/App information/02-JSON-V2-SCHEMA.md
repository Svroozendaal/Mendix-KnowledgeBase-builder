# JSON v2.0 Schema — Current Parser Output Reference

> Source: `KnowledgeBase-Creator/Mendix-model-overview-parser/src/mendix-model-overview-parser/MendixModelOverviewParser.cs` (lines 3597–3845)
> Serialization: `System.Text.Json`, `JsonNamingPolicy.CamelCase`, `WriteIndented = true`, UTF-8 without BOM

## File Tree

```
app-overview/<run-id>/
├── manifest.json
├── general/
│   ├── app-info.json           + .pseudo.txt
│   ├── user-roles.json         + .pseudo.txt
│   ├── all-modules.json        + .pseudo.txt
│   └── marketplace-modules.json + .pseudo.txt
└── modules/
    ├── <ModuleName>/
    │   ├── domain-model.json   + .pseudo.txt
    │   ├── flows.json          + .pseudo.txt
    │   ├── flows/
    │   │   ├── INDEX.json
    │   │   └── <slug>.json     (per-flow detail)
    │   ├── pages.json          + .pseudo.txt
    │   ├── pages/
    │   │   ├── INDEX.json
    │   │   └── <slug>.json     (per-page detail)
    │   └── resources.json      + .pseudo.txt
    └── marketplace/
        └── <ModuleName>/       (same structure, shallow)
```

---

## 1. manifest.json

```jsonc
{
  "schemaVersion": "2.0",                          // string, always "2.0"
  "generatedAtUtc": "2025-03-18T12:00:00.0000000Z", // ISO 8601
  "selectedModules": ["Module1", "Module2"],        // string[] (empty if all)
  "artifactCount": 42,                              // int
  "artifacts": [                                    // ManifestEntry[]
    {
      "type": "general-app-info-json",              // artifact type tag
      "path": "/absolute/path/to/file.json"         // absolute path on disk
    }
    // ...
  ]
}
```

**Artifact type tags:** `general-app-info-json`, `general-app-info-pseudo`, `general-user-roles-json`, `general-user-roles-pseudo`, `general-all-modules-json`, `general-all-modules-pseudo`, `general-marketplace-modules-json`, `general-marketplace-modules-pseudo`, `module-domain-model-json`, `module-domain-model-pseudo`, `module-flows-json`, `module-flows-pseudo`, `module-flow-detail-json`, `module-flow-collection-index-json`, `module-pages-json`, `module-pages-pseudo`, `module-page-detail-json`, `module-page-collection-index-json`, `module-resources-json`, `module-resources-pseudo`

---

## 2. general/app-info.json

```jsonc
{
  "schemaVersion": "2.0",                    // string
  "generatedAtUtc": "...",                   // ISO 8601
  "sourceMprPath": "C:/path/to/app.mpr",    // string
  "sourceDumpPath": "C:/path/to/dump.json",  // string
  "summary": {                               // OverviewSummary
    "moduleCount": 12,                       // int
    "entityCount": 45,                       // int
    "associationCount": 23,                  // int
    "enumerationCount": 8,                   // int
    "flowCount": 156,                        // int
    "microflowCount": 140,                   // int
    "nanoflowCount": 16,                     // int
    "ruleCount": 0,                          // int
    "workflowCount": 0,                      // int
    "flowNodeCount": 1234,                   // int
    "flowEdgeCount": 980,                    // int
    "flowCallEdgeCount": 87                  // int
  }
}
```

---

## 3. general/user-roles.json

```jsonc
{
  "projectSecurity": {                         // OverviewProjectSecurity | null
    "securityLevel": "Production",             // string | null
    "adminUserName": "MxAdmin",                // string | null
    "enableGuestAccess": false,                // bool
    "guestUserRoleName": null,                 // string | null
    "userRoles": [                             // OverviewUserRole[]
      {
        "name": "Administrator",               // string
        "moduleRoles": ["Module1.Admin"],       // string[]
        "manageAllRoles": true,                // bool
        "checkSecurity": true                  // bool
      }
    ]
  }
}
```

---

## 4. general/all-modules.json

```jsonc
{
  "modules": [                            // ModuleSummary[]
    {
      "module": "MyModule",               // string — module name
      "category": "Custom",              // string | null — "Custom", "Marketplace", "System"
      "fromAppStore": false,             // bool
      "moduleRoles": [                   // OverviewModuleRole[]
        {
          "name": "User",                // string
          "description": "Regular user"  // string | null
        }
      ],
      "entityCount": 5,                  // int
      "flowCount": 12,                   // int
      "pageCount": 8,                    // int
      "constantCount": 3                 // int
    }
  ]
}
```

---

## 5. general/marketplace-modules.json

```jsonc
{
  "modules": [                            // MarketplaceModuleSummary[]
    {
      "module": "Atlas_Core",             // string
      "moduleRoles": [],                  // OverviewModuleRole[]
      "entityCount": 2,                   // int
      "flowCount": 5,                     // int
      "pageCount": 3                      // int
    }
  ]
}
```

---

## 6. modules/\<Module\>/domain-model.json

```jsonc
{
  "module": "MyModule",                   // string
  "domainModel": {                        // OverviewDomainModel
    "entities": [                         // OverviewEntity[]
      {
        "name": "Customer",              // string — local name (not qualified)
        "isPersistable": true,           // bool
        "generalization": null,          // string | null — parent entity qualified name
        "attributes": [                  // OverviewAttribute[]
          {
            "name": "FullName",          // string
            "type": "String",            // string | null — "String","Integer","Long","Decimal","DateTime","Boolean","Enumeration","AutoNumber","Binary","HashString"
            "enumerationName": null,     // string | null — qualified enum name if type is "Enumeration"
            "length": 200,               // int | null — string max length
            "defaultValue": null,        // string | null
            "validationSummary": null    // string | null
          }
        ],
        "accessRules": [                 // OverviewAccessRule[]
          {
            "ruleKey": "User_ReadWrite", // string — stable identifier
            "moduleRoles": ["User"],     // string[] — role names
            "allowCreate": true,         // bool
            "allowDelete": false,        // bool
            "defaultMemberAccessRights": "ReadWrite", // string | null
            "xPathConstraint": "[Active = true()]",   // string | null — raw XPath
            "xPathEvidence": {           // OverviewXPathEvidence | null
              "constraint": "[Active = true()]", // string
              "summary": "Only active records"   // string
            },
            "memberAccesses": [          // OverviewMemberAccess[]
              {
                "memberName": "FullName",   // string
                "memberKind": "Attribute",  // "Attribute" | "Association"
                "accessRights": "ReadWrite" // string | null — "ReadOnly","ReadWrite","None"
              }
            ]
          }
        ]
      }
    ],
    "associations": [                    // OverviewAssociation[]
      {
        "name": "Customer_Order",        // string — association name
        "parentEntity": "Customer",      // string — owner side
        "childEntity": "Order",          // string — other side
        "cardinality": "[1..*]",         // string — "[1]","[0..1]","[*]","[1..*]"
        "type": null,                    // string | null — "Reference","ReferenceSet"
        "owner": "Default",             // string | null — "Default","Both"
        "storageFormat": null           // string | null
      }
    ],
    "enumerations": [                    // OverviewEnumeration[]
      {
        "name": "OrderStatus",           // string — local name
        "values": ["Draft", "Active", "Closed"] // string[]
      }
    ]
  }
}
```

---

## 7. modules/\<Module\>/flows.json (aggregate)

```jsonc
{
  "module": "MyModule",                   // string
  "flows": [                              // OverviewFlow[]
    {
      "flowId": "a1b2c3d4-...",          // string — stable UUID
      "kind": "Microflow",              // "Microflow" | "Nanoflow" | "Rule" | "Workflow"
      "qualifiedName": "MyModule.ACT_Process", // string
      "module": "MyModule",              // string
      "nodes": [                         // OverviewFlowNode[]
        {
          "nodeId": "node-001",          // string
          "nodeType": "StartEvent",      // string — "StartEvent","EndEvent","ActionActivity","ExclusiveSplit","InheritanceSplit","MergeNode","LoopedActivity","BreakEvent","ContinueEvent","ErrorEvent","Annotation"
          "label": "Start",              // string
          "detail": null,                // string | null — activity detail text
          "loopOwnerId": null,           // string | null — parent loop node ID
          "isExecutable": true,          // bool
          "calls": [                     // OverviewFlowCall[] — calls from this node
            {
              "callKind": "MicroflowCall",      // string
              "targetFlowName": "Mod.SUB_X",    // string — qualified name of target
              "sourceNodeId": "node-001"         // string
            }
          ]
        }
      ],
      "edges": [                         // OverviewFlowEdge[]
        {
          "edgeId": "edge-001",          // string
          "originNodeId": "node-001",    // string
          "destinationNodeId": "node-002", // string
          "condition": null,             // string | null — branch condition
          "isErrorHandler": false,       // bool
          "originConnectionIndex": 0,    // int | null
          "destinationConnectionIndex": 0 // int | null
        }
      ],
      "calls": [                         // OverviewFlowCall[] — all calls in flow
        {
          "callKind": "MicroflowCall",   // string — "MicroflowCall","NanoflowCall","JavaActionCall","RestCall","WebServiceCall"
          "targetFlowName": "Mod.SUB_X", // string
          "sourceNodeId": "node-003"     // string
        }
      ],
      "startNodeIds": ["node-001"],      // string[]
      "primaryExecutionOrderNodeIds": ["node-001","node-002","node-003"], // string[] — topological order
      "pseudocode": "// pseudocode...",  // string — human-readable pseudocode
      "retrieveActions": [               // OverviewFlowRetrieveAction[]
        {
          "nodeId": "node-010",          // string
          "summary": "Retrieve Customer from DB", // string
          "sourceKind": "Database",      // string — "Database","Association","Microflow"
          "entity": "MyModule.Customer", // string | null
          "association": null,           // string | null
          "xpath": "[Name != empty]"     // string | null
        }
      ],
      "decisionActions": [               // OverviewFlowDecisionAction[]
        {
          "nodeId": "node-020",          // string
          "summary": "Check active",     // string
          "caption": "Is Active?",       // string
          "expression": "$Customer/Active" // string
        }
      ],
      "showPageActions": [               // OverviewFlowShowPageAction[]
        {
          "nodeId": "node-030",          // string
          "summary": "Show details page", // string
          "targetPage": "MyModule.Customer_Detail" // string
        }
      ],
      "mutationActions": [               // OverviewFlowMutationAction[]
        {
          "nodeId": "node-040",          // string
          "actionKind": "Create",        // "Create" | "Update" | "Delete"
          "summary": "Create new order", // string
          "entity": "MyModule.Order",    // string | null
          "memberSummary": "Set Status='Draft', Customer=$Customer" // string | null
        }
      ]
    }
  ],
  "callEdges": [                         // OverviewCallEdge[] — cross-module call graph
    {
      "callerModule": "MyModule",        // string
      "callerFlow": "MyModule.ACT_Process", // string
      "callerKind": "Microflow",         // string
      "callKind": "MicroflowCall",       // string
      "sourceNodeId": "node-003",        // string
      "targetModule": "OtherModule",     // string
      "targetFlow": "OtherModule.SUB_Helper", // string
      "isInternal": false                // bool — true if caller and target are same module
    }
  ]
}
```

---

## 8. modules/\<Module\>/flows/\<slug\>.json (per-flow detail)

```jsonc
{
  "_meta": {                                  // Navigation metadata
    "objectType": "flow",                     // string
    "module": "MyModule",                     // string
    "qualifiedName": "MyModule.ACT_Process",  // string
    "stableId": "a1b2c3d4-...",              // string
    "slug": "act-process",                   // string — URL-safe identifier
    "l0Path": "knowledge-base/modules/MyModule/flows/act-process.abstract.md",
    "l1Path": "knowledge-base/modules/MyModule/flows/act-process.overview.md",
    "l2Path": "app-overview/current/modules/MyModule/flows/act-process.json",
    "l2Logical": "flow:MyModule.ACT_Process",
    "sourceRun": "run-20250318-120000",
    "aggregateJson": "app-overview/run-20250318-120000/modules/MyModule/flows.json",
    "aggregatePseudo": "app-overview/run-20250318-120000/modules/MyModule/flows.pseudo.txt",
    "collectionIndex": "app-overview/current/modules/MyModule/flows/INDEX.json"
  },
  // ... same fields as OverviewFlow in flows.json (flowId, kind, nodes, edges, etc.)
}
```

---

## 9. modules/\<Module\>/flows/INDEX.json

```jsonc
{
  "objectType": "flow-collection",
  "module": "MyModule",
  "sourceRun": "run-20250318-120000",
  "l0Path": "knowledge-base/modules/MyModule/flows/INDEX.abstract.md",
  "l1Path": "knowledge-base/modules/MyModule/FLOWS.md",
  "l2Path": "app-overview/current/modules/MyModule/flows/INDEX.json",
  "items": [                                 // FlowIndexItem[]
    {
      "objectType": "flow",
      "qualifiedName": "MyModule.ACT_Process",
      "stableId": "a1b2c3d4-...",
      "slug": "act-process",
      "kind": "Microflow",
      "nodeCount": 15,
      "l0Path": "...",
      "l1Path": "...",
      "l2Path": "...",
      "l2Logical": "flow:MyModule.ACT_Process",
      "sourceRun": "run-20250318-120000"
    }
  ]
}
```

---

## 10. modules/\<Module\>/pages.json (aggregate)

```jsonc
{
  "module": "MyModule",                       // string
  "pages": [                                  // OverviewPage[]
    {
      "qualifiedName": "MyModule.Customer_Overview", // string
      "name": "Customer_Overview",            // string — local name
      "title": "Customer Overview",           // string | null — display title
      "layout": "Atlas_Default",              // string | null — layout reference
      "allowedRoles": ["User", "Admin"],      // string[] — allowed module roles
      "parameters": [                         // OverviewPageParameter[]
        {
          "name": "Customer",                 // string
          "entityType": "MyModule.Customer"   // string | null
        }
      ],
      "isPopup": false,                       // bool
      "popupWidth": 0,                        // int
      "popupHeight": 0,                       // int
      "popupResizable": false,                // bool
      "url": "/customers",                    // string | null
      "excluded": false,                      // bool
      "dataSources": [                        // OverviewPageDataSource[]
        {
          "sourceId": "ds-001",               // string
          "sourceType": "Database",           // string — "Database","Microflow","Association","Nanoflow","XPath"
          "summary": "Retrieve active customers", // string
          "entity": "MyModule.Customer",      // string | null
          "constraint": "[Active = true()]",  // string | null — XPath
          "flowName": null                    // string | null — microflow/nanoflow source
        }
      ],
      "clientActions": [                      // OverviewPageClientAction[]
        {
          "actionId": "ca-001",               // string
          "actionType": "CallMicroflow",      // string — "ShowPage","CallMicroflow","CallNanoflow","CloseForm","SignOut","DeleteObject","SaveChanges","CancelChanges"
          "summary": "Call process microflow", // string
          "targetPage": null,                 // string | null
          "flowName": "MyModule.ACT_Process"  // string | null
        }
      ],
      "navigationProvenance": [               // OverviewPageNavigationProvenance[]
        {
          "provenanceId": "prov-001",         // string
          "sourceType": "Microflow",          // string — "Microflow","Navigation","Page"
          "summary": "Shown by ACT_Main",     // string
          "page": null,                       // string | null
          "userRole": null,                   // string | null
          "flowName": "MyModule.ACT_Main"     // string | null
        }
      ]
    }
  ],
  "snippets": [                               // OverviewSnippet[]
    {
      "qualifiedName": "MyModule.CustomerCard", // string
      "name": "CustomerCard",                // string
      "type": null,                           // string | null
      "parameters": []                        // OverviewPageParameter[]
    }
  ]
}
```

---

## 11. modules/\<Module\>/pages/\<slug\>.json and INDEX.json

Same `_meta` + detail structure as flows (see sections 8 and 9). Page detail includes all OverviewPage fields plus `_meta` navigation block.

---

## 12. modules/\<Module\>/resources.json

```jsonc
{
  "module": "MyModule",                       // string
  "constants": [                              // OverviewConstant[]
    {
      "qualifiedName": "MyModule.API_KEY",    // string
      "name": "API_KEY",                      // string
      "type": "String",                       // string | null
      "defaultValue": "changeme",             // string | null
      "documentation": "External API key",    // string | null
      "exposedToClient": false                // bool
    }
  ],
  "scheduledEvents": [                        // OverviewScheduledEvent[]
    {
      "qualifiedName": "MyModule.SE_DailyCleanup", // string
      "name": "SE_DailyCleanup",             // string
      "documentation": "Runs every night"    // string | null
    }
  ],
  "otherResources": [                         // OverviewResource[]
    {
      "qualifiedName": "MyModule.JA_Export",  // string
      "name": "JA_Export",                    // string
      "resourceType": "JavaAction"            // string — "JavaAction","ImportMapping","ExportMapping","MessageDefinition","DocumentTemplate","Regex","Rule"
    }
  ]
}
```

---

## Pseudocode Files (.pseudo.txt)

Each JSON file has a companion `.pseudo.txt` file containing a human-readable pseudocode representation of the same data. These are generated by dedicated methods in `MendixModelOverviewParser`:

- `BuildAppInfoPseudocode()`
- `BuildUserRolesPseudocode()`
- `BuildAllModulesOverviewPseudocode()`
- `BuildMarketplaceModulesPseudocode()`
- `BuildDomainModelPseudocode()`
- `BuildFlowsPseudocode()`
- `BuildPagesPseudocode()`
- `BuildResourcesPseudocode()`

The pseudocode files serve as a secondary L2 source for AI consumption — easier to parse than JSON for narrative generation.

---

## Data Type Reference

| C# Type | JSON Type | Notes |
|---------|-----------|-------|
| `string` | `"string"` | Never null unless marked `?` |
| `string?` | `"string" \| null` | Nullable |
| `int` | `number` | Integer |
| `int?` | `number \| null` | Nullable integer |
| `bool` | `true \| false` | |
| `DateTimeOffset` | `"string"` | ISO 8601 format |
| `IReadOnlyList<T>` | `T[]` | Always array, never null (empty = `[]`) |

## Serialization Rules

- **Naming**: `JsonNamingPolicy.CamelCase` — all property names are camelCase in JSON
- **Indentation**: `WriteIndented = true` — pretty-printed
- **Encoding**: UTF-8 without BOM
- **Nulls**: Included in output (not omitted)
