# PROMPT 03: KB Navigator, Tool Execution, and System Prompt

## Priority

Critical — this is the core intelligence layer that connects AI tool calls to knowledge base files.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. `.app-info/agents/OVERVIEW_KB_READER.md` — the KB Reader agent pattern. The system prompt must encode this exact navigation workflow, confidence levels, and guardrails.
5. `KnowledgeBase-Creator/artifacts/templates/KNOWLEDGEBASE_READER.md` — the READER.md template embedded in every generated KB. The system prompt builder reads and includes this content.
6. A generated KB at `mendix-data/knowledge-base/` — examine its structure: `READER.md`, `ROUTING.md`, `app/`, `modules/`, `routes/`.

## Problem Statement

The Copilot backend needs three services:
1. A **KB Navigator** that provides sandboxed, read-only file access to the knowledge base.
2. A **Tool Executor** that maps AI tool calls to KB Navigator methods.
3. A **System Prompt Builder** that constructs the AI system prompt from KB content.
4. A **Conversation Service** that manages the tool-use loop (AI calls tool → execute → feed result → repeat).

## Entry Criteria

1. Phase 2 complete — AI provider service can send messages and stream responses with tool-use support.
2. A generated knowledge base exists at `mendix-data/knowledge-base/` (or another location) for testing.

## Deliverable

### Path Sandbox (`backend/src/services/kb-navigator/path-sandbox.ts`)

Security utility that prevents directory traversal:

- `validatePath(kbRoot: string, relativePath: string): string` — returns the resolved absolute path or throws `PathTraversalError`
- Resolution steps:
  1. Join `kbRoot` and `relativePath` using `path.resolve`
  2. Resolve the final path (follow symlinks with `fs.realpath`)
  3. Verify the resolved path starts with the resolved `kbRoot`
  4. Reject paths containing null bytes
  5. Reject absolute paths in `relativePath` (must be relative)
- Must handle Windows backslash paths and Unix forward slashes
- Throw a custom `PathTraversalError` with a safe message (do not leak the resolved path)

**Adversarial test cases** (must all be rejected):
- `../../etc/passwd`
- `..\..\windows\system32\config`
- `C:\absolute\path`
- `/absolute/path`
- `modules/../../../outside`
- Paths with null bytes: `modules/test\0.md`
- Symbolic links that point outside kbRoot

### KB Navigator Service (`backend/src/services/kb-navigator/index.ts`)

Read-only file access sandboxed to the KB root:

- `readFile(kbRoot: string, relativePath: string): Promise<string>`
  - Validates path via sandbox
  - Reads file as UTF-8
  - Truncates output to 10,000 characters with a `[truncated]` marker if exceeded
  - Throws `FileNotFoundError` if the file does not exist

- `listFiles(kbRoot: string, relativePath?: string): Promise<KBFileEntry[]>`
  - Validates path via sandbox (defaults to root if no relativePath)
  - Returns directory entries with: `name`, `path` (relative to kbRoot), `type` (`file` or `directory`), `size`
  - Does not recurse into subdirectories (single level only)
  - Sorts: directories first, then files, alphabetically

- `searchContent(kbRoot: string, query: string, relativePath?: string): Promise<KBSearchResult[]>`
  - Validates path via sandbox
  - Searches `.md` files only (skip `.json`, binary files)
  - Case-insensitive substring match
  - Returns up to 20 results, each with: `file` (relative path), `lineNumber`, `content` (the matching line, trimmed)
  - If `relativePath` is provided, search only within that subdirectory
  - Recursive search through subdirectories

### Tool Definitions (`backend/src/services/tool-executor/tool-definitions.ts`)

JSON Schema definitions for the three KB tools, in Anthropic tool-use format:

```typescript
const KB_TOOLS: ToolDefinition[] = [
  {
    name: 'read_file',
    description: 'Read a file from the knowledge base. Use relative paths from the KB root (e.g., "ROUTING.md", "modules/Budget/README.md", "routes/by-flow.md").',
    input_schema: {
      type: 'object',
      properties: {
        path: { type: 'string', description: 'Relative path to the file within the knowledge base' }
      },
      required: ['path']
    }
  },
  {
    name: 'list_files',
    description: 'List files and directories at a path in the knowledge base. Returns names, types, and sizes. Useful for exploring the KB structure.',
    input_schema: {
      type: 'object',
      properties: {
        path: { type: 'string', description: 'Relative path to the directory (empty string or "/" for KB root)' }
      },
      required: ['path']
    }
  },
  {
    name: 'search_content',
    description: 'Search for text content across knowledge base markdown files. Returns matching lines with file paths and line numbers. Use this to find specific entities, flows, or concepts.',
    input_schema: {
      type: 'object',
      properties: {
        query: { type: 'string', description: 'Text to search for (case-insensitive)' },
        path: { type: 'string', description: 'Optional: restrict search to this subdirectory (e.g., "modules/Budget")' }
      },
      required: ['query']
    }
  }
];
```

### Tool Executor Service (`backend/src/services/tool-executor/index.ts`)

Maps AI tool calls to KB Navigator methods:

- `executeTool(kbRoot: string, toolCall: ToolCall): Promise<ToolResult>`
  - Dispatches based on `toolCall.name`:
    - `read_file` → `kbNavigator.readFile(kbRoot, args.path)`
    - `list_files` → `kbNavigator.listFiles(kbRoot, args.path)` (format as readable text)
    - `search_content` → `kbNavigator.searchContent(kbRoot, args.query, args.path)` (format as readable text)
  - Catches errors and returns `ToolResult` with `isError: true` and a user-friendly message
  - Never exposes absolute paths or system details in error messages

- `executeTools(kbRoot: string, toolCalls: ToolCall[]): Promise<ToolResult[]>`
  - Executes multiple tool calls (a single AI turn may request several)
  - Runs them sequentially (not in parallel, to avoid filesystem contention on large searches)

### System Prompt Builder (`backend/src/services/system-prompt/index.ts`)

Constructs the AI system prompt from KB content:

- `buildSystemPrompt(kbRoot: string): Promise<string>`
  1. Read `READER.md` from `kbRoot` — this is the primary navigation guide
  2. Read `ROUTING.md` from `kbRoot` — the quick-lookup routing table
  3. Construct the system prompt with these sections:
     - **Role**: "You are a KB Reader assistant for a Mendix application knowledge base. You answer architecture, functionality, and implementation questions by reading KB files using the provided tools."
     - **Navigation instructions**: Embed the content of READER.md (this teaches the AI how to navigate)
     - **Routing table**: Embed the content of ROUTING.md (this gives the AI the module/route index)
     - **Tool usage rules**: "Always use the read_file tool to read KB files. Never guess at file contents. Start with ROUTING.md to locate the right document, then follow the L0→L1→L2 navigation pattern."
     - **Confidence framework** (from `OVERVIEW_KB_READER.md`):
       - `export-backed` — data from model export (L1/L2), treat as fact
       - `inferred` — derived from naming conventions or patterns
       - `unknown` — data not available, flag explicitly
     - **Output format**: Answers should include evidence (file paths), confidence level, and gaps found
     - **Guardrails**: Do not invent behaviour. Prefer exact file references. Distinguish facts from interpretation.

### Conversation Service (`backend/src/services/conversation/index.ts`)

Manages the multi-turn tool-use loop:

- `processMessage(settings: AiSettings, kbRoot: string, conversation: Conversation, userMessage: string, onEvent: (event: WSServerEvent) => void, signal?: AbortSignal): Promise<Message[]>`
  1. Add the user message to the conversation
  2. Build the system prompt via `SystemPromptBuilder`
  3. Send to AI provider with tool definitions
  4. Collect the streaming response:
     - Forward `text_delta` chunks to `onEvent` as they arrive
     - When a `tool_use` block completes, forward a `tool_call` event to `onEvent`
     - Execute the tool via `ToolExecutorService`
     - Forward the `tool_result` event to `onEvent`
  5. If the AI response contains tool-use blocks (stop_reason = `tool_use`):
     - Append the assistant message (with tool_use blocks) to conversation
     - Append the tool results as a new message
     - Send the updated conversation back to the AI provider (loop)
  6. Repeat until the AI returns a text-only response (stop_reason = `end_turn`)
  7. Forward a `done` event with usage statistics
  8. Return all new messages (assistant + tool results) to be persisted
  9. Limit tool-use loops to a maximum of 20 iterations (prevent infinite loops)

## Acceptance Criteria

1. Path sandbox rejects all adversarial test cases listed above.
2. `readFile` correctly reads KB files and returns content.
3. `listFiles` returns accurate directory listings sorted correctly.
4. `searchContent` finds text matches across KB markdown files.
5. Tool executor correctly dispatches all three tool types.
6. System prompt builder reads READER.md and ROUTING.md and constructs a coherent prompt.
7. Conversation service handles a multi-turn tool-use loop where the AI reads multiple KB files to answer a question.
8. The tool-use loop terminates correctly (either text response or max iterations).

## Verification Steps

1. Write unit tests for `path-sandbox.ts` with all adversarial cases.
2. Test `readFile` against the real KB: read `READER.md`, read `modules/` subdirectories, read a flow abstract.
3. Test `searchContent`: search for "Budget" across the KB, verify results include relevant module files.
4. Test the full conversation loop: send "What does this application do?" with a real KB root, verify:
   - AI issues tool calls to read KB files
   - Tool results are fed back correctly
   - Final response references specific KB files
5. Run `npm run build` — no TypeScript errors.

## Exit Criteria

1. All KB navigator methods work correctly against a real knowledge base.
2. Path sandbox is tested and secure.
3. The tool-use loop completes a full conversation with multiple tool calls.
4. System prompt correctly embeds KB content.

## Skill Suggestions

- **Security review** skill for path sandbox testing.
- **Developer** agent for service implementation.
- **Tester** agent for adversarial path tests and integration scenarios.
