# Masterprompt D1 - Commit Message History
**Status: Implement immediately - Phase D**
**Complexity: Low-Medium**

---

## Goal

Implement deterministic commit-message file naming plus a read-only History view in the embedded UI for listing and reading stored commit messages on demand.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Current store route, store service, and compose modal wiring are verified in source.
4. Current navigation and settings patterns in UI are verified.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageCommitMessageStoreService.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionDataPaths.cs`
   - `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`
   - `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`
- `.agents/skills/documentation/SKILL.md`

---

## Your role

You are an expert C# developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. You will deliver:

1. Deterministic filename and header strategy for stored commit messages.
2. A new History UI view with lazy loading for message content.

---

## Confirmed current pointers

1. Store service:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageCommitMessageStoreService.cs`
2. Store route action:
   - `store-commit-message` in `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
3. Compose modal and store call wiring:
   - `showCommitMessageDialog(...)` in `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
4. Commit messages folder resolution:
   - `ExtensionDataPaths.GetCommitMessagesFolder(...)` in `studio-pro-extension-csharp/Processing/Core/ExtensionDataPaths.cs`
5. Existing UI tabs:
   - currently `Model changes`, `Model overview`, `Settings` in `AutoCommitMessagePanelHtml.cs`

---

## Part 1 - Commit message filename and content format

### Required filename format

Pattern:

```
<storyId>_<signature>_<yyyyMMdd>.txt
```

Examples:
- `US1234_JD_20260228.txt`
- `BUG-99_MO_20260301.txt`
- `_MO_20260228.txt` (empty story ID retained as empty segment)

Rules:
- `storyId` and `signature` come from compose modal values at store time.
- `yyyyMMdd` uses server local time.
- Sanitise `storyId` and `signature` to `[A-Za-z0-9_-]` only.
- If sanitised `storyId` is empty, keep empty segment.

### Required file content format

Stored file content must start with:

```
#commit:<shortCommitHash>
<blank line>
<message body>
```

`shortCommitHash`:
- first 8 chars of current HEAD SHA from repository in route layer.

Header behaviour:
- `#commit:` is metadata anchor.
- Must be hidden in History display/copy output.

### Write strategy (overwrite vs suffix)

For candidate `<storyId>_<signature>_<yyyyMMdd>.txt`:

1. If file does not exist: create new file.
2. If file exists:
   - read first line hash
   - if hash matches current HEAD short hash: overwrite same file
   - if hash differs: try suffix variants `_2`, `_3`, ... until:
     - free slot found -> write new file
     - existing slot with matching hash -> overwrite that slot

Add XML doc comments in store service describing naming, header, and collision strategy.

### Backend changes required

1. Update store service:
   - `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageCommitMessageStoreService.cs`
2. Update store route:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
3. Route must accept `storyId` and `signature` query parameters in addition to current body shape (`{ "message": "..." }`).
4. Route resolves HEAD short hash and passes it to store service.
5. Keep existing store response shape unchanged.

### UI changes required

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

When store is triggered from compose modal:
- pass `storyId` and `signature` as query parameters to `store-commit-message`.
- use existing modal input values (do not introduce duplicate fields).

---

## Part 2 - History view

### New route actions

Add constants in:
- `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`

Add handlers in:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`

Actions:

1. `list-commit-messages`
2. `read-commit-message`

#### `list-commit-messages`

Inputs:
- `commitMessagesBasePath`

Returns list metadata only, not file bodies:

```json
{
  "messages": [
    {
      "fileName": "US1234_JD_20260228.txt",
      "storyId": "US1234",
      "signature": "JD",
      "date": "2026-02-28",
      "filePath": "C:\\...\\Commit messages\\US1234_JD_20260228.txt"
    }
  ],
  "folder": "C:\\...\\Commit messages",
  "folderExists": true
}
```

Rules:
- parse metadata from filename pattern
- include non-matching files with `storyId/signature/date = null`
- sort by parsed date desc, unparseable dates last

#### `read-commit-message`

Inputs:
- `filePath`
- `commitMessagesBasePath` (for safety validation)

Returns:

```json
{
  "fileName": "US1234_JD_20260228.txt",
  "content": "...message body without #commit header..."
}
```

Mandatory security:
- path traversal guard: resolved file path must remain under resolved commit messages folder.

Header stripping:
- remove first `#commit:` line and immediate blank line from returned content.

### New history service

Create:
- `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageHistoryService.cs`

Required public API:

```csharp
public CommitMessageListResult ListMessages(string commitMessagesBasePath) { ... }
public CommitMessageReadResult ReadMessage(string filePath, string commitMessagesBasePath) { ... }
```

Service scope:
- read-only (no write/delete)
- metadata parse + content read + path guard

### UI History tab

Update:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Requirements:
1. Add `History` tab to navigation.
2. List panel:
   - load list on History tab activation
   - show loading state
   - show date/story/signature/filename where available
   - show folder-missing and empty states
   - include `Refresh list` action
3. Detail panel:
   - placeholder before selection
   - fetch content only on row click (`read-commit-message`)
   - show loading state
   - render read-only content
   - add copy button with inline `Copied!` feedback
4. Keep tab state in-session when switching tabs (selected row and scroll position).
5. Respect existing dark/light theme.

---

## Documentation requirements

Update documentation with:

1. Filename format + sanitisation + collision strategy
2. New route actions and contracts
3. Lazy-read behaviour for `read-commit-message`

Preferred files:
- `studio-pro-extension-csharp/Docs/ARCHITECTURE.md`
- `studio-pro-extension-csharp/Docs/EXPORT_CONTRACT.md`

If a dedicated history doc is added, reference it from these files.

---

## Constraints

- `read-commit-message` must only run on explicit user click.
- History view is read-only.
- Path traversal guard is mandatory.
- Do not change commit-messages folder location contract.
- Keep `store-commit-message` response shape unchanged.
- Preserve existing dark/light theme behaviour.

---

## Deliverables

1. Updated `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageCommitMessageStoreService.cs`.
2. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs` store route and new history routes.
3. Updated `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs` with new action/query constants.
4. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs` for story/signature route params and History tab UI.
5. New `studio-pro-extension-csharp/Processing/Services/AutoCommitMessageHistoryService.cs`.
6. Updated docs (`ARCHITECTURE.md`, `EXPORT_CONTRACT.md` or dedicated linked doc).
7. Unit tests for filename strategy, parsing, header stripping, and path traversal guard.

---

## Acceptance criteria

- [ ] Stored files follow `<storyId>_<signature>_<yyyyMMdd>.txt` pattern.
- [ ] Story/signature sanitisation applied.
- [ ] Stored files include `#commit:<shortHash>` header line.
- [ ] Same hash for same day/story/signature overwrites existing file.
- [ ] Different hash creates `_2`, `_3`, ... variants.
- [ ] History view never shows/copies `#commit:` header metadata.
- [ ] History tab appears with list/detail interaction.
- [ ] List endpoint returns sorted metadata and includes unparseable filenames.
- [ ] Detail endpoint reads content lazily on row click.
- [ ] Missing folder state is handled without crash.
- [ ] Path traversal attempts are rejected.
- [ ] Theme behaviour remains consistent.
- [ ] Unit tests pass.

## Exit Criteria

1. Deliverables completed.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
