# Prompt Index

## Purpose

Implementation prompts for the KB pipeline upgrade. Each prompt addresses a concrete delivery gap and is grouped into tracks:

1. **Deterministic track** (`01-07`): improvements to PowerShell scripts (composer, benchmark, pipeline).
2. **AI enrichment track** (`08-10`): upgrades to agent and skill files for post-composition enrichment.
3. **Context conversation track** (`11-15`): define and integrate a product-owner interview agent that writes additive context artifacts and handoff-ready TODO items.

Run prompts in order within each track because later prompts may depend on earlier outputs.

## Execution Rules

1. Before executing any prompt, read `.agents/AGENTS.md` and `.agents/FRAMEWORK.md`.
2. Read linked product-plan specs for context before editing.
3. Ask clarifying questions if scope is ambiguous.
4. Confirm assumptions before changing files.
5. For script changes, run:
   - `run-kb-quality-gate.ps1`
   - `run-kb-semantic-benchmark.ps1`
6. For documentation-only prompts, verify links and contracts are internally consistent.

## Prompt Map

### Deterministic Track (scripts)

| # | Prompt | Priority | Depends On | Target File(s) |
|---|---|---|---|---|
| 01 | [COMPOSER_PSEUDOCODE_NARRATIVES.md](COMPOSER_PSEUDOCODE_NARRATIVES.md) | Critical | - | `run-kb-compose.ps1` |
| 02 | [COMPOSER_ANNOTATION_INTENT.md](COMPOSER_ANNOTATION_INTENT.md) | High | 01 | `run-kb-compose.ps1` |
| 03 | [COMPOSER_FIX_CONSTANT_VALUE.md](COMPOSER_FIX_CONSTANT_VALUE.md) | High (bug) | - | `run-kb-compose.ps1` |
| 04 | [COMPOSER_ENTITY_GENERALIZATION.md](COMPOSER_ENTITY_GENERALIZATION.md) | High | - | `run-kb-compose.ps1` |
| 05 | [COMPOSER_NONCUSTOM_MODULE_DEPTH.md](COMPOSER_NONCUSTOM_MODULE_DEPTH.md) | Medium | - | `run-kb-compose.ps1` |
| 06 | [BENCHMARK_GENERALISATION.md](BENCHMARK_GENERALISATION.md) | Medium | - | `run-kb-semantic-benchmark.ps1` |
| 07 | [PIPELINE_PARTIAL_RERUN.md](PIPELINE_PARTIAL_RERUN.md) | Medium | - | `run-dump-parser.ps1` |

### AI Enrichment Track (agents and skills)

| # | Prompt | Priority | Depends On | Target File(s) |
|---|---|---|---|---|
| 08 | [AGENTS_POST_COMPOSITION_ROLE.md](AGENTS_POST_COMPOSITION_ROLE.md) | High | - | Agent files (`.app-info/agents/`, `KnowledgeBase-Creator/.agents/`) |
| 09 | [SKILLS_PRODUCT_PLAN_ALIGNMENT.md](SKILLS_PRODUCT_PLAN_ALIGNMENT.md) | High | 08 | Skill files (`.app-info/skills/`, `KnowledgeBase-Creator/.agents/skills/`) |
| 10 | [KB_ENRICHER_AGENT.md](KB_ENRICHER_AGENT.md) | High | 08, 09 | New agent spec (`.app-info/agents/OVERVIEW_KB_ENRICHER.md`) |

### Context Conversation Track (agent prompts and contracts)

| # | Prompt | Priority | Depends On | Target File(s) |
|---|---|---|---|---|
| 11 | [11-CONTEXT_AGENT_ROLE_AND_BOUNDARY.md](11-CONTEXT_AGENT_ROLE_AND_BOUNDARY.md) | High | - | New conversation agent spec (planned in `.app-info/agents/`) |
| 12 | [12-CONTEXT_INTERVIEW_PROTOCOL.md](12-CONTEXT_INTERVIEW_PROTOCOL.md) | High | 11 | Conversation protocol sections in the new agent spec |
| 13 | [13-CONTEXT_OVERLAY_AND_TODO_CONTRACT.md](13-CONTEXT_OVERLAY_AND_TODO_CONTRACT.md) | Critical | 11, 12 | Output contracts for `_reports/APP_CONTEXT_OVERLAY.md` and `_reports/APP_CONTEXT_TODO.md` |
| 14 | [14-PIPELINE_INTEGRATION_POST_KB_PRE_GAPSMITH.md](14-PIPELINE_INTEGRATION_POST_KB_PRE_GAPSMITH.md) | High | 11, 12, 13 | Workflow docs (`KNOWLEDGEBASE_CREATOR.md`, `ROUTING.md`, agent overviews) |
| 15 | [15-CONTEXT_VALIDATION_AND_GAP_HANDOFF.md](15-CONTEXT_VALIDATION_AND_GAP_HANDOFF.md) | High | 11, 12, 13, 14 | Validation and GAPSMITH handoff rules |

## Parallel Execution Notes

1. **Deterministic track**: Prompts `01`, `03`, `04`, and `05` all modify `run-kb-compose.ps1`; run sequentially in one session.
2. **AI enrichment track**: Prompts `08-10` should run in order.
3. **Context conversation track**: Prompts `11-15` should run in order.
4. **Cross-track**:
   - Deterministic and AI enrichment tracks are loosely coupled.
   - Context conversation track assumes KB generation exists; best run after `08-10` are in place.
