# PROMPT 02: WebView Message Bridge + Transport Layer

## Priority

Critical — enables all frontend-to-backend communication without HTTP/WebSocket.

## Context

Read before starting:

1. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — architecture and message protocol.
2. Phase 01 output — WebServerExtension serving the SPA.
3. `KnowledgeBase-Copilot/frontend/src/` — current frontend HTTP/WebSocket clients.
4. `KnowledgeBase-Copilot/backend/src/ws/chat.handler.ts` — current WebSocket handler.

## Problem Statement

The frontend currently communicates with the backend via `fetch()` (REST) and `WebSocket` (streaming). With the backend now running inside the C# extension, we need a new transport layer using the WebView message bridge (`chrome.webview.postMessage` ↔ `webView.PostMessageAsJsonAsync`).

## Deliverable

### 1. C# Message Router

Create a message router that receives messages from the WebView and dispatches to the appropriate service:

```csharp
public class MessageRouter
{
    private readonly Dictionary<string, IMessageHandler> _handlers = new();

    public void RegisterHandler(string type, IMessageHandler handler);

    public async Task HandleMessageAsync(string messageJson, IWebView webView)
    {
        // 1. Deserialize BridgeRequest
        // 2. Route to handler by type
        // 3. Send BridgeResponse back via webView.PostMessageAsJsonAsync
    }
}

public interface IMessageHandler
{
    Task<BridgeResponse> HandleAsync(BridgeRequest request, IResponseStream stream, CancellationToken ct);
}

public interface IResponseStream
{
    Task SendChunkAsync(string requestId, object payload);
}
```

**Message types to register (stubs initially):**
- `chat` → ChatMessageHandler (Phase 03)
- `kb` → KbMessageHandler (Phase 03)
- `config` → ConfigMessageHandler (Phase 03)
- `creator` → CreatorMessageHandler (Phase 04)
- `mx` → MxMessageHandler (Phase 05)

### 2. Frontend BridgeClient

Replace the current HTTP + WebSocket clients with a unified `BridgeClient`:

```typescript
// src/services/bridge-client.ts
type StreamCallback = (chunk: unknown) => void;

interface PendingRequest {
  resolve: (value: unknown) => void;
  reject: (error: Error) => void;
  onStream?: StreamCallback;
}

export class BridgeClient {
  private pending = new Map<string, PendingRequest>();
  private idCounter = 0;

  constructor() {
    window.chrome.webview.addEventListener('message', this.onMessage);
  }

  /** One-shot request/response */
  async request<T>(type: string, action: string, payload?: unknown): Promise<T>;

  /** Streaming request — calls onChunk for each stream message */
  stream(
    type: string,
    action: string,
    payload: unknown,
    onChunk: StreamCallback,
  ): { promise: Promise<void>; cancel: () => void };

  private onMessage = (event: MessageEvent) => {
    const response: BridgeResponse = JSON.parse(event.data);
    const pending = this.pending.get(response.id);
    if (!pending) return;

    if (response.type === 'stream' && pending.onStream) {
      pending.onStream(response.payload);
    } else if (response.type === 'result') {
      pending.resolve(response.payload);
      this.pending.delete(response.id);
    } else if (response.type === 'error') {
      pending.reject(new Error(response.payload as string));
      this.pending.delete(response.id);
    }
  };
}

export const bridge = new BridgeClient();
```

### 3. Fallback for Development Mode

When developing the frontend outside Studio Pro (e.g., `npm run dev` with Vite), the WebView message bridge is not available. Add a fallback that routes through HTTP:

```typescript
// src/services/transport.ts
const isWebView = typeof window !== 'undefined'
  && window.chrome?.webview !== undefined;

export const transport = isWebView
  ? new BridgeClient()
  : new HttpFallbackClient('http://localhost:3001');
```

This allows frontend development with `npm run dev` + a temporary Node.js backend, while production uses the message bridge.

### 4. Wire Up WebView Message Handling in DockablePane

In the `CopilotWebViewModel.InitWebView()`:

```csharp
public override void InitWebView(IWebView webView)
{
    webView.Address = _baseUrl;
    webView.MessageReceived += async (sender, json) =>
    {
        await _messageRouter.HandleMessageAsync(json, webView);
    };
}
```

## Exit Criteria

1. Frontend can send a message via `chrome.webview.postMessage()` and receive a response.
2. Health check works via the message bridge: `bridge.request('config', 'health')` → `{ status: 'ok' }`.
3. Streaming works: C# can send multiple `stream` responses for a single request ID.
4. Cancellation works: frontend `cancel()` sends a cancel message, C# aborts the operation.
5. Fallback HTTP mode works for frontend dev (`npm run dev`).
6. `dotnet build` and `npm run build` succeed.

## Out of Scope

- Actual service implementations (Phase 03+).
- Chat/conversation logic (Phase 03).
- KB Creator (Phase 04).
- mx CLI (Phase 05).
