# SKILL: Module Analysis

## Purpose

Analyse a single Mendix module in depth — its entities, flows, pages, resources, and how they interconnect.

## Used By

KB Navigator, KB Analyst, KB Domain Expert, Mendix Developer

## Procedure

1. Read `modules/<Module>/README.md` for app and system modules, or `modules/_marktplace/<Module>/README.md` for marketplace modules, for the module summary.
2. Read `modules/<Module>/DOMAIN.md` for app and system modules, or `modules/_marktplace/<Module>/DOMAIN.md` for marketplace modules, for the data model.
3. Read `modules/<Module>/FLOWS.md` for app and system modules, or `modules/_marktplace/<Module>/FLOWS.md` for marketplace modules, for business logic.
4. Read `modules/<Module>/PAGES.md` for app and system modules, or `modules/_marktplace/<Module>/PAGES.md` for marketplace modules, for UI components.
5. Read `modules/<Module>/RESOURCES.md` for app and system modules, or `modules/_marktplace/<Module>/RESOURCES.md` for marketplace modules, for constants and scheduled events.
6. Cross-reference `routes/by-entity.md` for entities used outside this module.
7. Cross-reference `routes/cross-module.md` for module dependencies.

## Output

A structured module profile:

| Aspect | Detail |
|---|---|
| **Purpose** | What this module does |
| **Entities** | Count and key entities |
| **Flows** | Count and key flows by type (ACT, DS, VAL) |
| **Pages** | Count and key pages |
| **Dependencies** | Modules this module calls / is called by |
| **External usage** | Entities or flows used by other modules |
