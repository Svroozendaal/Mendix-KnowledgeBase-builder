# MxCLI Integration — Overview

## Purpose

Replace the current KB extraction pipeline (`mx dump-mpr` → C# parser → JSON v2.0) with **mxcli** as the single extraction layer, while **preserving the static KB + enrichment model** that makes the knowledge base valuable.

## Current Architecture

```
.mpr file
  │
  ▼
mx dump-mpr ──────────► Raw XML dump (mendix-data/dumps/)
  │
  ▼
C# Parser ────────────► Structured JSON v2.0 (mendix-data/app-overview/)
  │                       ├── manifest.json
  │                       ├── general/
  │                       │   ├── app-info.json
  │                       │   ├── user-roles.json
  │                       │   ├── all-modules.json
  │                       │   └── marketplace-modules.json
  │                       └── modules/<Module>/
  │                           ├── domain-model.json
  │                           ├── flows.json + flows/<slug>.json
  │                           ├── pages.json + pages/<slug>.json
  │                           └── resources.json
  │
  ▼
PowerShell Composer ──► Markdown KB (mendix-data/knowledge-base/)
  │                       ├── READER.md, ROUTING.md
  │                       ├── app/ (APP_OVERVIEW, SECURITY, CALL_GRAPH)
  │                       ├── modules/<Module>/ (README, DOMAIN, FLOWS, PAGES, RESOURCES)
  │                       ├── routes/ (by-entity, by-flow, by-page, cross-module)
  │                       └── _reports/ (quality, benchmarks)
  │
  ▼
AI Enrichment ────────► INTERPRETATION.md, flow/page narratives, gap resolution
```

## Proposed Architecture

```
.mpr file
  │
  ▼
mxcli ────────────────► Structured JSON (same mendix-data/app-overview/ location)
  │                       ├── manifest.json (same schema, new generator field)
  │                       ├── general/
  │                       │   ├── app-info.json        ◄── SHOW STRUCTURE + catalog queries
  │                       │   ├── user-roles.json      ◄── SHOW PROJECT SECURITY + SHOW USER ROLES
  │                       │   ├── all-modules.json     ◄── SELECT * FROM CATALOG.modules
  │                       │   └── marketplace-modules.json
  │                       └── modules/<Module>/
  │                           ├── domain-model.json    ◄── catalog entities/attributes + DESCRIBE
  │                           ├── flows.json           ◄── catalog microflows + DESCRIBE + REFS
  │                           ├── pages.json           ◄── catalog pages + DESCRIBE
  │                           └── resources.json       ◄── catalog constants + java_actions
  │
  ▼
PowerShell Composer ──► Markdown KB (UNCHANGED — same templates, same output)
  │
  ▼
AI Enrichment ────────► INTERPRETATION.md, narratives (UNCHANGED)
```

## What Changes

| Layer | Change | Impact |
|-------|--------|--------|
| **Extraction** | `mx dump-mpr` + C# parser → `mxcli` commands | Dependencies reduced from 3 tools to 1 |
| **JSON output** | Same v2.0 schema, produced by mxcli instead of C# | Composer does not need to change |
| **Composer** | No change | Reads same JSON, produces same KB |
| **Enrichment** | No change | Operates on same static KB structure |
| **Copilot** | Optional: can also query mxcli live | Additive, does not replace static KB |

## What Does NOT Change

1. **The KB is still a static artifact** — files on disk, not a live query service
2. **The 3-layer progressive disclosure model** (L0 abstract → L1 overview → L2 JSON)
3. **AI enrichment** — INTERPRETATION.md, business narratives, gap resolution
4. **The composer templates and scripts** — they consume the same JSON schema
5. **Quality gates and benchmarks** — same validation pipeline
6. **The Copilot** — reads the same KB structure

## What Improves

1. **Richer extraction** — mxcli catalog has more data than the C# parser (activities, widgets, refs, XPath, workflows, OData, business events)
2. **Cross-references built-in** — REFS catalog table + SHOW CALLERS/CALLEES/IMPACT replace inferred relationships
3. **No dump step** — mxcli reads .mpr directly, eliminating the intermediate XML dump
4. **Single dependency** — one Go binary vs (mx + .NET runtime + PowerShell)
5. **Incremental potential** — mxcli snapshot system enables future incremental KB updates
6. **New KB sections possible** — workflows, OData services, business events, widget inventory, lint results

## Integration Approach

The integration produces JSON files **in the same v2.0 schema** so the existing composer works unchanged. This is a **drop-in replacement** for the extraction layer.

New data that mxcli can provide (workflows, OData, widgets, refs) can be added as **additional JSON files** alongside the existing ones, with corresponding new composer templates added incrementally.

## Document Index

| Document | Purpose |
|----------|---------|
| [01-OVERVIEW.md](01-OVERVIEW.md) | This document — vision and architecture |
| [02-JSON-V2-SCHEMA.md](02-JSON-V2-SCHEMA.md) | Current parser JSON v2.0 schema (field-level reference) |
| [03-MXCLI-CATALOG-SCHEMA.md](03-MXCLI-CATALOG-SCHEMA.md) | mxcli catalog tables and output format reference |
| [04-SCHEMA-MAPPING.md](04-SCHEMA-MAPPING.md) | Field-by-field mapping: v2.0 ↔ mxcli |
| [05-ENRICHMENT-STRATEGY.md](05-ENRICHMENT-STRATEGY.md) | How enrichment is preserved and enhanced |
