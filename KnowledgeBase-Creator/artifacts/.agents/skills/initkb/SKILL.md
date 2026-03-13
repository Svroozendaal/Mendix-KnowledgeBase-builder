---
name: initkb
description: Compatibility entry point for a generated KB. If the linked source run folder exists, enrich this KB in place just like `/enrichkb`. If the user explicitly wants a rebuild from source, or if the source run folder is missing, delegate back to the creator package.
---

# INITKB

## Purpose

Use `/initkb` inside a generated KB as a compatibility entry point.

If the user only wants the AI narrative layer, prefer `/enrichkb`. If they run `/initkb` anyway and the linked source run folder exists, perform the same in-place enrichment flow as `/enrichkb`.

## Required inputs

Read `_sources/creator-link.json` first and resolve:

- `knowledgeBaseRoot`
- `lastRunFolder`
- `creatorRoot`
- `creatorInitkbRunner`
- `appName`

If `_sources/INITKB_HANDOFF.md` exists, read it immediately after `creator-link.json` and use it as the path-and-validation source of truth.

## In-place enrichment path

If `lastRunFolder` exists and the user did not explicitly request a rebuild from source, follow the same enrichment procedure as `/enrichkb`.

## Rebuild fallback

If `lastRunFolder` is missing, or if the user explicitly wants to rebuild from source, delegate to the creator package by reporting:

```powershell
.\wizard\run-initkb.ps1 -KnowledgeBaseRoot "<knowledgeBaseRoot>"
```

## Output

Report:

- app name
- KB root
- source run folder
- whether in-place enrichment ran or a rebuild handoff was required
- which files were enriched when in-place enrichment ran
- which Unknown items were resolved when in-place enrichment ran
- remaining gaps
- whether post-enrichment validation was rerun
