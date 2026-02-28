# Masterprompt A2 - Fix Legacy Folder Drift
**Status: Implement immediately (housekeeping)**
**Complexity: Low**

---

## Goal

Align deployment folder creation with current runtime folder names and add a safe one-time migration for legacy installations.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Current deploy script and runtime folder contracts are verified from source.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `deploy-autocommitmessage.ps1`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionDataPaths.cs`
   - `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are a C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. Your task is focused housekeeping: align deploy-time folders with runtime paths and provide an idempotent legacy folder migration.

---

## Confirmed current pointers

1. Deploy script to audit and update:
   - `deploy-autocommitmessage.ps1`
2. Runtime folder source of truth:
   - `studio-pro-extension-csharp/Processing/Core/ExtensionDataPaths.cs`
3. Startup hook for one-time migration call:
   - `studio-pro-extension-csharp/UI/DockablePane/AutoCommitMessageDockablePaneExtension.cs`

Current deploy script pre-creates:
- `exports/`
- `processed/`
- `errors/`
- `structured/`
- `dumps/`

Runtime folder contract currently uses:
- `raw-changes/`
- `processed/`
- `errors/`
- `app-overview/`
- `dumps/`
- `Commit messages/`

---

## What you need to do

### 1. Audit deploy script

Audit exactly:
- `deploy-autocommitmessage.ps1`

Document all pre-created folders and classify:
- legacy: `exports/`, `structured/`
- current: `raw-changes/`, `processed/`, `errors/`, `app-overview/`, `dumps/`, `Commit messages/`

### 2. Update deploy script

In `deploy-autocommitmessage.ps1`:
- remove creation of `exports/` and `structured/`
- ensure creation of:
  - `raw-changes/`
  - `processed/`
  - `errors/`
  - `app-overview/`
  - `dumps/`
  - `Commit messages/`

Add comment block at top of folder-creation block:

```powershell
# Folders must match runtime paths in AutoCommitMessageExportService and AutoCommitMessageModelOverviewService.
# Last verified: [date you make this change]
```

### 3. Add one-time migration helper

Create:
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageFolderMigrationService.cs`

Service behaviour:
1. Input: resolved data root path.
2. Check for legacy folders `exports/` and `structured/`.
3. If present, rename to:
   - `_legacy_exports/`
   - `_legacy_structured/`
4. Log warning that legacy folders were renamed and can be manually removed after validation.
5. Be idempotent on repeated startup runs.

Call this service once during startup initialisation flow using confirmed startup hook path.

### 4. Verify runtime references

Run codebase search for hardcoded `exports` or `structured` in C# files.

If found outside legacy migration logic:
- update to current runtime names
- document each changed reference in implementation note

---

## Constraints

- Do not change route handlers, data contracts, or UI code.
- Do not delete existing user data.
- Migration must be safe to run every startup (idempotent).
- Do not add new NuGet dependencies.

---

## Deliverables

1. Updated `deploy-autocommitmessage.ps1`.
2. New `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageFolderMigrationService.cs`.
3. Startup initialisation update to call migration service once.
4. Audit note listing every legacy folder reference found and disposition.

---

## Acceptance criteria

- [ ] Deploy script pre-creates exactly: `raw-changes/`, `processed/`, `errors/`, `app-overview/`, `dumps/`, `Commit messages/`.
- [ ] Deploy script no longer pre-creates `exports/` or `structured/`.
- [ ] First startup with legacy folders renames to `_legacy_*` and logs warning.
- [ ] Subsequent startups are no-op for already migrated folders.
- [ ] No C# source contains hardcoded `exports` or `structured` except explicit legacy migration logic.

## Exit Criteria

1. Deliverables completed.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
