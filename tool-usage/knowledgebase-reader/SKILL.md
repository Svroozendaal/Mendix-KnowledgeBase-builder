---
name: knowledgebase-reader
description: Resolve a generated Mendix knowledge base, bootstrap from its READER.md and ROUTING.md, then route interpretation work into the KB's shipped agent framework without invoking creator pipeline commands.
---

# KNOWLEDGEBASE-READER

## Purpose

Use this skill when the user wants to read, navigate, or interpret a knowledge base that has already been created.

## Start by resolving the KB

Ask for or confirm the KB root when it is not already clear.

## Execution order

1. Read `<kb-root>/READER.md`.
2. Read `<kb-root>/ROUTING.md`.
3. Read `<kb-root>/.agents/AGENTS.md` when deeper routing is required.
4. Route the task into the generated KB's own `.agents/` framework.

## Guardrails

- Never run creator pipeline commands from this skill.
- Never treat `KnowledgeBase-Creator/` as the source of truth for app interpretation once the KB exists.
- If the KB is missing `READER.md`, `ROUTING.md`, or its shipped `.agents/` bundle, report the gap and redirect the user to rebuild or repair the KB first.
