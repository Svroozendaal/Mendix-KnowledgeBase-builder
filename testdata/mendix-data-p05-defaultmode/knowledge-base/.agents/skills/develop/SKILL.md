---
name: develop
description: Start a guided development workflow from user story to implementation plan. Orchestrates sub-agents to investigate the KB, propose solutions, analyse impact, review security, and produce a step-by-step task list.
---

# DEVELOP

## Purpose

Use `/develop` when a developer has a user story or feature request and wants a guided path to a complete implementation plan grounded in this knowledge base.

## Required Inputs

- A user story or feature description from the developer.
- This knowledge base must be populated (`ROUTING.md`, module files, and route indexes must exist).

## Procedure

1. Read `.agents/agents/DEVELOPMENT_TEAM.md`.
2. Follow the Development Team agent's 7-phase workflow.
3. The workflow is conversational — present findings, ask for approval, iterate.
4. Save the final implementation plan to `_plans/STORY_<title-slug>.md`.

## Phase Summary

| Phase | Delegates To | Purpose |
|---|---|---|
| 1. Intake | User Story Interpreter | Parse story, map to KB, ask clarifying questions |
| 2. Investigation | KB Feature Interpreter, KB Flow Tracer, KB Analyst | Find related elements in custom modules |
| 3. High-Level Solution | Mendix Developer | Propose functional solution, flag high-impact flows |
| 4. Detailed Solution | Mendix Developer, Planner | Conceptual design with phased structure |
| 5. Impact Analysis | KB Analyst | Full blast radius assessment |
| 6. Security Review | KB Security Reviewer | Access rules, role assignments, XPath constraints |
| 7. Implementation Plan | Todo Maker | Single-artifact task breakdown, saved to file |

## Guardrails

- This is a read-only workflow. The only file created is the implementation plan in `_plans/`.
- All investigation is grounded in KB content. No external tools, pipelines, or Mendix tooling.
- The developer must approve each phase gate before proceeding.
- Only custom modules are targeted for implementation. Marketplace and system modules are reference-only.

## Output

A saved implementation plan at `_plans/STORY_<title-slug>.md` containing:

- Story breakdown and mapping
- Approved solution summary
- Impact analysis with blast radius
- Security review
- Step-by-step implementation tasks at single-artifact granularity
