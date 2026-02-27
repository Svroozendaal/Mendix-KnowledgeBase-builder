# Open Questions

This file captures unresolved product and operational decisions that should be confirmed with the product owner/maintainer.

## Product intent

1. What is the expected primary audience for this extension today:
   - local developers only,
   - reviewers/architects,
   - or both equally?
2. Should the extension remain focused on Studio Pro 10 only, or should we start planning explicit compatibility checks for Studio Pro 11?
3. Is commit-message generation intended to stay outside this extension, or should this extension eventually propose/preview commit text directly in-pane?

## Data and retention

1. What retention policy should apply to `mendix-data/exports` and `mendix-data/dumps`?
2. Are exported payloads allowed to contain sensitive model metadata in your environment, or do we need redaction rules before downstream processing?
3. Should dump persistence (`persistModelDumps`) stay always enabled during export, or become configurable?

## Quality and operations

1. Which quality gate is required before release:
   - manual verification only,
   - automated unit tests for processing layer,
   - or both?
2. Do you want a documented "supported max project size" expectation for refresh/export performance?
3. Should we add structured diagnostic logs for support scenarios, and if yes where should logs be written?

## Workflow and ownership

1. Who owns schema version changes for export payloads?
2. Should `.app-info/features` capture only implemented functionality, or also accepted backlog items?
3. Do you want a formal release checklist document in-repo for extension deployments?
