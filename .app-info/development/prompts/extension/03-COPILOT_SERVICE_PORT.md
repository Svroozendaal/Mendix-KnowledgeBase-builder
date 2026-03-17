# PROMPT 03: KB Copilot Service Port (TypeScript → C#)

## Priority

Critical — this is the core feature. Copilot must work before any other feature area.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — architecture overview.
2. Phase 01 + 02 output — WebServerExtension + message bridge.
3. `KnowledgeBase-Copilot/backend/src/services/` — all TypeScript services to port.
4. `KnowledgeBase-Copilot/backend/src/services/conversation/index.ts` — agentic loop (552 lines).
5. `KnowledgeBase-Copilot/backend/src/services/ai-provider/` — CLI provider implementations.
6. `KnowledgeBase-Copilot/backend/src/services/system-prompt/index.ts` — prompt builder.
7. `KnowledgeBase-Copilot/backend/src/services/question-classifier/index.ts` — classifier.
8. `KnowledgeBase-Copilot/backend/src/services/kb-navigator/index.ts` — KB file access.
9. `KnowledgeBase-Copilot/backend/src/services/tool-executor/` — tool dispatch.

## Problem Statement

Port all KB Copilot backend services from TypeScript to C# and wire them into the message bridge from Phase 02. The React frontend should be able to hold the same conversations as before, but now powered by C# instead of Node.js.

## Deliverable

### 1. AIProviderService (C#)

Port the CLI provider pattern. The extension spawns `claude` or `codex` CLI processes and communicates via stdin/stdout.

```csharp
public class AIProviderService
{
    public IAsyncEnumerable<StreamChunk> SendMessageAsync(
        AiSettings settings,
        AIProviderOptions options,
        CancellationToken ct);

    public Task<ValidationResult> ValidateProviderAsync(AiSettings settings);
    public CliDetectionResult DetectCli(string type); // "claude" | "codex"
}
```

**Key implementation details:**
- Use `System.Diagnostics.Process` with `RedirectStandardInput/Output`.
- Parse streaming JSON from stdout (same `StreamChunk` model as TypeScript).
- Handle process lifecycle: start, cancel (kill), timeout.
- Map exit codes and stderr to `CliNotFoundError`, `AuthenticationError`, `ProviderError`.

### 2. ConversationService (C#)

Port the agentic tool loop. This is the most complex service.

**Constants:**
- `MAX_TOOL_LOOPS = 8`
- `HISTORY_WINDOW_SIZE = 10`
- `MAX_PREFETCH_FILES = 2`

**Port these methods:**
1. `ProcessMessageAsync()` — main entry point:
   - Seed KB context (first turn only).
   - Question classification + pre-fetch.
   - Build system prompt.
   - Agentic loop: send to AI → collect stream → execute tools → loop.
2. `BuildApiView()` — token optimization:
   - `CompressOldToolResults()` — keep last 2 tool results, summarize older.
   - `WindowMessages()` — if > 10 messages, replace old with summary.
3. `SeedKbContext()` — load READER.md + ROUTING.md as synthetic tool messages.
4. `PrefetchContext()` — pre-fetch KB files for direct-lookup questions.
5. `CollectStream()` — parse streaming response into Message + ToolCall structures.

**Event streaming via message bridge:**
- Replace WebSocket events with `IResponseStream.SendChunkAsync()`.
- Same event types: `text_delta`, `tool_call`, `tool_result`, `error`, `done`.

### 3. KBNavigator (C#)

```csharp
public class KBNavigator
{
    public const int MaxFileLength = 5000;
    public const int MaxSearchResults = 10;

    public Task<string> ReadFileAsync(string kbRoot, string relativePath);
    public Task<KBFileEntry[]> ListFilesAsync(string kbRoot, string? relativePath);
    public Task<KBSearchResult[]> SearchContentAsync(string kbRoot, string query, string? relativePath);
}
```

**Port path sandbox:**
- `ValidatePath()` using `Path.GetFullPath()` + `StartsWith()` check.
- Reject null bytes, absolute paths in relative portion.
- Follow symlinks via `FileInfo.ResolveLinkTarget()`.

### 4. QuestionClassifier (C#)

Port the regex/heuristic classifier:
- Parse route index files (by-entity.md, by-page.md, by-flow.md) into artifact maps.
- Extract `US\d+` / user story patterns.
- Match artifact names (case-insensitive, word-boundary).
- Return `ClassificationResult` with category, artifacts, suggested searches, confidence.

### 5. SystemPromptBuilder (C#)

Port the dynamic system prompt:
- Same prompt structure (role, navigation strategy, tool rules, confidence framework, output format).
- Adapt tool rules based on provider type (CLI tools vs custom tools).
- Inject classification hint when provided.

### 6. ToolExecutor (C#)

```csharp
public class ToolExecutor
{
    public Task<ToolResult[]> ExecuteToolsAsync(string kbRoot, ToolCall[] toolCalls);
}
```

Tools: `read_file`, `list_files`, `search_content` — dispatch to KBNavigator.

### 7. ConversationStore (C#)

Port JSON file persistence:
- Storage: `{mendixAppDir}/kb-copilot/conversations/{id}.json`
- CRUD: create, load, save, delete, list, updateTitle.
- Sort by `updatedAt` descending.

### 8. ConfigService (C#)

Port config file read/write:
- File: `{mendixAppDir}/kb-copilot/config.json`
- Default settings for AI provider, KB root, etc.

### 9. Message Handlers

Wire all services into the Phase 02 message router:

```csharp
// ChatMessageHandler
"chat" / "sendMessage"   → ConversationService.ProcessMessageAsync (streaming)
"chat" / "cancel"        → CancellationToken.Cancel()

// KbMessageHandler
"kb" / "readFile"        → KBNavigator.ReadFileAsync
"kb" / "listFiles"       → KBNavigator.ListFilesAsync
"kb" / "searchContent"   → KBNavigator.SearchContentAsync

// ConfigMessageHandler
"config" / "load"        → ConfigService.LoadConfig
"config" / "save"        → ConfigService.SaveConfig
"config" / "health"      → { status: "ok" }

// ConversationMessageHandler
"conversation" / "list"          → ConversationStore.ListConversations
"conversation" / "load"          → ConversationStore.LoadConversation
"conversation" / "create"        → ConversationStore.CreateConversation
"conversation" / "delete"        → ConversationStore.DeleteConversation
"conversation" / "updateTitle"   → ConversationStore.UpdateTitle
```

## Exit Criteria

1. Full chat conversation works in Studio Pro (same quality as Node.js version).
2. Tool loop executes up to 8 iterations with KB file access.
3. Question classification pre-fetches context for direct-lookup questions.
4. Token optimization (compression + windowing) reduces context size for long conversations.
5. Conversation persistence works (create, load, list, delete).
6. Config load/save works.
7. Streaming text appears incrementally in the UI.
8. `dotnet build` succeeds. Manual test in Studio Pro passes.

## Risks

| Risk | Mitigation |
|---|---|
| CLI process spawning blocked in extension context | Test `Process.Start` early. Check Studio Pro sandbox restrictions. |
| JSON streaming parsing differences between TS/C# | Use `System.Text.Json` with `JsonDocument.Parse` for streaming chunks. Test with real CLI output. |
| Async enumerable complexity | Use `IAsyncEnumerable<StreamChunk>` with `Channel<T>` for buffered producer/consumer. |
