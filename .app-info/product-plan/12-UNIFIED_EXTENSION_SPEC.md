# Unified Mendix Studio Pro Extension — Requirements Specification

## Objective

Consolidate the KB Copilot, KB Creator, and Mendix Development tooling into a single Mendix Studio Pro C# extension. Eliminate the external Node.js runtime dependency. Package for distribution via the Mendix Marketplace.

## Target Platform

- **Mendix Studio Pro:** 10.24+ (ExtensionsAPI v10.24.x)
- **Runtime:** .NET 8.0 (single self-contained DLL)
- **Frontend:** React 18 + TypeScript SPA (bundled as static assets inside the extension)

## Architecture Overview

```
┌─────────────────────────────────────────────────────┐
│                 Mendix Studio Pro                     │
│  ┌───────────────────────────────────────────────┐   │
│  │       Unified Extension (C# DLL)              │   │
│  │                                               │   │
│  │  ┌─────────────┐  ┌────────────────────────┐ │   │
│  │  │ MenuExtension│  │ DockablePaneExtension  │ │   │
│  │  │ (entry point)│  │ (WebView host)         │ │   │
│  │  └─────────────┘  └────────────────────────┘ │   │
│  │                                               │   │
│  │  ┌────────────────────────────────────────┐   │   │
│  │  │         WebServerExtension             │   │   │
│  │  │  (serves React SPA + API routes)       │   │   │
│  │  │                                        │   │   │
│  │  │  /                → index.html (SPA)   │   │   │
│  │  │  /assets/*        → JS/CSS bundles     │   │   │
│  │  │  /api/chat        → AI chat endpoint   │   │   │
│  │  │  /api/kb/*        → KB navigator       │   │   │
│  │  │  /api/config      → Settings           │   │   │
│  │  │  /api/creator/*   → KB Creator         │   │   │
│  │  │  /api/mx/*        → mx CLI bridge      │   │   │
│  │  └────────────────────────────────────────┘   │   │
│  │                                               │   │
│  │  ┌──────────────────────────────────────┐     │   │
│  │  │           Core Services (C#)         │     │   │
│  │  │                                      │     │   │
│  │  │  • AIProviderService                 │     │   │
│  │  │  • ConversationService               │     │   │
│  │  │  • KBNavigator                       │     │   │
│  │  │  • QuestionClassifier                │     │   │
│  │  │  • SystemPromptBuilder               │     │   │
│  │  │  • KBCreatorPipeline                 │     │   │
│  │  │  • MxCliService                      │     │   │
│  │  │  • ConfigService                     │     │   │
│  │  └──────────────────────────────────────┘     │   │
│  └───────────────────────────────────────────────┘   │
│                                                       │
│  ┌───────────────────────────────────────────────┐   │
│  │              WebView (Chromium)                │   │
│  │  ┌─────────────────────────────────────────┐  │   │
│  │  │          React SPA (Tabbed UI)          │  │   │
│  │  │                                         │  │   │
│  │  │  [Copilot] [Creator] [Developer]        │  │   │
│  │  │                                         │  │   │
│  │  │  Tab 1: Chat UI (KB Q&A)               │  │   │
│  │  │  Tab 2: KB Creator wizard               │  │   │
│  │  │  Tab 3: Mendix dev tools (mx CLI)       │  │   │
│  │  └─────────────────────────────────────────┘  │   │
│  └───────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

## Communication Pattern

### WebView Message Bridge (replaces HTTP + WebSocket)

The current architecture uses HTTP REST + WebSocket between the React frontend and Node.js backend. The unified extension replaces this with the Studio Pro WebView message bridge:

| Direction | Current | New |
|---|---|---|
| Frontend → Backend | `fetch('/api/...')` + `new WebSocket('/ws')` | `chrome.webview.postMessage(json)` |
| Backend → Frontend | WebSocket events | `webView.PostMessageAsJsonAsync(json)` |
| Streaming | WebSocket `text_delta` events | Chunked `postMessage` calls from C# |

**Message Protocol:**

```typescript
// Frontend → C# (request)
interface BridgeRequest {
  id: string;          // correlation ID
  type: 'chat' | 'kb' | 'creator' | 'mx' | 'config';
  action: string;      // e.g. 'sendMessage', 'readFile', 'runPipeline'
  payload: unknown;
}

// C# → Frontend (response / stream)
interface BridgeResponse {
  id: string;          // correlates to request
  type: 'result' | 'stream' | 'error';
  payload: unknown;
}
```

**Frontend adapter layer:** A `BridgeClient` class wraps `chrome.webview.postMessage()` and exposes the same async interface as the current HTTP/WS clients. This isolates the transport change from React components.

### Fallback: WebServerExtension HTTP

For scenarios where the WebView message bridge is insufficient (e.g., large file transfers, SSE streaming), the extension can use `IWebServer.AddRoute()` to serve HTTP endpoints. The `WebServerBaseUrl` property provides the base URL. This is a fallback — prefer the message bridge for most operations.

## Feature Areas

### Feature 1: KB Copilot (Port from Node.js)

Port the existing TypeScript backend services to C#. The frontend React SPA remains largely unchanged (transport layer swap only).

**Services to port:**

| TypeScript Service | C# Equivalent | Notes |
|---|---|---|
| `AIProviderService` | `AIProviderService` | Claude CLI + Codex CLI process spawning. Same `stdin/stdout` streaming pattern. |
| `ConversationService` | `ConversationService` | Agentic tool loop (max 8 iterations). Token optimization (compression + windowing). |
| `KBNavigator` | `KBNavigator` | File read/list/search against KB root. Path sandbox validation. |
| `QuestionClassifier` | `QuestionClassifier` | Regex/heuristic classifier. Artifact index from route files. |
| `SystemPromptBuilder` | `SystemPromptBuilder` | Dynamic system prompt with classification hints. |
| `ToolExecutor` | `ToolExecutor` | Dispatch read_file, list_files, search_content tools. |
| `ConversationStore` | `ConversationStore` | JSON file persistence in app directory. |
| `ConfigService` | `ConfigService` | `copilot-config.json` read/write. |

**Key port considerations:**

1. **CLI process management:** Use `System.Diagnostics.Process` with async stdout/stderr reading for Claude CLI and Codex CLI.
2. **Streaming:** The agentic loop streams `text_delta` events. In C#, use `PostMessageAsJsonAsync` for each chunk.
3. **Path sandbox:** Port `validatePath()` logic using `Path.GetFullPath()` + prefix check.
4. **Conversation persistence:** Same JSON-per-conversation model, stored in `{mendixAppDir}/kb-copilot/conversations/`.
5. **Markdown search:** Port the recursive markdown content search (currently `searchRecursive` in KBNavigator).

### Feature 2: KB Creator (Integrate Existing C# Pipeline)

The KB Creator pipeline is already C#. Integration means exposing the existing pipeline steps as extension API endpoints.

**Existing pipeline (from `KnowledgeBase-Creator/`):**

1. `mx dump-mpr` → raw Mendix model export
2. `ModelOverviewCli` → structured JSON (app-overview)
3. Scaffold → KB folder structure
4. Compose → markdown KB files
5. Validate → quality gates

**Integration approach:**

- Reference the existing C# projects as project dependencies (or embed compiled assemblies).
- Expose pipeline steps via the message bridge:
  - `creator.runFull` — run complete pipeline
  - `creator.runStep` — run individual step (dump, parse, scaffold, compose, validate)
  - `creator.getStatus` — pipeline progress events
  - `creator.getConfig` — pipeline configuration

**Frontend (Creator tab):**

- Wizard-style UI matching current `KnowledgeBaseCreator.Wizard` flow
- Step progress visualization
- Log output streaming
- Configuration form (MPR path, output directory, options)

**Key considerations:**

1. **MPR path:** The extension runs inside Studio Pro, which knows the current app's MPR path. Auto-detect via `ICurrentApp` or equivalent ExtensionsAPI.
2. **Output directory:** Default to `{mendixAppDir}/mendix-data/knowledge-base/`.
3. **Long-running operations:** Pipeline steps can take minutes. Use background tasks with progress reporting via message bridge.

### Feature 3: Mendix Development (mx CLI Bridge)

Expose Mendix `mx` CLI commands through the extension for AI-assisted development.

**mx CLI capabilities to expose:**

| Command | Purpose | UI Surface |
|---|---|---|
| `mx dump-mpr` | Export model data | Creator tab (pipeline step 1) |
| `mx create-entity` | Create domain model entity | Developer tab |
| `mx create-microflow` | Create microflow | Developer tab |
| `mx create-page` | Create page | Developer tab |
| `mx check` | Run consistency checks | Developer tab |
| `mx show-version` | Show runtime version | Settings/status |

**Architecture:**

```csharp
public class MxCliService
{
    private readonly string _mxPath;  // auto-detected or configured

    public async Task<MxResult> RunCommandAsync(
        string command,
        string[] args,
        string workingDirectory,
        CancellationToken ct);

    public async Task<string> GetVersionAsync();
    public bool IsAvailable { get; }
}
```

**Key considerations:**

1. **mx CLI location:** Auto-detect from Studio Pro installation path or `PATH`.
2. **MPR locking:** Studio Pro locks the MPR file. Some `mx` commands require the file to be unlocked. The extension must coordinate with Studio Pro's file locking.
3. **Model refresh:** After `mx` modifies the model, Studio Pro needs to reload. Investigate ExtensionsAPI for triggering model refresh.
4. **AI integration:** The Copilot's agentic loop can invoke mx CLI commands as tools, enabling AI-assisted Mendix development (e.g., "Create an entity called Invoice with attributes Name, Amount, Date").

## Frontend Structure

### Tabbed SPA Layout

```
┌──────────────────────────────────────────────┐
│  [🤖 Copilot]  [📦 Creator]  [🔧 Developer] │
├──────────────────────────────────────────────┤
│                                              │
│  (Active tab content area)                   │
│                                              │
│  Copilot tab:                                │
│    - Conversation list sidebar               │
│    - Chat messages with markdown rendering   │
│    - Tool call/result indicators             │
│    - Message input with send button          │
│                                              │
│  Creator tab:                                │
│    - Pipeline step selector                  │
│    - Configuration form                      │
│    - Progress bar / step indicators          │
│    - Log output panel                        │
│                                              │
│  Developer tab:                              │
│    - Command palette / action cards          │
│    - Parameter forms per command             │
│    - Output / result panel                   │
│    - AI-assisted mode toggle                 │
│                                              │
└──────────────────────────────────────────────┘
```

### Frontend Tech Stack (retained)

- **React 18** + TypeScript
- **Vite** (build tool, outputs static assets)
- **react-markdown** + remark-gfm (markdown rendering)
- **highlight.js** (code syntax highlighting)

### Transport Adapter

```typescript
// bridge-client.ts — replaces current HTTP + WebSocket clients
class BridgeClient {
  private pending = new Map<string, { resolve, reject, onStream? }>();

  constructor() {
    window.chrome.webview.addEventListener('message', this.onMessage);
  }

  async request<T>(type: string, action: string, payload?: unknown): Promise<T> { ... }

  stream(type: string, action: string, payload: unknown, onChunk: (data) => void): AbortHandle { ... }

  private onMessage = (event: MessageEvent) => { ... };
}

export const bridge = new BridgeClient();
```

## Configuration Schema

```json
{
  "ai": {
    "provider": "claude-cli | codex-cli",
    "model": "string (optional, provider default)",
    "maxToolLoops": 8,
    "historyWindowSize": 10
  },
  "kb": {
    "root": "string (auto-detected from app dir)",
    "maxFileLength": 5000,
    "maxSearchResults": 10
  },
  "creator": {
    "outputDir": "mendix-data/knowledge-base",
    "mprPath": "string (auto-detected)",
    "parserPath": "string (bundled or configured)",
    "skipModules": ["string[]"]
  },
  "mx": {
    "cliPath": "string (auto-detected or configured)",
    "timeout": 60000
  }
}
```

**Storage location:** `{mendixAppDir}/kb-copilot/config.json`

## Packaging and Distribution

### Mendix Marketplace Requirements

| Requirement | Status | Notes |
|---|---|---|
| **Licence** | MIT or Apache 2.0 | No GPL v3 (Marketplace restriction) |
| **Security review** | Required | Mendix QSM (Quality & Security Management) review |
| **Documentation** | Required | Usage guide, screenshots, prerequisites |
| **Package format** | DLL + manifest.json | Single extension package |
| **Target SP version** | 10.24+ | Declared in manifest |
| **Dependencies** | Self-contained | No external runtime (Node.js eliminated) |

### Extension Package Structure

```
kb-extension/
├── manifest.json
├── KbExtension.dll              (main extension + all dependencies)
├── frontend/                    (embedded or as resources)
│   ├── index.html
│   └── assets/
│       ├── index-[hash].js
│       └── index-[hash].css
├── tools/                       (bundled binaries)
│   └── ModelOverviewCli.exe     (KB Creator parser)
└── README.md                    (Marketplace description)
```

### manifest.json

```json
{
  "mx_extensions": ["KbExtension.dll"],
  "mx_build_extensions": []
}
```

## Migration Path

### Phase 1: Self-Contained Backend (Current → WebServerExtension)

- Port Node.js backend services to C# within the extension.
- Use `WebServerExtension` to serve the React SPA and HTTP API routes.
- WebView loads `WebServerBaseUrl` instead of `localhost:3001`.
- **Result:** No external Node.js process needed. Extension is self-contained.

### Phase 2: Message Bridge (HTTP → PostMessage)

- Replace HTTP fetch calls with `chrome.webview.postMessage()`.
- Replace WebSocket streaming with chunked `PostMessageAsJsonAsync()`.
- Keep HTTP routes as fallback for large payloads.
- **Result:** Lower latency, no port conflicts, cleaner architecture.

### Phase 3: KB Creator Integration

- Embed KB Creator pipeline as project references.
- Add Creator tab to frontend SPA.
- Auto-detect MPR path from Studio Pro context.
- **Result:** One-click KB generation from within Studio Pro.

### Phase 4: mx CLI Integration

- Add MxCliService for command execution.
- Add Developer tab with command palette.
- Integrate mx CLI as Copilot tools for AI-assisted development.
- **Result:** AI can create entities, microflows, pages via natural language.

### Phase 5: Marketplace Publication

- Licence audit (ensure MIT/Apache 2.0 compliance for all dependencies).
- Security review preparation (QSM submission).
- Documentation, screenshots, demo video.
- **Result:** Published on Mendix Marketplace.

## Risks and Mitigations

| # | Risk | Impact | Mitigation |
|---|---|---|---|
| R1 | ExtensionsAPI WebView limitations | High | Prototype message bridge early. Fall back to WebServerExtension HTTP if needed. |
| R2 | CLI process spawning blocked by Studio Pro sandbox | High | Test `System.Diagnostics.Process` in extension context early. May need to use ExtensionsAPI process APIs if available. |
| R3 | MPR file locking conflicts with mx CLI | Medium | Coordinate with Studio Pro's lock management. Some commands may require "save and close" workflow. |
| R4 | Large C# DLL size with all dependencies | Medium | Use ILMerge or single-file publish. Strip debug symbols. Target specific runtime. |
| R5 | Marketplace security review rejection | Medium | Audit all dependencies. Remove any GPL v3 transitive deps. Document all external process invocations. |
| R6 | Streaming latency via message bridge | Low | Benchmark message bridge throughput. Fall back to SSE via WebServerExtension if needed. |
| R7 | Studio Pro version compatibility | Medium | Target 10.24+ only. Pin ExtensionsAPI NuGet version. Test against each minor release. |

## Success Criteria

1. Extension loads in Studio Pro 10.24+ without external processes.
2. KB Copilot chat works with same quality as current Node.js version.
3. KB Creator pipeline runs from within Studio Pro via Creator tab.
4. mx CLI commands execute from Developer tab.
5. AI can invoke mx CLI commands as tools during Copilot conversations.
6. Extension published on Mendix Marketplace.
7. Cold start (extension load to first interaction) under 3 seconds.

## Out of Scope

1. Mendix IModel API integration (using mx CLI instead).
2. MCP server/client integration (using mx CLI instead).
3. Multi-user / collaborative features.
4. Cloud-hosted AI providers (CLI-only for now — Claude CLI, Codex CLI).
5. Mobile / web Mendix Studio support (Studio Pro desktop only).
