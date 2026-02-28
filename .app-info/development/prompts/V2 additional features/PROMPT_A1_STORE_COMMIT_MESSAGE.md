# Masterprompt A1 - Wire `store-commit-message` into the UI
**Status: Implement immediately**
**Complexity: Low**

---

## Goal

Complete the commit-message storage flow in the existing UI without changing backend route/service contracts.

## Entry Criteria

1. Clarifying workflow questions have been asked as needed.
2. Scope and non-goals are confirmed.
3. Existing route contract and UI state keys are verified from source files.

## Required First Action

1. Read `.agents/AGENTS.md`.
2. Read `.agents/FRAMEWORK.md`.
3. Read `.app-info/ROUTING.md`.
4. Read `.app-info/development/prompts/OVERVIEW.md`.
5. Read:
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`
   - `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`
   - `studio-pro-extension-csharp/Processing/Core/ExtensionConstants.cs`

## Skill Suggestion Step

Ask: "Which skills should be used for this prompt?"

Default suggestions:
- `.app-info/skills/mendix-studio-pro-10/SKILL.md`
- `.agents/skills/testing/SKILL.md`

---

## Your role

You are an expert C# and embedded-web-UI developer working on a Mendix Studio Pro 10 extension called `AutoCommitMessage`. You have full access to the extension source. Your job is to complete a half-built feature: the commit-message storage flow.

---

## Confirmed current contract and keys

### Backend route contract (do not change)

File:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessageWebServerExtension.cs`

Action and route:
- action value: `store-commit-message` (`ExtensionConstants.StoreCommitMessageActionValue`)
- route prefix: `autocommitmessage` (`ExtensionConstants.WebServerRoutePrefix`)

Expected request:
- HTTP method: `POST`
- Body: JSON with string field `message`
- Query params already supported by existing action URL builder:
  - `projectPath`
  - `action=store-commit-message`
  - optional `commitMessagesBasePath`

Responses:
- `200`: `{ success: true, message, outputPath, outputFolder }`
- `400`: invalid/empty body or empty message
- `500`: exception message

### UI localStorage keys (already present)

File:
- `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`

Keys:
- store flag: `autocommitmessage.storeCommitMessages`
- commit messages base path: `autocommitmessage.commitMessagesBasePath`

---

## What you need to implement

### 1. Honor the store flag in the Create message flow

When user clicks **Create message**:
1. Keep existing compose behaviour.
2. Keep clipboard copy behaviour.
3. If `autocommitmessage.storeCommitMessages` is `true`, call `store-commit-message` with:
   - request body JSON `{ "message": "<composedText>" }`
   - existing query params including `commitMessagesBasePath`
4. Show non-blocking inline status in modal:
   - success: `Message saved`
   - failure: `Save failed - copied to clipboard only`
5. Do not use `alert()`.

### 2. Settings view

In existing Settings view (`AutoCommitMessagePanelHtml.cs`):
- Ensure toggle label is explicit: `Save commit messages to disk`.
- Bind toggle to `autocommitmessage.storeCommitMessages`.
- Ensure commit-messages base path input is shown only when toggle is enabled.
- Ensure value persists via existing localStorage wiring.

### 3. Match route contract exactly

Use current backend contract exactly as documented above.
Do not change route handler or store service logic.

---

## Constraints

- Do not change backend service or route handler logic.
- Do not add new localStorage keys.
- Do not redesign modal; only wire store call + inline status.
- Keep UI changes inside `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
- Match existing code style.

---

## Deliverables

1. Updated `studio-pro-extension-csharp/UI/Web/AutoCommitMessagePanelHtml.cs`.
2. Short implementation note including:
   - route contract used
   - localStorage keys used
   - assumptions made
3. If backend change is unavoidable, explain exact reason and exact change.

---

## Acceptance criteria

- [ ] Store flag OFF: Create message copies to clipboard only, no store request.
- [ ] Store flag ON with path set: Create message copies and stores.
- [ ] Success response shows `Message saved` in modal without closing modal.
- [ ] Failure response shows `Save failed - copied to clipboard only` without JS error.
- [ ] Settings toggle/path persist correctly through localStorage.

## Exit Criteria

1. Deliverables completed without backend contract changes.
2. Acceptance criteria pass.
3. Prompt updates are documented in `.app-info/memory/PROMPT_CHANGES.md` when accepted.
