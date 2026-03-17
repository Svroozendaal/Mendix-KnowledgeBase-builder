# PROMPT 07: Mendix Marketplace Publication

## Priority

Medium — final phase, after all features are stable.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — packaging requirements and marketplace constraints.
2. Phase 01–06 output — complete, polished extension.
3. Mendix Marketplace documentation — submission process, requirements, guidelines.

## Problem Statement

Package the extension for distribution on the Mendix Marketplace. This involves licence compliance, documentation, security preparation, and building the final distributable package.

## Deliverable

### 1. Licence Audit

**Requirement:** MIT or Apache 2.0 (no GPL v3 or other copyleft licences).

- Audit all NuGet package licences.
- Audit all npm package licences (frontend dependencies ship as bundled JS).
- Document any LGPL dependencies (acceptable if dynamically linked).
- Remove or replace any GPL v3 transitive dependencies.
- Add `LICENCE` file (MIT) to the extension root.

### 2. Package Build Script

Create a build script that produces the marketplace-ready package:

```powershell
# build-marketplace-package.ps1
# 1. Build frontend (npm run build)
# 2. Build C# extension (dotnet publish)
# 3. Bundle ModelOverviewCli.exe
# 4. Create manifest.json
# 5. Copy frontend dist into extension output
# 6. Create ZIP package
```

**Output structure:**
```
KbExtension/
├── manifest.json
├── KbExtension.dll
├── [dependency DLLs]
├── frontend/
│   ├── index.html
│   └── assets/
├── tools/
│   └── ModelOverviewCli.exe
├── LICENCE
└── README.md
```

### 3. Documentation

**README.md** (ships with the extension):
- What the extension does (3 features).
- Prerequisites (Studio Pro 10.24+, Claude CLI or Codex CLI installed).
- Installation steps.
- Quick start guide.
- Configuration reference.
- Troubleshooting common issues.

**Marketplace listing content:**
- Title: "KB Assistant — AI Knowledge Base for Mendix Apps"
- Short description (1-2 sentences).
- Full description with feature list.
- Screenshots (Copilot tab, Creator tab, Developer tab).
- Category: Development Tools.
- Compatibility: Studio Pro 10.24+.

### 4. Security Review Preparation

Prepare materials for Mendix QSM (Quality & Security Management) review:

- Document all external process invocations (Claude CLI, Codex CLI, mx CLI, ModelOverviewCli).
- Document all file system access patterns and sandboxing.
- Document all network access (none — CLI tools handle network).
- Verify no secrets/credentials are stored in plain text.
- Ensure path traversal protections are in place (KBNavigator path sandbox).

### 5. CI Workflow Update

Update `.github/workflows/build-knowledgebase-creator-artifact.yml` (or create a new workflow) to:
1. Build the complete extension package.
2. Run licence compliance check.
3. Upload the marketplace-ready ZIP as a GitHub artifact.

### 6. Version Strategy

- Use SemVer: `1.0.0` for initial marketplace release.
- Store version in `KbExtension.csproj` `<Version>` property.
- Frontend displays version in settings panel.
- manifest.json includes version metadata.

## Exit Criteria

1. Licence audit passes — no GPL v3 dependencies.
2. Build script produces a clean marketplace package.
3. README.md is clear and complete.
4. Screenshots captured for all three tabs.
5. Security review materials documented.
6. CI workflow builds the marketplace package.
7. Extension installs from the built package in a clean Studio Pro 10.24+ environment.
8. Submitted to Mendix Marketplace (or ready for submission).

## Out of Scope

- Automated marketplace submission (manual process).
- Marketplace analytics or telemetry.
- Auto-update mechanism (Marketplace handles this).
