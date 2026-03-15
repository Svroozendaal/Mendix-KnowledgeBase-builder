# PROMPT 02: AI Provider Service

## Priority

Critical — this is the core service that all AI interactions flow through.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/development/prompts/copilot/INDEX.md`
4. `KnowledgeBase-Creator/wizard/lib/ai-provider.ps1` — the PowerShell reference implementation. The TypeScript version must match its provider selection, CLI resolution, error code semantics, and streaming output parsing.
5. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/WizardRuntime.cs` — `DetectClaudeCli()` and `DetectCodexCli()` methods for CLI path resolution logic, and the `AiSettings` class for the data model.
6. `KnowledgeBase-Creator/wizard/src/KnowledgeBaseCreator.Wizard/SettingsForm.cs` — model dropdown values: `claude-sonnet-4-20250514`, `claude-haiku-4-5-20251001`, `claude-opus-4-6`.

## Problem Statement

The Copilot backend needs a TypeScript AI provider abstraction that mirrors the wizard's PowerShell `ai-provider.ps1`. It must support all three providers (Claude CLI, Codex CLI, Claude API), produce streaming output, handle tool-use blocks, and follow the same exit-code contract.

## Entry Criteria

1. Phase 1 complete — shared types compiled, backend skeleton running.
2. Shared types for `AiProvider`, `AiSettings`, `ToolCall`, and `ToolResult` exist in `@kb-copilot/shared`.

## Deliverable

### CLI Resolver (`backend/src/services/ai-provider/cli-resolver.ts`)

Finds CLI executables on the system, mirroring `WizardRuntime.DetectClaudeCli()` and `DetectCodexCli()`:

- **Claude CLI resolution order:**
  1. Explicit path from config (if provided and exists)
  2. `where claude` / `which claude` (platform-aware)
  3. Common locations:
     - Windows: `%LOCALAPPDATA%\Programs\claude\claude.exe`, `%APPDATA%\npm\claude.cmd`, `%LOCALAPPDATA%\Microsoft\WinGet\Links\claude.exe`
     - macOS/Linux: standard PATH locations
  4. Prefer `.cmd` shim over extensionless scripts on Windows (matches `WizardRuntime.cs` line ~530)

- **Codex CLI resolution order:**
  1. Explicit path from config
  2. `where codex` / `which codex`
  3. `%APPDATA%\npm\codex.cmd` (Windows)

- Returns the resolved path or `null` if not found.

### Provider Interface (`backend/src/services/ai-provider/types.ts`)

```typescript
interface AIProviderOptions {
  messages: Message[];
  systemPrompt: string;
  tools?: ToolDefinition[];
  maxTokens?: number;
  onCancel?: AbortSignal;
}

interface StreamChunk {
  type: 'text_delta' | 'tool_use_start' | 'tool_use_delta' | 'tool_use_end' | 'message_stop' | 'error';
  // Fields vary by type — text, toolCallId, toolName, partialJson, usage, etc.
}

interface AIProvider {
  sendMessage(options: AIProviderOptions): AsyncIterable<StreamChunk>;
  validateConfig(settings: AiSettings): Promise<{ valid: boolean; error?: string }>;
}
```

### Claude CLI Provider (`backend/src/services/ai-provider/claude-cli.provider.ts`)

- Spawns the Claude CLI process with flags: `--print --output-format stream-json --max-turns 1`
- Passes the system prompt via `--system-prompt` flag
- Passes tool definitions — use `--allowedTools` with custom tool names, or embed tool schemas in the system prompt if Claude CLI does not support custom tool schemas directly
- Parses `stream-json` output line by line (matching `Read-StreamJsonLine` from `ai-provider.ps1`):
  - Lines are JSON objects with a `type` field
  - `content_block_delta` with `delta.type === 'text_delta'` → yield text chunk
  - `content_block_start` with `content_block.type === 'tool_use'` → yield tool_use_start
  - `content_block_delta` with `delta.type === 'input_json_delta'` → yield tool_use_delta
  - `content_block_stop` → yield tool_use_end
  - `message_stop` → yield message_stop
- Handles process exit codes matching the contract: 0=success, non-zero mapped to 2/3/4/1
- Supports cancellation via `AbortSignal` → kills the child process

### Codex CLI Provider (`backend/src/services/ai-provider/codex-cli.provider.ts`)

- Spawns Codex CLI with flags: `-q --full-auto`
- Passes prompt as stdin or argument (match `Invoke-CodexCli` from `ai-provider.ps1`)
- Parses output — Codex CLI output format may differ; parse line-by-line and yield text chunks
- Note: Codex CLI may not support tool-use natively. If not, tool definitions should be embedded in the system prompt and tool_use blocks parsed from the text output.

### Claude API Provider (`backend/src/services/ai-provider/claude-api.provider.ts`)

- HTTP POST to `https://api.anthropic.com/v1/messages` with `stream: true`
- Request headers: `x-api-key`, `anthropic-version: 2023-06-01`, `content-type: application/json`
- Request body includes: `model` (from config), `max_tokens`, `system` (system prompt), `messages`, `tools` (tool definitions in Anthropic format), `stream: true`
- Parses SSE stream (Server-Sent Events):
  - `event: content_block_delta` with `data.delta.type === 'text_delta'` → yield text
  - `event: content_block_start` with `data.content_block.type === 'tool_use'` → yield tool_use_start
  - `event: content_block_delta` with `data.delta.type === 'input_json_delta'` → yield tool_use_delta
  - `event: content_block_stop` → yield tool_use_end
  - `event: message_stop` → yield message_stop with usage data
  - `event: error` → yield error chunk
- API key is read from config, never logged (mask to first 12 chars + "..." in any debug output)
- Model defaults: `claude-sonnet-4-20250514`

### Provider Service (`backend/src/services/ai-provider/index.ts`)

- `AIProviderService` class that selects the correct provider based on `AiSettings.provider`
- `sendMessage(settings, options)` → delegates to the appropriate provider
- `validateProvider(settings)` → tests connectivity (send a minimal "hello" message)
- `detectCli(type: 'claude' | 'codex')` → uses CLI resolver to find executables

## Exit-Code / Error Contract

Match the PowerShell contract from `ai-provider.ps1`:

| Code | Meaning | TypeScript Error |
|---|---|---|
| 0 | Success | — |
| 2 | CLI not found / not installed | `CliNotFoundError` |
| 3 | Authentication failure | `AuthenticationError` |
| 4 | API error (rate limit, bad key) | `ApiError` |
| 1 | Other / unknown | `ProviderError` |

Define these as custom error classes in `backend/src/services/ai-provider/errors.ts`.

## Acceptance Criteria

1. CLI resolver finds Claude CLI on the current machine (if installed).
2. Claude API provider sends a simple message and streams the response (requires API key).
3. Claude CLI provider sends a simple message and streams the response (requires CLI installed).
4. Tool definitions are included in requests and `tool_use` blocks are correctly yielded as `StreamChunk` objects.
5. Error classes match the exit-code contract.
6. API key is never logged or exposed in error messages.

## Verification Steps

1. Write a small test script in `backend/src/test-provider.ts` that:
   - Loads config from `copilot-config.json` (or falls back to defaults)
   - Sends "Say hello in one sentence" to the configured provider
   - Logs each streamed chunk type and content
   - Verifies the response completes with a `message_stop` chunk
2. Run `npm run build` — no TypeScript errors.
3. Test CLI detection: run the resolver and confirm it finds/does not find the CLI as expected.

## Exit Criteria

1. All three provider implementations exist and compile.
2. At least one provider (Claude API or Claude CLI) is verified working end-to-end with streaming.
3. Tool-use blocks are correctly parsed from the stream.
4. Custom error classes are defined and thrown appropriately.

## Skill Suggestions

- **Developer** agent for TypeScript service implementation.
- **Security review** skill for API key handling (never logged, never sent to frontend).
