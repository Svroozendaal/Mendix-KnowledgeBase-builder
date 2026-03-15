# PROMPT 06: Integration Testing, Polish, and Documentation

## Priority

High — this prompt ensures the copilot works correctly end-to-end and is ready for use.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. All Phase 1-5 deliverables — the complete Copilot application
5. `.app-info/agents/OVERVIEW_KB_READER.md` — verify the copilot follows this agent pattern
6. A generated KB at `mendix-data/knowledge-base/` for integration testing

## Problem Statement

The individual phases have been built and unit-tested in isolation. This phase validates the full end-to-end flow against a real knowledge base, adds error handling polish, and creates documentation so users and AI assistants can work with the Copilot codebase.

## Entry Criteria

1. Phase 5 complete — frontend chat UI fully functional.
2. At least one generated knowledge base exists (from the KnowledgeBase Creator pipeline).
3. `npm run dev` starts both backend and frontend without errors.

## Deliverable

### 1. System Prompt Template File

Extract the system prompt from code into a maintainable template:

- `backend/src/services/system-prompt/kb-reader-prompt.md` — the static part of the system prompt (role, navigation rules, confidence framework, guardrails, output format)
- The `SystemPromptBuilder` reads this template and interpolates `{{READER_MD}}` and `{{ROUTING_MD}}` placeholders with the actual KB content
- This separation allows the system prompt to be tuned without changing TypeScript code

### 2. Error Handling Improvements

Review and harden error handling across all layers:

**Backend:**
- KB folder becoming unavailable mid-conversation → clear error event via WebSocket, not a crash
- AI provider timeout (30-second timeout per API call) → timeout error event
- AI provider rate limiting → specific error message with retry guidance
- WebSocket disconnection during streaming → clean up in-progress requests
- Malformed WebSocket messages → log warning, send error event, do not crash
- Config file corruption → fall back to defaults, log warning

**Frontend:**
- WebSocket reconnection with exponential backoff (1s, 2s, 4s, 8s, max 30s)
- Connection status indicator in the header (green dot = connected, yellow = reconnecting, red = disconnected)
- Error toast/banner for provider errors (not found, auth failure, API error) with actionable messages:
  - `CliNotFoundError` → "Claude CLI not found. Check Settings to configure the path."
  - `AuthenticationError` → "Authentication failed. Check your API key in Settings."
  - `ApiError` → "AI provider error: [message]. Try again or switch providers."
- Disable chat input when no KB is configured (show prompt to set up KB path)
- Disable chat input when no AI provider is configured (show prompt to open settings)
- Handle empty conversations gracefully (welcome message with example questions)

### 3. Conversation Export

Add the ability to export a conversation as markdown:

- `GET /api/conversations/:id/export` — returns the conversation as a formatted markdown string
- Format:
  ```markdown
  # KB Copilot Conversation — [title]
  **Date:** [createdAt]
  **Knowledge Base:** [kbRoot]

  ---

  **User:** [message content]

  **Assistant:** [message content]

  > Tool: read_file("modules/Budget/README.md")
  > [truncated result]

  ---
  ```
- Frontend: "Export" button in the conversation sidebar (downloads as `.md` file)

### 4. Welcome Screen

When no conversation is selected or a new conversation is empty:

- Show a welcome message: "KnowledgeBase Copilot"
- Brief description: "Ask questions about your Mendix application's architecture, flows, entities, and pages."
- Example question chips (clickable, pre-fill the chat input):
  - "What does this application do?"
  - "How does budget creation work?"
  - "Which modules depend on each other?"
  - "What pages does the Admin role see?"
  - "Show me the entity model for [module]"

### 5. Integration Test Scenarios

Test each scenario manually against a real KB. Document results.

**Scenario 1 — Basic question flow:**
1. Configure Claude API provider with valid key
2. Validate KB at `mendix-data/knowledge-base/`
3. Create new conversation
4. Ask: "What does this application do?"
5. **Verify:** AI reads `ROUTING.md` and `app/APP_OVERVIEW.md` via tool calls. Response includes app description with file references. Confidence tagged as `export-backed`.

**Scenario 2 — Multi-tool navigation:**
1. Ask: "How does budget management work?"
2. **Verify:** AI reads `ROUTING.md`, then navigates to relevant module's `FLOWS.md`, reads flow abstracts, then reads flow overviews. Multiple tool-use turns occur. Final answer cites specific flow files.

**Scenario 3 — Cross-module query:**
1. Ask: "Which modules depend on SmartExpenses?"
2. **Verify:** AI reads `routes/cross-module.md`. Answer includes dependency information.

**Scenario 4 — Provider switching:**
1. Switch from Claude API to Claude CLI in settings
2. Start a new conversation, ask a question
3. **Verify:** Response streams correctly from the CLI provider

**Scenario 5 — Conversation persistence:**
1. Have a multi-turn conversation (at least 3 exchanges)
2. Close the browser tab
3. Reopen `http://localhost:5173`
4. **Verify:** Conversation appears in sidebar, loads with full history including tool calls

**Scenario 6 — Error recovery:**
1. Configure an invalid API key
2. Send a message
3. **Verify:** Error event shows "Authentication failed" with guidance to check settings
4. Fix the API key in settings
5. Send another message
6. **Verify:** Works correctly

**Scenario 7 — KB unavailable:**
1. Start a conversation with a valid KB
2. Rename/move the KB folder
3. Send a message
4. **Verify:** Error message indicates KB folder not found, does not crash

**Scenario 8 — Confidence levels:**
1. Ask: "What is the business purpose of [module]?"
2. **Verify:** If the AI reads `INTERPRETATION.md`, the response flags that content as `inferred`. If reading from model export overviews, flags as `export-backed`.

### 6. Documentation

**`KnowledgeBase-Copilot/README.md`:**
- Project description (what it does, how it relates to the KB Creator)
- Prerequisites: Node.js 18+, npm, a generated KB, an AI provider (Claude API key or Claude CLI)
- Quick start:
  1. `cd KnowledgeBase-Copilot && npm install`
  2. `npm run dev`
  3. Open `http://localhost:5173`
  4. Configure AI provider in Settings
  5. Set KB path and validate
  6. Start chatting
- Architecture overview: monorepo structure, backend services, frontend components
- Configuration: `copilot-config.json` format, environment variables
- Reusable components: list of components designed for Studio Pro extraction

**`KnowledgeBase-Copilot/AGENTS.md`:**
- AI assistant entry point for the Copilot codebase
- Directory structure overview
- Key files and their purposes
- How to add new tools, modify the system prompt, or add UI components
- Reference to this prompt set for development history

### 7. Root `.gitignore` Update

Ensure the root `.gitignore` (or a local `KnowledgeBase-Copilot/.gitignore`) excludes:
- `node_modules/`
- `dist/`
- `copilot-config.json` (contains API keys)
- `conversations/` (user data, do not commit)

## Acceptance Criteria

1. All 8 integration test scenarios pass against a real KB.
2. Error states show user-friendly messages with actionable guidance.
3. Connection status indicator reflects actual WebSocket state.
4. Conversation export produces clean markdown.
5. Welcome screen shows with example questions.
6. `README.md` has complete setup instructions.
7. `AGENTS.md` provides a clear entry point for AI assistants.
8. `npm run dev` starts the full stack with a single command.

## Verification Steps

1. Run through all 8 integration test scenarios and document pass/fail.
2. Simulate errors: invalid API key, missing KB folder, disconnected WebSocket — verify each produces a clear user-facing message.
3. Export a conversation and verify the markdown is well-formatted.
4. Follow the README from scratch: clone, install, dev, configure, chat — verify a new user can get started.
5. Run `npm run build` — no errors.

## Exit Criteria

1. The copilot is usable end-to-end by a developer with a generated KB.
2. Error handling is graceful and actionable.
3. Documentation is complete.
4. The system prompt produces accurate, well-cited answers following the KB Reader agent pattern.

## Skill Suggestions

- **Tester** agent for integration test scenario execution.
- **Documenter** agent for README and AGENTS.md.
- **Security review** skill for final audit (API key handling, path sandbox, error messages).
