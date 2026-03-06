# Parser Enrichment Specification (Additive)

## Objective

List optional parser enrichments that improve composition quality without breaking existing contracts.

## Compatibility Principle

1. Maintain `schemaVersion: 2.0` unless a non-backward-compatible structure change is introduced.
2. Add new fields only as optional/additive values.
3. Keep existing fields and semantics stable.

## Enrichment Candidates

### 1. Scheduled Event Enrichment

Current state:

1. Scheduled event output includes name and documentation.
2. Schedule expression and target flow are often unavailable to composer.

Proposed additive fields (if source data exists):

1. `scheduleExpression`
2. `targetFlow`
3. `isEnabled` (if available)

Benefit:

1. Removes avoidable unknowns in `RESOURCES.md`.
2. Improves scenario coverage for automation-impact QA questions.

### 2. Flow Action Tagging

Current state:

1. Composer derives behaviour by parsing node labels/details.

Proposed additive flow metadata:

1. `actionTags` per flow (e.g. `ReadEntity`, `WriteEntity`, `ShowPage`, `CallFlow`).
2. Optional `entityMentions`.
3. Optional `pageMentions`.

Benefit:

1. Reduces brittle text parsing.
2. Increases determinism for lifecycle and routing synthesis.

### 3. Access Constraint Hints

Current state:

1. XPath constraints are available, but plain-language conversion is composer-only.

Proposed additive field:

1. `xPathConstraintHint` (normalised textual hint) per access rule.

Benefit:

1. Consistent security explanations across generated docs.

## Implementation Guardrails

1. Parser enrichments must not remove current fields.
2. Composer must treat enrichment fields as optional and fallback gracefully.
3. Benchmark and quality gate must pass with or without enrichments.

## Migration Strategy

1. Phase A: implement composer using existing v2.0 fields first.
2. Phase B: add parser enrichments.
3. Phase C: switch composer to prefer enrichment fields, fallback to legacy parse.

## Non-Goals

1. Full schema redesign.
2. Breaking parser API changes.
3. Runtime behaviour simulation beyond static model evidence.
