# PROMPT 05: React Frontend — Chat UI

## Priority

High — this prompt builds the user-facing chat interface with reusable components.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. Phase 4 deliverables — REST API and WebSocket endpoints in `backend/src/`
5. Shared types in `shared/src/types/` — all type definitions for messages, events, config
6. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/SettingsForm.cs` — reference for the AI settings UI pattern (radio buttons, conditional panels, model dropdown)

## Problem Statement

The frontend needs a responsive chat interface that streams AI responses in real-time, shows tool calls inline, and provides configuration panels for AI provider settings and KB folder selection. All components must be designed as self-contained, reusable units suitable for later embedding in a Mendix Studio Pro extension panel.

## Entry Criteria

1. Phase 4 complete — backend API and WebSocket working.
2. Frontend skeleton from Phase 1 exists and builds.

## Deliverable

### Design Principles

1. **Component isolation**: `ChatPanel` must accept dependencies via props/context. It must not import from `App.tsx` or use global state directly. This is essential for later extraction into a Mendix Studio Pro widget.
2. **Responsive layout**: At sidebar width (~400px), the conversation sidebar collapses to a hamburger menu and settings opens as a modal overlay. At full width, both can be shown alongside the chat.
3. **Streaming UX**: Text appears character-by-character as `text_delta` events arrive. Tool calls appear as collapsible blocks between text segments. Auto-scroll during streaming, but stop auto-scrolling if the user scrolls up.

### App Shell (`frontend/src/App.tsx`)

- Layout with three zones:
  1. **Left sidebar** — conversation list (collapsible)
  2. **Centre** — chat panel (always visible)
  3. **Right header area** — settings and KB picker buttons
- Resizable: toggle between sidebar width (~400px) and full width
- Responsive breakpoints: below 600px the sidebar hides behind a hamburger button
- State management: use React context for global state (config, current conversation, KB info)

### App Context (`frontend/src/context/AppContext.tsx`)

- `AppProvider` wrapping the app with:
  - `config: CopilotConfig` — loaded from `/api/config` on mount
  - `kbInfo: KBInfo | null` — validated KB info
  - `currentConversation: Conversation | null`
  - `conversations: ConversationMeta[]`
  - Methods: `updateConfig`, `selectConversation`, `createConversation`, `deleteConversation`, `setKbRoot`

### WebSocket Hook (`frontend/src/hooks/useWebSocket.ts`)

- `useWebSocket(url: string)` returning:
  - `connected: boolean`
  - `sendMessage(msg: WSClientMessage): void`
  - `cancel(): void`
  - `onEvent: (handler: (event: WSServerEvent) => void) => void`
- Auto-reconnect on disconnect (exponential backoff, max 5 retries)
- Connection state indicator (connected/reconnecting/disconnected)

### Conversation Hook (`frontend/src/hooks/useConversation.ts`)

- `useConversation(conversationId: string)` returning:
  - `messages: Message[]` — the full message list including streaming state
  - `isStreaming: boolean`
  - `sendMessage(content: string): void` — sends via WebSocket, appends user message optimistically
  - `cancel(): void`
- Handles incoming WebSocket events:
  - `text_delta` → append to current assistant message content
  - `tool_call` → add tool call block to current message
  - `tool_result` → add tool result block
  - `done` → mark streaming complete, reload conversation from API to sync persisted state

### REST API Client (`frontend/src/services/api.ts`)

Typed fetch wrappers for all backend endpoints:
- `getConfig()`, `saveConfig(config)`, `validateProvider()`, `detectCli(type)`
- `validateKb(path)`, `getKbInfo()`
- `getConversations()`, `getConversation(id)`, `createConversation(kbRoot?)`, `deleteConversation(id)`, `updateConversationTitle(id, title)`

### Chat Panel (`frontend/src/components/ChatPanel/ChatPanel.tsx`)

**This is the primary reusable component.** It must be self-contained.

- Props: `conversationId: string`, `kbInfo: KBInfo`
- Contains: `MessageList`, `ChatInput`
- Manages its own WebSocket connection via `useConversation`
- Shows an empty state when no messages: "Ask a question about your Mendix application..."
- Shows a "Connecting..." state when WebSocket is not yet connected

### Message List (`frontend/src/components/ChatPanel/MessageList.tsx`)

- Scrollable container for messages
- Auto-scroll to bottom during streaming
- Stop auto-scroll when user scrolls up (detect scroll position)
- Resume auto-scroll when user scrolls back to bottom
- Each message renders via `MessageRenderer` or `ToolCallRenderer` based on content type

### Chat Input (`frontend/src/components/ChatPanel/ChatInput.tsx`)

- Multi-line text area (auto-grows up to 6 lines)
- **Enter** sends the message, **Shift+Enter** inserts a newline
- Send button on the right side
- Disabled during streaming (shows a "Stop" button instead that calls `cancel()`)
- Placeholder text: "Ask about your Mendix application..."

### Message Renderer (`frontend/src/components/MessageRenderer/MessageRenderer.tsx`)

Renders a single message (user or assistant):

- **User messages**: Simple text bubble, right-aligned or left-aligned with label
- **Assistant messages**: Rendered markdown with:
  - Headings, paragraphs, lists, bold/italic
  - Code blocks with syntax highlighting (use a lightweight library like `highlight.js` or `prism` — keep the dependency small)
  - Inline code
  - KB file path references displayed as styled badges/links (e.g., `modules/Budget/README.md` shown with a file icon)
  - Confidence level badges: `export-backed` (green), `inferred` (amber), `unknown` (grey)
- Use `react-markdown` for markdown rendering with `remark-gfm` for GitHub-flavoured markdown tables

### Tool Call Renderer (`frontend/src/components/ToolCallRenderer/ToolCallRenderer.tsx`)

Renders tool call activity inline in the message stream:

- **Loading state**: Shows "Reading `<path>`..." with a spinner/pulse animation
- **Completed state**: Collapsible section with:
  - Header: tool icon + tool name + primary argument (e.g., "read_file — modules/Budget/README.md")
  - Collapsed by default after completion
  - Expandable body shows the (truncated) tool result content in a code block
- **Error state**: Red header with error message, expanded by default
- Visually distinct from chat messages (indented, lighter background, monospace for paths)

### Settings Panel (`frontend/src/components/SettingsPanel/SettingsPanel.tsx`)

Mirrors the wizard's `SettingsForm.cs` layout:

- Opens as a modal/dialog overlay
- **Provider selection**: Three radio buttons (Claude CLI, Codex CLI, Claude API)
- **Claude CLI panel** (shown when Claude CLI selected):
  - Text input for CLI path
  - "Auto detect" button (calls `POST /api/config/detect-cli`)
  - Status indicator (found/not found)
- **Codex CLI panel** (shown when Codex CLI selected):
  - Text input for CLI path
  - "Auto detect" button
  - Status indicator
- **Claude API panel** (shown when Claude API selected):
  - API key input with password masking
  - "Show/Hide" toggle
  - Model dropdown: `claude-sonnet-4-20250514`, `claude-haiku-4-5-20251001`, `claude-opus-4-6`
- **Test connection** button (calls `POST /api/config/validate-provider`)
- **Save / Cancel** buttons

### KB Picker (`frontend/src/components/KBPicker/KBPicker.tsx`)

- Text input for the KB folder path (browser security prevents true folder picking)
- "Validate" button that calls `POST /api/kb/validate`
- Status display:
  - **Valid**: green tick, shows app name and module count from `KBInfo`
  - **Invalid**: red cross, shows error message
  - **Unchecked**: grey, "Enter a path and click Validate"
- On successful validation, saves the path to config via `PUT /api/config`

### Conversation Sidebar (`frontend/src/components/ConversationSidebar/ConversationSidebar.tsx`)

- "New conversation" button at the top
- List of saved conversations showing: title, date, message count
- Click to load a conversation
- Delete button (with confirmation) on hover/swipe
- Currently active conversation is highlighted
- Sorted by most recent first

### Styling

- Use CSS modules (`.module.css` files co-located with components) for scoped styling
- Design tokens as CSS custom properties in a root `variables.css`:
  - `--color-primary`, `--color-bg`, `--color-surface`, `--color-text`, `--color-border`
  - `--color-confidence-export` (green), `--color-confidence-inferred` (amber), `--color-confidence-unknown` (grey)
  - `--radius-sm`, `--radius-md`
  - `--sidebar-width: 280px`, `--chat-max-width: 800px`
- Dark/light theme support via a `[data-theme]` attribute on the root element (optional, not required for Phase 5, but structure the CSS to support it)
- Font: system font stack (`-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, ...`)

## Acceptance Criteria

1. Chat UI sends messages and streams AI responses in real-time.
2. Tool calls render inline with collapsible result sections.
3. Settings panel allows switching between AI providers and saves config.
4. KB folder picker validates and displays KB info.
5. Conversation sidebar lists, loads, creates, and deletes conversations.
6. Layout is responsive between 400px sidebar width and full page width.
7. Markdown, code blocks, and tables render correctly in AI responses.
8. Auto-scroll works during streaming and pauses when user scrolls up.

## Verification Steps

1. Run `npm run dev` — both servers start. Open `http://localhost:5173`.
2. Open settings → configure Claude API with a valid API key → Save → test connection succeeds.
3. Open KB picker → enter path to `mendix-data/knowledge-base/` → Validate → shows app name and module count.
4. Create a new conversation → type "What does this application do?" → Enter.
5. Verify:
   - Text streams in real-time
   - Tool calls appear as collapsible blocks (e.g., "Reading ROUTING.md...")
   - Final answer includes markdown formatting and file references
6. Resize the browser to ~400px width → verify sidebar collapses, chat adapts.
7. Reload the page → verify the conversation persists and reloads.
8. Create a second conversation → switch between them → verify correct messages load.

## Exit Criteria

1. Full chat flow works end-to-end from the browser.
2. All components are self-contained and do not depend on global app state directly.
3. Responsive layout functions at both sidebar and full-page widths.
4. Settings and KB picker are fully functional.

## Skill Suggestions

- **Designer** agent for React component architecture and responsive layout.
- **Developer** agent for WebSocket hook and state management.
- **Tester** agent for responsive layout testing at different widths.
