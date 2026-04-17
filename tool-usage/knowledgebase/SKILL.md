---
name: knowledgebase
description: Run the full Mendix knowledge base creation pipeline by gathering source inputs first, then invoking the creator package's init and enrich flows, followed by revalidation and a completion report.
---

# KNOWLEDGEBASE

## Purpose

Use this skill when the user wants to create, rebuild, or regenerate a Mendix knowledge base from source.

## Start by gathering inputs

Before running anything, ask for or confirm:

1. the source application or `.mpr` path
2. the target KB or `mendix-data` output location
3. the Mendix tooling path or version context
4. optional module scope
5. strict-mode preference
6. whether this is a fresh build or a rebuild of an existing KB

## Execution order

1. Read `KnowledgeBase-Creator/AGENTS.md`.
2. Use `KnowledgeBase-Creator/.agents/agents/KNOWLEDGEBASE_CREATOR.md`.
3. Run the internal `initkb` flow.
4. Run the internal `enrichkb` flow.
5. Re-run scaffold validation.
6. Re-run the quality gate.
7. Report the final status, enriched files, and remaining gaps.

## Guardrails

- Always treat `KnowledgeBase-Creator/` as the runtime tool package.
- Do not bypass the creator package with ad hoc script sequences unless debugging the creator itself.
- Do not report success unless post-enrichment validation and the quality gate both pass.
