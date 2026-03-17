# PROMPT 01: WebServerExtension + SPA Hosting

## Priority

Critical — foundational infrastructure for all subsequent phases.

## Context

Read before starting:

1. `.agents/AGENTS.md`
2. `.agents/FRAMEWORK.md`
3. `.app-info/product-plan/12-UNIFIED_EXTENSION_SPEC.md` — full requirements spec.
4. `KnowledgeBase-Copilot/mendix-extension/KbCopilotExtension/` — current extension code.
5. `KnowledgeBase-Copilot/frontend/` — current React SPA.

## Problem Statement

The current extension opens a WebView pointing to `http://localhost:3001`, requiring an external Node.js process. This phase replaces that with Studio Pro's built-in `WebServerExtension`, which serves the React SPA directly from within the extension process.

## Deliverable

### 1. WebServerExtension Implementation

Create a new class that extends `WebServerExtension` from the Mendix ExtensionsAPI:

```csharp
[Export(typeof(WebServerExtension))]
public class KbWebServer : WebServerExtension
{
    public override void InitializeWebServer(IWebServer webServer)
    {
        // Serve static frontend assets (index.html, JS, CSS)
        // Serve API routes (stub for now, full implementation in later phases)
    }
}
```

**Static asset serving:**
- Embed the Vite-built frontend (`frontend/dist/`) as embedded resources in the DLL, OR
- Copy frontend assets to a known directory alongside the DLL and serve from disk.
- Serve `index.html` for all non-API, non-asset routes (SPA fallback).
- Set correct MIME types for `.js`, `.css`, `.html`, `.svg`, `.png`.

**API route stubs:**
- `GET /api/health` → `{ "status": "ok" }` (for connectivity testing).
- Other API routes will be added in subsequent phases.

### 2. Update DockablePane to Use WebServerBaseUrl

Modify `CopilotDockablePane` to load the SPA from the extension's web server instead of `localhost:3001`:

```csharp
public class CopilotWebViewModel : WebViewDockablePaneViewModel
{
    private readonly Uri _baseUrl;

    public CopilotWebViewModel(Uri webServerBaseUrl)
    {
        Title = "KB Assistant";
        _baseUrl = webServerBaseUrl;
    }

    public override void InitWebView(IWebView webView)
    {
        webView.Address = _baseUrl;
    }
}
```

The `WebServerBaseUrl` is available from the `WebServerExtension` base class. Pass it to the pane via MEF composition or a shared service.

### 3. Frontend Build Integration

Update the extension's build process to:
1. Run `npm run build` in `frontend/` (Vite production build).
2. Copy `frontend/dist/` contents into the extension's output directory.
3. Ensure the CI workflow (`.github/workflows/build-knowledgebase-creator-artifact.yml`) includes the frontend build step.

### 4. Rename Extension

Rename the extension from `KbCopilotExtension` to `KbExtension` (or `MendixKbExtension`) to reflect its broader scope. Update:
- Project name and namespace.
- `manifest.json` reference.
- Menu item text: "KB Copilot" → "KB Assistant" (or keep "KB Copilot" if preferred).
- DockablePane title.

## Exit Criteria

1. Extension loads in Studio Pro 10.24+.
2. Opening the pane shows the React SPA (served by the extension, not localhost:3001).
3. `GET /api/health` returns `200 OK` via the extension's web server.
4. No external Node.js process running.
5. `dotnet build` succeeds.
6. Frontend assets are included in the extension output.

## Out of Scope

- API routes beyond health check (Phase 02+).
- Message bridge (Phase 02).
- KB Creator integration (Phase 04).
- mx CLI integration (Phase 05).

## Risks

| Risk | Mitigation |
|---|---|
| `WebServerExtension` API differs from expected | Prototype early. Check ExtensionsAPI docs/samples for `IWebServer.AddRoute()` signature. |
| Embedded resources increase DLL size significantly | Frontend dist is typically < 1MB. Acceptable. |
| MIME type handling gaps | Test all asset types. Add explicit MIME mappings. |
