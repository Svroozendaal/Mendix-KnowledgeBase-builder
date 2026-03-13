# Product Plan Index

## Purpose

This folder defines the implementation baseline for upgrading the Mendix knowledge-base pipeline into an AI-useful product while keeping the current file contract unchanged.

The plan is decision-complete for:

1. Final KB content expectations.
2. Tooling and pipeline changes.
3. Validation gates and benchmark criteria.
4. Rollout sequence and risk controls.

## Scope

In scope:

1. In-place KB quality upgrade for existing file set (`READER.md`, `ROUTING.md`, `app/*`, `modules/*`, `routes/*`).
2. Deep behavioural documentation for `Custom` modules.
3. Hybrid quality model:
   - structural contracts
   - semantic completeness thresholds
   - semantic QA benchmark.
4. New generation tooling:
   - `run-kb-compose.ps1`
   - `run-kb-semantic-benchmark.ps1`
   - quality-gate expansion.

Out of scope:

1. Breaking folder contract changes.
2. Renaming/removing required KB files.
3. Mandatory parser schema version change (stays `2.0` unless future compatibility decision says otherwise).

## Locked Decisions

1. Strategy: in-place improvement (no parallel KB schema).
2. Depth policy: custom-module depth first; marketplace/system shallow unless coupled to custom behaviours.
3. Flow depth policy: tiered (`Tier 1`, `Tier 2`, `Tier 3`) with deterministic assignment rules.
4. Quality policy: pass requires structural + semantic + benchmark gates.

## Document Map

1. [01-END_STATE_KB_SPEC.md](01-END_STATE_KB_SPEC.md)  
   Final required KB structure, generated KB root layout, and per-file acceptance contract.
2. [02-CONTENT_MODEL_CUSTOM_DEPTH.md](02-CONTENT_MODEL_CUSTOM_DEPTH.md)  
   Behaviour-first content model and tiered flow narrative rules.
3. [03-TOOLCHAIN_ARCHITECTURE.md](03-TOOLCHAIN_ARCHITECTURE.md)  
   End-to-end pipeline architecture and script orchestration.
4. [04-PARSER_ENRICHMENT_SPEC.md](04-PARSER_ENRICHMENT_SPEC.md)  
   Optional/additive parser enrichments and compatibility constraints.
5. [05-KB_COMPOSER_SPEC.md](05-KB_COMPOSER_SPEC.md)  
   Deterministic composition rules for markdown generation.
6. [06-ROUTING_AND_INDEX_SPEC.md](06-ROUTING_AND_INDEX_SPEC.md)  
   Index synthesis rules for entities, pages, flows, dependencies.
7. [07-QUALITY_GATE_HYBRID_SPEC.md](07-QUALITY_GATE_HYBRID_SPEC.md)  
   Structural plus semantic thresholds and failure policy.
8. [08-SEMANTIC_BENCHMARK_SUITE.md](08-SEMANTIC_BENCHMARK_SUITE.md)  
   Canonical QA scenarios, evidence expectations, scoring model.
9. [09-IMPLEMENTATION_ROADMAP.md](09-IMPLEMENTATION_ROADMAP.md)  
   Phase-by-phase execution plan and completion gates.
10. [10-RISK_REGISTER.md](10-RISK_REGISTER.md)  
    Risks, mitigations, and fallback paths.
11. [11-CONTEXT_CONVERSATION_AGENT_SPEC.md](11-CONTEXT_CONVERSATION_AGENT_SPEC.md)
    Post-KB conversation agent contract for interview-derived app context, additive overlay outputs, and GAPSMITH handoff mapping.

## Context Conversation Extension (2026-03-05)

This extension adds a product-owner-first context conversation layer to improve AI answer quality without altering export-backed facts.

Locked details:

1. Pipeline position: post-KB generation/enrichment, pre-GAPSMITH.
2. Output artifacts:
   - `<kb-root>/_reports/APP_CONTEXT_OVERLAY.md`
   - `<kb-root>/_reports/APP_CONTEXT_TODO.md`
3. Trust model: conservative tagged confidence with explicit contradiction handling.
4. Handoff model: context TODO items can escalate to GAPSMITH as parser or AI interpretation gaps.

## Addressed Gaps (2026-03-05 Review)

The following gaps were identified and patched into the relevant spec files:

1. **Benchmark portability** (08): added two-tier benchmark model (structural app-generic + optional app-specific). SmartExpenses scenarios retained as pilot calibration only.
2. **Partial re-run strategy** (03): added skip flags (`-SkipDump`, `--SkipParser`, `-SkipScaffold`, `-RunFolder`) for resuming from any pipeline step.
3. **Template/composer relationship** (03): clarified that templates provide fallback structure and heading contract source of truth; composer overwrites with derived content.
4. **`.env` configuration contract** (03): documented all required/optional variables with defaults and validation rules.
5. **KB format versioning** (01): added `KB Format Version` field spec for `READER.md` with patch/minor increment rules.
6. **Evidence extraction limitations** (07): documented known regex miss rates for show-page (~30-50%) and entity touch (~10-20%) detection.
7. **AI consumption strategy** (01): added navigation pattern, design principles, and expected prompt patterns for AI consumers.
8. **CI and regression testing** (09): added Phase 10 with GitHub Actions workflow and diff-based regression baseline.
9. **Parser build/distribution** (03): documented binary distribution and `dotnet publish` fallback.
10. **New risks** (10): added R8 (benchmark portability), R9 (template/composer drift), R10 (no regression baseline).

## Success Definition

The product plan is considered implemented when:

1. All scripts and docs described in this folder exist and run.
2. Generated KBs keep the existing file contract and pass scaffold validation.
3. Custom-module KB content passes semantic thresholds.
4. Structural benchmark (app-generic) scores at least `80/100` with zero critical failures.
5. App-specific benchmark (when provided) scores at least `85/100` with zero critical failures.
6. CI regression workflow passes on reference export.
7. Context conversation spec and prompt track (`11` to `15`) exist and are internally consistent with agent and routing docs.
