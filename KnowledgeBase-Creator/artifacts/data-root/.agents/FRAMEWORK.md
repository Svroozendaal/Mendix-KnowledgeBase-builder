# FRAMEWORK
## Standalone Mendix Data Operating Model

This package contains three evidence layers with different strengths.

## Layers

| Layer | Path | Strength | Use case |
|---|---|---|---|
| Knowledge base | `{{KB_ROOT}}` | Fastest to navigate | Normal app understanding and question answering |
| Overview export | `{{RUN_FOLDER}}` | Strongest structured source evidence | Verification, tracing, and `Unknown` follow-up |
| Raw dump | `{{DUMPS_ROOT}}` | Lowest-level fallback | Parser-gap and deep-debug investigation |

## Reading Strategy

1. Start with the knowledge base.
2. Escalate to the overview export only when needed.
3. Use the raw dump only when both higher layers are insufficient.

## Current Mapping

- Active run: `{{RUN_FOLDER}}`
- Active KB: `{{KB_ROOT}}`
- KB entry guide: `{{KB_READER}}`

## Package Principle

The package is easiest to understand when agents treat it as a funnel:

1. broad navigation in the KB,
2. source verification in the overview export,
3. root-cause debugging in the raw dump.
