# PROMPT 05: Mendix mx CLI Integration + Developer Tab

## Priority

High — third feature area, enables AI-assisted Mendix development.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — architecture overview and mx CLI requirements.
2. Phase 01–03 output — extension infrastructure + Copilot services.
3. Phase 04 output — KB Creator integration (uses `mx dump-mpr`).
4. Mendix mx CLI documentation — research available commands and their parameters.

## Problem Statement

Enable the extension to execute Mendix `mx` CLI commands, both from a UI (Developer tab) and programmatically as Copilot tools (AI-assisted development).

## Deliverable

### 1. MxCliService (C#)

```csharp
public class MxCliService
{
    private string? _mxPath;

    /// Auto-detect mx CLI from Studio Pro installation or PATH.
    public async Task InitializeAsync();

    /// Run an mx CLI command.
    public async Task<MxResult> RunCommandAsync(
        string command,
        string[] args,
        string workingDirectory,
        IProgress<string>? outputProgress = null,
        CancellationToken ct = default);

    /// Check mx CLI availability.
    public bool IsAvailable { get; }

    /// Get mx CLI version.
    public async Task<string> GetVersionAsync();
}

public record MxResult(
    int ExitCode,
    string StdOut,
    string StdErr,
    bool Success);
```

**mx CLI discovery order:**
1. Configured path (from settings).
2. Studio Pro installation directory (alongside Studio Pro executable).
3. System PATH.

### 2. mx CLI Tool Definitions for Copilot

Register mx CLI commands as Copilot tools so the AI can invoke them during conversations:

```csharp
public static readonly ToolDefinition[] MX_TOOLS = new[]
{
    new ToolDefinition
    {
        Name = "mx_create_entity",
        Description = "Create a new entity in the Mendix domain model.",
        InputSchema = new { /* module, name, attributes[] */ }
    },
    new ToolDefinition
    {
        Name = "mx_create_microflow",
        Description = "Create a new microflow in a Mendix module.",
        InputSchema = new { /* module, name, parameters[] */ }
    },
    new ToolDefinition
    {
        Name = "mx_create_page",
        Description = "Create a new page in a Mendix module.",
        InputSchema = new { /* module, name, layout */ }
    },
    new ToolDefinition
    {
        Name = "mx_check",
        Description = "Run Mendix consistency checks on the app.",
        InputSchema = new { /* optional scope */ }
    },
};
```

**Integration with ConversationService:**
- Add mx tools to the tool definitions when the AI provider supports them.
- Extend `ToolExecutor` to dispatch `mx_*` tool calls to `MxCliService`.
- System prompt includes mx tool descriptions when available.

### 3. mx Message Handler

```csharp
// MxMessageHandler
"mx" / "runCommand"    → MxCliService.RunCommandAsync (streaming output)
"mx" / "getVersion"    → MxCliService.GetVersionAsync
"mx" / "isAvailable"   → MxCliService.IsAvailable
"mx" / "getCommands"   → List available mx commands with parameters
```

### 4. Frontend Developer Tab

Add a "Developer" tab to the React SPA:

**Layout:**
```
┌──────────────────────────────────────────┐
│  Mendix Development Tools                │
│                                          │
│  mx CLI Status: ✓ Available (v10.24.0)   │
│                                          │
│  Quick Actions                           │
│  ┌────────────────────────────────────┐  │
│  │ [Create Entity]  [Create Page]     │  │
│  │ [Create Microflow]  [Run Checks]   │  │
│  └────────────────────────────────────┘  │
│                                          │
│  Command Builder                         │
│  ┌────────────────────────────────────┐  │
│  │ Command: [dropdown: create-entity] │  │
│  │ Module:  [__________________]      │  │
│  │ Name:    [__________________]      │  │
│  │ Attrs:   [+ Add attribute]         │  │
│  │                                    │  │
│  │ [▶ Execute]                        │  │
│  └────────────────────────────────────┘  │
│                                          │
│  AI-Assisted Mode                        │
│  ┌────────────────────────────────────┐  │
│  │ Describe what you want to create:  │  │
│  │ [________________________________] │  │
│  │ [🤖 Generate with AI]             │  │
│  └────────────────────────────────────┘  │
│                                          │
│  Output                                  │
│  ┌────────────────────────────────────┐  │
│  │ Entity "Invoice" created in        │  │
│  │ module "MyModule"                  │  │
│  └────────────────────────────────────┘  │
└──────────────────────────────────────────┘
```

**Components:**
- `DeveloperTab` — container with command palette + AI mode.
- `CommandBuilder` — dynamic form based on selected command.
- `QuickActions` — cards for common operations.
- `AiAssistInput` — natural language input that routes to Copilot with mx tools enabled.
- `OutputPanel` — command results and errors.

### 5. Model Refresh After Changes

After an mx CLI command modifies the model:
1. Notify the user that the model has changed.
2. If possible, trigger a model refresh in Studio Pro via ExtensionsAPI.
3. If no API for refresh exists, instruct the user to close and reopen the app or refresh manually.

## Exit Criteria

1. mx CLI is auto-detected and version displayed in Developer tab.
2. Entity creation works via the command builder UI.
3. Microflow creation works via the command builder UI.
4. Consistency checks run and display results.
5. AI-assisted mode: user types "Create an entity called Invoice with Name, Amount, Date" and the Copilot creates it via mx CLI tools.
6. `dotnet build` succeeds.

## Risks

| Risk | Mitigation |
|---|---|
| MPR file locked by Studio Pro during mx CLI execution | Test locking behavior. May need "save first" workflow. |
| mx CLI commands change between versions | Pin to 10.24+ commands. Document minimum mx CLI version. |
| Model refresh not available via ExtensionsAPI | Fall back to user notification. Research IApp.Reload or similar. |
| AI generates invalid mx CLI parameters | Validate parameters before execution. Return clear error messages. |

## Out of Scope

- Custom mx CLI commands or plugins.
- Direct IModel API access.
- MCP server/client integration.
