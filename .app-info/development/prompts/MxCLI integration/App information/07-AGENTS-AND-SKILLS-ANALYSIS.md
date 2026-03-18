# Agents & Skills Analysis — mxcli Impact Assessment

## Inventory Summary

The KB pipeline involves **5 app-specific agents** and **7 app-specific skills** that form the extraction → composition → routing → reading chain. This document analyses each for mxcli impact.

```
OVERVIEWSMITH ──► extraction (dump + C# parser)
       │
KNOWLEDGEBASE_CREATOR ──► orchestration
       │
OVERVIEW_KB_BUILDER ──► composition (3 skills)
       │   ├── mendix-overview-general-interpretation
       │   ├── mendix-overview-module-interpretation
       │   └── mendix-overview-routing-synthesis
       │
GAPSMITH ──► gap audit
       │
OVERVIEW_KB_READER ──► querying
```

Supporting skills:
- `mendix-model-overview-export` — export format knowledge
- `mendix-model-dump-inspection` — raw dump diff logic
- `mendix-studio-pro-10` — Studio Pro extension constraints
- `mendix-sdk` — SDK usage guidance

---

## Impact Classification

| Component | Impact Level | Phase | Summary |
|-----------|-------------|-------|---------|
| **OVERVIEWSMITH** | **Major rewrite** | 1 | Core workflow entirely based on `mx dump-mpr` + C# parser |
| **mendix-model-overview-export** | **Major rewrite** | 1 | Documents C# parser export process |
| **mendix-model-dump-inspection** | **Deprecate/Replace** | 1 | Entire skill based on `mx dump-mpr` JSON diff |
| **KNOWLEDGEBASE_CREATOR** | Moderate update | 1 | Pipeline references, validation steps |
| **GAPSMITH** | Moderate update | 1 | Gap types, parser references |
| **mendix-studio-pro-10** | Moderate update | 1 | Dump-related constraints |
| **OVERVIEW_KB_BUILDER** | Minor update | 1 | Required inputs description |
| **mendix-overview-general-interpretation** | Minor update | 1 | `.pseudo.txt` references |
| **mendix-overview-module-interpretation** | Minor update | 1 | `.pseudo.txt` references |
| **OVERVIEW_KB_READER** | **Enhancement** | 2–4 | New mxcli query escalation path |
| **mendix-overview-routing-synthesis** | No changes | — | Reads composed KB only |
| **mendix-sdk** | No changes | — | Generic SDK guidance |

---

## Detailed Analysis Per Component

### 1. OVERVIEWSMITH — Major Rewrite

**Current role:** Own the `mx dump-mpr` + C# parser lifecycle — single-dump parsing, flow execution ordering, app/module overview exports, pseudocode readability.

**Current workflow:**
1. Build one working snapshot from `mx dump-mpr`
2. Parse complete domain + flow inventory by module
3. Derive flow graph ordering from `StartEvent` and `SequenceFlow`
4. Detect flow-to-flow calls and resolve module boundaries
5. Export deterministic JSON and pseudocode artefacts
6. Keep CLI output contracts aligned with KB pipeline expectations

**Required inputs reference:**
- `MendixModelOverviewParser.cs` (C# parser implementation)
- `PARSER_LIBRARY.md` / `RULE_LIBRARY.md` (parser function/rule references)

**mxcli changes:**

Every step of the core workflow changes:

| Current Step | mxcli Replacement |
|---|---|
| Build snapshot from `mx dump-mpr` | `mxcli open <app.mpr>` → builds in-memory SQLite catalog automatically |
| Parse domain + flow inventory by module | `SELECT * FROM CATALOG.modules`, then per-module: `CATALOG.entities`, `CATALOG.attributes`, `CATALOG.microflows`, `CATALOG.pages` |
| Derive flow graph ordering | `DESCRIBE MICROFLOW <name>` produces MDL with execution flow; or activities table in Full mode |
| Detect flow-to-flow calls | `SELECT * FROM CATALOG.refs WHERE RefKind='call'` or `SHOW CALLERS/CALLEES <flow>` |
| Export JSON + pseudocode | Transform mxcli output → JSON v2.0 schema (the mapping documented in `04-SCHEMA-MAPPING.md`) |
| Keep CLI contracts aligned | Now mxcli command contracts instead of parser contracts |

**New required inputs:**
- mxcli binary path or availability check
- mxcli command reference (new skill: `mendix-mxcli`)
- Schema mapping reference (`04-SCHEMA-MAPPING.md`)

**New workflow:**
1. Open `.mpr` with mxcli (`mxcli open <app.mpr>`)
2. Query catalog tables to build module inventory
3. For each module: query entities, attributes, flows, pages, resources from catalog
4. For each flow: use `DESCRIBE MICROFLOW` for MDL / `CATALOG.activities` for activity detail
5. Build cross-references from `CATALOG.refs` + `SHOW CALLERS/CALLEES`
6. Transform all data into JSON v2.0 schema
7. Write JSON + pseudocode files to `app-overview/<run>/`

**Guardrails changes:**
- "Prefer deterministic graph logic" → still applies (mxcli catalog is deterministic)
- "Keep artefact naming stable" → still applies
- "Use additive schema changes" → still applies
- NEW: "Validate mxcli availability and version before starting"
- NEW: "Handle mxcli gaps (associations, constants, scheduled events) with fallback or explicit Unknown markers"

---

### 2. mendix-model-overview-export — Major Rewrite

**Current purpose:** Documents the C# parser export format (v2.0 structure, how exports are produced, key conventions).

**What changes:**

The "How Exports Are Produced" section (lines 36–46) is entirely parser-specific:
```
Currently:
  Exports are generated by MendixModelOverviewParser (a C# parser) that reads
  a Mendix .mpr working dump (mx dump-mpr output). The parser:
  1. Parses one working dump snapshot
  2. Builds object and resource indexes by $ID
  3. Inventories domain model, flows, pages, and resources per module
  4. Determines flow execution order using graph traversal
  5. Detects flow-to-flow calls and builds a call graph
  6. Outputs structured JSON + pseudocode per file category
```

**mxcli replacement:**
```
Exports are generated by the mxcli extraction layer that reads a Mendix .mpr
file directly. The extraction:
1. Opens the .mpr with `mxcli open` (builds in-memory SQLite catalog)
2. Queries catalog tables for module inventory
3. For each module: queries entities, attributes, flows, pages, resources
4. Uses DESCRIBE commands for flow detail and MDL representation
5. Queries refs table for call graph and cross-references
6. Transforms catalog data into JSON v2.0 schema files
```

**Export structure section:** Unchanged — same v2.0 folder structure.

**Key conventions section:**
- "Pseudocode flow ordering" → changes: mxcli's `DESCRIBE MICROFLOW` produces MDL-format text rather than graph-traversal-ordered pseudocode. Either adapt MDL to pseudocode format, or update the convention.
- "Module classification" → unchanged (Custom/System/Marketplace still derived from metadata)
- "Entity access rules" → enhanced (mxcli `xpath_expressions` table provides parsed XPath ASTs)
- "Page parameters" → unchanged

**Manifest format section:** Minor update — add `generator: "mxcli"` field to distinguish from parser-generated manifests.

---

### 3. mendix-model-dump-inspection — Deprecate or Replace

**Current purpose:** Retrieve detailed Mendix model changes from `mx dump-mpr` JSON artifacts (working vs head dump comparison).

**Why it's affected:** The entire skill is built around `mx dump-mpr` JSON artifacts:
- Step 1: Locate `workingDumpPath` and `headDumpPath`
- Step 2: Parse both dump files as JSON
- Steps 3–7: Build snapshots, compute diffs, extract details

**mxcli approach:** mxcli has a **snapshot system** that enables model comparison:
- `mxcli snapshot create` — captures current model state
- Snapshots can be diffed to find changes
- No intermediate XML dump needed

**Options:**

| Option | Description | Effort |
|---|---|---|
| **A) Deprecate** | Remove skill entirely; KB pipeline doesn't need model diffs for extraction | Low |
| **B) Replace with mxcli snapshot skill** | New skill using mxcli snapshot/diff for change detection | Medium |
| **C) Keep for backward compatibility** | Maintain for apps still using `mx dump-mpr` path | Low but creates maintenance burden |

**Recommendation:** Option A for Phase 1 (the KB extraction pipeline doesn't use model diffs — it reads the current model state). Option B can be added in Phase 3 for incremental KB updates.

The `PARSER_LIBRARY.md` and `RULE_LIBRARY.md` references become obsolete with the mxcli approach and should be archived.

---

### 4. KNOWLEDGEBASE_CREATOR — Moderate Update

**What changes:**

| Section | Current | With mxcli |
|---|---|---|
| Required Inputs #5 | "Source export run folder path" | Same — mxcli extraction still produces this folder |
| Required Inputs #7 | `run-kb-scaffold.ps1` | Same |
| Step 1: Validate | Reads `manifest.json`, confirms v2.0 | Same, but may add `generator` field check |
| Step 2: Scaffold | Runs `run-kb-scaffold.ps1` | Same |
| Step 3: Delegate | Delegates to OVERVIEW_KB_BUILDER | Same |
| Step 5: Validate | Runs scaffold + quality gate scripts | Same |
| READER.md Template | References "structured model overview export" | Update to mention mxcli extraction |

**Pipeline description** in READER.md template (line 114):
```
Currently: "built from a structured model overview export"
Update to: "built from a structured model extraction (via mxcli)"
```

**New optional step:** Before Step 1, optionally run mxcli extraction if no run folder exists:
```
Step 0 (optional): Extract
  If no run folder provided, and .mpr path given:
  Run mxcli extraction to produce app-overview/<run>/
```

---

### 5. GAPSMITH — Moderate Update

**What changes:**

**Gap type PARSER_GAP → EXTRACTION_GAP:**

The `PARSER_GAP` type (lines 86–102) is defined in terms of the C# parser:
```
Currently:
  "Use this when the understanding problem originates from missing or
   insufficient evidence in the overview export"
  - "required evidence is absent from <run>/general/*.json or <run>/modules/*/*.json"
  - "the source behaviour likely exists in the raw Mendix model, but the
     overview export does not expose it"
```

With mxcli, the gap type should be renamed to `EXTRACTION_GAP` and the definition updated:
- "required evidence is absent from the extraction output"
- "the source data exists in the .mpr model (queryable via mxcli catalog) but the extraction layer does not map it to JSON v2.0"
- NEW sub-type: `MXCLI_CATALOG_GAP` — data exists in .mpr but mxcli catalog doesn't expose it (e.g., associations, constants pre-enhancement)

**Required Inputs #10:**
```
Currently: Parser implementation (MendixModelOverviewParser.cs)
Update to: mxcli extraction script + schema mapping reference
```

**Owner Tracks:** Add new track:
```
6. `mxcli Enhancement` — gap requires mxcli catalog table or command addition
```

**Diagnostic workflow:** Step 4 changes from "inspect parser implementation only when export absence is still ambiguous" to "query mxcli catalog directly to verify data availability in the model."

---

### 6. mendix-studio-pro-10 — Moderate Update

**Current references to dump/parser:**
- "persist dumps only during explicit export" → mxcli doesn't produce dumps
- "focus Git scope on `.mpr`/`.mprops`" → unchanged
- "validate against real paths" → unchanged

**Changes:**
- Remove dump persistence constraints (mxcli reads .mpr directly)
- Add mxcli availability check (Go binary in PATH or configured location)
- Update export trigger mechanism

---

### 7. OVERVIEW_KB_BUILDER — Minor Update

**What changes:**

**Required Inputs #6:**
```
Currently: "Source export run folder (v2.0 structure)"
Same structure, but add note: "produced by mxcli extraction (or legacy C# parser)"
```

**Phase 1: Validate export artefacts:**
```
Currently: "Read manifest.json - confirm schemaVersion is 2.0"
Add: Check generator field — if "mxcli", validate v2.0 compatibility
```

**Pseudocode handling:**
The builder references `.pseudo.txt` files alongside `.json` files. If mxcli produces MDL-format text instead of pseudocode, the builder needs to understand both formats, or the extraction layer must convert MDL to pseudocode format.

---

### 8. mendix-overview-general-interpretation — Minor Update

**Required inputs (lines 14–20)** reference `.pseudo.txt` files:
```
1. <run-folder>/general/app-info.pseudo.txt + .json
2. <run-folder>/general/user-roles.pseudo.txt + .json
...
6. <run-folder>/modules/*/flows.pseudo.txt
7. <run-folder>/modules/*/domain-model.pseudo.txt
```

**If mxcli extraction produces `.pseudo.txt`:** No changes needed — the skill reads the same files.

**If mxcli extraction produces MDL instead of pseudocode:** The skill workflow step 4 (build call graph by scanning flow files) needs to parse MDL format instead of pseudocode format.

**Enhancement opportunity:** The security overview (step 3) can be richer with mxcli's `xpath_expressions` table providing parsed XPath ASTs instead of raw XPath strings.

---

### 9. mendix-overview-module-interpretation — Minor Update

Same `.pseudo.txt` dependency as the general interpretation skill.

**Enhancement opportunities with richer mxcli data:**
- Flow documentation (step 3): With `activities` table (Full mode), flow action descriptions become more precise — explicit `EntityRef`, `ActionType`, `Caption` per activity
- Page documentation (step 4): With `widgets` table (Full mode), page descriptions can include actual UI components
- Resources (step 5): If mxcli adds constants/scheduled events tables, resources become export-backed

---

### 10. OVERVIEW_KB_READER — Enhancement (Phase 2–4)

**Current design:** Read-only access to the static KB. Hard-blocked from raw data (`app-overview/`, `dumps/`) without explicit user approval. Escalation path is binary: KB answer OR ask user to approve raw data access.

**mxcli enhancement — new escalation tier:**

```
Current escalation:
  KB files → (blocked) → ask user → raw data access

Enhanced escalation:
  KB files → mxcli live query → (blocked) → ask user → full raw data access
```

**New capability: mxcli query fallback (Phase 4)**

When the KB cannot answer a question, instead of immediately asking the user for raw data access, the reader could invoke mxcli commands for a targeted, low-cost structural query:

| Question type | KB answer | mxcli fallback |
|---|---|---|
| "What's the exact XPath on Entity.AccessRule?" | KB has plain-language summary | `DESCRIBE ENTITY <name>` returns exact XPath |
| "What are all callers of this flow?" | KB has direct callers only | `SHOW CALLERS <flow> TRANSITIVE` returns full chain |
| "What changed since last KB generation?" | KB is static, can't answer | mxcli snapshot diff (if snapshots are stored) |
| "What widgets are on this page?" | KB has layout summary only | `DESCRIBE PAGE <name>` or `CATALOG.widgets` query |
| "What's the full MDL of this microflow?" | KB has pseudocode summary | `DESCRIBE MICROFLOW <name>` returns full MDL |

**New guardrail for mxcli queries:**
```
6b. MXCLI QUERY — When the KB answer is incomplete but a targeted mxcli command
    can fill the gap without full raw data traversal, the reader MAY invoke
    mxcli commands directly. This is lower cost than raw data access and does
    not require user approval. Flag the source as "mxcli-live" in the confidence
    level.
```

**New confidence level:**
```
- mxcli-live — data from a real-time mxcli query against the .mpr file.
  Treat as factual, but note it may differ from the static KB if the model
  has changed since KB generation.
```

**New example queries:**

| Question | Start file | mxcli fallback | Layer depth |
|---|---|---|---|
| "What's the full body of flow X?" | L1 overview | `DESCRIBE MICROFLOW X` | mxcli-live |
| "Who calls flow X transitively?" | `routes/by-flow.md` (direct only) | `SHOW CALLERS X TRANSITIVE` | mxcli-live |
| "What widgets are on page Y?" | L1 page overview | `SELECT * FROM CATALOG.widgets WHERE PageRef='Y'` | mxcli-live |
| "Has the model changed since KB was built?" | Cannot answer | mxcli snapshot comparison | mxcli-live |
| "What's the exact XPath constraint?" | KB has plain-language | `DESCRIBE ENTITY X` | mxcli-live |

**Output template update:**
```markdown
Confidence:
- [export-backed | inferred | mxcli-live | unknown]
```

---

### 11. mendix-overview-routing-synthesis — No Changes

This skill reads composed KB documents (`app/`, `modules/*/`), not export data. It operates entirely downstream of extraction and composition. Fully unaffected by mxcli integration.

---

### 12. mendix-sdk — No Changes

Generic SDK usage guidance unrelated to extraction pipeline.

---

## New Skill Needed: mendix-mxcli

A new app-specific skill should be created to document mxcli capabilities, commands, and catalog schema for use by multiple agents:

```
.app-info/skills/mendix-mxcli/SKILL.md
```

**Purpose:** Understanding mxcli commands, catalog tables, MDL syntax, and integration patterns for the KB pipeline.

**Used by:**
- OVERVIEWSMITH — for extraction workflow
- OVERVIEW_KB_READER — for live query fallback (Phase 4)
- GAPSMITH — for verifying data availability in the model
- KNOWLEDGEBASE_CREATOR — for optional extraction step

**Content outline:**
1. mxcli overview — Go binary, reads .mpr directly
2. Catalog system — fast mode (basic) vs full mode (activities, widgets, refs, XPath)
3. Key commands — SHOW, DESCRIBE, SEARCH, SHOW CALLERS/CALLEES/IMPACT
4. Catalog SQL — `SELECT ... FROM CATALOG.<table>` syntax
5. MDL syntax — text-based representation of Mendix model elements
6. Snapshot system — create/compare model snapshots
7. Lint & report — architectural quality analysis
8. Schema mapping — pointer to `04-SCHEMA-MAPPING.md`

---

## Pseudocode Format Decision

A critical decision affects multiple skills: **Does mxcli produce `.pseudo.txt` files?**

**Current state:** The C# parser produces both `.json` and `.pseudo.txt` for every file. Multiple skills reference `.pseudo.txt` as the "AI-readable" format.

**mxcli output:** mxcli produces MDL (Mendix Definition Language) text via `DESCRIBE` commands. MDL is structured differently from the current pseudocode format.

**Options:**

| Option | Description | Impact |
|---|---|---|
| **A) mxcli extraction converts MDL → pseudocode** | Extraction layer transforms MDL into the existing pseudocode format | Skills unchanged, extraction layer more complex |
| **B) Skills accept MDL as alternative to pseudocode** | Update skills to handle both formats | Skills updated, extraction layer simpler |
| **C) Drop pseudocode, use MDL everywhere** | Replace pseudocode with MDL | Skills rewritten, simpler long-term |
| **D) Drop pseudocode, rely on JSON only** | JSON becomes the only export format | Skills simplified, pseudocode references removed |

**Recommendation:** Option A for Phase 1 (minimum disruption), migrate to Option B in Phase 2. The extraction layer is already responsible for the transformation, so adding MDL-to-pseudocode conversion keeps all downstream skills stable.

---

## Phase Summary

### Phase 1: Drop-in Replacement
| Component | Action |
|---|---|
| OVERVIEWSMITH | Rewrite core workflow to use mxcli commands |
| mendix-model-overview-export | Rewrite "How Exports Are Produced" section |
| mendix-model-dump-inspection | Archive (not needed for extraction pipeline) |
| KNOWLEDGEBASE_CREATOR | Update pipeline references, add optional extraction step |
| GAPSMITH | Rename PARSER_GAP → EXTRACTION_GAP, add MXCLI_CATALOG_GAP |
| mendix-studio-pro-10 | Remove dump constraints, add mxcli availability |
| OVERVIEW_KB_BUILDER | Minor: note mxcli as source, validate generator field |
| mendix-overview-general-interpretation | No change if pseudocode preserved (Option A) |
| mendix-overview-module-interpretation | No change if pseudocode preserved (Option A) |
| NEW: mendix-mxcli skill | Create mxcli command/catalog reference skill |

### Phase 2: Enhanced Extraction
| Component | Action |
|---|---|
| mendix-overview-general-interpretation | Leverage richer XPath data from mxcli for SECURITY.md |
| mendix-overview-module-interpretation | Leverage activities/widgets data for richer flow/page docs |
| mendix-overview-routing-synthesis | No changes |
| GAPSMITH | Update diagnostic checks to query mxcli catalog |

### Phase 3: Extended KB Sections
| Component | Action |
|---|---|
| mendix-overview-module-interpretation | New output files: WORKFLOWS.md, INTEGRATIONS.md, WIDGETS.md |
| mendix-overview-routing-synthesis | New route files: by-workflow.md, by-integration.md |
| OVERVIEW_KB_BUILDER | Add new skills or extend existing ones for new sections |

### Phase 4: Live Copilot Enhancement
| Component | Action |
|---|---|
| OVERVIEW_KB_READER | Add mxcli query fallback with `mxcli-live` confidence level |
| NEW: mendix-mxcli skill | Add query patterns for reader use |
