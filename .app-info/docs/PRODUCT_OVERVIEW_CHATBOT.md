# Product Overview for Chatbot

## What This Product Is

Mendix KnowledgeBase Builder is a Windows-first toolchain that turns a Mendix `.mpr` application model into a self-contained, AI-navigable markdown knowledge base.

The product has two linked outputs:

1. A creator package in `KnowledgeBase-Creator/` that runs the pipeline.
2. A generated knowledge base in `mendix-data/knowledge-base/` that can be queried, enriched, validated, and shared as a standalone artifact.

Its purpose is to let an AI assistant answer questions about a Mendix application without needing the raw `.mpr` file or the entire codebase in context.

## The Problem It Solves

Mendix applications are hard for AI tools to understand directly because the source of truth is a model file and multiple derived artefacts rather than a conventional text-first code repository.

This product solves that by:

1. Extracting structured facts from the `.mpr`.
2. Transforming those facts into deterministic markdown documents.
3. Organising the markdown so an AI can navigate file by file instead of loading everything at once.
4. Marking confidence levels and unresolved gaps so the AI knows what is export-backed, inferred, or unknown.

## Primary Users

1. Product owners who want to ask high-level questions about app behaviour.
2. Developers and analysts who need fast orientation on modules, entities, pages, flows, and security.
3. AI assistants that need a predictable documentation structure to answer questions accurately.
4. Teams who want a portable KB package they can move between machines.

## End-to-End Workflow

1. User selects a Mendix `.mpr` file.
2. The tool finds or receives the correct Mendix `mx.exe`.
3. `mx dump-mpr` and the model overview parser generate a structured export in `mendix-data/app-overview/<run>/`.
4. The scaffold step creates the KB folder contract in `mendix-data/knowledge-base/`.
5. The composer fills the KB markdown files with deterministic content derived from the export.
6. The quality gate checks structural completeness and semantic coverage thresholds.
7. The semantic benchmark runs QA-style scenarios and scores the generated KB.
8. Optional AI enrichment improves semantic quality while keeping the file contract intact.
9. Optional context-conversation steps add business context overlays under `_reports/` without changing export-backed facts.
10. GAPSMITH can inspect remaining gaps and create follow-up TODOs for parser or AI interpretation improvements.

## Main Components

### 1. Creator Package

The runnable package lives in `KnowledgeBase-Creator/`.

Key entry points:

1. `KnowledgeBaseCreator.exe`
   - interactive Windows launcher for the full pipeline.
2. `wizard/run-initkb.ps1`
   - full rebuild plus handoff into AI enrichment.
3. `wizard/run-dump-parser.ps1`
   - deterministic pipeline runner for dump, parse, scaffold, compose, validate, quality gate, and benchmark.
4. `wizard/run-kb-scaffold.ps1`
   - creates or validates the KB folder contract.
5. `wizard/run-kb-compose.ps1`
   - writes the markdown knowledge base from export JSON.
6. `wizard/run-kb-quality-gate.ps1`
   - checks required headings, links, and semantic thresholds.
7. `wizard/run-kb-semantic-benchmark.ps1`
   - scores the KB using structural and optional app-specific QA scenarios.

### 2. Structured Export

The parser output is the machine-readable source of truth for KB generation.

Location:

`mendix-data/app-overview/<run>/`

Typical contents:

1. `manifest.json`
2. `general/*.json`
3. `modules/<Module>/domain-model.json`
4. `modules/<Module>/flows.json`
5. `modules/<Module>/pages.json`
6. `modules/<Module>/resources.json`

Current export schema version: `2.0`

### 3. Generated Knowledge Base

The KB is a markdown artefact built for AI navigation, not just for human reading.

Current output root:

`mendix-data/knowledge-base/`

Required KB contract:

```text
knowledge-base/
  READER.md
  ROUTING.md
  app/
    APP_OVERVIEW.md
    MODULE_LANDSCAPE.md
    SECURITY.md
    CALL_GRAPH.md
  modules/
    <Module>/
      README.md
      DOMAIN.md
      FLOWS.md
      PAGES.md
      RESOURCES.md
    _marktplace/
      <MarketplaceModule>/
        README.md
        DOMAIN.md
        FLOWS.md
        PAGES.md
        RESOURCES.md
  routes/
    by-entity.md
    by-page.md
    by-flow.md
    cross-module.md
  _sources/
    manifest.json
    SOURCE_REF.md
```

Additive runtime files may also exist:

```text
knowledge-base/
  CLAUDE.md
  .agents/
  _sources/
    creator-link.json
    INITKB_HANDOFF.md
  _reports/
    UNKNOWN_TODO.md
    semantic-benchmark.md
    APP_CONTEXT_OVERLAY.md
    APP_CONTEXT_TODO.md
```

### 4. AI Navigation Model

The KB is designed so an AI assistant can answer questions by reading only the relevant files.

Expected navigation pattern:

1. Start with `READER.md` to understand scope, confidence semantics, and the file map.
2. Read `ROUTING.md` to identify the right document for the question.
3. Read only the targeted app, module, or route files needed for the answer.

Examples:

1. "What does the app do?" -> `READER.md` + `app/APP_OVERVIEW.md`
2. "How does feature X work?" -> `ROUTING.md` + relevant module `FLOWS.md`
3. "Who can access entity Y?" -> `app/SECURITY.md` + relevant `DOMAIN.md`
4. "Which flows touch entity Z?" -> `routes/by-entity.md` + `routes/by-flow.md`

## Content and Quality Rules

The KB is not meant to be a loose narrative. It follows a contract.

Key rules:

1. Preserve the required KB file structure.
2. Prefer export-backed facts over inference.
3. Use explicit confidence markers:
   - `Export-backed`
   - `Inferred`
   - `Unknown`
4. Avoid `Unknown` when the answer can be derived from the export.
5. Keep custom modules behaviour-rich and non-custom modules concise.
6. Keep output deterministic so the same input yields equivalent markdown.

## Depth Strategy

The product uses asymmetric documentation depth.

1. Custom modules get deep behavioural coverage.
2. Marketplace and system modules stay concise unless they are important to custom behaviour.
3. High-impact custom flows get tiered narratives:
   - `Tier 1`: behaviour-critical, cross-module, or UI-important flows
   - `Tier 2`: meaningful supporting behaviour
   - `Tier 3`: lower-detail catalogue coverage

## Validation Model

The product uses three validation layers.

### 1. Structural Validation

Checks that the expected KB files and headings exist.

### 2. Quality Gate

Checks semantic completeness thresholds such as:

1. page-flow linkage coverage
2. flow-entity coverage
3. entity lifecycle mapping

### 3. Semantic Benchmark

Runs QA-style scenarios to test whether the KB can answer important questions.

Current policy:

1. Structural benchmark must score at least `80/100` with zero critical failures.
2. App-specific benchmark, when provided, must score at least `85/100` with zero critical failures.

## AI Enrichment and Gap Handling

The deterministic pipeline produces the baseline KB. AI enrichment is a controlled second phase.

The enrichment phase should:

1. improve semantic density
2. resolve items from `_reports/UNKNOWN_TODO.md`
3. preserve required headings, links, and tables
4. keep export-backed facts separate from inferred context

GAPSMITH is the follow-up analysis workflow for identifying whether remaining problems are:

1. parser gaps
2. composition gaps
3. AI interpretation gaps
4. app-specific context gaps

## Current Product Status

Implemented and documented areas already present in the repository include:

1. structured export pipeline
2. model overview export v2.0
3. model overview CLI test harness
4. portable KnowledgeBase Creator artifact

The repository also contains a substantial product-plan set covering:

1. end-state KB specification
2. toolchain architecture
3. parser enrichment rules
4. composer rules
5. routing/index rules
6. quality gate rules
7. semantic benchmark rules
8. implementation roadmap
9. risk register
10. context conversation extension

## Important Constraints

1. The KB file contract is intended to remain stable.
2. Breaking structural changes should be versioned through the KB format version, not introduced silently.
3. The parser schema version and the KB format version are separate concerns.
4. Context overlays are additive and must not overwrite export-backed facts.
5. The generated KB is designed to be self-contained and shareable.

## Known Terminology

1. `mpr`
   - the Mendix application model file.
2. `run folder`
   - one parser/export execution under `mendix-data/app-overview/<run>/`.
3. `knowledge base root`
   - the generated markdown KB at `mendix-data/knowledge-base/`.
4. `creator package`
   - the portable tooling under `KnowledgeBase-Creator/`.
5. `Unknown TODO`
   - a documented evidence gap where the pipeline could not derive a reliable answer.

## Suggested Questions to Ask About This Product

1. What problem is Mendix KnowledgeBase Builder solving?
2. How does the pipeline work from `.mpr` to markdown KB?
3. What is the exact generated KB file structure?
4. What is the difference between export-backed, inferred, and unknown content?
5. How do quality gate and semantic benchmark differ?
6. What is the purpose of `_reports/UNKNOWN_TODO.md`?
7. What is the difference between the creator package and the generated knowledge base?
8. How do AI enrichment and GAPSMITH fit into the workflow?
9. Which parts are implemented already versus still part of the longer-term roadmap?
10. What are the main risks or limitations of the current approach?
