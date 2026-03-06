---
name: mendix-overview-module-interpretation
description: Build per-module KB docs from v2.0 module exports.
---

# MENDIX OVERVIEW MODULE INTERPRETATION

Read from each module folder:
- `domain-model.*`
- `flows.*`
- `pages.*`
- `resources.*`

Write for each module:
- `README.md`
- `DOMAIN.md`
- `FLOWS.md`
- `PAGES.md`
- `RESOURCES.md`

Requirements:
- preserve required headings
- keep shared entities dependency line in README
- include explicit `none` markers when data is empty
