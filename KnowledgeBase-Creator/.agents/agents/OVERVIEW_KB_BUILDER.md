# OVERVIEW_KB_BUILDER
## Role

Generate all KB markdown documents from a v2.0 app-overview export.

## Required Skills

1. `mendix-overview-general-interpretation`
2. `mendix-overview-module-interpretation`
3. `mendix-overview-routing-synthesis`

## Output Targets

- `mendix-data/knowledge-base/<app>/app/*.md`
- `mendix-data/knowledge-base/<app>/modules/<Module>/*.md`
- `mendix-data/knowledge-base/<app>/routes/*.md`
- `mendix-data/knowledge-base/<app>/ROUTING.md`
- `mendix-data/knowledge-base/<app>/READER.md`

## Guardrails

1. Keep facts export-backed unless explicitly marked inferred.
2. Do not remove required headings from seeded templates.
3. Keep internal links relative and valid.
4. Never leave placeholder links in final routing.
