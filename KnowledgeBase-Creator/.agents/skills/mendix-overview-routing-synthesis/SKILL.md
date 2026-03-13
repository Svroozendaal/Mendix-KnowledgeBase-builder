---
name: mendix-overview-routing-synthesis
description: Validate and enrich cross-reference route indexes after enrichment.
---

# MENDIX OVERVIEW ROUTING SYNTHESIS

## Context

The pipeline has already composed all route files with export-backed cross-references. This skill guides the AI to validate link integrity and update completeness stats after enrichment.

## Files to validate and enrich

### `ROUTING.md`
- Verify the module index table is accurate (all custom modules listed with correct categories)
- Update completeness stats if enrichment resolved any Unknown items
- Verify all relative links resolve to existing files

### `routes/by-entity.md`
- Verify entity cross-references are complete
- Add any missing entity lifecycle mappings discovered during enrichment

### `routes/by-flow.md`
- Verify flow cross-references include all Tier 1 flows
- Check that flow-to-entity mappings are accurate

### `routes/by-page.md`
- Verify page-to-flow links are accurate
- Check that role assignments match `app/SECURITY.md`

### `routes/cross-module.md`
- Verify cross-module dependency matrix
- Add narrative about module coupling patterns if applicable

## Validation Checklist

1. Every relative link in route files resolves to an existing file
2. No placeholder links remain (e.g., `[TODO]`, `[link]()`)
3. Completeness section in `ROUTING.md` reflects post-enrichment state
4. Entity counts match between route indexes and module DOMAIN files
5. Flow counts match between route indexes and module FLOWS files

## Rules

- Never modify export-backed data in route tables
- Only update stats and add narrative context
- Mark any added content as `Confidence: Inferred`
- Flag broken links as issues rather than removing them
